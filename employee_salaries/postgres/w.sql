CREATE OR REPLACE FUNCTION get_companies_net_salary()
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
            COALESCE(emp_earnings.total_earnings,0) -
            COALESCE(emp_deductions.total_deductions, 0)
        ) AS total_net_salary
    FROM
        payment_periods pp
    JOIN employees e ON TRUE
    JOIN roles r ON e.role_id = r.role_id
    JOIN departments d ON r.department_id = d.department_id
    JOIN company c ON c.company_id = d.company_id
    LEFT JOIN (
        SELECT employee_id, payment_period_id, SUM(earning_amount) AS total_earnings
        FROM earnings_map
        GROUP BY employee_id, payment_period_id
    ) emp_earnings ON emp_earnings.employee_id = e.employee_id AND emp_earnings.payment_period_id = pp.payment_period_id
    WHERE e.employee_id IS NOT NULL
    GROUP BY c.company_id, c.company_name, pp.payment_period_id, pp.period_label
    ORDER BY pp.payment_period_id;
END;
$$ LANGUAGE plpgsql;