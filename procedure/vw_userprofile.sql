CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_userprofile` AS
    SELECT 
        `u`.`id` AS `userId`,
        `u`.`username` AS `username`,
        `u`.`firstName` AS `firstName`,
        `u`.`lastName` AS `lastName`,
        CONCAT(`u`.`firstName`, ' ', `u`.`lastName`) AS `fullName`,
        `u`.`email` AS `email`,
        `u`.`emailVerifiedAt` AS `emailVerifiedAt`,
        `u`.`phoneNumber` AS `phoneNumber`,
        `u`.`addresses` AS `addresses`,
        `u`.`birthday` AS `birthday`,
        `u`.`thumbnailUrl` AS `thumbnailUrl`,
        `u`.`hasLocked` AS `hasLocked`,
        `u`.`loginFailedAttempts` AS `loginFailedAttempts`,
        `u`.`createdAt` AS `userCreatedAt`,
        `u`.`roleId` AS `roleId`,
        `r`.`name` AS `roleName`,
        `us`.`planId` AS `currentPlanId`,
        `sp`.`name` AS `currentPlanName`,
        `sp`.`price` AS `planPrice`,
        `us`.`startDate` AS `subStartDate`,
        `us`.`endDate` AS `subEndDate`,
        `u`.`authorId` AS `authorId`,
        `a`.`firstName` AS `authorFirstName`,
        `a`.`lastName` AS `authorLastName`
    FROM
        ((((`dbms_listenary`.`user` `u`
        JOIN `dbms_listenary`.`role` `r` ON (`r`.`id` = `u`.`roleId`))
        LEFT JOIN `dbms_listenary`.`usersubscriptions` `us` ON (`us`.`userId` = `u`.`id`
            AND `us`.`endDate` >= CURRENT_TIMESTAMP()))
        LEFT JOIN `dbms_listenary`.`subscriptionplans` `sp` ON (`sp`.`id` = `us`.`planId`))
        LEFT JOIN `dbms_listenary`.`author` `a` ON (`a`.`id` = `u`.`authorId`))