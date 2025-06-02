USE library_management;

-- 1. Seed Library (3 rows)
INSERT INTO library (library_name, library_location, library_contact, established_year) VALUES
('Central Library', 'Nairobi', 254712345678, '1980-05-12'),
('Westside Branch', 'Mombasa', 254701234567, '1995-09-10'),
('Eastside Branch', 'Kisumu', 254723456789, '2005-01-15');

-- 2. Seed Librarian (5 rows) - FK: library_id from above (1 to 3)
INSERT INTO librarian (library_id, librarian_number, librarian_firstname, librarian_lastname, librarian_email, librarian_contact, gender, hire_date) VALUES
(1, 'LIB1001', 'Alice', 'Mwangi', 'alice.mwangi@example.com', 254798765432, 'Female', '2010-06-01'),
(1, 'LIB1002', 'John', 'Otieno', 'john.otieno@example.com', 254712345670, 'Male', '2012-08-15'),
(2, 'LIB2001', 'Grace', 'Njeri', 'grace.njeri@example.com', 254723456780, 'Female', '2015-02-20'),
(2, 'LIB2002', 'Peter', 'Kariuki', 'peter.kariuki@example.com', 254701234560, 'Male', '2018-07-05'),
(3, 'LIB3001', 'Susan', 'Kamau', 'susan.kamau@example.com', 254734567890, 'Female', '2020-11-10');

-- 3. Seed Section (3 rows) - FK: library_id (1 to 3)
INSERT INTO section (section_name, library_id) VALUES
('Fiction', 1),
('Science', 2),
('Arts', 3);

-- 4. Seed Category (4 rows) - FK: section_id (1 to 3)
INSERT INTO category (section_id, category_name, category_description) VALUES
(1, 'Novels', 'Fictional stories and novels'),
(1, 'Short Stories', 'Collection of short stories'),
(2, 'Physics', 'Books related to Physics'),
(3, 'Painting', 'Books about painting and visual arts');

-- 5. Seed Subcategory (4 rows) - FK: category_id (1 to 4)
INSERT INTO subcategory (category_id, subcategory_name, subcategory_description) VALUES
(1, 'Contemporary Novels', 'Modern novels from 21st century'),
(1, 'Classic Novels', 'Novels from classic authors'),
(3, 'Quantum Physics', 'Books on quantum mechanics'),
(4, 'Watercolor', 'Techniques and guides on watercolor painting');

-- 6. Seed Rack (4 rows) - FK: subcategory_id (1 to 4)
INSERT INTO rack (subcategory_id) VALUES
(1),
(2),
(3),
(4);

-- 7. Seed Catalog (5 rows) - FK: rack_id (1 to 4), librarian_id (1 to 5)
INSERT INTO catalog
(rack_id, isbn, published_year, edition, language, book_name, book_description, book_type, librarian_id, date_added)
VALUES
(1, '978-3-16-148410-0', '2015-06-01', 1, 'English', 'Contemporary Society', 'A contemporary novel about society', 'BORROWABLE', 1, '2015-06-15'),
(2, '978-0-14-143951-8', '1990-01-10', 3, 'English', 'Classic 19th Century', 'A classic novel from 19th century', 'BORROWABLE', 2, '1990-02-01'),
(3, '978-0-19-850155-6', '2018-09-25', 2, 'English', 'Quantum Physics', 'Advanced quantum physics concepts', 'EXCLUSIVE', 3, '2018-10-01'),
(4, '978-1-234-56789-7', '2020-03-15', 1, 'English', 'Watercolor for Beginners', 'Watercolor techniques for beginners', 'DIGITAL', 4, '2020-03-20'),
(1, '978-1-86197-876-9', '2017-11-11', 1, 'English', 'Short Stories', 'Short stories collection', 'BORROWABLE', 5, '2017-11-30');

-- 8. Seed Author (5 rows)
INSERT INTO author (author_name, bio, nationality, birth_date) VALUES
('James Mwangi', 'Author of contemporary novels', 'Kenyan', '1970-01-15'),
('Jane Austen', 'Classic English novelist', 'British', '1775-12-16'),
('Richard Feynman', 'Renowned physicist and author', 'American', '1918-05-11'),
('Anna Smith', 'Watercolor artist and author', 'Canadian', '1980-07-22'),
('Mark Twain', 'Famous American writer', 'American', '1835-11-30');

-- 9. Seed Book_Author (5 rows) - FK: author_id (1 to 5), catalog_id (1 to 5)
INSERT INTO book_author (author_id, catalog_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- 10. Seed Book_Copy (7 rows) - FK: catalog_id (1 to 5)
INSERT INTO book_copy (catalog_id, copy_status, is_available, borrowed_date, due_date, book_condition) VALUES
(1, 'Good', TRUE, '2025-01-01', '2025-01-15', 'New'),
(1, 'Good', FALSE, '2025-04-01', '2025-04-15', 'Used'),
(2, 'Fair', TRUE, '2025-02-01', '2025-02-15', 'Used'),
(3, 'Excellent', TRUE, '2025-03-01', '2025-03-15', 'New'),
(4, 'Good', TRUE, '2025-01-10', '2025-01-25', 'New'),
(5, 'Fair', FALSE, '2025-03-10', '2025-03-20', 'Used'),
(5, 'Good', TRUE, '2025-04-05', '2025-04-20', 'New');

-- 11. Seed Borrower (5 rows)
INSERT INTO borrower (firstname, lastname, phone, borrower_email, address, is_a_member) VALUES
('Paul', 'Kimani', 254700111222, 'paul.kimani@example.com', 'Nairobi', TRUE),
('Mary', 'Wanjiku', 254701223344, 'mary.wanjiku@example.com', 'Mombasa', TRUE),
('James', 'Mwangi', 254702334455, 'james.mwangi@example.com', 'Kisumu', FALSE),
('Lucy', 'Achieng', 254703445566, 'lucy.achieng@example.com', 'Nakuru', TRUE),
('John', 'Kamau', 254704556677, 'john.kamau@example.com', 'Eldoret', FALSE);

-- 12. Seed Borrow_Log (5 rows) - FK: book_copy_id (1 to 7), borrower_id (1 to 5)
INSERT INTO borrow_log (book_copy_id, borrower_id, borrow_date, due_date, return_date, is_returned) VALUES
(1, 1, '2025-01-01', '2025-01-15', '2025-01-14', TRUE),
(2, 2, '2025-04-01', '2025-04-15', NULL, FALSE),
(3, 3, '2025-02-01', '2025-02-15', '2025-02-14', TRUE),
(6, 4, '2025-03-10', '2025-03-20', NULL, FALSE),
(7, 5, '2025-04-05', '2025-04-20', NULL, FALSE);

-- 13. Seed Penalty (2 rows) - FK: borrow_log_id (1 to 5)
INSERT INTO penalty (borrow_log_id, penalty_amount) VALUES
(2, 500),
(4, 1000);

-- 14. Seed Access_Granted (3 rows) - FK: catalog_id (1 to 5), librarian_id (1 to 5), book_copy_id (1 to 7), borrower_id (1 to 5)
INSERT INTO access_granted (catalog_id, librarian_id, book_copy_id, date_granted, due_date, borrower_id) VALUES
(1, 1, 1, '2025-01-01', '2025-01-15', 1),
(2, 2, 2, '2025-04-01', '2025-04-15', 2),
(5, 5, 7, '2025-04-05', '2025-04-20', 5);
