CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_AddNewBook`(
    IN p_name VARCHAR(500), IN p_description TEXT, IN p_thumbnailUrl TEXT,
    IN p_country VARCHAR(100), IN p_language VARCHAR(10), IN p_pageNumber INT,
    IN p_releaseDate INT, IN p_ebookFileUrl TEXT, IN p_audioFileUrl TEXT,
    IN p_copyrightUrl TEXT, IN p_authorId INT, IN p_categoryId INT,
    IN p_submittedBy INT, OUT p_newBookId INT, OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN ROLLBACK; SET p_newBookId = -1; SET p_message = 'ERROR: Không thể thêm sách.'; END;
    START TRANSACTION;
        INSERT INTO books (name, description, thumbnailUrl, country, language, pageNumber,
            releaseDate, ebookFileUrl, audioFileUrl, copyrightFileUrl, approvalStatus,
            isHidden, submittedByUserId, viewCount, weeklyViewCount, createdAt, updatedAt)
        VALUES (p_name, p_description, p_thumbnailUrl, p_country, p_language, p_pageNumber,
            p_releaseDate, p_ebookFileUrl, p_audioFileUrl, p_copyrightUrl, 'PENDING',
            FALSE, p_submittedBy, 0, 0, NOW(), NOW());
        SET p_newBookId = LAST_INSERT_ID();
        IF p_authorId IS NOT NULL AND p_authorId > 0 THEN
            INSERT INTO authorsofbooks (AuthorId, BookId) VALUES (p_authorId, p_newBookId);
        END IF;
        IF p_categoryId IS NOT NULL AND p_categoryId > 0 THEN
            INSERT INTO categoriesofbooks (BookId, CategoryId) VALUES (p_newBookId, p_categoryId);
        END IF;
    COMMIT;
    SET p_message = CONCAT('SUCCESS: Sách đã được nộp. ID = ', p_newBookId);
END