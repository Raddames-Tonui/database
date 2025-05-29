-- Company information
CREATE TABLE company (
    company_id BIGSERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    company_email VARCHAR(150) NOT NULL,
    address TEXT NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Department definitions
CREATE TABLE departments (
    department_id BIGSERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_description TEXT,
    company_id BIGINT NOT NULL REFERENCES company(company_id),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Role definitions
CREATE TABLE roles (
    role_id BIGSERIAL PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
    role_description TEXT,
    department_id BIGINT NOT NULL REFERENCES departments(department_id),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Permissions definitions
CREATE TABLE permissions (
    permission_id BIGSERIAL PRIMARY KEY,
    permission_name VARCHAR(100) NOT NULL,
    permission_value BOOLEAN NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Role-Permission mapping
CREATE TABLE role_permission (
    role_permission_id BIGSERIAL PRIMARY KEY,
    role_id BIGINT NOT NULL REFERENCES roles(role_id),
    permission_id BIGINT NOT NULL REFERENCES permissions(permission_id),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee statuses
CREATE TABLE employee_statuses (
    status_code VARCHAR(20) PRIMARY KEY,
    status_label VARCHAR(50) NOT NULL,
    status_description VARCHAR(150),
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employees
CREATE TABLE employees (
    employee_id BIGSERIAL PRIMARY KEY,
    employee_staff_number VARCHAR(30) NOT NULL UNIQUE,
    employee_firstname VARCHAR(50) NOT NULL,
    employee_lastname VARCHAR(50) NOT NULL,
    employee_surname VARCHAR(50),
    employee_phone_number VARCHAR(15) NOT NULL,
    employee_email VARCHAR(150) NOT NULL UNIQUE,
    employee_date_of_birth DATE NOT NULL,
    employee_home_location VARCHAR(100) NOT NULL,
    role_id BIGINT NOT NULL REFERENCES roles(role_id),
    employment_type VARCHAR(30) NOT NULL,
    salary_type VARCHAR(30) NOT NULL,
    employment_date DATE NOT NULL,
    termination_date DATE,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Authentication table linked to employee
CREATE TABLE authentication (
    user_account_id BIGSERIAL PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password TEXT NOT NULL,
    employee_id BIGINT NOT NULL UNIQUE REFERENCES employees(employee_id)
);

-- Payroll periods
CREATE TABLE payment_periods (
    payment_period_id BIGSERIAL PRIMARY KEY,
    period_label VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Master earnings table
CREATE TABLE earnings (
    earnings_id BIGSERIAL PRIMARY KEY,
    earning_name VARCHAR(50) NOT NULL,
    earning_description TEXT,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Master deductions table
CREATE TABLE deductions (
    deduction_id BIGSERIAL PRIMARY KEY,
    deduction_name VARCHAR(50) NOT NULL,
    deduction_description TEXT,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee earnings per period
CREATE TABLE earnings_map (
    earnings_map_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    payment_period_id BIGINT NOT NULL REFERENCES payment_periods(payment_period_id),
    earnings_id BIGINT NOT NULL REFERENCES earnings(earnings_id),
    earning_amount DECIMAL(10, 2) NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee deductions per period
CREATE TABLE deductions_map (
    deduction_map_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    payment_period_id BIGINT NOT NULL REFERENCES payment_periods(payment_period_id),
    deduction_id BIGINT NOT NULL REFERENCES deductions(deduction_id),
    deduction_amount DECIMAL(10, 2) NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payroll summary
CREATE TABLE payroll_summary (
    payroll_summary_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    payment_period_id BIGINT NOT NULL REFERENCES payment_periods(payment_period_id),
    gross_pay DECIMAL(10, 2) NOT NULL,
    total_deductions DECIMAL(10, 2) NOT NULL,
    net_pay DECIMAL(10, 2) NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employee leave records
CREATE TABLE employee_leaves (
    leave_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    leave_type VARCHAR(30) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employment contracts
CREATE TABLE employment_contracts (
    contract_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    contract_type VARCHAR(30) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    basic_salary DECIMAL(10, 2) NOT NULL,
    benefits JSONB,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit logs (traceable to employee via authentication)
CREATE TABLE audit_logs (
    log_id BIGSERIAL PRIMARY KEY,
    action_performed TEXT NOT NULL,
    performed_by BIGINT REFERENCES authentication(user_account_id),
    affected_table VARCHAR(50) NOT NULL,
    record_id BIGINT,
    change_details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
