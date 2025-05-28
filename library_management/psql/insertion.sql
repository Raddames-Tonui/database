-- Insert into library
INSERT INTO library (library_name, library_location, library_contact, established_year)
VALUES
('Macmillan Memorial Library', 'Nairobi CBD', 254701112233, '1995-03-15');

-- Insert into librarian
INSERT INTO librarian (library_id, librarian_number, librarian_firstname, librarian_lastname, librarian_email, librarian_contact, gender, hire_date)
VALUES
(1, 'L001', 'Alice', 'Mutua', 'alice@macmillan.org', 254711112233, 'Female', '2010-01-01'),
(1, 'L002', 'Brian', 'Otieno', 'brian@macmillan.org', 254722223344, 'Male', '2015-07-15');

-- Insert into section
INSERT INTO section (section_name, library_id)
VALUES
('Science', 1),
('Literature', 1),
('Technology', 1);

-- Insert into category
INSERT INTO category (section_id, category_name, category_description)
VALUES
(1, 'Physics', 'Books related to physical sciences'),
(2, 'Novels', 'Literary fiction and creative writing'),
(3, 'Software Engineering', 'Software and programming related content');

-- Insert into subcategory
INSERT INTO subcategory (category_id, subcategory_name, subcategory_description)
VALUES
(1, 'Quantum Mechanics', 'Advanced physics topics'),
(2, 'African Literature', 'Novels written by African authors'),
(3, 'Web Development', 'Frontend and backend web programming');

-- Insert into rack
INSERT INTO rack (subcategory_id)
VALUES (1), (2), (3);

-- Insert into author
INSERT INTO author (author_name, bio, nationality, birth_date)
VALUES
('Stephen Hawking', 'Renowned physicist and cosmologist', 'British', '1942-01-08'),
('Chinua Achebe', 'Pioneer of African literature', 'Nigerian', '1930-11-16'),
('Robert C. Martin', 'Software craftsman and author of Clean Code', 'American', '1952-01-01');

-- Insert into catalog
INSERT INTO catalog (rack_id, isbn, published_year, edition, language, book_description, book_type, librarian_id, date_added)
VALUES
(1, '9780553380163', '2001-09-01', 1, 'English', 'A Brief History of Time explained', 'EXCLUSIVE', 1, '2023-01-01'),
(2, '9780385474542', '1994-03-01', 2, 'English', 'Things Fall Apart by Achebe', 'BORROWABLE', 2, '2023-02-01'),
(3, '9780132350884', '2008-08-01', 1, 'English', 'Clean Code software principles', 'BORROWABLE', 1, '2023-03-01');

-- Insert into book_author
INSERT INTO book_author (author_id, catalog_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert into book_copy with is_available column
INSERT INTO book_copy (catalog_id, copy_status, book_condition, is_available)
VALUES
(1, 'New',  'Excellent', FALSE), -- Access granted
(2, 'Used', 'Good', FALSE),      -- Borrowed
(2, 'Used', 'Good', FALSE),      -- Borrowed
(3, 'New',  'Excellent', FALSE), -- Borrowed
(3, 'New',  'Excellent', TRUE);  -- Free

-- Insert into borrower
INSERT INTO borrower (firstname, lastname, phone, borrower_email, address, is_a_member)
VALUES
('John', 'Kamau', 254733445566, 'john@example.com', 'Kilimani, Nairobi', TRUE),
('Mary', 'Wambui', 254744556677, 'mary@example.com', 'Westlands, Nairobi', TRUE),
('James', 'Kariuki', 254755667788, 'james@example.com', 'Langata, Nairobi', FALSE),
('Linda', 'Njeri', 254766778899, 'linda@example.com', 'Parklands, Nairobi', TRUE);

-- Insert into borrow_log
INSERT INTO borrow_log (book_copy_id, borrower_id, borrow_date, due_date, return_date, is_returned)
VALUES
-- Returned
(2, 1, '2025-02-01', '2025-02-15', '2025-02-14', TRUE),
-- Not yet returned
(3, 2, '2025-03-01', '2025-03-15', NULL, FALSE),
(4, 1, '2025-04-01', '2025-04-15', NULL, FALSE),
-- Returned late
(2, 3, '2025-04-20', '2025-05-01', '2025-05-05', TRUE),
-- New borrow
(5, 4, '2025-05-10', '2025-05-24', NULL, FALSE);

-- Insert into penalty
INSERT INTO penalty (borrow_log_id, penalty_amount)
VALUES
(2, 500),    -- For borrow_log with ID 2
(3, 1000),   -- For borrow_log with ID 3
(4, 250);    -- Late return

-- Insert into access_granted (for EXCLUSIVE books)
INSERT INTO access_granted (catalog_id, librarian_id, book_copy_id, borrower_id, date_granted, due_date)
VALUES
(1, 1, 1, 2, '2025-01-01', '2025-01-10');
