CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `dbms_listenary`.`vw_platformdashboard` AS
    SELECT 
        (SELECT 
                COUNT(0)
            FROM
                `dbms_listenary`.`books`) AS `totalBooks`,
        (SELECT 
                COUNT(0)
            FROM
                `dbms_listenary`.`user`
            WHERE
                `dbms_listenary`.`user`.`roleId` = 2) AS `totalUsers`,
        (SELECT 
                COUNT(0)
            FROM
                `dbms_listenary`.`author`) AS `totalAuthors`,
        (SELECT 
                COUNT(0)
            FROM
                `dbms_listenary`.`books`
            WHERE
                `dbms_listenary`.`books`.`approvalStatus` = 'PENDING') AS `totalPendingBooks`,
        (SELECT 
                COALESCE(SUM(`dbms_listenary`.`books`.`viewCount`),
                            0)
            FROM
                `dbms_listenary`.`books`) AS `totalSystemViews`,
        (SELECT 
                COUNT(0)
            FROM
                `dbms_listenary`.`comments`) AS `totalComments`