CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ResetWeeklyViews`(OUT p_message VARCHAR(255))
BEGIN
    UPDATE books SET weeklyViewCount = 0, updatedAt = NOW();
    SET p_message = 'SUCCESS: Đã làm mới số lượt xem tuần.';
END