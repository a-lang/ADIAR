-- Change the DB name cc_raida as yours.
USE cc_raida;
INSERT INTO ans SELECT * FROM ans_tmp;
INSERT INTO transfer SELECT * FROM transfer_tmp;
