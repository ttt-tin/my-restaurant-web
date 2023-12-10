
DELIMITER //
DROP PROCEDURE IF EXISTS TOP_STAFFS_OF_MONTH//
CREATE PROCEDURE TOP_STAFFS_OF_MONTH(IN monthday INT)
BEGIN
  SELECT 
	  s.Staff_name AS Name_of_staff, 
	  SUM(b.Total_payment) AS Total_revenue
  FROM 
	BILL AS b
  INNER JOIN 
	STAFF AS s ON b.Staff_ID = s.Staff_ID
  WHERE 
	monthday = MONTH(b.Start_time)
  GROUP BY s.Staff_ID
  ORDER BY Total_revenue DESC;
END //

DELIMITER ;
-- CALL TOP_STAFFS_OF_MONTH('09') ;

DELIMITER //
DROP PROCEDURE IF EXISTS DISH_ON_DISCOUNT//
CREATE PROCEDURE DISH_ON_DISCOUNT(IN today varchar(20))
BEGIN 
	SELECT  
		DISH.Dname AS Dish, 
        DISH.Price AS Origin_price, 
		D.Discount_value,
		(DISH.Price - D.Discount_value) AS Discount_price
    FROM 
		DISH 
    INNER JOIN 
		DISCOUNT AS D on DISH.Dish_ID = D.Dish_ID
    WHERE 
		today <= DATE(D.End_time) AND today >= DATE(D.Start_time)
	ORDER BY Discount_price DESC;
END //
DELIMITER ;

-- use restaurant;
-- CALL DISH_ON_DISCOUNT("2023-08-4"); 

DELIMITER //
DROP PROCEDURE IF EXISTS INGREDIENT_FROM_SUPPLIER//
CREATE PROCEDURE INGREDIENT_FROM_SUPPLIER
(
    IN name_ingredient VARCHAR(50),
    IN name_supplier VARCHAR(50)
)
BEGIN
	SELECT 
		S.Supplier_name AS Supplier,
		I.Ing_name AS Ingredient,
        SP.Amount,
        SP.Price,
        SB.Date_of_buying AS Buying_Date,
		(SP.Amount * SP.Price) AS Total_payment
	FROM Supplier AS S
	INNER JOIN Supply AS SP ON S.Supplier_ID = SP.Supplier_ID
	INNER JOIN Ingredient AS I ON SP.Ing_ID = I.Ing_ID
	INNER JOIN Supply_Bill AS SB ON SP.Sbill_ID = SB.Sbill_ID
	WHERE
 		(name_ingredient = I.Ing_name) AND (name_supplier = S.Supplier_name);
		
END //
DELIMITER ;
-- CALL INGREDIENT_FROM_SUPPLIER("Bơ","Công ty phô mai"); 