CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_pendingbooks` AS
    SELECT 
        `b`.`id` AS `bookId`,
        `b`.`name` AS `bookName`,
        `b`.`thumbnailUrl` AS `thumbnailUrl`,
        `b`.`description` AS `description`,
        `b`.`copyrightFileUrl` AS `copyrightFileUrl`,
        `b`.`approvalStatus` AS `approvalStatus`,
        `b`.`createdAt` AS `submittedAt`,
        `b`.`submittedByUserId` AS `submittedByUserId`,
        CONCAT(`u`.`firstName`, ' ', `u`.`lastName`) AS `submittedByName`,
        `u`.`username` AS `submittedByUsername`,
        `a`.`id` AS `authorId`,
        CONCAT(`a`.`firstName`, ' ', `a`.`lastName`) AS `authorFullName`,
        `c`.`name` AS `categoryName`
    FROM
        (((((`dbms_listenary`.`books` `b`
        LEFT JOIN `dbms_listenary`.`user` `u` ON (`u`.`id` = `b`.`submittedByUserId`))
        LEFT JOIN `dbms_listenary`.`authorsofbooks` `aob` ON (`aob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`author` `a` ON (`a`.`id` = `aob`.`AuthorId`))
        LEFT JOIN `dbms_listenary`.`categoriesofbooks` `cob` ON (`cob`.`BookId` = `b`.`id`))
        LEFT JOIN `dbms_listenary`.`category` `c` ON (`c`.`id` = `cob`.`CategoryId`))
    WHERE
        `b`.`approvalStatus` = 'PENDING'
    ORDER BY `b`.`createdAt` DESC