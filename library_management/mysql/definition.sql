-- Step 1: Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS library_management;

-- Step 2: Select the database to use
USE library_management;

-- Step 3: Create Tables

-- Library Table (Base table)
CREATE TABLE library (
    library_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    library_name CHAR(255) NOT NULL,
    library_location CHAR(255) NOT NULL,
    library_contact BIGINT NOT NULL,
    established_year DATE NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Librarian references Library
CREATE TABLE librarian (
    librarian_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    library_id BIGINT  UNSIGNED  NOT NULL,
    librarian_number VARCHAR(255) NOT NULL,
    librarian_firstname CHAR(25) NOT NULL,
    librarian_lastname CHAR(25) NOT NULL,
    librarian_email VARCHAR(25) NOT NULL,
    librarian_contact BIGINT NOT NULL,
    gender CHAR(10) NOT NULL,
    hire_date DATE NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT librarian_librarian_email_unique UNIQUE (librarian_email),
    CONSTRAINT librarian_librarian_contact_unique UNIQUE (librarian_contact),
    FOREIGN KEY (library_id) REFERENCES library(library_id)
);

-- Section references Library
CREATE TABLE section (
    section_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    section_name CHAR(255) NOT NULL,
    library_id BIGINT  UNSIGNED  NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT section_section_name_unique UNIQUE (section_name),
    FOREIGN KEY (library_id) REFERENCES library(library_id)
);

-- Category references Section
CREATE TABLE category (
    category_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    section_id BIGINT  UNSIGNED  NOT NULL,
    category_name CHAR(255) NOT NULL,
    category_description VARCHAR(255) NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT category_category_name_unique UNIQUE (category_name),
    FOREIGN KEY (section_id) REFERENCES section(section_id)
);

-- Subcategory references Category
CREATE TABLE subcategory (
    subcategory_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_id BIGINT UNSIGNED  NOT NULL,
    subcategory_name VARCHAR(255) NOT NULL,
    subcategory_description TEXT NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT subcategory_subcategory_name_unique UNIQUE (subcategory_name),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- Rack references Subcategory
CREATE TABLE rack (
    rack_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    subcategory_id BIGINT UNSIGNED  NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subcategory_id) REFERENCES subcategory(subcategory_id)
);

-- Catalog references Rack and Librarian
CREATE TABLE catalog (
    catalog_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    rack_id BIGINT UNSIGNED  NOT NULL,
    isbn VARCHAR(255) NOT NULL,
    published_year DATE NOT NULL,
    edition INT NOT NULL,
    language CHAR(255) NOT NULL,
    book_name CHAR(50) NOT NULL,
    book_description TEXT NOT NULL,
    book_type ENUM('EXCLUSIVE', 'BORROWABLE', 'DIGITAL') NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    librarian_id BIGINT UNSIGNED  NOT NULL,
    date_added DATE NOT NULL,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT catalog_isbn_unique UNIQUE (isbn),
    FOREIGN KEY (rack_id) REFERENCES rack(rack_id),
    FOREIGN KEY (librarian_id) REFERENCES librarian(librarian_id)
);

-- Author table
CREATE TABLE author (
    author_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    author_name CHAR(255) NOT NULL,
    bio TEXT NOT NULL,
    nationality CHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Book Copy references Catalog
CREATE TABLE book_copy (
    book_copy_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    catalog_id BIGINT UNSIGNED  NOT NULL,
    copy_status CHAR(255) NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    borrowed_date DATE NOT NULL,
    due_date DATE NOT NULL,
    book_condition CHAR(255) NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id)
);

-- Book Author (Many-to-Many: Catalog & Author)
CREATE TABLE book_author (
    book_author_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    author_id BIGINT UNSIGNED  NOT NULL,
    catalog_id BIGINT UNSIGNED  NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES author(author_id),
    FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id)
);

-- Borrower
CREATE TABLE borrower (
    borrower_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname CHAR(255) NOT NULL,
    lastname CHAR(255) NOT NULL,
    phone BIGINT NOT NULL,
    borrower_email VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    is_a_member BOOLEAN NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT borrower_phone_unique UNIQUE (phone),
    CONSTRAINT borrower_borrower_email_unique UNIQUE (borrower_email)
);

-- Borrow Log references Book Copy and Borrower
CREATE TABLE borrow_log (
    borrow_log_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    book_copy_id BIGINT UNSIGNED  NOT NULL,
    borrower_id BIGINT UNSIGNED  NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    is_returned BOOLEAN NOT NULL DEFAULT FALSE,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_copy_id) REFERENCES book_copy(book_copy_id),
    FOREIGN KEY (borrower_id) REFERENCES borrower(borrower_id)
);

-- Penalty references Borrow Log
CREATE TABLE penalty (
    penalty_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    borrow_log_id BIGINT UNSIGNED  NOT NULL,
    penalty_amount BIGINT NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT penalty_borrow_log_id_unique UNIQUE (borrow_log_id),
    FOREIGN KEY (borrow_log_id) REFERENCES borrow_log(borrow_log_id)
);

-- Access Granted references Catalog, Librarian, Book Copy, and Borrower
CREATE TABLE access_granted (
    access_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    catalog_id BIGINT UNSIGNED  NOT NULL,
    librarian_id BIGINT UNSIGNED  NOT NULL,
    book_copy_id BIGINT UNSIGNED  NOT NULL,
    date_granted DATE NOT NULL,
    due_date DATE NOT NULL,
    borrower_id BIGINT UNSIGNED  NOT NULL,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id),
    FOREIGN KEY (librarian_id) REFERENCES librarian(librarian_id),
    FOREIGN KEY (book_copy_id) REFERENCES book_copy(book_copy_id),
    FOREIGN KEY (borrower_id) REFERENCES borrower(borrower_id)
);