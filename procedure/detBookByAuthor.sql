CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetBooksByAuthor`(IN p_authorId INT)
BEGIN
    SELECT b.id, b.name, b.thumbnailUrl, b.viewCount, b.releaseDate, b.approvalStatus,
        ROUND(AVG(cm.rating), 1) AS avgRating, COUNT(DISTINCT cm.id) AS totalReviews
    FROM books b
    JOIN authorsofbooks aob ON aob.BookId = b.id AND aob.AuthorId = p_authorId
    LEFT JOIN comments cm   ON cm.bookId = b.id
    WHERE b.approvalStatus = 'APPROVED' AND b.isHidden = FALSE
    GROUP BY b.id, b.name, b.thumbnailUrl, b.viewCount, b.releaseDate, b.approvalStatus
    ORDER BY b.viewCount DESC;
END