-- Drpping views
DROP VIEW IF EXISTS employee_status_view;


-- CREATE OR REPLACE VIEW employee_status_view AS
-- SELECT
--     e.*,
--     es.status_code,
--     es.status_label,
--     es.status_description
-- FROM employees e
-- LEFT JOIN (
--     SELECT
--         e_inner.employee_id,
--         CASE
--             WHEN e_inner.termination_date IS NOT NULL AND e_inner.termination_date <= CURRENT_DATE THEN 'Terminated'
--             WHEN e_inner.termination_date IS NOT NULL AND e_inner.termination_date > CURRENT_DATE THEN 'Leaving'
--             WHEN EXISTS (
--                 SELECT 1
--                 FROM employee_leaves l
--                 WHERE l.employee_id = e_inner.employee_id
--                     AND CURRENT_DATE BETWEEN l.start_date AND l.end_date
--                     AND l.status = 'approved'
--             ) THEN 'Onleave'
--             WHEN CURRENT_DATE < (e_inner.employment_date + INTERVAL '1 month') THEN 'New'
--             ELSE 'Active'
--         END AS status_code
--     FROM employees e_inner
-- ) computed ON computed.employee_id = e.employee_id
-- LEFT JOIN employee_statuses es ON es.status_code = computed.status_code;


CREATE OR REPLACE VIEW employee_status_view AS
SELECT
    e.employee_staff_number,
    concat(e.employee_firstname, '', employee_lastname) AS employee_name,
    e.employment_date,
    e.termination_date,
    r.role_name,
    d.department_name,
    CASE
        WHEN e.termination_date IS NOT NULL AND e.termination_date <= CURRENT_DATE THEN 'terminated'
        WHEN e.termination_date IS NOT NULL AND e.termination_date > CURRENT_DATE THEN 'leaving'
        WHEN EXISTS(
            SELECT 1
            FROM employee_leaves l
            WHERE l.employee_id = e.employee_id
                AND CURRENT_DATE BETWEEN l.start_date AND l.end_date
                AND l.status = 'approved'
            )THEN 'onleave'
        WHEN CURRENT_DATE < e.employment_date + INTERVAL '1 month' THEN 'new'
        ELSE 'active'
    END AS status_code,
    es.status_description
FROM employees e
INNER JOIN  roles r ON e.role_id = r.role_id
INNER JOIN departments d ON r.department_id = d.department_id
INNER JOIN employee_statuses es ON status_code = es.status_code;


-- 2. Display all the newly created employees grouped by the different departments.
SELECT * FROM employee_status_view WHERE  status_code = 'new';

-- 3. Display the total number of active employees in a department.
SELECT * FROM employee_status_view WHERE  status_code = 'active' AND department_name='Engineering';
SELECT * FROM employee_status_view WHERE  status_code = 'terminated' ;

-- 4 Generate a report on the total earnings of an employee and total deductions as well as their net pay.
CREATE OR REPLACE VIEW employee_payroll_report AS
SELECT
    e.employee_staff_number,
    CONCAT(e.employee_firstname, ' ', e.employee_lastname) AS fullname,
    e.salary_type,
    pp.payment_period_id,
    pp.period_label,
    COALESCE(SUM(em.earning_amount), 0) AS earning_amount,
    COALESCE(SUM(dm.deduction_amount), 0) AS deduction_amount,
    COALESCE(SUM(em.earning_amount), 0) - COALESCE(SUM(dm.deduction_amount), 0) AS net_pay
FROM employees e
JOIN payment_periods pp ON TRUE
INNER JOIN earnings_map em
    ON e.employee_id = em.employee_id AND pp.payment_period_id = em.payment_period_id
INNER JOIN deductions_map dm
    ON e.employee_id = dm.employee_id AND pp.payment_period_id = dm.payment_period_id
GROUP BY
    e.employee_staff_number,
    e.salary_type,
    e.employee_firstname,
    e.employee_lastname,
    pp.payment_period_id,
    pp.period_label;

SELECT * FROM employee_payroll_report WHERE employee_staff_number = 'ST1002';

-- 5. Generate a report on the total allowances and net salaries of each employee in a department.
CREATE OR REPLACE VIEW employee_allowance_report AS
SELECT
    e.employee_staff_number,
    e.employee_firstname,
    d.department_name,
    pp.period_label,

    -- Sum of all earnings with names containing 'Allowance'
    COALESCE(SUM(CASE
        WHEN es.earning_name ILIKE '%allowance%' THEN em.earning_amount
        ELSE 0
    END), 0) AS total_allowances,

    -- Net pay = total earnings - total deductions
    COALESCE(SUM(em.earning_amount), 0) - COALESCE(SUM(COALESCE(dm.deduction_amount, 0)), 0) AS net_salary

FROM employees e

JOIN roles r ON e.role_id = r.role_id
JOIN departments d ON r.department_id = d.department_id
JOIN payment_periods pp ON TRUE  -- Cross join to cover all periods
LEFT JOIN earnings_map em ON e.employee_id = em.employee_id AND pp.payment_period_id = em.payment_period_id
LEFT JOIN earnings es ON em.earnings_id = es.earnings_id
LEFT JOIN deductions_map dm ON e.employee_id = dm.employee_id AND pp.payment_period_id = dm.payment_period_id

GROUP BY
    e.employee_staff_number,
    e.employee_firstname,
    d.department_name,
    pp.period_label;


--6.  Generate a report on the total net salary the company has to pay its employees.
--     Net Salary = Gross Salary - (Taxes + Deductions)
CREATE OR REPLACE FUNCTION get_company_net_salary()
RETURNS TABLE (
    company_id BIGINT,
    company_name VARCHAR,
    payment_period_id BIGINT,
    period_label VARCHAR,
    total_net_salary NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.company_id,
        c.company_name,
        pp.payment_period_id,
        pp.period_label,
        SUM(
            COALESCE(emp_earnings.total_earnings, 0) -
            COALESCE(emp_deductions.total_deductions, 0)
        ) AS total_net_salary
    FROM
        payment_periods pp
    JOIN employees e ON TRUE
    JOIN roles r ON e.role_id = r.role_id
    JOIN departments d ON r.department_id = d.department_id
    JOIN company c ON d.company_id = c.company_id
    LEFT JOIN (
        SELECT em.employee_id, em.payment_period_id, SUM(em.earning_amount) AS total_earnings
        FROM earnings_map em
        GROUP BY em.employee_id, em.payment_period_id
    ) emp_earnings ON emp_earnings.employee_id = e.employee_id AND emp_earnings.payment_period_id = pp.payment_period_id
    LEFT JOIN (
        SELECT dm.employee_id, dm.payment_period_id, SUM(dm.deduction_amount) AS total_deductions
        FROM deductions_map dm
        GROUP BY dm.employee_id, dm.payment_period_id
    ) emp_deductions ON emp_deductions.employee_id = e.employee_id AND emp_deductions.payment_period_id = pp.payment_period_id
    WHERE e.employee_id IS NOT NULL
    GROUP BY c.company_id, c.company_name, pp.payment_period_id, pp.period_label
    ORDER BY pp.payment_period_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_company_net_salary();

--7.  Generate a report on the history of payment i.e. total earnings, total PAYE, total net salary for an employee in each of the months prior to the current month.
CREATE OR REPLACE FUNCTION get_employee_previous_payment_history()
RETURNS TABLE (
    employee_name VARCHAR,
    employee_staff_number VARCHAR,
    payment_period_id BIGINT,
    period_label VARCHAR,
    basic_salary NUMERIC,
    total_earnings NUMERIC,
    total_paye NUMERIC,
    total_net_salary NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        concat(e.employee_firstname, ' ', e.employee_lastname)::VARCHAR AS employee_name,
        e.employee_staff_number,
        pp.payment_period_id,
        pp.period_label,
        ec.basic_salary,
        COALESCE(SUM(em.earning_amount), 0) AS total_earnings,
        COALESCE(SUM(
            CASE WHEN d.deduction_name = 'PAYE' THEN dm.deduction_amount ELSE 0 END
        ), 0) AS total_paye,
        COALESCE(ec.basic_salary, 0) + COALESCE(SUM(em.earning_amount), 0) - COALESCE(SUM(dm.deduction_amount), 0) AS total_net_salary
    FROM employees e
    LEFT JOIN employment_contracts ec ON e.employee_id = ec.employee_id
    JOIN roles r ON e.role_id = r.role_id
    JOIN departments dep ON r.department_id = dep.department_id
    JOIN company c ON dep.company_id = c.company_id
    JOIN payment_periods pp ON TRUE
    LEFT JOIN earnings_map em ON em.employee_id = e.employee_id AND em.payment_period_id = pp.payment_period_id
    LEFT JOIN deductions_map dm ON dm.employee_id = e.employee_id AND dm.payment_period_id = pp.payment_period_id
    LEFT JOIN deductions d ON dm.deduction_id = d.deduction_id
    WHERE pp.start_date < date_trunc('month', CURRENT_DATE) -- prior months only
    GROUP BY e.employee_firstname, e.employee_lastname, e.employee_staff_number, pp.payment_period_id, pp.period_label, ec.basic_salary
    ORDER BY e.employee_firstname, e.employee_lastname, pp.payment_period_id;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM  get_employee_previous_payment_history()