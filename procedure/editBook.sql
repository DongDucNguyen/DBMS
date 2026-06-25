CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_EditBook`(
    IN p_bookId INT, IN p_userId INT, IN p_name VARCHAR(500),
    IN p_description TEXT, IN p_thumbnailUrl TEXT, OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_ownerId INT;
    SELECT submittedByUserId INTO v_ownerId FROM books WHERE id = p_bookId;
    IF v_ownerId != p_userId THEN
        SET p_message = 'ERROR: Bạn không có quyền chỉnh sửa cuốn sách này.';
    ELSE
        UPDATE books SET name = p_name, description = p_description,
            thumbnailUrl = p_thumbnailUrl, approvalStatus = 'PENDING', updatedAt = NOW()
        WHERE id = p_bookId;
        SET p_message = 'SUCCESS: Sách đã được cập nhật và tự động về trạng thái chờ duyệt.';
    END IF;
END