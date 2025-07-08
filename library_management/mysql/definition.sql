-- Step 1: Create database
CREATE DATABASE IF NOT EXISTS library_management;
USE library_management;

# DROP DATABASE library_management;

-- School Library Table
CREATE TABLE school_library (
                                library_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                library_name VARCHAR(255) NOT NULL,
                                library_location VARCHAR(255) NOT NULL,
                                library_contact VARCHAR(20) NOT NULL,
                                established_year YEAR NOT NULL,
                                date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Librarian Table
CREATE TABLE librarian (
                           librarian_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                           library_id BIGINT UNSIGNED NOT NULL,
                           librarian_number VARCHAR(100) NOT NULL,
                           librarian_firstname VARCHAR(50) NOT NULL,
                           librarian_lastname VARCHAR(50) NOT NULL,
                           librarian_email VARCHAR(100) NOT NULL,
                           librarian_contact VARCHAR(20) NOT NULL,
                           gender ENUM('Male', 'Female', 'Other') NOT NULL,
                           hire_date DATE NOT NULL,
                           date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           CONSTRAINT uq_librarian_email UNIQUE (librarian_email),
                           CONSTRAINT uq_librarian_contact UNIQUE (librarian_contact),
                           FOREIGN KEY (library_id) REFERENCES school_library(library_id)
);

-- Section Table
CREATE TABLE section (
                         section_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                         section_name VARCHAR(100) NOT NULL,
                         library_id BIGINT UNSIGNED NOT NULL,
                         date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         CONSTRAINT uq_section_name UNIQUE (section_name),
                         FOREIGN KEY (library_id) REFERENCES school_library(library_id)
);

-- Category Table
CREATE TABLE category (
                          category_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                          section_id BIGINT UNSIGNED NOT NULL,
                          category_name VARCHAR(100) NOT NULL,
                          category_description TEXT NOT NULL,
                          date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          CONSTRAINT uq_category_name UNIQUE (category_name),
                          FOREIGN KEY (section_id) REFERENCES section(section_id)
);

-- Subcategory Table
CREATE TABLE subcategory (
                             subcategory_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                             category_id BIGINT UNSIGNED NOT NULL,
                             subcategory_name VARCHAR(100) NOT NULL,
                             subcategory_description TEXT NOT NULL,
                             date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             CONSTRAINT uq_subcategory_name UNIQUE (subcategory_name),
                             FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- Rack Table
CREATE TABLE rack (
                      rack_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                      subcategory_id BIGINT UNSIGNED NOT NULL,
                      date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                      FOREIGN KEY (subcategory_id) REFERENCES subcategory(subcategory_id)
);

-- Catalog Table
CREATE TABLE catalog (
                         catalog_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                         rack_id BIGINT UNSIGNED NOT NULL,
                         isbn VARCHAR(20) NOT NULL,
                         published_year YEAR NOT NULL,
                         edition SMALLINT NOT NULL,
                         book_language VARCHAR(50) NOT NULL,
                         book_name VARCHAR(100) NOT NULL,
                         book_description TEXT NOT NULL,
                         book_type ENUM('EXCLUSIVE', 'BORROWABLE', 'DIGITAL') NOT NULL,
                         date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         librarian_id BIGINT UNSIGNED NOT NULL,
                         date_added DATE NOT NULL,
                         date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         CONSTRAINT uq_isbn UNIQUE (isbn),
                         FOREIGN KEY (rack_id) REFERENCES rack(rack_id),
                         FOREIGN KEY (librarian_id) REFERENCES librarian(librarian_id)
);

-- Author Table
CREATE TABLE author (
                        author_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                        author_name VARCHAR(100) NOT NULL,
                        bio TEXT NOT NULL,
                        nationality VARCHAR(50) NOT NULL,
                        birth_date DATE NOT NULL,
                        date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Book Copy Table
CREATE TABLE book_copy (
                           book_copy_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                           catalog_id BIGINT UNSIGNED NOT NULL,
                           copy_status ENUM('GOOD', 'DAMAGED', 'LOST') NOT NULL,
                           is_available BOOLEAN NOT NULL DEFAULT TRUE,
                           borrowed_date DATE,
                           due_date DATE,
                           book_condition VARCHAR(50) NOT NULL,
                           date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id)
);

-- Book Author Table (Many-to-Many)
CREATE TABLE book_author (
                             book_author_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                             author_id BIGINT UNSIGNED NOT NULL,
                             catalog_id BIGINT UNSIGNED NOT NULL,
                             date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             FOREIGN KEY (author_id) REFERENCES author(author_id),
                             FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id)
);

-- Borrower Table
CREATE TABLE borrower (
                          borrower_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                          firstname VARCHAR(50) NOT NULL,
                          lastname VARCHAR(50) NOT NULL,
                          phone VARCHAR(20) NOT NULL,
                          borrower_email VARCHAR(100) NOT NULL,
                          address TEXT NOT NULL,
                          is_a_member BOOLEAN NOT NULL,
                          date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                          CONSTRAINT uq_borrower_phone UNIQUE (phone),
                          CONSTRAINT uq_borrower_email UNIQUE (borrower_email)
);

-- Borrow Log Table
CREATE TABLE borrow_log (
                            borrow_log_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                            book_copy_id BIGINT UNSIGNED NOT NULL,
                            borrower_id BIGINT UNSIGNED NOT NULL,
                            borrow_date DATE NOT NULL,
                            due_date DATE NOT NULL,
                            return_date DATE,
                            is_returned BOOLEAN NOT NULL DEFAULT FALSE,
                            date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            FOREIGN KEY (book_copy_id) REFERENCES book_copy(book_copy_id),
                            FOREIGN KEY (borrower_id) REFERENCES borrower(borrower_id)
);

-- Penalty Table
CREATE TABLE penalty (
                         penalty_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                         borrow_log_id BIGINT UNSIGNED NOT NULL,
                         penalty_amount DECIMAL(10,2) NOT NULL,
                         date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         CONSTRAINT uq_penalty_log UNIQUE (borrow_log_id),
                         FOREIGN KEY (borrow_log_id) REFERENCES borrow_log(borrow_log_id)
);

-- Access Granted Table
CREATE TABLE access_granted (
                                access_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                catalog_id BIGINT UNSIGNED NOT NULL,
                                librarian_id BIGINT UNSIGNED NOT NULL,
                                book_copy_id BIGINT UNSIGNED NOT NULL,
                                date_granted DATE NOT NULL,
                                due_date DATE NOT NULL,
                                borrower_id BIGINT UNSIGNED NOT NULL,
                                date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                FOREIGN KEY (catalog_id) REFERENCES catalog(catalog_id),
                                FOREIGN KEY (librarian_id) REFERENCES librarian(librarian_id),
                                FOREIGN KEY (book_copy_id) REFERENCES book_copy(book_copy_id),
                                FOREIGN KEY (borrower_id) REFERENCES borrower(borrower_id)
);
