CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_newestbooks` AS
    SELECT 
        `b`.`id` AS `bookId`,
        `b`.`name` AS `bookName`,
        `b`.`thumbnailUrl` AS `thumbnailUrl`,
        `b`.`releaseDate` AS `releaseDate`,
        `b`.`viewCount` AS `viewCount`,
        `b`.`createdAt` AS `createdAt`,
        `b`.`approvalStatus` AS `approvalStatus`,
        `b`.`isHidden` AS `isHidden`,
        `a`.`id` AS `authorId`,
        CONCAT(`a`.`firstName`, ' ', `a`.`lastName`) AS `authorFullName`,
        `c`.`name` AS `categoryName`
    FROM
        ((((`dbms_listenary`.`books` `b`
        LEFT JOIN `dbms_listenary`.`authorsofbooks` `aob` ON (`aob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`author` `a` ON (`a`.`id` = `aob`.`AuthorId`))
        LEFT JOIN `dbms_listenary`.`categoriesofbooks` `cob` ON (`cob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`category` `c` ON (`c`.`id` = `cob`.`CategoryId`))
    WHERE
        `b`.`approvalStatus` = 'APPROVED'
            AND `b`.`isHidden` = 0
            AND `b`.`thumbnailUrl` IS NOT NULL
            AND `b`.`thumbnailUrl` <> ''
    ORDER BY `b`.`createdAt` DESC , COALESCE(`b`.`releaseDate`, 0) DESC