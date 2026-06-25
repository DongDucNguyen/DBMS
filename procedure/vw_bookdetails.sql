CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_bookdetails` AS
    SELECT 
        `b`.`id` AS `bookId`,
        `b`.`name` AS `bookName`,
        `b`.`description` AS `description`,
        `b`.`thumbnailUrl` AS `thumbnailUrl`,
        `b`.`country` AS `country`,
        `b`.`language` AS `language`,
        `b`.`pageNumber` AS `pageNumber`,
        `b`.`releaseDate` AS `releaseDate`,
        `b`.`ebookFileUrl` AS `ebookFileUrl`,
        `b`.`audioFileUrl` AS `audioFileUrl`,
        `b`.`copyrightFileUrl` AS `copyrightFileUrl`,
        `b`.`viewCount` AS `viewCount`,
        `b`.`weeklyViewCount` AS `weeklyViewCount`,
        `b`.`approvalStatus` AS `approvalStatus`,
        `b`.`isHidden` AS `isHidden`,
        `b`.`submittedByUserId` AS `submittedByUserId`,
        `b`.`createdAt` AS `bookCreatedAt`,
        `b`.`updatedAt` AS `bookUpdatedAt`,
        `a`.`id` AS `authorId`,
        `a`.`firstName` AS `authorFirstName`,
        `a`.`lastName` AS `authorLastName`,
        CONCAT(`a`.`firstName`, ' ', `a`.`lastName`) AS `authorFullName`,
        `a`.`imagineUrl` AS `authorImageUrl`,
        `c`.`id` AS `categoryId`,
        `c`.`name` AS `categoryName`,
        `ph`.`id` AS `publishingHouseId`,
        `ph`.`name` AS `publishingHouseName`,
        ROUND(AVG(`cm`.`rating`), 1) AS `avgRating`,
        COUNT(DISTINCT `cm`.`id`) AS `totalReviews`
    FROM
        ((((((`dbms_listenary`.`books` `b`
        LEFT JOIN `dbms_listenary`.`authorsofbooks` `aob` ON (`aob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`author` `a` ON (`a`.`id` = `aob`.`AuthorId`))
        LEFT JOIN `dbms_listenary`.`categoriesofbooks` `cob` ON (`cob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`category` `c` ON (`c`.`id` = `cob`.`CategoryId`))
        LEFT JOIN `dbms_listenary`.`publishinghouse` `ph` ON (`ph`.`id` = `b`.`PublishingHouseId`))
        LEFT JOIN `dbms_listenary`.`comments` `cm` ON (`cm`.`bookId` = `b`.`id`))
    GROUP BY `b`.`id` , `b`.`name` , `b`.`description` , `b`.`thumbnailUrl` , `b`.`country` , `b`.`language` , `b`.`pageNumber` , `b`.`releaseDate` , `b`.`ebookFileUrl` , `b`.`audioFileUrl` , `b`.`copyrightFileUrl` , `b`.`viewCount` , `b`.`weeklyViewCount` , `b`.`approvalStatus` , `b`.`isHidden` , `b`.`submittedByUserId` , `b`.`createdAt` , `b`.`updatedAt` , `a`.`id` , `a`.`firstName` , `a`.`lastName` , `a`.`imagineUrl` , `c`.`id` , `c`.`name` , `ph`.`id` , `ph`.`name`