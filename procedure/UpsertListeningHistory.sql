CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_UpsertListeningHistory`(
    IN p_userId INT, IN p_bookId INT, IN p_chapterId INT,
    IN p_audioTimeline FLOAT, IN p_isFinished BOOLEAN, OUT p_message VARCHAR(255)
)
BEGIN
    DECLARE v_existing INT;
    SELECT COUNT(*) INTO v_existing FROM listeningaudiobook WHERE userId = p_userId AND bookId = p_bookId;
    IF v_existing > 0 THEN
        UPDATE listeningaudiobook
        SET audioChapterId = p_chapterId, audioTimeline = p_audioTimeline,
            isFinished = p_isFinished, lastListenedAt = NOW()
        WHERE userId = p_userId AND bookId = p_bookId;
        SET p_message = 'SUCCESS: Đã cập nhật lịch sử nghe.';
    ELSE
        INSERT INTO listeningaudiobook (userId, bookId, audioChapterId, audioTimeline, isFinished, lastListenedAt)
        VALUES (p_userId, p_bookId, p_chapterId, p_audioTimeline, p_isFinished, NOW());
        UPDATE books SET viewCount = viewCount + 1 WHERE id = p_bookId;
        SET p_message = 'SUCCESS: Đã thêm lịch sử nghe mới.';
    END IF;
END