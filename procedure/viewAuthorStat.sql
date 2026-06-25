CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_authorstats` AS
    SELECT 
        `a`.`id` AS `authorId`,
        `a`.`firstName` AS `firstName`,
        `a`.`lastName` AS `lastName`,
        CONCAT(`a`.`firstName`, ' ', `a`.`lastName`) AS `fullName`,
        `a`.`imagineUrl` AS `imagineUrl`,
        `a`.`birthday` AS `birthday`,
        `a`.`description` AS `authorBio`,
        COUNT(DISTINCT `b`.`id`) AS `totalBooks`,
        COALESCE(SUM(`b`.`viewCount`), 0) AS `totalViews`,
        COALESCE(ROUND(AVG(`b`.`viewCount`), 0), 0) AS `avgViewsPerBook`,
        ROUND(AVG(`cm`.`rating`), 1) AS `avgRating`,
        COUNT(DISTINCT `cm`.`id`) AS `totalReviews`
    FROM
        (((`dbms_listenary`.`author` `a`
        LEFT JOIN `dbms_listenary`.`authorsofbooks` `aob` ON (`aob`.`AuthorId` = `a`.`id`))
        LEFT JOIN `dbms_listenary`.`books` `b` ON (`b`.`id` = `aob`.`BookId`
            AND `b`.`approvalStatus` = 'APPROVED'
            AND `b`.`isHidden` = 0))
        LEFT JOIN `dbms_listenary`.`comments` `cm` ON (`cm`.`bookId` = `b`.`id`))
    GROUP BY `a`.`id` , `a`.`firstName` , `a`.`lastName` , `a`.`imagineUrl` , `a`.`birthday` , `a`.`description`