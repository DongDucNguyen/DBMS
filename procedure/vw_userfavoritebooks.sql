CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_userfavoritebooks` AS
    SELECT 
        `uf`.`userId` AS `userId`,
        `uf`.`bookId` AS `bookId`,
        `b`.`name` AS `bookName`,
        `b`.`thumbnailUrl` AS `thumbnailUrl`,
        `b`.`viewCount` AS `viewCount`,
        `b`.`approvalStatus` AS `approvalStatus`,
        `a`.`id` AS `authorId`,
        CONCAT(`a`.`firstName`, ' ', `a`.`lastName`) AS `authorFullName`,
        ROUND(AVG(`cm`.`rating`), 1) AS `avgRating`
    FROM
        ((((`dbms_listenary`.`userfavorites` `uf`
        JOIN `dbms_listenary`.`books` `b` ON (`b`.`id` = `uf`.`bookId`))
        LEFT JOIN `dbms_listenary`.`authorsofbooks` `aob` ON (`aob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`author` `a` ON (`a`.`id` = `aob`.`AuthorId`))
        LEFT JOIN `dbms_listenary`.`comments` `cm` ON (`cm`.`bookId` = `b`.`id`))
    WHERE
        `b`.`approvalStatus` = 'APPROVED'
            AND `b`.`isHidden` = 0
    GROUP BY `uf`.`userId` , `uf`.`bookId` , `b`.`id` , `b`.`name` , `b`.`thumbnailUrl` , `b`.`viewCount` , `b`.`approvalStatus` , `a`.`id` , `a`.`firstName` , `a`.`lastName`