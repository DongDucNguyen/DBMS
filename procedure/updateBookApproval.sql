CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UpdateBookApproval`(
    IN p_bookId INT, IN p_status ENUM('APPROVED','REJECTED','PENDING'),
    IN p_adminId INT, OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM books WHERE id = p_bookId;
    IF v_count = 0 THEN
        SET p_message = 'ERROR: Không tìm thấy sách với ID này.';
    ELSE
        UPDATE books SET approvalStatus = p_status, updatedAt = NOW() WHERE id = p_bookId;
        SET p_message = CONCAT('SUCCESS: Đã cập nhật trạng thái sách ', p_bookId, ' → ', p_status);
    END IF;
END