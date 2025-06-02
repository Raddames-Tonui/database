

# 2. Generate a report of books that fall under a specific category or sub-category.
DELIMITER $$

CREATE PROCEDURE get_books_by_category_or_subcategory (
    IN category_or_subcategory_name VARCHAR(255)
)
BEGIN
    SELECT DISTINCT c.catalog_id, c.isbn, c.published_year, c.edition, c.language, c.book_description, c.book_type
    FROM catalog c
    INNER JOIN rack r ON c.rack_id = r.rack_id
    INNER JOIN subcategory sc ON r.subcategory_id = sc.subcategory_id
    INNER JOIN category cat ON sc.category_id = cat.category_id
    WHERE cat.category_name = category_or_subcategory_name
       OR sc.subcategory_name = category_or_subcategory_name;
END$$

DELIMITER ;


CALL get_books_by_category_or_subcategory('Novels');
CALL get_books_by_category_or_subcategory('Classic Novels');

# 3. Generate a report of books that belong to an author.
DELIMITER $$

CREATE PROCEDURE get_author_books(
    IN in_author_name VARCHAR(255)
)
BEGIN
    SELECT
        a.author_name,
        a.nationality,
        a.bio,
        c.book_name,
        c.book_description,
        c.book_type,
        c.edition
    FROM author a
    INNER JOIN book_author ba ON a.author_id = ba.author_id
    INNER JOIN catalog c ON ba.catalog_id = c.catalog_id
    WHERE a.author_name = in_author_name;
END $$

DELIMITER ;

CALL get_author_books('James Mwangi')

# 4. Generate a report of books added to the catalog by a librarian.

DELIMITER $$

CREATE PROCEDURE librarian_catalog(
    IN in_librarian_name VARCHAR(50)
)
BEGIN
    SELECT
        l.librarian_firstname,
        l.librarian_lastname,
        l.librarian_email,
        c.book_type,
        c.book_description,
        c.edition,
        c.language
    FROM librarian l
    INNER JOIN catalog c ON l.librarian_id = c.librarian_id
    WHERE l.librarian_firstname = in_librarian_name
       OR l.librarian_lastname = in_librarian_name;
END $$

DELIMITER ;

# ------------------------ Task Two: Library Management Part 2 ------------------------------------------
# 2. Generate a report of the history of access of an exclusive book by members.
DELIMITER $$

CREATE PROCEDURE GetExclusiveBookAccessHistory()
BEGIN
    SELECT
        ag.access_id,
        c.book_name,
        br.firstname,
        br.lastname,
        ag.date_granted,
        ag.due_date
    FROM access_granted ag
    JOIN catalog c ON ag.catalog_id = c.catalog_id
    JOIN borrower br ON ag.borrower_id = br.borrower_id
    WHERE c.book_type = 'EXCLUSIVE'
    ORDER BY ag.date_granted DESC;
END $$

DELIMITER ;

CALL GetExclusiveBookAccessHistory();

# 3. Generate a report of all the books that were borrowed between certain dates and the members who borrowed them.
DELIMITER $$

CREATE PROCEDURE GetBooksBorrowedBetweenDates(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT
        c.book_name,
        br.firstname,
        br.lastname,
        bl.borrow_date,
        bl.due_date,
        bl.return_date
    FROM borrow_log bl
    JOIN book_copy bc ON bl.book_copy_id = bc.book_copy_id
    JOIN catalog c ON bc.catalog_id = c.catalog_id
    JOIN borrower br ON bl.borrower_id = br.borrower_id
    WHERE bl.borrow_date BETWEEN start_date AND end_date
    ORDER BY bl.borrow_date;
END $$

DELIMITER ;

CALL GetBooksBorrowedBetweenDates('2025-01-01', '2025-06-01');


# 4. Generate a report of the number of copies remaining for books that have been borrowed.
DELIMITER $$

CREATE PROCEDURE GetCopiesStatus()
BEGIN
    SELECT
        c.book_name,
        COUNT(bc.book_copy_id) AS total_copies,
        SUM(CASE WHEN bc.is_available = TRUE THEN 1 ELSE 0 END) AS available_copies,
        SUM(CASE WHEN bc.is_available = FALSE THEN 1 ELSE 0 END) AS borrowed_copies
    FROM book_copy bc
    JOIN catalog c ON bc.catalog_id = c.catalog_id
    GROUP BY c.book_name;
END $$

DELIMITER ;


CALL GetCopiesStatus();

# 5. Generate a report of the members who have been penalized for not returning books before the deadlines.
DELIMITER $$

CREATE PROCEDURE GetPenalizedMembers()
BEGIN
    SELECT DISTINCT
        br.borrower_id,
        br.firstname,
        br.lastname,
        br.phone,
        IFNULL(p.penalty_amount, 0) AS penalty_amount,
        bl.due_date,
        bl.return_date,
        CASE
            WHEN bl.return_date IS NULL AND bl.due_date < CURRENT_DATE THEN 'Overdue - Not Returned'
            WHEN bl.return_date > bl.due_date THEN 'Returned Late'
            ELSE 'Returned On Time'
        END AS penalty_status
    FROM borrow_log bl
    JOIN borrower br ON bl.borrower_id = br.borrower_id
    LEFT JOIN penalty p ON p.borrow_log_id = bl.borrow_log_id
    WHERE (bl.return_date > bl.due_date)
       OR (bl.return_date IS NULL AND bl.due_date < CURRENT_DATE)
    ORDER BY br.lastname, br.firstname;
END $$

DELIMITER ;


CALL GetPenalizedMembers();


# 6. Generate a report of the borrowing history of a member, including any penalties incurred.
DELIMITER $$

CREATE PROCEDURE GetMemberBorrowingHistory(IN member_id BIGINT)
BEGIN
    SELECT
        b.firstname,
        b.lastname,
        b.is_a_member,
        b.phone,
        c.book_name,
        bl.borrow_date,
        bl.due_date,
        bl.return_date,
        COALESCE(p.penalty_amount, 0) AS penalty_amount
    FROM borrow_log bl
    JOIN borrower  b ON bl.borrower_id = b.borrower_id
    JOIN book_copy bc ON bl.book_copy_id = bc.book_copy_id
    JOIN catalog c ON bc.catalog_id = c.catalog_id
    LEFT JOIN penalty p ON bl.borrow_log_id = p.borrow_log_id
    WHERE bl.borrower_id = member_id
    ORDER BY bl.borrow_date DESC;
END $$

DELIMITER ;

CALL GetMemberBorrowingHistory(1);


# 7. Generate a report of the total revenue the library makes from penalties between certain dates.
DELIMITER $$

CREATE PROCEDURE GetPenaltyRevenue(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT
        start_date AS from_date,
        end_date AS to_date,
        IFNULL(SUM(p.penalty_amount), 0) AS total_penalty
    FROM penalty p
    JOIN borrow_log bl ON p.borrow_log_id = bl.borrow_log_id
    WHERE p.date_created BETWEEN start_date AND end_date;
END $$

DELIMITER ;


CALL GetPenaltyRevenue('2025-01-01', '2025-06-30');
