CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_listeninghistory` AS
    SELECT 
        `lab`.`id` AS `historyId`,
        `lab`.`userId` AS `userId`,
        `lab`.`bookId` AS `bookId`,
        `lab`.`audioChapterId` AS `audioChapterId`,
        `lab`.`audioTimeline` AS `audioTimeline`,
        `lab`.`isFinished` AS `isFinished`,
        `lab`.`lastListenedAt` AS `lastListenedAt`,
        `b`.`name` AS `bookName`,
        `b`.`thumbnailUrl` AS `bookThumbnail`,
        CONCAT(`a`.`firstName`, ' ', `a`.`lastName`) AS `authorFullName`,
        `ac`.`chapterNumber` AS `chapterNumber`,
        `ac`.`name` AS `chapterName`,
        `ac`.`duration` AS `duration`
    FROM
        ((((`dbms_listenary`.`listeningaudiobook` `lab`
        JOIN `dbms_listenary`.`books` `b` ON (`b`.`id` = `lab`.`bookId`))
        LEFT JOIN `dbms_listenary`.`authorsofbooks` `aob` ON (`aob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`author` `a` ON (`a`.`id` = `aob`.`AuthorId`))
        LEFT JOIN `dbms_listenary`.`audiochapter` `ac` ON (`ac`.`id` = `lab`.`audioChapterId`))
    ORDER BY `lab`.`lastListenedAt` DESC