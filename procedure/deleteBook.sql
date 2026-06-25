CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_DeleteBook`(
    IN p_bookId INT, IN p_userId INT, IN p_roleId INT, OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_ownerId INT;
    SELECT submittedByUserId INTO v_ownerId FROM books WHERE id = p_bookId;
    IF v_ownerId != p_userId AND p_roleId != 1 THEN
        SET p_message = 'ERROR: Bạn không có quyền xóa cuốn sách này.';
    ELSE
        DELETE FROM listeningaudiobook WHERE bookId = p_bookId;
        DELETE FROM comments           WHERE bookId = p_bookId;
        DELETE FROM userfavorites      WHERE bookId = p_bookId;
        DELETE FROM audiochapter       WHERE bookId = p_bookId;
        DELETE FROM authorsofbooks     WHERE bookId = p_bookId;
        DELETE FROM categoriesofbooks  WHERE bookId = p_bookId;
        DELETE FROM books WHERE id = p_bookId;
        SET p_message = 'SUCCESS: Sách và dữ liệu liên kết đã bị xóa.';
    END IF;
END