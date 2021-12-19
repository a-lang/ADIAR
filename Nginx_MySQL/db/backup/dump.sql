DROP PROCEDURE IF EXISTS syncTables;

DELIMITER $$
CREATE PROCEDURE syncTables()
BEGIN
        SELECT COUNT(*) INTO @records FROM ans;
        IF (@records <> 16777216) THEN
                SELECT "Invalid number of records. It's not safe to carry on" AS "";
        ELSE
                START TRANSACTION;
                SET autocommit = 0;
                SET unique_checks = 0;
                ALTER TABLE ans_tmp DISABLE KEYS;
                SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                DELETE FROM ans_tmp;
                DELETE FROM transfer_tmp;

                INSERT INTO ans_tmp SELECT * FROM ans;
                INSERT INTO transfer_tmp SELECT * FROM transfer;
                COMMIT;
        END IF;
END $$

CALL syncTables();
