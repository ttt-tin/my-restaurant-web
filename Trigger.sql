-- Trigger delete record in bill_dishes, bill_table and pay(optional)
DELIMITER //
DROP TRIGGER IF EXISTS `trigger_delete_bill`//
CREATE TRIGGER `trigger_delete_bill` BEFORE DELETE ON `bill` FOR EACH ROW
BEGIN
  DECLARE bill_id INT;
  SET bill_id = OLD.Bill_ID;

  DELETE FROM `bill_dishes` bd WHERE bd.`Bill_ID` = bill_id;
  DELETE FROM `bill_tables` bt WHERE bt.`Bill_ID` = bill_id;
  DELETE FROM `pay` p WHERE p.`Bill_ID` = bill_id;
END//
DELIMITER ;
-- Trigger updates total payment and total discount
DELIMITER //
DROP TRIGGER IF EXISTS update_bill_totals//
CREATE TRIGGER update_bill_totals
AFTER INSERT ON BILL_DISHES
FOR EACH ROW
BEGIN
  DECLARE total_payment INT;
  DECLARE total_discount INT;
  DECLARE percent FLOAT default 0;
  DECLARE charge INT;
  -- Calculate total price
  SET total_payment = (SELECT Total_Payment FROM `BILL` b WHERE b.Bill_ID = NEW.Bill_ID);
  SELECT SUM(d.Price * bd.Amount) INTO total_payment
  FROM BILL_DISHES bd
  INNER JOIN DISH d ON bd.Dish_ID = d.Dish_ID
  WHERE bd.Bill_ID = NEW.Bill_ID;
	-- Check if the bill is for VIP tables and calculate surcharges
  IF EXISTS (
  SELECT * 
  FROM BILL b 
  JOIN BILL_TABLES bt ON b.Bill_ID = bt.Bill_ID 
  JOIN VIP_TABLE vt ON bt.Table_ID = vt.Vtable_ID
  WHERE b.Bill_ID = NEW.Bill_ID
  )
  THEN
  -- Calculate total surcharge
	SELECT calculate_charge(NEW.Bill_ID) into charge;
  ELSE SET charge = 0;
  END IF;
  
  -- Calculate total discount
  SELECT SUM(
     bd.Amount* (
      CASE
        WHEN NOW() BETWEEN ds.Start_time AND ds.End_time
        THEN ds.Discount_value
        ELSE 0
      END
    )
  ) INTO total_discount
  FROM BILL_DISHES bd
  INNER JOIN DISH d ON bd.Dish_ID = d.Dish_ID
  LEFT JOIN DISCOUNT ds ON d.Dish_ID = ds.Dish_ID
  WHERE bd.Bill_ID = NEW.Bill_ID;
    -- Check if this invoice is paid by a member guest
	IF EXISTS (SELECT * FROM BILL b JOIN PAY p ON b.Bill_ID = p.Bill_ID WHERE b.Bill_ID = NEW.Bill_ID) THEN
    -- Get the discount percentage value
		SELECT rd.discount INTO percent
        FROM PAY p
        INNER JOIN CUSTOMER c ON p.Customer_ID = c.Customer_ID
        INNER JOIN RANK_DISCOUNT rd ON c.Rank_ID = rd.Rank
        WHERE p.Bill_ID = NEW.Bill_ID;
	-- Update discount value
    END IF;		
	SET total_payment = (total_payment+charge-total_discount)*(1-percent);
  -- Update the Total_payment and Total_discount values of the BILL table
  UPDATE BILL b SET b.Total_payment = total_payment, b.Total_discount = total_discount
  WHERE b.Bill_ID = NEW.Bill_ID;
END//
DELIMITER ;

-- Trigger updates total payment and total discount when delete a bill_dishes
DELIMITER //
DROP TRIGGER IF EXISTS update_bill_totals_delete//
CREATE TRIGGER update_bill_totals_delete
BEFORE DELETE ON BILL_DISHES
FOR EACH ROW
BEGIN
  DECLARE total_payment INT;
  DECLARE total_discount INT;
  DECLARE delete_discount INT default 0;
  DECLARE percent FLOAT default 0;
  DECLARE charge INT;
  DECLARE start_time DATETIME;
  DECLARE end_time DATETIME;
  SET total_payment = (SELECT b.Total_payment FROM BILL b WHERE b.Bill_ID = OLD.Bill_ID);
  SET total_discount = (SELECT b.Total_discount FROM BILL b WHERE b.Bill_ID = OLD.Bill_ID);
  SELECT b.Start_time, b.End_time INTO start_time, end_time
  FROM `BILL` b
  WHERE b.Bill_ID = OLD.Bill_ID;
  IF NOW() BETWEEN start_time AND end_time THEN
    SET total_payment = (SELECT b.Total_payment FROM `BILL` b WHERE b.Bill_ID = OLD.Bill_ID);            
      -- Check if this invoice is paid by a member guest
    IF EXISTS (SELECT * FROM BILL b JOIN PAY p ON b.Bill_ID = p.Bill_ID WHERE b.Bill_ID = OLD.Bill_ID) THEN
      -- Get the discount percentage value
      SELECT rd.discount INTO percent
          FROM PAY p
          INNER JOIN CUSTOMER c ON p.Customer_ID = c.Customer_ID
          INNER JOIN RANK_DISCOUNT rd ON c.Rank_ID = rd.Rank
          WHERE p.Bill_ID = OLD.Bill_ID; 
    -- Update discount value
    END IF;		
	  SET total_payment = (total_payment)/(1-percent) + (SELECT b.Total_discount FROM `BILL` b WHERE b.Bill_ID = OLD.Bill_ID);
    
    SELECT SUM(
      bd.Amount* (
        CASE
          WHEN NOW() BETWEEN ds.Start_time AND ds.End_time
          THEN ds.Discount_value
          ELSE 0
        END
      )
    ) into delete_discount
    FROM BILL_DISHES bd
    INNER JOIN DISH d ON bd.Dish_ID = d.Dish_ID
    INNER JOIN DISCOUNT ds ON d.Dish_ID = ds.Dish_ID
    WHERE bd.Bill_ID = OLD.Bill_ID AND bd.Dish_ID = OLD.Dish_ID;
    SET total_discount = total_discount - delete_discount;

  -- Update the Total_payment and Total_discount values of the BILL table
  END IF;
  -- Calculate total price
  SET total_payment = total_payment - (SELECT SUM(d.Price * bd.Amount)
		  FROM BILL_DISHES bd
		  INNER JOIN DISH d ON bd.Dish_ID = d.Dish_ID
		  WHERE bd.Bill_ID = OLD.Bill_ID AND bd.Dish_ID = OLD.Dish_ID);
	-- Check if the bill is for VIP tables and calculate surcharges
  IF EXISTS (
  SELECT * 
  FROM BILL b 
  JOIN BILL_TABLES bt ON b.Bill_ID = bt.Bill_ID 
  JOIN VIP_TABLE vt ON bt.Table_ID = vt.Vtable_ID
  WHERE b.Bill_ID = OLD.Bill_ID
  )
  THEN
  -- Calculate total surcharge
	SELECT calculate_charge(OLD.Bill_ID) into charge;
  ELSE SET charge = 0;
  END IF;
  
  -- Calculate total discount
  
  UPDATE BILL b 
  SET b.Total_payment = total_payment - charge, b.Total_discount = total_discount
  WHERE b.Bill_ID = OLD.Bill_ID;
END//
DELIMITER ;

-- CALL insert_bill('2023-12-09 14:00:00', '2023-12-09 16:00:00', 3,0, 0, 5);
-- 	
-- INSERT INTO `BILL_TABLES` VALUES (9,6);

-- INSERT INTO `BILL_DISHES` VALUES (9,6,2);

-- INSERT INTO PAY VALUES(9,17);

-- INSERT INTO `DISCOUNT` (Discount_value, Start_time, End_time, Dish_ID) VALUES (10000,'2023-12-08 00:00:00','2023-12-10 23:59:59',6);
-- INSERT INTO `BILL_DISHES` VALUES (8,6,2);
-- SELECT calculate_charge(1);

-- CALL delete_bill(8);



-- Trigger updates the total amount of the invertory and the quantity of ingredients each time a new ingredient is imported
DELIMITER //
DROP TRIGGER IF EXISTS update_supplybill //
CREATE TRIGGER update_supplybill
AFTER INSERT ON SUPPLY
FOR EACH ROW
BEGIN
	DECLARE total_payment INT;
    SET total_payment = 0;
    SELECT SUM(s.Price * s.Amount) INTO total_payment
    FROM SUPPLY s
    WHERE s.Sbill_ID = NEW.Sbill_ID;
    
    UPDATE SUPPLY_BILL sb
    SET sb.Total_payment = total_payment
    WHERE sb.Sbill_ID = NEW.Sbill_ID;
    
    UPDATE INGREDIENT ing
    SET ing.Remain_amount = ing.Remain_amount + NEW.Amount
    WHERE ing.Ing_ID = NEW.ing_ID;
END//
DELIMITER ;
-- Trigger update the ingredients when delete an ordered dish
DELIMITER //
DROP TRIGGER IF EXISTS update_ing_dish_delete //
CREATE TRIGGER update_ing_dish_delete
BEFORE DELETE ON BILL_DISHES
FOR EACH ROW
BEGIN
    DECLARE drop_amount FLOAT; -- amount of ingredients needed to prepare the dish
    DECLARE dish_amount INT;  -- quantity of the item ordered
    DECLARE num_ing INT;      -- number of ingredients needed to make that dish
    DECLARE Ing_ID int;
    DECLARE Amount FLOAT;
    DECLARE cursor_ing CURSOR FOR SELECT di.Ing_ID, di.Amount
				 FROM BILL_DISHES bd
                 INNER JOIN DISH_INGREDIENTS di ON bd.Dish_ID = di.Dish_ID
                 WHERE bd.Bill_ID = OLD.Bill_ID and bd.Dish_ID = OLD.Dish_ID;
	-- Calculate the number of ingredients needed to make the ordered dish
    SET num_ing = (SELECT COUNT(*)
				 FROM BILL_DISHES bd
                 INNER JOIN DISH_INGREDIENTS di ON bd.Dish_ID = di.Dish_ID
                 WHERE bd.Bill_ID = OLD.Bill_ID  and bd.Dish_ID = OLD.Dish_ID);
	-- Calculate the quantity of the ordered item
    SELECT bd.Amount into dish_amount
    FROM BILL_DISHES bd
    WHERE bd.Bill_ID = OLD.Bill_ID and bd.Dish_ID = OLD.Dish_ID;
    -- For each ingredient that makes up the dish, it will be repeated to subtract the amount of ingredients in inventory
    OPEN cursor_ing;
	read_loop: LOOP
		FETCH cursor_ing INTO Ing_ID, Amount;
		SET drop_amount = dish_amount * Amount;
		UPDATE INGREDIENT ing
		SET ing.Remain_amount = ing.Remain_amount + drop_amount
		WHERE ing.Ing_ID = Ing_ID;
        SET num_ing = num_ing -1;
		IF num_ing = 0 THEN
			leave read_loop;
		END IF;
    END LOOP;
END//
DELIMITER ;
-- Trigger updates the customer's accumulated points and rank every time he/she makes a payment
DELIMITER //
DROP TRIGGER IF EXISTS update_points//
CREATE TRIGGER update_points
AFTER INSERT ON PAY
FOR EACH ROW
BEGIN
	DECLARE points INT default 0;
    DECLARE c_points INT;
    SET points = (SELECT b.Total_payment 
					FROM BILL b 
                    INNER JOIN PAY p ON b.Bill_ID = p.Bill_ID
                    WHERE b.Bill_ID = NEW.Bill_ID
                    ) / 100000;
	
    UPDATE CUSTOMER c
    SET c.Points = c.Points + points
    WHERE c.Customer_ID = NEW.Customer_ID;
    
    SET c_points = (SELECT c.Points
					FROM CUSTOMER c
                    WHERE c.Customer_ID = NEW.Customer_ID);
    
    IF c_points >= 200 THEN
		UPDATE CUSTOMER c
        SET c.Rank = 'Vàng', c.Rank_ID = 1
        WHERE  c.Customer_ID = NEW.Customer_ID;
	ELSEIF c_points >=100 THEN
		UPDATE CUSTOMER c
        SET c.Rank = 'Bạc', c.Rank_ID = 2
        WHERE  c.Customer_ID = NEW.Customer_ID;
	ELSEIF c_points >=50 THEN
		UPDATE CUSTOMER c
        SET c.Rank = 'Đồng', c.Rank_ID = 3
        WHERE  c.Customer_ID = NEW.Customer_ID;
	ELSE 
		UPDATE CUSTOMER c
        SET c.Rank = 'Không', c.Rank_ID = 0
        WHERE  c.Customer_ID = NEW.Customer_ID;
	END IF;
END//

-- INSERT INTO SUPPLY VALUES (12,8,6,40000,40);

-- Trigger cập nhật nguyên liệu khi báo cáo nguyên liệu
DELIMITER //
DROP TRIGGER IF EXISTS update_ing_report //
CREATE TRIGGER update_ing_report
AFTER INSERT ON REPORT
FOR EACH ROW
BEGIN
	DECLARE real_amount FLOAT;
    SELECT r.Real_amount INTO real_amount
    FROM REPORT r
    WHERE r.Report_ID = NEW.Report_ID;
    
    UPDATE INGREDIENT ing
    SET ing.Remain_amount = NEW.Real_amount
    WHERE ing.Ing_ID = NEW.ing_ID;
END//
DELIMITER ;
-- Trigger updates ingredients when ordering an item
DELIMITER //
DROP TRIGGER IF EXISTS update_ing_dish //
CREATE TRIGGER update_ing_dish
AFTER INSERT ON BILL_DISHES
FOR EACH ROW
BEGIN
    DECLARE use_amount FLOAT; -- amount of ingredients needed to prepare the dish
    DECLARE dish_amount INT;  -- quantity of the item ordered
    DECLARE num_ing INT;      -- number of ingredients needed to make that dish
    DECLARE Ing_ID int;
    DECLARE Amount FLOAT;
    DECLARE cursor_ing CURSOR FOR SELECT di.Ing_ID, di.Amount
				 FROM BILL_DISHES bd
                 INNER JOIN DISH_INGREDIENTS di ON bd.Dish_ID = di.Dish_ID
                 WHERE bd.Bill_ID = NEW.Bill_ID and bd.Dish_ID = NEW.Dish_ID;
	-- Calculate the number of ingredients needed to make the ordered dish
    SET num_ing = (SELECT COUNT(*)
				 FROM BILL_DISHES bd
                 INNER JOIN DISH_INGREDIENTS di ON bd.Dish_ID = di.Dish_ID
                 WHERE bd.Bill_ID = NEW.Bill_ID  and bd.Dish_ID = NEW.Dish_ID);
	-- Calculate the quantity of the ordered item
    SELECT bd.Amount into dish_amount
    FROM BILL_DISHES bd
    WHERE bd.Bill_ID = NEW.Bill_ID and bd.Dish_ID = NEW.Dish_ID;
    -- For each ingredient that makes up the dish, it will be repeated to subtract the amount of ingredients in inventory
    OPEN cursor_ing;
	read_loop: LOOP
		FETCH cursor_ing INTO Ing_ID, Amount;
		SET use_amount = dish_amount * Amount;
		UPDATE INGREDIENT ing
		SET ing.Remain_amount = ing.Remain_amount - use_amount
		WHERE ing.Ing_ID = Ing_ID;
        SET num_ing = num_ing -1;
		IF num_ing = 0 THEN
			leave read_loop;
		END IF;
    END LOOP;
END//
DELIMITER ;

-- INSERT INTO REPORT (Real_amount, Ing_ID, Staff_ID, Report_date) VALUES (15, 7, 17, NOW());
-- INSERT INTO BILL_DISHES VALUES (9, 20, 10);

-- INSERT INTO discount (`Discount_value`, `Start_time`, `End_time`, `Dish_ID`) VALUES(10000, '2023-12-08 00:00:00', '2023-12-20 00:00:00', 6);
-- CALL insert_bill('2023-12-10 16:00:00', '2023-12-12 19:00:00', 3, 0,0,2);
-- INSERT INTO BILL_TABLES VALUES (12,2);
-- CALL Add_Bill_dishes(12,6,2);
-- CALL Add_Bill_dishes(12,1,2);

-- CALL Delete_Bill_dishes(12,6);

-- SELECT SUM(d.Price * bd.Amount)
-- 		  FROM BILL_DISHES bd
-- 		  INNER JOIN DISH d ON bd.Dish_ID = d.Dish_ID
-- 		  WHERE bd.Bill_ID = 12 AND bd.Dish_ID = 6

