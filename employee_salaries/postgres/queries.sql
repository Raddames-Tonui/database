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



-- Generate a report on the total earnings of an employee and total deductions as well as their net pay.
-- Generate a report on the total allowances and net salaries of each employee in a department.
-- Generate a report on the total net salary the company has to pay its employees.
-- Generate a report on the history of payment i.e. total earnings, total PAYE, total net salary for an employee in each of the months prior to the current month.