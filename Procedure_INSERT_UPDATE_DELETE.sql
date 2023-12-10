--  -- -- -- -- -- -- -- Procedure to insert, update, delete BILL_TABLES -- -- -- -- -- -- -- -- --
-- Procedure to add a new BILL_TABLES
DELIMITER //
DROP PROCEDURE IF EXISTS insert_bill_table//
CREATE PROCEDURE insert_bill_table(
	IN p_bill_ID INT,
    IN p_table_ID INT
)
BEGIN
	IF p_bill_ID IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không được để trống!';
	END IF;
    IF p_bill_ID < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn là một số nguyên dương!';
	END IF;
    IF NOT EXISTS (SELECT 1 FROM `BILL` b WHERE b.Bill_ID = p_bill_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không tồn tại!';
	END IF;
    IF p_table_ID IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn không được để trống!';
	END IF;
     IF p_table_ID < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn là một số nguyên dương!';
	END IF;
     IF NOT EXISTS (SELECT 1 FROM `TABLE_COMMON` tc WHERE tc.Table_ID = p_table_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn không tồn tại!';
	END IF;
    INSERT INTO `BILL_TABLES`(`Bill_ID`,`Table_ID`) VALUES (p_bill_ID,p_table_ID);
     SELECT 'Thêm bill_table vào hóa đơn thành công!' AS Message;
END//
DELIMITER ;

-- Procedure to update a BILL_TABLES
DELIMITER //
DROP PROCEDURE IF EXISTS update_bill_table//
CREATE PROCEDURE update_bill_table(
	IN p_bill_ID INT,
    IN p_table_ID INT,
    IN new_bill_ID INT,
    IN new_table_ID INT
)
BEGIN
	IF p_bill_ID IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không được để trống!';
	END IF;
    IF p_bill_ID < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn là một số nguyên dương!';
	END IF;
    IF NOT EXISTS (SELECT 1 FROM `BILL` b WHERE b.Bill_ID = p_bill_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không tồn tại!';
	END IF;
    IF p_table_ID IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn không được để trống!';
	END IF;
     IF p_table_ID < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn là một số nguyên dương!';
	END IF;
     IF NOT EXISTS (SELECT 1 FROM `TABLE_COMMON` tc WHERE tc.Table_ID = p_table_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn không tồn tại!';
	END IF;
    IF NOT EXISTS (SELECT 1 FROM `BILL_TABLES` bt WHERE bt.Bill_ID = p_bill_ID AND bt.Table_ID = p_table_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã BILL_TABLES không tồn tại!';
	END IF;
    UPDATE `BILL_TABLES` bt
    SET bt.Bill_ID = new_bill_ID, bt.Table_ID = new_table_ID
    WHERE bt.Bill_ID = p_bill_ID AND bt.Table_ID = p_table_ID;
    SELECT 'Chỉnh sửa bill_table thành công!' AS Message;
END//
DELIMITER ;

-- Procedure to delete a bill_tables
DELIMITER //
DROP PROCEDURE IF EXISTS delete_bill_table//
CREATE PROCEDURE delete_bill_table(
	IN p_bill_ID INT,
    IN p_table_ID INT
)
BEGIN
	IF p_bill_ID IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không được để trống!';
	END IF;
    IF p_bill_ID < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn là một số nguyên dương!';
	END IF;
    IF NOT EXISTS (SELECT 1 FROM `BILL` b WHERE b.Bill_ID = p_bill_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không tồn tại!';
	END IF;
    IF p_table_ID IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn không được để trống!';
	END IF;
     IF p_table_ID < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn là một số nguyên dương!';
	END IF;
     IF NOT EXISTS (SELECT 1 FROM `TABLE_COMMON` tc WHERE tc.Table_ID = p_table_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bàn không tồn tại!';
	END IF;
    IF NOT EXISTS (SELECT 1 FROM `BILL_TABLES` bt WHERE bt.Bill_ID = p_bill_ID AND bt.Table_ID = p_table_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã BILL_TABLES không tồn tại!';
	END IF;
    DELETE FROM `BILL_TABLES`
    WHERE bt.Bill_ID = p_bill_ID AND bt.Table_ID = p_table_ID;
    SELECT 'Xóa bill_table thành công!' AS Message;
END//
DELIMITER ;

--  -- -- -- -- -- -- -- Procedure to insert, update, delete BILL_DISHES -- -- -- -- -- -- -- -- --
-- Procedure add into BILL_DISHES
DELIMITER //
DROP PROCEDURE IF EXISTS Add_Bill_dishes//
CREATE PROCEDURE Add_Bill_dishes(
	IN p_bill_ID INT,
    IN p_dish_ID INT,
    IN p_amount INT
)
BEGIN
	IF p_bill_ID IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không được để trống!';
	END IF;
    IF p_dish_ID IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã món ăn không được để trống!';
	END IF;
    IF p_amount IS NULL THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Số lượng không được để trống!';
	END IF;
    IF p_bill_ID < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn là một số nguyên dương!';
	END IF;
    IF p_dish_ID < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã món ăn là một số nguyên dương!';
	END IF;
    IF p_amount < 0 THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Số lượng là một số nguyên dương!';
	END IF;
    IF NOT EXISTS (SELECT 1 FROM `BILL` b WHERE b.Bill_ID = p_bill_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không tồn tại!';
	END IF;
    IF NOT EXISTS (SELECT 1 FROM `DISH` d WHERE d.Dish_ID = p_dish_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không tồn tại!';
	END IF;
	INSERT INTO `BILL_DISHES` (`Bill_ID`, `Dish_ID`, `Amount`)
        VALUES (p_bill_ID, p_dish_ID, p_amount);
        SELECT 'Thêm món ăn vào hóa đơn thành công!' AS Message;
END//
DELIMITER ;
-- Procedure update BILL_DISHES

DELIMITER //
DROP PROCEDURE IF EXISTS Update_Bill_dishes//
CREATE PROCEDURE Update_Bill_dishes(
    IN p_bill_ID INT,
    IN p_dish_ID INT,
    IN p_new_amount INT
)
BEGIN
    IF p_bill_ID IS NULL OR p_dish_ID IS NULL THEN
        SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn và mã món ăn không được để trống!';
    END IF;
    
    IF p_new_amount IS NULL THEN
        SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Số lượng mới không được để trống!';
    END IF;
    
    IF p_new_amount < 0 THEN
        SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Số lượng mới phải là một số nguyên dương!';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM `BILL` b WHERE b.Bill_ID = p_bill_ID) THEN
        SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không tồn tại!';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM `DISH` d WHERE d.Dish_ID = p_dish_ID) THEN
        SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã món ăn không tồn tại!';
    END IF;
    
    UPDATE `BILL_DISHES`
    SET `Amount` = p_new_amount
    WHERE `Bill_ID` = p_bill_ID AND `Dish_ID` = p_dish_ID;
    
    SELECT 'Cập nhật thông tin thành công!' AS Message;
END//
DELIMITER ;

-- Procedure xóa BILL_DISHES

DELIMITER //
DROP PROCEDURE IF EXISTS Delete_Bill_dishes//
CREATE PROCEDURE Delete_Bill_dishes(
    IN p_bill_ID INT,
    IN p_dish_ID INT
)
BEGIN
	DECLARE percent FLOAT default 0;
    DECLARE new_charge INT;
    IF p_bill_ID IS NULL OR p_dish_ID IS NULL THEN
        SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn và mã món ăn không được để trống!';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM `BILL` b WHERE b.Bill_ID = p_bill_ID) THEN
        SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã hóa đơn không tồn tại!';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM `DISH` d WHERE d.Dish_ID = p_dish_ID) THEN
        SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã món ăn không tồn tại!';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM `BILL_DISHES` bd WHERE bd.Bill_ID = p_bill_ID AND bd.Dish_ID = p_dish_ID) THEN
		SIGNAL SQLSTATE '22000'
        SET MESSAGE_TEXT = 'Mã bill_dishes không tồn tại!';
    END IF;
    DELETE FROM `BILL_DISHES` bd
    WHERE bd.`Bill_ID` = p_bill_ID AND bd.`Dish_ID` = p_dish_ID;
    SELECT 'Xóa thông tin thành công!' AS Message;
    
-- 		UPDATE
    SET new_charge = calculate_charge(p_bill_ID);
    -- Check if this invoice is paid by a member guest
	IF EXISTS (SELECT * FROM BILL b JOIN PAY p ON b.Bill_ID = p.Bill_ID WHERE b.Bill_ID = p_bill_ID) THEN
    -- Get the discount percentage value
		SELECT rd.discount INTO percent
        FROM PAY p
        INNER JOIN CUSTOMER c ON p.Customer_ID = c.Customer_ID
        INNER JOIN RANK_DISCOUNT rd ON c.Rank_ID = rd.Rank
        WHERE p.Bill_ID = p_bill_ID; 
	-- Update discount value
    END IF;		
    UPDATE `BILL` b
    SET b.Total_payment = (b.Total_payment + new_charge)*(1-percent)
    WHERE b.Bill_ID = p_bill_ID;
END//
DELIMITER ;

--  -- -- -- -- -- -- -- Procedure to insert, update, delete BILL -- -- -- -- -- -- -- -- --

-- Thủ tục thêm hóa đơn mới
DELIMITER //
DROP PROCEDURE IF EXISTS `insert_bill`//
CREATE PROCEDURE `insert_bill`(
  IN `start_time` DATETIME,
  IN `end_time` DATETIME,
  IN `num_of_people` INT,
  IN `total_discount` INT,
  IN `total_payment` INT,
  IN `staff_id` INT
)
BEGIN

  -- Kiểm tra dữ liệu hợp lệ

  IF start_time IS NULL THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Thời gian bắt đầu không được để trống!';
  END IF;

  IF end_time IS NULL THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Thời gian kết thúc không được để trống!';
  END IF;

  IF num_of_people <= 0 THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Số lượng người phải lớn hơn 0!';
  END IF;

  IF total_discount < 0 THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Số tiền giảm giá phải lớn hơn hoặc bằng 0!';
  END IF;

  IF total_payment < 0 THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Số tiền thanh toán phải lớn hơn hoặc bằng 0!';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM `STAFF` WHERE `Staff_ID`= `staff_id`) THEN
    SIGNAL SQLSTATE '22000'
		SET MESSAGE_TEXT = 'Mã nhân viên không nằm trong cơ sở dữ liệu của hệ thống!';
  -- Thêm dữ liệu vào bảng
	END IF;
  INSERT INTO `BILL` (
    `start_time`,
    `end_time`,
    `num_of_people`,
    `total_discount`,
    `total_payment`,
    `staff_id`
  ) VALUES (
    `start_time`,
    `end_time`,
    `num_of_people`,
    `total_discount`,
    `total_payment`,
    `staff_id`
  );
  SELECT 'Thêm hóa đơn mới thành công!' AS Message;
END//
DELIMITER ;
-- Thủ tục cập nhật thông tin hóa đơn
DELIMITER //
DROP PROCEDURE IF EXISTS `update_bill` //
CREATE PROCEDURE `update_bill`(
  IN `bill_id` INT,
  IN `start_time` DATETIME,
  IN `end_time` DATETIME,
  IN `num_of_people` INT,
  IN `total_discount` INT,
  IN `total_payment` INT
)
BEGIN
  -- Kiểm tra dữ liệu hợp lệ
  IF bill_id IS NULL THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'ID hóa đơn không được để trống!';
  END IF;
  IF start_time IS NULL THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Thời gian bắt đầu không được để trống!';
  END IF;
  IF end_time IS NULL THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Thời gian kết thúc không được để trống!';
  END IF;
  IF num_of_people <= 0 THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Số lượng người phải lớn hơn 0!';
  END IF;

  IF total_discount < 0 THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Số tiền giảm giá phải lớn hơn hoặc bằng 0!';
  END IF;
  IF total_payment < 0 THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Số tiền thanh toán phải lớn hơn hoặc bằng 0!';
  END IF;

  -- Cập nhật dữ liệu vào bảng
  UPDATE `BILL`
  SET
    `start_time` = `start_time`,
    `end_time` = `end_time`,
    `num_of_people` = `num_of_people`,
    `total_discount` = `total_discount`,
    `total_payment` = `total_payment`
  WHERE
    `Bill_ID` = `bill_id`;
	SELECT 'Cập nhật thông tin hóa đơn thành công!' AS Message;
END;

-- Thủ tục xóa hóa đơn
DELIMITER //
DROP PROCEDURE IF EXISTS `delete_bill` //
CREATE PROCEDURE `delete_bill`(
  IN p_bill_id INT
)
BEGIN
  -- Kiểm tra dữ liệu hợp lệ
  IF p_bill_id IS NULL THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'ID hóa đơn không được để trống!';
  END IF;
  -- Kiểm tra hóa đơn có tồn tại hay không
  SELECT COUNT(*)
  FROM `BILL` b
  WHERE b.`Bill_ID` = p_bill_id;
  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '22000'
      SET MESSAGE_TEXT = 'Hóa đơn không tồn tại!';
  END IF;
  -- Xóa hóa đơn
  DELETE FROM `BILL` b
  WHERE b.`Bill_ID` = p_bill_id;
  SELECT 'Xóa hóa đơn thành công!' AS Message;
END//
DELIMITER ;

--  -- -- -- -- -- -- -- Procedure to insert, update, delete STAFF -- -- -- -- -- -- -- -- --
-- Thủ tục thêm nhân viên mới
DELIMITER //
DROP PROCEDURE IF EXISTS sp_InsertStaff //
CREATE PROCEDURE sp_InsertStaff(
    IN p_StaffName VARCHAR(255),
    IN p_StaffAddress VARCHAR(255),
    IN p_Sphone VARCHAR(255),
    IN p_Sex VARCHAR(128),
    IN p_AreaName VARCHAR(255)
)
BEGIN
    -- Kiểm tra dữ liệu hợp lệ
    IF LENGTH(p_StaffName) <= 0 THEN
        -- Thêm một nhân viên mới
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tên nhân viên không được bỏ trống';
    ELSEIF LENGTH(p_StaffAddress) <= 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Địa chỉ không được bỏ trống';
	ELSEIF LENGTH(p_Sphone) <= 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số điện thoại không được bỏ trống';
	ELSEIF LENGTH(p_Sphone) != 12 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số điện thoại là một ký tự có 10 chữ số theo định dạng: xxx-xxx-xxxx';
	ELSEIF EXISTS ( SELECT 1 FROM `STAFF` WHERE `Sphone` = p_Sphone ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Số điện thoại đã tồn tại';
	ELSEIF LENGTH(p_Sex) <= 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Giới tính không được bỏ trống';
	ELSEIF LENGTH(p_AreaName) <= 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Khu vực không được bỏ trống';
	ELSEIF NOT EXISTS (SELECT 1 FROM `AREA` WHERE `Area_name`= p_AreaName) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'p_Area không tồn tại trong AREA .';
	ELSE
		INSERT INTO `STAFF` (`Staff_name`, `Staff_address`, `Sphone`, `Sex`, `Area_name`)
        VALUES (p_StaffName, p_StaffAddress, p_Sphone, p_Sex, p_AreaName);
        SELECT 'Thêm nhân viên thành công!' AS Message;
    END IF;
END //
DELIMITER ;
call sp_InsertStaff('Lê Nguyễn Hải Đăng', 'Q8',  '090-555-0124', 'Nam', 'Phòng dịch vụ');
-- Thủ tục cập nhật thông tin nhân viên
DELIMITER //
DROP PROCEDURE IF EXISTS sp_UpdateStaff //
CREATE PROCEDURE sp_UpdateStaff(
	IN p_staff_ID INT,
    IN p_new_StaffAddress VARCHAR(255),
    IN p_new_Sphone VARCHAR(255),
    IN p_new_Name VARCHAR(255),
    IN p_new_AreaName VARCHAR(255)
)
BEGIN
    -- Kiểm tra dữ liệu hợp lệ
    IF LENGTH(p_new_Name) <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tên nhân viên không được bỏ trống';
    ELSEIF LENGTH(p_new_StaffAddress) <= 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Địa chỉ không được bỏ trống';
	ELSEIF LENGTH(p_new_Sphone) <= 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số điện thoại không được bỏ trống';
	ELSEIF LENGTH(p_new_Sphone) != 12 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số điện thoại là một ký tự có 10 chữ số theo định dạng: xxx-xxx-xxxx';
	ELSEIF EXISTS ( SELECT 1 FROM `STAFF` WHERE `Sphone` = p_new_Sphone ) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Số điện thoại đã tồn tại';
	ELSEIF LENGTH(p_new_AreaName) <= 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Khu vực không được bỏ trống';
	ELSEIF NOT EXISTS (SELECT 1 FROM `AREA` WHERE `Area_name`= p_new_AreaName) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'p_new_AreaName không tồn tại trong AREA .';
	ELSE
		UPDATE `STAFF` 
        SET `Staff_name` = p_new_Name,
			`Staff_address` = p_new_StaffAddress,
            `Sphone` = p_new_Sphone,
            `Area_name`= p_new_AreaName
		WHERE `Staff_ID` = p_Staff_ID;
        SELECT 'Chỉnh sửa thông tin nhân viên thành công!' AS Message;
    END IF;
END //
-- Thủ tục xóa nhân viên
DELIMITER //
DROP PROCEDURE IF EXISTS sp_DeleteStaff //
CREATE PROCEDURE sp_DeleteStaff(
	IN p_staff_ID INT
)
BEGIN
	-- Kiểm tra mã nhân viên có tồn tại hay không
	DECLARE staff_count INT;
    SELECT COUNT(*)
	FROM `STAFF`
	WHERE `Staff_ID` = p_staff_ID;
	IF ROW_COUNT() = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nhân viên không tồn tại!';
	END IF;
    -- Check if staff is managing an Area
    SET staff_count =0;
    SELECT COUNT(*) INTO staff_count FROM `Area` WHERE `Supervisor_ID` = p_staff_ID;
    IF staff_count = 0 THEN 
		SET FOREIGN_KEY_CHECKS = 0;
        DELETE FROM `STAFF` WHERE `Staff_ID` = p_staff_ID;
        SET FOREIGN_KEY_CHECKS = 1;
        SELECT 'Xóa nhân viên thành công!' AS Message;
    ELSE 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa nhân viên đang giám sát một khu vực!';
    END IF ;
END//
DELIMITER ;


