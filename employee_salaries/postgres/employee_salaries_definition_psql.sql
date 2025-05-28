CREATE TABLE company (
    company_id BIGSERIAL PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    company_email VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE departments (
    department_id BIGSERIAL PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL,
    department_description TEXT NOT NULL,
    company_id BIGINT NOT NULL REFERENCES company(company_id),
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE roles (
    role_id BIGSERIAL PRIMARY KEY,
    role_name VARCHAR(255) NOT NULL,
    role_description TEXT NOT NULL,
    department_id BIGINT NOT NULL REFERENCES departments(department_id),
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE permissions (
    permission_id BIGSERIAL PRIMARY KEY,
    permission_name VARCHAR(255) NOT NULL,
    permission_value BOOLEAN NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE role_permission (
    role_permission_id BIGSERIAL PRIMARY KEY,
    permission_id BIGINT NOT NULL REFERENCES permissions(permission_id),
    role_id BIGINT NOT NULL REFERENCES roles(role_id),
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE authentication (
    user_account_id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password TEXT NOT NULL
);

CREATE TABLE employees (
    employee_id BIGSERIAL PRIMARY KEY,
    employee_staff_number VARCHAR(255) NOT NULL UNIQUE,
    employee_firstname VARCHAR(255) NOT NULL,
    employee_lastname VARCHAR(255) NOT NULL,
    employee_surname VARCHAR(255) NOT NULL,
    employee_email VARCHAR(255) NOT NULL REFERENCES authentication(email),
    employee_phone_number BIGINT NOT NULL,
    employee_date_of_birth DATE NOT NULL,
    employee_home_location VARCHAR(255) NOT NULL,
    role_id BIGINT NOT NULL REFERENCES roles(role_id),
    employment_type VARCHAR(255) NOT NULL,
    salary_type VARCHAR(255) NOT NULL,
    employment_date DATE NOT NULL,
    termination_date DATE NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE employee_status (
    status_id BIGSERIAL PRIMARY KEY,
    status_name VARCHAR(255) NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE status_history (
    status_history_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    status_id BIGINT NOT NULL REFERENCES employee_status(status_id),
    status_start_date DATE NOT NULL,
    status_end_date DATE,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE payment_periods (
    payment_period_id BIGSERIAL PRIMARY KEY,
    period_label VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE earnings (
    earnings_id BIGSERIAL PRIMARY KEY,
    earning_name VARCHAR(255) NOT NULL,
    earning_description TEXT NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE deductions (
    deduction_id BIGSERIAL PRIMARY KEY,
    deduction_name VARCHAR(255) NOT NULL,
    deduction_description TEXT NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE earnings_map (
    earnings_map_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    payment_period_id BIGINT NOT NULL REFERENCES payment_periods(payment_period_id),
    earnings_id BIGINT NOT NULL REFERENCES earnings(earnings_id),
    earning_amount DECIMAL(8, 2) NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);

CREATE TABLE deductions_map (
    deduction_map_id BIGSERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL REFERENCES employees(employee_id),
    deduction_id BIGINT NOT NULL REFERENCES deductions(deduction_id),
    payment_period_id BIGINT NOT NULL REFERENCES payment_periods(payment_period_id),
    deduction_amount DECIMAL(8, 2) NOT NULL,
    date_created TIMESTAMP NOT NULL,
    date_modified TIMESTAMP NOT NULL
);
