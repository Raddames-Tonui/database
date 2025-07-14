-- ==========================================
-- DROP EXISTING VIEWS IF THEY EXIST
-- ==========================================

IF OBJECT_ID('employee_status_view', 'V') IS NOT NULL
DROP VIEW employee_status_view;
GO

IF OBJECT_ID('employee_payroll_report', 'V') IS NOT NULL
DROP VIEW employee_payroll_report;
GO

IF OBJECT_ID('employee_allowance_report', 'V') IS NOT NULL
DROP VIEW employee_allowance_report;
GO

IF OBJECT_ID('get_company_net_salary', 'IF') IS NOT NULL
DROP FUNCTION get_company_net_salary;
GO

IF OBJECT_ID('get_employee_previous_payment_history', 'IF') IS NOT NULL
DROP FUNCTION get_employee_previous_payment_history;
GO


-- 1. VIEW: Employee Status with Computed Status Code

CREATE VIEW employee_status_view AS
SELECT
    e.employee_staff_number,
    e.employee_firstname + ' ' + e.employee_lastname AS employee_name,
    e.employment_date,
    e.termination_date,
    r.role_name,
    d.department_name,
    CASE
        WHEN e.termination_date IS NOT NULL AND e.termination_date <= CAST(GETDATE() AS DATE) THEN 'terminated'
        WHEN e.termination_date IS NOT NULL AND e.termination_date > CAST(GETDATE() AS DATE) THEN 'leaving'
        WHEN EXISTS (
            SELECT 1 FROM employee_leaves l
            WHERE l.employee_id = e.employee_id
              AND CAST(GETDATE() AS DATE) BETWEEN l.start_date AND l.end_date
              AND l.status = 'approved'
        ) THEN 'onleave'
        WHEN CAST(GETDATE() AS DATE) < DATEADD(month, 1, e.employment_date) THEN 'new'
        ELSE 'active'
        END AS status_code,
    es.status_description
FROM employees e
         INNER JOIN roles r ON e.role_id = r.role_id
         INNER JOIN departments d ON r.department_id = d.department_id
         INNER JOIN employee_statuses es ON es.status_code =
                                            CASE
                                                WHEN e.termination_date IS NOT NULL AND e.termination_date <= CAST(GETDATE() AS DATE) THEN 'terminated'
                                                WHEN e.termination_date IS NOT NULL AND e.termination_date > CAST(GETDATE() AS DATE) THEN 'leaving'
                                                WHEN EXISTS (
                                                    SELECT 1 FROM employee_leaves l
                                                    WHERE l.employee_id = e.employee_id
                                                      AND CAST(GETDATE() AS DATE) BETWEEN l.start_date AND l.end_date
                                                      AND l.status = 'approved'
                                                ) THEN 'onleave'
                                                WHEN CAST(GETDATE() AS DATE) < DATEADD(month, 1, e.employment_date) THEN 'new'
                                                ELSE 'active'
                                                END;
GO


-- 2. VIEW: Payroll Report - Earnings, Deductions, Net Pay


CREATE VIEW employee_payroll_report AS
SELECT
    e.employee_staff_number,
    e.employee_firstname + ' ' + e.employee_lastname AS fullname,
    e.salary_type,
    pp.payment_period_id,
    pp.period_label,
    ISNULL(SUM(em.earning_amount), 0) AS earning_amount,
    ISNULL(SUM(dm.deduction_amount), 0) AS deduction_amount,
    ISNULL(SUM(em.earning_amount), 0) - ISNULL(SUM(dm.deduction_amount), 0) AS net_pay
FROM employees e
         JOIN payment_periods pp ON 1 = 1
         LEFT JOIN earnings_map em ON e.employee_id = em.employee_id AND pp.payment_period_id = em.payment_period_id
         LEFT JOIN deductions_map dm ON e.employee_id = dm.employee_id AND pp.payment_period_id = dm.payment_period_id
GROUP BY
    e.employee_staff_number,
    e.salary_type,
    e.employee_firstname,
    e.employee_lastname,
    pp.payment_period_id,
    pp.period_label;
GO


-- 3. VIEW: Allowances and Net Salary by Department


CREATE VIEW employee_allowance_report AS
SELECT
    e.employee_staff_number,
    e.employee_firstname,
    d.department_name,
    pp.period_label,
    SUM(CASE
            WHEN LOWER(es.earning_name) LIKE '%allowance%' THEN em.earning_amount
            ELSE 0
        END) AS total_allowances,
    ISNULL(SUM(em.earning_amount), 0) - ISNULL(SUM(ISNULL(dm.deduction_amount, 0)), 0) AS net_salary
FROM employees e
         JOIN roles r ON e.role_id = r.role_id
         JOIN departments d ON r.department_id = d.department_id
         JOIN payment_periods pp ON 1 = 1
         LEFT JOIN earnings_map em ON e.employee_id = em.employee_id AND pp.payment_period_id = em.payment_period_id
         LEFT JOIN earnings es ON em.earnings_id = es.earnings_id
         LEFT JOIN deductions_map dm ON e.employee_id = dm.employee_id AND pp.payment_period_id = dm.payment_period_id
GROUP BY
    e.employee_staff_number,
    e.employee_firstname,
    d.department_name,
    pp.period_label;
GO


-- 4. FUNCTION: Company Net Salary Report


CREATE FUNCTION get_company_net_salary()
    RETURNS TABLE
    AS
RETURN
SELECT
    c.company_id,
    c.company_name,
    pp.payment_period_id,
    pp.period_label,
    SUM(ISNULL(emp_earnings.total_earnings, 0) - ISNULL(emp_deductions.total_deductions, 0)) AS total_net_salary
FROM payment_periods pp
         JOIN employees e ON 1 = 1
         JOIN roles r ON e.role_id = r.role_id
         JOIN departments d ON r.department_id = d.department_id
         JOIN company c ON d.company_id = c.company_id
         LEFT JOIN (
    SELECT employee_id, payment_period_id, SUM(earning_amount) AS total_earnings
    FROM earnings_map
    GROUP BY employee_id, payment_period_id
) emp_earnings ON emp_earnings.employee_id = e.employee_id AND emp_earnings.payment_period_id = pp.payment_period_id
         LEFT JOIN (
    SELECT employee_id, payment_period_id, SUM(deduction_amount) AS total_deductions
    FROM deductions_map
    GROUP BY employee_id, payment_period_id
) emp_deductions ON emp_deductions.employee_id = e.employee_id AND emp_deductions.payment_period_id = pp.payment_period_id
WHERE e.employee_id IS NOT NULL
GROUP BY c.company_id, c.company_name, pp.payment_period_id, pp.period_label;
GO


-- 5. FUNCTION: Employee Previous Monthly Payment History


CREATE FUNCTION get_employee_previous_payment_history()
    RETURNS TABLE
    AS
RETURN
SELECT
    e.employee_firstname + ' ' + e.employee_lastname AS employee_name,
    e.employee_staff_number,
    pp.payment_period_id,
    pp.period_label,
    ec.basic_salary,
    ISNULL(SUM(em.earning_amount), 0) AS total_earnings,
    ISNULL(SUM(CASE WHEN d.deduction_name = 'PAYE' THEN dm.deduction_amount ELSE 0 END), 0) AS total_paye,
    ISNULL(ec.basic_salary, 0) + ISNULL(SUM(em.earning_amount), 0) - ISNULL(SUM(dm.deduction_amount), 0) AS total_net_salary
FROM employees e
         LEFT JOIN employment_contracts ec ON e.employee_id = ec.employee_id
         JOIN roles r ON e.role_id = r.role_id
         JOIN departments dep ON r.department_id = dep.department_id
         JOIN company c ON dep.company_id = c.company_id
         JOIN payment_periods pp ON 1 = 1
         LEFT JOIN earnings_map em ON em.employee_id = e.employee_id AND em.payment_period_id = pp.payment_period_id
         LEFT JOIN deductions_map dm ON dm.employee_id = e.employee_id AND dm.payment_period_id = pp.payment_period_id
         LEFT JOIN deductions d ON dm.deduction_id = d.deduction_id
WHERE pp.start_date < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
GROUP BY
    e.employee_firstname,
    e.employee_lastname,
    e.employee_staff_number,
    pp.payment_period_id,
    pp.period_label,
    ec.basic_salary;
GO


-- USAGE EXAMPLES:


-- 1. New Employees by Department
SELECT * FROM employee_status_view WHERE status_code = 'terminated';

-- 2. Active Employees in Engineering
SELECT * FROM employee_status_view WHERE status_code = 'active' AND department_name = 'Engineering';

-- 3. View Payroll Report
SELECT * FROM employee_payroll_report WHERE employee_staff_number = 'ST1002';

-- 4. View Allowance Report
SELECT * FROM employee_allowance_report;

-- 5. Get Net Salary Company Report
SELECT * FROM get_company_net_salary();

-- 6. Get Previous Monthly Salary Report
SELECT * FROM get_employee_previous_payment_history();
