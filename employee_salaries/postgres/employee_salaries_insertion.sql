-- COMPANY
INSERT INTO company (
    company_name, location, company_email, address, date_created, date_modified
) VALUES (
    'Sky World Ltd', 'Nairobi', 'info@skyworld.co.ke', 'Kilimani Road, Nairobi', '2025-01-01', '2025-01-01'
);

-- DEPARTMENTS
INSERT INTO departments (
    department_name, department_description, company_id, date_created, date_modified
) VALUES
    ('Engineering', 'Handles system architecture and development tasks', 1, '2025-01-01', '2025-01-01'),
    ('HR', 'Manages human resources', 1, '2025-01-01', '2025-01-01');

-- ROLES
INSERT INTO roles (
    role_name, role_description, department_id, date_created, date_modified
) VALUES
    ('Software Engineer', 'Backend systems and APIs', 1, '2025-01-01', '2025-01-01'),
    ('DevOps Engineer', 'CI/CD and infrastructure automation', 1, '2025-01-01', '2025-01-01'),
    ('HR Manager', 'Handles employee onboarding', 2, '2025-01-01', '2025-01-01');

-- PERMISSIONS
INSERT INTO permissions (
    permission_name, permission_value, date_created, date_modified
) VALUES
    ('View Payroll', TRUE, '2025-01-01', '2025-01-01'),
    ('Edit Employee', TRUE, '2025-01-01', '2025-01-01');

-- ROLE-PERMISSION MAPPING
INSERT INTO role_permission (
    permission_id, role_id, date_created, date_modified
) VALUES
    (1, 1, '2025-01-01', '2025-01-01'),  -- Software Engineer can View Payroll
    (2, 3, '2025-01-01', '2025-01-01');  -- HR Manager can Edit Employee

-- AUTHENTICATION
INSERT INTO authentication (email, password) VALUES
    ('alice@skyworld.co.ke', 'hashed_pass1'),
    ('bob@skyworld.co.ke', 'hashed_pass2'),
    ('clara@skyworld.co.ke', 'hashed_pass3'),
    ('dave@skyworld.co.ke', 'hashed_pass4'),
    ('eve@skyworld.co.ke', 'hashed_pass5');

-- EMPLOYEES
INSERT INTO employees (
    employee_staff_number, employee_firstname, employee_lastname, employee_surname,
    employee_email, employee_phone_number, employee_date_of_birth, employee_home_location,
    role_id, employment_type, salary_type, employment_date, termination_date,
    date_created, date_modified
) VALUES
    ('EMP001', 'Alice', 'Muthoni', 'Wanjiru', 'alice@skyworld.co.ke', 720001001, '1994-04-10', 'Nakuru',
     1, 'Permanent', 'Monthly', '2025-03-01', '2025-12-31', '2025-03-01', '2025-03-01'),

    ('EMP002', 'Bob', 'Otieno', 'Onyango', 'bob@skyworld.co.ke', 720002002, '1990-07-15', 'Kisumu',
     1, 'Permanent', 'Monthly', '2025-02-15', '2025-12-31', '2025-02-15', '2025-02-15'),

    ('EMP003', 'Clara', 'Nduta', 'Kariuki', 'clara@skyworld.co.ke', 720003003, '1992-12-20', 'Nyeri',
     2, 'Permanent', 'Monthly', '2025-04-01', '2025-12-31', '2025-04-01', '2025-04-01'),

    ('EMP004', 'Dave', 'Mutua', 'Mwanzia', 'dave@skyworld.co.ke', 720004004, '1988-06-22', 'Machakos',
     3, 'Permanent', 'Monthly', '2025-01-10', '2025-05-15', '2025-01-10', '2025-01-10'),

    ('EMP005', 'Eve', 'Kamau', 'Wambui', 'eve@skyworld.co.ke', 720005005, '1995-11-05', 'Thika',
     3, 'Contract', 'Monthly', '2025-05-01', '2025-12-31', '2025-05-01', '2025-05-01');

-- EMPLOYEE STATUS TYPES
INSERT INTO employee_status (
    status_name, date_created, date_modified
) VALUES
    ('new', '2025-01-01', '2025-01-01'),
    ('active', '2025-01-01', '2025-01-01'),
    ('leaving', '2025-01-01', '2025-01-01'),
    ('terminated', '2025-01-01', '2025-01-01');

-- EMPLOYEE STATUS HISTORY
INSERT INTO status_history (
    employee_id, status_id, status_start_date, status_end_date, date_created, date_modified
) VALUES
    (1, 1, '2025-03-01', '2025-05-01', '2025-03-01', '2025-03-01'),
    (1, 2, '2025-05-02', NULL, '2025-05-01', '2025-05-01'),

    (2, 1, '2025-02-15', '2025-05-01', '2025-02-15', '2025-02-15'),
    (2, 2, '2025-05-02', NULL, '2025-05-01', '2025-05-01'),

    (3, 1, '2025-04-01', '2025-05-01', '2025-04-01', '2025-04-01'),
    (3, 2, '2025-05-02', NULL, '2025-05-01', '2025-05-01'),

    (4, 2, '2025-01-10', '2025-05-15', '2025-01-10', '2025-01-10'),
    (4, 3, '2025-05-15', '2025-05-31', '2025-05-15', '2025-05-15'),
    (4, 4, '2025-06-01', NULL, '2025-05-31', '2025-05-31'),

    (5, 1, '2025-05-01', NULL, '2025-05-01', '2025-05-01');

-- PAYMENT PERIODS
INSERT INTO payment_periods (
    period_label, start_date, end_date, date_created, date_modified
) VALUES
    ('March 2025', '2025-03-01', '2025-03-31', '2025-03-01', '2025-03-01'),
    ('April 2025', '2025-04-01', '2025-04-30', '2025-04-01', '2025-04-01'),
    ('May 2025', '2025-05-01', '2025-05-31', '2025-05-01', '2025-05-01');

-- EARNINGS TYPES
INSERT INTO earnings (
    earning_name, earning_description, date_created, date_modified
) VALUES
    ('Basic Salary', 'Base pay per employee', '2025-01-01', '2025-01-01'),
    ('House Allowance', '3% of basic salary', '2025-01-01', '2025-01-01'),
    ('Transport Allowance', '1.5% of basic salary', '2025-01-01', '2025-01-01'),
    ('Mortgage Allowance', '2% of basic salary', '2025-01-01', '2025-01-01');

-- DEDUCTIONS
INSERT INTO deductions (
    deduction_name, deduction_description, date_created, date_modified
) VALUES
    ('PAYE', '14% tax on total earnings', '2025-01-01', '2025-01-01'),
    ('NHIF', 'Health insurance contribution', '2025-01-01', '2025-01-01'),
    ('NSSF', 'Social security pension fund', '2025-01-01', '2025-01-01'),
    ('HELB', 'Loan repayment deduction', '2025-01-01', '2025-01-01'),
    ('SACCO', 'Cooperative savings deduction', '2025-01-01', '2025-01-01');

-- EARNINGS MAP (mapping employees to earnings per payment period)
INSERT INTO earnings_map (
    employee_id, payment_period_id, earnings_id, earning_amount, date_created, date_modified
) VALUES
    -- Alice (employee_id=2)
    (2, 1, 1, 100000.00, '2025-03-31', '2025-03-31'),  -- Basic Salary
    (2, 1, 2, 3000.00, '2025-03-31', '2025-03-31'),    -- House Allowance (3%)
    (2, 1, 3, 1500.00, '2025-03-31', '2025-03-31'),    -- Transport Allowance (1.5%)
    (2, 1, 4, 2000.00, '2025-03-31', '2025-03-31'),    -- Mortgage Allowance (2%)

    (2, 2, 1, 102000.00, '2025-04-30', '2025-04-30'),  -- Basic Salary + 2%
    (2, 2, 2, 3060.00, '2025-04-30', '2025-04-30'),
    (2, 2, 3, 1530.00, '2025-04-30', '2025-04-30'),
    (2, 2, 4, 2040.00, '2025-04-30', '2025-04-30'),

    (2, 3, 1, 104000.00, '2025-05-31', '2025-05-31'),  -- Basic Salary + 4%
    (2, 3, 2, 3120.00, '2025-05-31', '2025-05-31'),
    (2, 3, 3, 1560.00, '2025-05-31', '2025-05-31'),
    (2, 3, 4, 2080.00, '2025-05-31', '2025-05-31');

-- DEDUCTIONS MAP (mapping deductions per employee per period)
INSERT INTO deductions_map (
    employee_id, payment_period_id, deduction_id, deduction_amount, date_created, date_modified
) VALUES
    (2, 1, 1, 17000.00, '2025-03-31', '2025-03-31'), -- PAYE March
    (2, 1, 2, 1500.00, '2025-03-31', '2025-03-31'),  -- NHIF March
    (2, 1, 3, 2000.00, '2025-03-31', '2025-03-31'),  -- NSSF March
    (2, 1, 4, 1000.00, '2025-03-31', '2025-03-31'),  -- HELB March
    (2, 1, 5, 1200.00, '2025-03-31', '2025-03-31'),  -- SACCO March

    (2, 2, 1, 17300.00, '2025-04-30', '2025-04-30'), -- PAYE April
    (2, 2, 2, 1530.00, '2025-04-30', '2025-04-30'),
    (2, 2, 3, 2040.00, '2025-04-30', '2025-04-30'),
    (2, 2, 4, 1020.00, '2025-04-30', '2025-04-30'),
    (2, 2, 5, 1240.00, '2025-04-30', '2025-04-30'),

    (2, 3, 1, 17600.00, '2025-05-31', '2025-05-31'), -- PAYE May
    (2, 3, 2, 1560.00, '2025-05-31', '2025-05-31'),
    (2, 3, 3, 2080.00, '2025-05-31', '2025-05-31'),
    (2, 3, 4, 1040.00, '2025-05-31', '2025-05-31'),
    (2, 3, 5, 1280.00, '2025-05-31', '2025-05-31');

