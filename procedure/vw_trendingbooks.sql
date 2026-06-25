CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_trendingbooks` AS
    SELECT 
        `b`.`id` AS `bookId`,
        `b`.`name` AS `bookName`,
        `b`.`thumbnailUrl` AS `thumbnailUrl`,
        `b`.`description` AS `description`,
        `b`.`viewCount` AS `viewCount`,
        `b`.`weeklyViewCount` AS `weeklyViewCount`,
        `b`.`releaseDate` AS `releaseDate`,
        `b`.`country` AS `country`,
        `b`.`approvalStatus` AS `approvalStatus`,
        `a`.`id` AS `authorId`,
        CONCAT(`a`.`firstName`, ' ', `a`.`lastName`) AS `authorFullName`,
        `a`.`imagineUrl` AS `authorImageUrl`,
        `c`.`name` AS `categoryName`,
        ROUND(AVG(`cm`.`rating`), 1) AS `avgRating`,
        COUNT(DISTINCT `cm`.`id`) AS `totalReviews`
    FROM
        (((((`dbms_listenary`.`books` `b`
        LEFT JOIN `dbms_listenary`.`authorsofbooks` `aob` ON (`aob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`author` `a` ON (`a`.`id` = `aob`.`AuthorId`))
        LEFT JOIN `dbms_listenary`.`categoriesofbooks` `cob` ON (`cob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`category` `c` ON (`c`.`id` = `cob`.`CategoryId`))
        LEFT JOIN `dbms_listenary`.`comments` `cm` ON (`cm`.`bookId` = `b`.`id`))
    WHERE
        `b`.`approvalStatus` = 'APPROVED'
            AND `b`.`isHidden` = 0
    GROUP BY `b`.`id` , `b`.`name` , `b`.`thumbnailUrl` , `b`.`description` , `b`.`viewCount` , `b`.`weeklyViewCount` , `b`.`releaseDate` , `b`.`country` , `b`.`approvalStatus` , `a`.`id` , `a`.`firstName` , `a`.`lastName` , `a`.`imagineUrl` , `c`.`name`
    ORDER BY `b`.`viewCount` DESC