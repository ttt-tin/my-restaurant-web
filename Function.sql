-- Function to calculate the VIP table charge
DELIMITER //
DROP FUNCTION IF EXISTS calculate_charge//
CREATE FUNCTION calculate_charge(bill_id INT)
RETURNS INT
deterministic
BEGIN
	DECLARE charge INT;
    DECLARE total_charge INT;
    DECLARE so_mon INT;
    DECLARE so_nguoi INT;
    DECLARE so_nguoi_min INT;
    
    -- Calculate total surcharge unit price for VIP table
    SELECT SUM(vt.Charges) INTO charge
    FROM `BILL` b
    INNER JOIN `BILL_TABLES` bt ON b.Bill_ID = bt.Bill_ID
    INNER JOIN `VIP_TABLE` vt ON bt.Table_ID = vt.Vtable_ID
    WHERE b.Bill_ID = bill_id;
    -- Total number of dishes ordered
    SELECT SUM(
		bd.Amount
    )  INTO so_mon
    FROM `BILL` b
    JOIN `BILL_DISHES` bd ON b.Bill_ID = bd.Bill_ID
    WHERE b.Bill_ID = bill_id;
    -- Guest number
    SET so_nguoi = (SELECT Num_of_people FROM `BILL` b WHERE b.Bill_ID = bill_id);
    -- Calculate the surcharge amount if the number of dishes ordered is less than the number of people
    IF so_mon < so_nguoi THEN
     SET total_charge = (so_nguoi - so_mon)*charge;
	ELSE 
	 SET total_charge = 0;
	END IF;
    -- Get the minimum number of people for that table
    SELECT SUM(t.Min_people) into so_nguoi_min
					FROM `BILL` b
					INNER JOIN `BILL_TABLES` bt ON b.Bill_ID = bt.Bill_ID
					INNER JOIN `TABLE_COMMON` t ON bt.Table_ID = t.Table_ID
					WHERE b.Bill_ID = bill_id;
    -- Calculate the surcharge amount if the number of people is less than the minimum number
    IF so_nguoi < so_nguoi_min THEN
     SET total_charge = total_charge + (so_nguoi_min - so_nguoi)*charge;
	ELSE 
	 SET total_charge = total_charge;
	END IF;
    

    RETURN total_charge;
END//
DELIMITER ;
-- Function to check the status of a table
DELIMITER //
DROP FUNCTION IF EXISTS check_status//
CREATE FUNCTION check_status (ID_ban int) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE status_table VARCHAR(50);
  SET status_table = (SELECT status FROM table_common WHERE ID_ban = table_common.Table_ID);
  IF status_table = "Không sẵn sàng" THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END //
DELIMITER ;
