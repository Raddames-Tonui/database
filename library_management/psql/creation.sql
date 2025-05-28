-- Step 1: Create the database
-- CREATE DATABASE library_management;

-- Step 2: Connect to the database
-- \c library_management;

-- Step 3: Create Tables

-- Library Table
CREATE TABLE library (
    library_id BIGSERIAL PRIMARY KEY,
    library_name VARCHAR(255) NOT NULL,
    library_location VARCHAR(255) NOT NULL,
    library_contact BIGINT NOT NULL,
    established_year DATE NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Librarian
CREATE TABLE librarian (
    librarian_id BIGSERIAL PRIMARY KEY,
    library_id BIGINT NOT NULL,
    librarian_number VARCHAR(255) NOT NULL,
    librarian_firstname VARCHAR(25) NOT NULL,
    librarian_lastname VARCHAR(25) NOT NULL,
    librarian_email VARCHAR(255) NOT NULL,
    librarian_contact BIGINT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    hire_date DATE NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT librarian_email_unique UNIQUE (librarian_email),
    CONSTRAINT librarian_contact_unique UNIQUE (librarian_contact),
    FOREIGN KEY (library_id) REFERENCES library(library_id)
);

-- Section
CREATE TABLE section (
    section_id BIGSERIAL PRIMARY KEY,
    section_name VARCHAR(255) NOT NULL UNIQUE,
    library_id BIGINT NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (library_id) REFERENCES library(library_id)
);

-- Category
CREATE TABLE category (
    category_id BIGSERIAL PRIMARY KEY,
    section_id BIGINT NOT NULL,
    category_name VARCHAR(255) NOT NULL UNIQUE,
    category_description VARCHAR(255) NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES section(section_id)
);

-- Subcategory
CREATE TABLE subcategory (
    subcategory_id BIGSERIAL PRIMARY KEY,
    category_id BIGINT NOT NULL,
    subcategory_name VARCHAR(255) NOT NULL UNIQUE,
    subcategory_description TEXT NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- Rack
CREATE TABLE rack (
    rack_id BIGSERIAL PRIMARY KEY,
    subcategory_id BIGINT NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subcategory_id) REFERENCES subcategory(subcategory_id)
);

-- Catalog
CREATE TABLE catalog (
    catalog_id BIGSERIAL PRIMARY KEY,
    rack_id BIGINT NOT NULL,
    isbn VARCHAR(255) NOT NULL UNIQUE,
    published_year DATE NOT NULL,
    edition INT NOT NULL,
    language VARCHAR(255) NOT NULL,
    book_description TEXT NOT NULL,
    book_type VARCHAR(20) NOT NULL CHECK (book_type IN ('EXCLUSIVE', 'BORROWABLE', 'DIGITAL')),
    librarian_id BIGINT NOT NULL,
    date_added DATE NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rack_id) REFERENCES rack(rack_id),
    FOREIGN KEY (librarian_id) REFERENCES librarian(librarian_id)
);

-- Author
CREATE TABLE author (
    author_id BIGSERIAL PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL,
    bio TEXT NOT NULL,
    nationality VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Book Copy
CREATE TABLE book_copy (
    book_copy_id BIGSERIAL PRIMARY KEY,
    catalog_id BIGINT NOT NULL,
    copy_status VARCHAR(255) NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    book_condition VARCHAR(255) NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id)
);

-- Book Author
CREATE TABLE book_author (
    book_author_id BIGSERIAL PRIMARY KEY,
    author_id BIGINT NOT NULL,
    catalog_id BIGINT NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES author(author_id),
    FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id)
);

-- Borrower
CREATE TABLE borrower (
    borrower_id BIGSERIAL PRIMARY KEY,
    firstname VARCHAR(255) NOT NULL,
    lastname VARCHAR(255) NOT NULL,
    phone BIGINT NOT NULL UNIQUE,
    borrower_email VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    is_a_member BOOLEAN NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Borrow Log
CREATE TABLE borrow_log (
    borrow_log_id BIGSERIAL PRIMARY KEY,
    book_copy_id BIGINT NOT NULL,
    borrower_id BIGINT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    is_returned BOOLEAN NOT NULL DEFAULT FALSE,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_copy_id) REFERENCES book_copy(book_copy_id),
    FOREIGN KEY (borrower_id) REFERENCES borrower(borrower_id)
);

-- Penalty
CREATE TABLE penalty (
    penalty_id BIGSERIAL PRIMARY KEY,
    borrow_log_id BIGINT NOT NULL UNIQUE,
    penalty_amount BIGINT NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (borrow_log_id) REFERENCES borrow_log(borrow_log_id)
);

-- Access Granted
CREATE TABLE access_granted (
    access_id BIGSERIAL PRIMARY KEY,
    catalog_id BIGINT NOT NULL,
    librarian_id BIGINT NOT NULL,
    book_copy_id BIGINT NOT NULL,
    borrower_id BIGINT NOT NULL,
    date_granted DATE NOT NULL,
    due_date DATE NOT NULL,
    date_created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id),
    FOREIGN KEY (librarian_id) REFERENCES librarian(librarian_id),
    FOREIGN KEY (book_copy_id) REFERENCES book_copy(book_copy_id),
    FOREIGN KEY (borrower_id) REFERENCES borrower(borrower_id)
);
