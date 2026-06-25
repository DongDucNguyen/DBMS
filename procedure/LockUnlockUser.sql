CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_LockUnlockUser`(
    IN p_userId INT, IN p_lock BOOLEAN, OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM `user` WHERE id = p_userId;
    IF v_count = 0 THEN
        SET p_message = 'ERROR: Không tìm thấy tài khoản.';
    ELSE
        UPDATE `user` SET hasLocked = p_lock, updatedAt = NOW() WHERE id = p_userId;
        IF p_lock THEN
            SET p_message = CONCAT('SUCCESS: Đã khóa tài khoản userId = ', p_userId);
        ELSE
            SET p_message = CONCAT('SUCCESS: Đã mở khóa tài khoản userId = ', p_userId);
        END IF;
    END IF;
END