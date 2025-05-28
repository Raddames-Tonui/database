-- Stores basic company information
CREATE TABLE company (
    company_id BIGSERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    company_email VARCHAR(150) NOT NULL,
    address TEXT NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Departments within a company
CREATE TABLE departments (
    department_id BIGSERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_description TEXT,
    company_id BIGINT NOT NULL REFERENCES company(company_id),
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Roles within departments
CREATE TABLE roles (
    role_id BIGSERIAL PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
    role_description TEXT,
    department_id BIGINT NOT NULL REFERENCES departments(department_id),
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);


-- Defines system permissions (e.g., can_create_user)
CREATE TABLE permissions (
    permission_id BIGSERIAL PRIMARY KEY,
    permission_name VARCHAR(100) NOT NULL,
    permission_value BOOLEAN NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Maps roles to permissions
CREATE TABLE role_permission (
    role_permission_id BIGSERIAL PRIMARY KEY,
    role_id BIGINT NOT NULL REFERENCES roles(role_id),
    permission_id BIGINT NOT NULL REFERENCES permissions(permission_id),
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Authentication table (email must be unique)
CREATE TABLE authentication (
    user_account_id BIGSERIAL PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password TEXT NOT NULL
);


-- Defines employee statuses (e.g., active, terminated)
CREATE TABLE employee_statuses (
    status_code VARCHAR(20) PRIMARY KEY,
    status_label VARCHAR(50) NOT NULL,
    status_description VARCHAR(150),
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Main employee table
CREATE TABLE employees (
    employee_id BIGSERIAL PRIMARY KEY,
    employee_staff_number VARCHAR(30) NOT NULL UNIQUE,
    status_code VARCHAR(20) NOT NULL REFERENCES employee_statuses(status_code),
    employee_firstname VARCHAR(50) NOT NULL,
    employee_lastname VARCHAR(50) NOT NULL,
    employee_surname VARCHAR(50),
    employee_email VARCHAR(150) NOT NULL REFERENCES authentication(email),
    employee_phone_number VARCHAR(15) NOT NULL,
    employee_date_of_birth DATE NOT NULL,
    employee_home_location VARCHAR(100) NOT NULL,
    role_id BIGINT NOT NULL REFERENCES roles(role_id),
    employment_type VARCHAR(30) NOT NULL, -- e.g., full-time, part-time
    salary_type VARCHAR(30) NOT NULL,     -- e.g., fixed, hourly
    employment_date DATE NOT NULL,
    termination_date DATE,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);


-- Payroll periods (e.g., monthly, biweekly)
CREATE TABLE payment_periods (
    payment_period_id BIGSERIAL PRIMARY KEY,
    period_label VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Earnings master list (e.g., base pay, bonuses)
CREATE TABLE earnings (
    earnings_id BIGSERIAL PRIMARY KEY,
    earning_name VARCHAR(50) NOT NULL,
    earning_description TEXT,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Deductions master list (e.g., taxes, pension)
CREATE TABLE deductions (
    deduction_id BIGSERIAL PRIMARY KEY,
    deduction_name VARCHAR(50) NOT NULL,
    deduction_description TEXT,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Map of employee earnings per payment period
CREATE TABLE earnings_map (
    earnings_map_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    payment_period_id BIGINT NOT NULL REFERENCES payment_periods(payment_period_id),
    earnings_id BIGINT NOT NULL REFERENCES earnings(earnings_id),
    earning_amount DECIMAL(10, 2) NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Map of employee deductions per payment period
CREATE TABLE deductions_map (
    deduction_map_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    payment_period_id BIGINT NOT NULL REFERENCES payment_periods(payment_period_id),
    deduction_id BIGINT NOT NULL REFERENCES deductions(deduction_id),
    deduction_amount DECIMAL(10, 2) NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Payroll summary by employee and period
CREATE TABLE payroll_summary (
    payroll_summary_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    payment_period_id BIGINT NOT NULL REFERENCES payment_periods(payment_period_id),
    gross_pay DECIMAL(10, 2) NOT NULL,
    total_deductions DECIMAL(10, 2) NOT NULL,
    net_pay DECIMAL(10, 2) NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);


-- Tracks employee leave applications
CREATE TABLE employee_leaves (
    leave_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    leave_type VARCHAR(30) NOT NULL, -- e.g., sick, annual, maternity
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL, -- e.g., pending, approved, rejected
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

-- Tracks employee contracts
CREATE TABLE employment_contracts (
    contract_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    contract_type VARCHAR(30) NOT NULL, -- e.g., permanent, intern
    start_date DATE NOT NULL,
    end_date DATE,
    basic_salary DECIMAL(10, 2) NOT NULL,
    benefits JSONB,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);


-- Logs actions for security and tracking
CREATE TABLE audit_logs (
    log_id BIGSERIAL PRIMARY KEY,
    action_performed TEXT NOT NULL,
    performed_by BIGINT REFERENCES authentication(user_account_id),
    affected_table VARCHAR(50) NOT NULL,
    record_id BIGINT,
    change_details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

