CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ToggleFavorite`(
    IN p_userId INT, IN p_bookId INT, OUT p_action VARCHAR(10), OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_existing INT;
    SELECT COUNT(*) INTO v_existing FROM userfavorites WHERE userId = p_userId AND bookId = p_bookId;
    IF v_existing > 0 THEN
        DELETE FROM userfavorites WHERE userId = p_userId AND bookId = p_bookId;
        SET p_action = 'REMOVED'; SET p_message = 'SUCCESS: Đã xóa khỏi danh sách yêu thích.';
    ELSE
        INSERT INTO userfavorites (userId, bookId) VALUES (p_userId, p_bookId);
        SET p_action = 'ADDED'; SET p_message = 'SUCCESS: Đã thêm vào danh sách yêu thích.';
    END IF;
END