CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UserSubscribe`(
    IN p_userId INT, IN p_planId VARCHAR(20), IN p_paymentJson JSON, OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_duration INT;
    DECLARE v_endDate DATETIME;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; SET p_message = 'ERROR: Thanh toán thất bại.'; END;
    SELECT duration INTO v_duration FROM subscriptionplans WHERE id = p_planId;
    IF v_duration IS NULL THEN
        SET p_message = 'ERROR: Gói đăng ký không hợp lệ.';
    ELSE
        SET v_endDate = DATE_ADD(NOW(), INTERVAL v_duration DAY);
        START TRANSACTION;
            DELETE FROM usersubscriptions WHERE userId = p_userId;
            INSERT INTO usersubscriptions (userId, planId, startDate, endDate, paymentInfo)
            VALUES (p_userId, p_planId, NOW(), v_endDate, p_paymentJson);
        COMMIT;
        SET p_message = CONCAT('SUCCESS: Đăng ký gói ', p_planId, ' thành công đến ', v_endDate);
    END IF;
END