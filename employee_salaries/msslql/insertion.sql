-- Insert seed company
INSERT INTO company (company_name, location, company_email, address, date_created, date_modified)
VALUES ('SkyTech Solutions', 'Nairobi', 'info@skytech.co.ke', '123 Innovation Drive, Nairobi', GETDATE(), GETDATE());

-- Insert employee statuses
INSERT INTO employee_statuses (status_code, status_label, status_description, date_created, date_modified)
VALUES
    ('new', 'New', 'Employed within the current month', GETDATE(), GETDATE()),
    ('active', 'Active', 'Currently employed and active', GETDATE(), GETDATE()),
    ('leaving', 'Leaving', 'Leaving the company this month', GETDATE(), GETDATE()),
    ('onleave', 'Onleave', 'Employee is on a break', GETDATE(), GETDATE()),
    ('terminated', 'Terminated', 'No longer working at the company', GETDATE(), GETDATE());

-- Insert departments
INSERT INTO departments (department_name, department_description, company_id, date_created, date_modified)
VALUES
    ('Engineering', 'Handles all tech development', 1, GETDATE(), GETDATE()),
    ('HR', 'Manages recruitment and employee welfare', 1, GETDATE(), GETDATE());

-- Insert roles
INSERT INTO roles (role_name, role_description, department_id, date_created, date_modified)
VALUES
    ('Software Engineer', 'Develops and maintains software', 1, GETDATE(), GETDATE()),
    ('DevOps Engineer', 'Manages deployments and CI/CD', 1, GETDATE(), GETDATE()),
    ('HR Officer', 'Handles recruitment', 2, GETDATE(), GETDATE());

-- Insert permissions
INSERT INTO permissions (permission_name, permission_value, date_created, date_modified)
VALUES
    ('can_create_user', 1, GETDATE(), GETDATE()),
    ('can_view_payroll', 1, GETDATE(), GETDATE());

-- Assign permissions to roles
INSERT INTO role_permission (role_id, permission_id, date_created, date_modified)
VALUES
    (1, 1, GETDATE(), GETDATE()),
    (2, 2, GETDATE(), GETDATE());

-- Insert employees
INSERT INTO employees (
    employee_staff_number, employee_firstname, employee_lastname, employee_surname,
    employee_email, employee_phone_number, employee_date_of_birth, employee_home_location,
    role_id, employment_type, salary_type, employment_date, termination_date,
    date_created, date_modified)
VALUES
    ('ST1001', 'Alice', 'Johnson', NULL, 'alice@skytech.co.ke', '0711000001', '1990-05-20', 'Kilimani', 1, 'full-time', 'fixed', CAST(GETDATE() AS DATE), NULL, GETDATE(), GETDATE()),
    ('ST1002', 'Bob', 'Smith', NULL, 'bob@skytech.co.ke', '0711000002', '1988-03-11', 'Westlands', 2, 'full-time', 'fixed', DATEADD(MONTH, -4, GETDATE()), NULL, GETDATE(), GETDATE()),
    ('ST1003', 'Carol', 'White', NULL, 'carol@skytech.co.ke', '0711000003', '1992-07-15', 'Roysambu', 3, 'full-time', 'fixed', DATEADD(MONTH, -5, GETDATE()), NULL, GETDATE(), GETDATE()),
    ('ST1004', 'Dave', 'Green', NULL, 'dave@skytech.co.ke', '0711000004', '1995-12-25', 'Embakasi', 1, 'full-time', 'fixed', DATEADD(MONTH, -7, GETDATE()), NULL, GETDATE(), GETDATE()),
    ('ST1005', 'Eve', 'Black', NULL, 'eve@skytech.co.ke', '0711000005', '1985-09-01', 'Langata', 2, 'full-time', 'fixed', DATEADD(MONTH, -8, GETDATE()), NULL, GETDATE(), GETDATE()),
    ('ST1006', 'Frank', 'Brown', NULL, 'frank@skytech.co.ke', '0711000006', '1991-01-01', 'South C', 3, 'full-time', 'fixed', DATEADD(MONTH, -10, GETDATE()), CAST(GETDATE() AS DATE), GETDATE(), GETDATE()),
    ('ST1007', 'Grace', 'Wilson', NULL, 'grace@skytech.co.ke', '0711000007', '1983-10-10', 'Kasarani', 1, 'full-time', 'fixed', DATEADD(MONTH, -12, GETDATE()), DATEADD(MONTH, -1, GETDATE()), GETDATE(), GETDATE()),
    ('ST1008', 'Heidi', 'Thompson', NULL, 'heidi@skytech.co.ke', '0711000008', '1994-06-06', 'Kikuyu', 2, 'full-time', 'fixed', DATEADD(MONTH, -6, GETDATE()), NULL, GETDATE(), GETDATE()),
    ('ST1009', 'Ivan', 'Adams', NULL, 'ivan@skytech.co.ke', '0711000009', '1996-11-17', 'Donholm', 3, 'full-time', 'fixed', CAST(GETDATE() AS DATE), NULL, GETDATE(), GETDATE()),
    ('ST1010', 'Judy', 'Clark', NULL, 'judy@skytech.co.ke', '0711000010', '1989-02-02', 'Uthiru', 1, 'full-time', 'fixed', DATEADD(MONTH, -3, GETDATE()), NULL, GETDATE(), GETDATE());

-- Insert authentication accounts
INSERT INTO authentication (employee_id, email, password)
VALUES
    (1, 'alice@skytech.co.ke', 'hashedpass1'),
    (2, 'bob@skytech.co.ke', 'hashedpass2'),
    (3, 'carol@skytech.co.ke', 'hashedpass3'),
    (4, 'dave@skytech.co.ke', 'hashedpass4'),
    (5, 'eve@skytech.co.ke', 'hashedpass5'),
    (6, 'frank@skytech.co.ke', 'hashedpass6'),
    (7, 'grace@skytech.co.ke', 'hashedpass7'),
    (8, 'heidi@skytech.co.ke', 'hashedpass8'),
    (9, 'ivan@skytech.co.ke', 'hashedpass9'),
    (10, 'judy@skytech.co.ke', 'hashedpass10');

-- Insert payment periods
INSERT INTO payment_periods (period_label, start_date, end_date, date_created, date_modified)
VALUES
    ('January 2025', '2025-01-01', '2025-01-31', GETDATE(), GETDATE()),
    ('February 2025', '2025-02-01', '2025-02-28', GETDATE(), GETDATE()),
    ('March 2025', '2025-03-01', '2025-03-31', GETDATE(), GETDATE()),
    ('April 2025', '2025-04-01', '2025-04-30', GETDATE(), GETDATE());

-- Insert earnings types
INSERT INTO earnings (earning_name, earning_description, date_created, date_modified)
VALUES
    ('Housing Allowance', '3% of basic salary paid after 3 months of employment', GETDATE(), GETDATE()),
    ('Transport Allowance', '1.5% of basic salary paid after 3 months of employment', GETDATE(), GETDATE()),
    ('Mortgage Allowance', '2% of basic salary paid after 3 months of employment', GETDATE(), GETDATE());

-- Insert deductions types
INSERT INTO deductions (deduction_name, deduction_description, date_created, date_modified)
VALUES
    ('PAYE', 'Income tax deduction', GETDATE(), GETDATE()),
    ('NHIF', 'Health insurance deduction', GETDATE(), GETDATE());

-- Insert audit logs
INSERT INTO audit_logs (action_performed, performed_by, affected_table, record_id, change_details)
VALUES
    ('Created employee Alice Johnson', 1, 'employees', 1, 'Initial insert of new employee'),
    ('Updated status of Frank to leaving', 2, 'employees', 6, 'Changed status_code from active to leaving');

-- Insert leave records
INSERT INTO employee_leaves (employee_id, leave_type, start_date, end_date, status, date_created, date_modified)
VALUES
    (3, 'annual', '2025-04-10', '2025-04-20', 'approved', GETDATE(), GETDATE()),
    (5, 'sick', '2025-04-05', '2025-04-07', 'approved', GETDATE(), GETDATE());

-- Insert employment contracts
INSERT INTO employment_contracts (employee_id, contract_type, start_date, end_date, basic_salary, benefits, date_created, date_modified)
VALUES
    (1, 'permanent', '2025-05-01', NULL, 100000.00, N'{"health": "provided", "bonus": "eligible"}', GETDATE(), GETDATE()),
    (2, 'permanent', '2025-01-01', NULL, 110000.00, N'{"health": "provided"}', GETDATE(), GETDATE());

-- Insert earnings_map
-- Same logic, no changes needed
-- Insert deductions_map
-- Same logic, no changes needed

-- ⚠ If needed, convert CURRENT_TIMESTAMP to GETDATE() everywhere
-- ⚠ Use N prefix before strings containing JSON or Unicode (MSSQL-safe)

