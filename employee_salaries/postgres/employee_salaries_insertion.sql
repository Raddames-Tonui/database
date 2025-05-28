-- Insert seed company
INSERT INTO company (company_name, location, company_email, address, date_created, date_modified)
VALUES ('SkyTech Solutions', 'Nairobi', 'info@skytech.co.ke', '123 Innovation Drive, Nairobi', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert employee statuses
INSERT INTO employee_statuses (status_code, status_label, status_description, date_created, date_modified)
VALUES 
('new', 'New', 'Employed within the current month', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('active', 'Active', 'Currently employed and active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('leaving', 'Leaving', 'Leaving the company this month', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('terminated', 'Terminated', 'No longer working at the company', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert departments
INSERT INTO departments (department_name, department_description, company_id, date_created, date_modified)
VALUES 
('Engineering', 'Handles all tech development', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('HR', 'Manages recruitment and employee welfare', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert roles
INSERT INTO roles (role_name, role_description, department_id, date_created, date_modified)
VALUES 
('Software Engineer', 'Develops and maintains software', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('DevOps Engineer', 'Manages deployments and CI/CD', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('HR Officer', 'Handles recruitment', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert permissions
INSERT INTO permissions (permission_name, permission_value, date_created, date_modified)
VALUES 
('can_create_user', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('can_view_payroll', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Assign permissions to roles
INSERT INTO role_permission (role_id, permission_id, date_created, date_modified)
VALUES 
(1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert authentication accounts
INSERT INTO authentication (email, password)
VALUES 
('alice@skytech.co.ke', 'hashedpass1'),
('bob@skytech.co.ke', 'hashedpass2'),
('carol@skytech.co.ke', 'hashedpass3'),
('dave@skytech.co.ke', 'hashedpass4'),
('eve@skytech.co.ke', 'hashedpass5'),
('frank@skytech.co.ke', 'hashedpass6'),
('grace@skytech.co.ke', 'hashedpass7'),
('heidi@skytech.co.ke', 'hashedpass8'),
('ivan@skytech.co.ke', 'hashedpass9'),
('judy@skytech.co.ke', 'hashedpass10');

-- Insert employees
INSERT INTO employees (
    employee_staff_number, status_code, employee_firstname, employee_lastname, employee_surname,
    employee_email, employee_phone_number, employee_date_of_birth, employee_home_location,
    role_id, employment_type, salary_type, employment_date, termination_date,
    date_created, date_modified)
VALUES 
('ST1001', 'new', 'Alice', 'Johnson', NULL, 'alice@skytech.co.ke', '0711000001', '1990-05-20', 'Kilimani', 1, 'full-time', 'fixed', CURRENT_DATE, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1002', 'active', 'Bob', 'Smith', NULL, 'bob@skytech.co.ke', '0711000002', '1988-03-11', 'Westlands', 2, 'full-time', 'fixed', CURRENT_DATE - INTERVAL '4 months', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1003', 'active', 'Carol', 'White', NULL, 'carol@skytech.co.ke', '0711000003', '1992-07-15', 'Roysambu', 3, 'full-time', 'fixed', CURRENT_DATE - INTERVAL '5 months', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1004', 'active', 'Dave', 'Green', NULL, 'dave@skytech.co.ke', '0711000004', '1995-12-25', 'Embakasi', 1, 'full-time', 'fixed', CURRENT_DATE - INTERVAL '7 months', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1005', 'active', 'Eve', 'Black', NULL, 'eve@skytech.co.ke', '0711000005', '1985-09-01', 'Langata', 2, 'full-time', 'fixed', CURRENT_DATE - INTERVAL '8 months', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1006', 'leaving', 'Frank', 'Brown', NULL, 'frank@skytech.co.ke', '0711000006', '1991-01-01', 'South C', 3, 'full-time', 'fixed', CURRENT_DATE - INTERVAL '10 months', CURRENT_DATE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1007', 'terminated', 'Grace', 'Wilson', NULL, 'grace@skytech.co.ke', '0711000007', '1983-10-10', 'Kasarani', 1, 'full-time', 'fixed', CURRENT_DATE - INTERVAL '12 months', CURRENT_DATE - INTERVAL '1 month', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1008', 'active', 'Heidi', 'Thompson', NULL, 'heidi@skytech.co.ke', '0711000008', '1994-06-06', 'Kikuyu', 2, 'full-time', 'fixed', CURRENT_DATE - INTERVAL '6 months', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1009', 'new', 'Ivan', 'Adams', NULL, 'ivan@skytech.co.ke', '0711000009', '1996-11-17', 'Donholm', 3, 'full-time', 'fixed', CURRENT_DATE, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('ST1010', 'active', 'Judy', 'Clark', NULL, 'judy@skytech.co.ke', '0711000010', '1989-02-02', 'Uthiru', 1, 'full-time', 'fixed', CURRENT_DATE - INTERVAL '3 months', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert payment periods (monthly)
INSERT INTO payment_periods (period_label, start_date, end_date, date_created, date_modified)
VALUES 
('January 2025', '2025-01-01', '2025-01-31', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('February 2025', '2025-02-01', '2025-02-28', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('March 2025', '2025-03-01', '2025-03-31', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('April 2025', '2025-04-01', '2025-04-30', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert earnings types
INSERT INTO earnings (earning_name, earning_description, date_created, date_modified)
VALUES 
('Basic Salary', 'Monthly base salary', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Allowance', 'Monthly allowances including house, transport, mortgage', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert deductions types
INSERT INTO deductions (deduction_name, deduction_description, date_created, date_modified)
VALUES 
('PAYE', 'Income tax deduction', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('NHIF', 'Health insurance deduction', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert a few audit logs
INSERT INTO audit_logs (action_performed, performed_by, affected_table, record_id, change_details)
VALUES 
('Created employee Alice Johnson', 1, 'employees', 1, 'Initial insert of new employee'),
('Updated status of Frank to leaving', 2, 'employees', 6, 'Changed status_code from active to leaving');

-- Insert a few leave applications
INSERT INTO employee_leaves (employee_id, leave_type, start_date, end_date, status, date_created, date_modified)
VALUES 
(3, 'annual', '2025-04-10', '2025-04-20', 'approved', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'sick', '2025-04-05', '2025-04-07', 'approved', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert contracts
INSERT INTO employment_contracts (employee_id, contract_type, start_date, end_date, basic_salary, benefits, date_created, date_modified)
VALUES 
(1, 'permanent', '2025-05-01', NULL, 100000.00, '{"health": "provided", "bonus": "eligible"}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'permanent', '2025-01-01', NULL, 110000.00, '{"health": "provided"}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);