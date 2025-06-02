

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

CALL librarian_catalog('John');