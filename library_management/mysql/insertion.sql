USE library_management;

-- 1. Insert the Single Library
INSERT INTO school_library (library_name, library_location, library_contact, established_year) VALUES
    ('Macmillan Memorial Library', 'Nairobi CBD', '0700123456', 1931);

-- 2. Librarians
INSERT INTO librarian (library_id, librarian_number, librarian_firstname, librarian_lastname, librarian_email, librarian_contact, gender, hire_date) VALUES
                                                                                                                                                         (1, 'MAC001', 'Janet', 'Omondi', 'janet.omondi@macmillan.org', '0700111000', 'Female', '2010-03-12'),
                                                                                                                                                         (1, 'MAC002', 'Eric', 'Mutua', 'eric.mutua@macmillan.org', '0700222000', 'Male', '2015-06-20'),
                                                                                                                                                         (1, 'MAC003', 'Linda', 'Wairimu', 'linda.wairimu@macmillan.org', '0700333000', 'Female', '2020-01-10');

-- 3. Sections
INSERT INTO section (section_name, library_id) VALUES
                                                   ('Science and Technology', 1),
                                                   ('Social Sciences', 1),
                                                   ('Literature and Fiction', 1);

-- 4. Categories
INSERT INTO category (section_id, category_name, category_description) VALUES
                                                                           (1, 'Physics', 'Fundamental and advanced physics books'),
                                                                           (1, 'Computer Science', 'Books on programming, AI, and systems'),
                                                                           (2, 'History', 'Books covering world and Kenyan history'),
                                                                           (3, 'African Literature', 'Works by African novelists and poets');

-- 5. Subcategories
INSERT INTO subcategory (category_id, subcategory_name, subcategory_description) VALUES
                                                                                     (1, 'Quantum Mechanics', 'Books focused on quantum physics and uncertainty'),
                                                                                     (2, 'Machine Learning', 'Introductory and advanced ML theory'),
                                                                                     (3, 'Kenyan History', 'Colonial and post-colonial Kenya'),
                                                                                     (4, 'Modern African Fiction', 'Post-independence African narratives');

-- 6. Racks
INSERT INTO rack (subcategory_id) VALUES
                                      (1), (2), (3), (4);

-- 7. Authors
INSERT INTO author (author_name, bio, nationality, birth_date) VALUES
                                                                   ('Dr. Achieng Okello', 'Physics researcher and lecturer at UoN', 'Kenyan', '1975-04-10'),
                                                                   ('Prof. Brian Mwangi', 'Computer Scientist and AI evangelist', 'Kenyan', '1980-09-23'),
                                                                   ('David Njoroge', 'Renowned Kenyan historian', 'Kenyan', '1965-12-05'),
                                                                   ('Ngũgĩ wa Thiong’o', 'Legendary Kenyan novelist and playwright', 'Kenyan', '1938-01-05');

-- 8. Catalog
INSERT INTO catalog (
    rack_id, isbn, published_year, edition, book_language, book_name, book_description, book_type, librarian_id, date_added
) VALUES
      (1, '9789966000011', 2016, 1, 'English', 'Quantum Basics', 'An introduction to quantum theory', 'BORROWABLE', 1, '2020-06-01'),
      (2, '9789966000028', 2019, 2, 'English', 'AI for Beginners', 'Understanding artificial intelligence', 'BORROWABLE', 2, '2021-01-15'),
      (3, '9789966000035', 2014, 1, 'English', 'Kenya: A Historical Perspective', 'A deep look at Kenyan history', 'BORROWABLE', 3, '2021-03-05'),
      (4, '9789966000042', 2020, 3, 'English', 'Petals of Blood', 'A novel about post-independence Kenya', 'EXCLUSIVE', 1, '2022-04-12');

-- 9. Book Author (1-to-many & many-to-many)
INSERT INTO book_author (author_id, catalog_id) VALUES
                                                    (1, 1),
                                                    (2, 2),
                                                    (3, 3),
                                                    (4, 4);

-- 10. Book Copies
INSERT INTO book_copy (catalog_id, copy_status, is_available, borrowed_date, due_date, book_condition) VALUES
                                                                                                           (1, 'GOOD', TRUE, NULL, NULL, 'New'),
                                                                                                           (1, 'GOOD', FALSE, '2025-06-01', '2025-06-15', 'Used'),
                                                                                                           (2, 'GOOD', TRUE, NULL, NULL, 'New'),
                                                                                                           (3, 'GOOD', TRUE, NULL, NULL, 'Good'),
                                                                                                           (4, 'GOOD', FALSE, '2025-07-01', '2025-07-20', 'Excellent');

-- 11. Borrowers
INSERT INTO borrower (firstname, lastname, phone, borrower_email, address, is_a_member) VALUES
                                                                                            ('Samuel', 'Koech', '0712345678', 'samuel.koech@reader.com', 'Nairobi West', TRUE),
                                                                                            ('Beatrice', 'Mumbi', '0718765432', 'beatrice.mumbi@reader.com', 'Kilimani', TRUE);

-- 12. Borrow Logs
INSERT INTO borrow_log (book_copy_id, borrower_id, borrow_date, due_date, return_date, is_returned) VALUES
                                                                                                        (2, 1, '2025-06-01', '2025-06-15', NULL, FALSE),
                                                                                                        (5, 2, '2025-07-01', '2025-07-20', NULL, FALSE);

-- 13. Penalties
INSERT INTO penalty (borrow_log_id, penalty_amount) VALUES
    (1, 200.00);

-- 14. Access Granted
INSERT INTO access_granted (catalog_id, librarian_id, book_copy_id, date_granted, due_date, borrower_id) VALUES
                                                                                                             (1, 1, 2, '2025-06-01', '2025-06-15', 1),
                                                                                                             (4, 1, 5, '2025-07-01', '2025-07-20', 2);
