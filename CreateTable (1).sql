-- Active: 1701660512403@@127.0.0.1@3306@restaurant
DROP DATABASE IF EXISTS `restaurant`;
CREATE DATABASE `restaurant`;
USE `restaurant`;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `AREA`;
CREATE TABLE `AREA` (
	`Area_name` VARCHAR(255) NOT NULL UNIQUE,
	`Number_of_staff` INT NOT NULL,
    `Supervisor_ID` INT,
	PRIMARY KEY (`Area_name`)
);

DROP TABLE IF EXISTS `STAFF`;
CREATE TABLE `STAFF`(
	`Staff_ID` INT NOT NULL AUTO_INCREMENT,
    `Staff_name` VARCHAR(255) NOT NULL,
    `Staff_address` VARCHAR(255) NOT NULL,
    `Sphone` VARCHAR(255) NOT NULL,
    `Sex` VARCHAR(128) NOT NULL,
    `Area_name` VARCHAR(255),
    PRIMARY KEY (`Staff_ID`)
);

DROP TABLE IF EXISTS `INGREDIENT`;
CREATE TABLE `INGREDIENT`(
    `Ing_ID` INT NOT NULL AUTO_INCREMENT,
    `Ing_name` VARCHAR(255) NOT NULL,
    `Ing_unit` VARCHAR(255) NOT NULL,
    `Ing_description` VARCHAR(255) NOT NULL,
    `Remain_amount` INT NOT NULL,
    PRIMARY KEY (`Ing_ID`)
);

DROP TABLE IF EXISTS `SUPPLIER`;
CREATE TABLE `SUPPLIER`(
	`Supplier_ID` INT NOT NULL AUTO_INCREMENT,
	`Supplier_name` VARCHAR(255) NOT NULL,
    `Sup_address` VARCHAR(255) NOT NULL,
    `EMAIL` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`Supplier_ID`)
);

DROP TABLE IF EXISTS `SUPPLY_BILL`;
CREATE TABLE `SUPPLY_BILL`(
	`Sbill_ID` INT NOT NULL AUTO_INCREMENT,
    `Date_of_buying` DATETIME NOT NULL,
    `Total_payment` INT NOT NULL,
    `Staff_ID` INT NOT NULL,
    PRIMARY KEY (`Sbill_ID`),
    FOREIGN KEY (`Staff_ID`) REFERENCES `STAFF`(`Staff_ID`)
);

DROP TABLE IF EXISTS `BILL`;
CREATE TABLE `BILL`(
	Bill_ID INT NOT NULL AUTO_INCREMENT,
    Start_time DATETIME NOT NULL,
    End_time DATETIME NOT NULL,
    Num_of_people INT NOT NULL,
    Total_discount INT NOT NULL,
    Total_payment INT NOT NULL,
    Staff_ID INT NOT NULL,
    PRIMARY KEY (Bill_ID),
    FOREIGN KEY (Staff_ID) REFERENCES STAFF(`Staff_ID`)
);

DROP TABLE IF EXISTS `DISH`;
CREATE TABLE `DISH`(
	`Dish_ID` INT NOT NULL AUTO_INCREMENT,
    `Price` INT NOT NULL,
    `Category` VARCHAR(255) NOT NULL,
    `Dname` VARCHAR(255) NOT NULL,
    `Thumbnail` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`Dish_ID`)
);

DROP TABLE IF EXISTS `DISCOUNT`;
CREATE TABLE `DISCOUNT`(
	`Discount_ID` INT NOT NULL AUTO_INCREMENT,
    `Discount_value` INT NOT NULL,
    `Start_time` datetime NOT NULL,
    `End_time` datetime NOT NULL,
    `Dish_ID` INT NOT NULL,
    PRIMARY KEY (`Discount_ID`),
    FOREIGN KEY (`Dish_ID`) REFERENCES `DISH`(`Dish_ID`)
);

DROP TABLE IF EXISTS `BOOKING`;
CREATE TABLE `BOOKING`(
	`Booking_ID` INT NOT NULL AUTO_INCREMENT,
    `Customer_name` VARCHAR(255) NOT NULL,
    `Phone` VARCHAR(16) NOT NULL,
    `Appointment_time` DATETIME NOT NULL,
    `Number_of_table` INT NOT NULL,
    PRIMARY KEY (`Booking_ID`)
);

DROP TABLE IF EXISTS `REPORT`;
CREATE TABLE `REPORT`(
    `Report_ID` INT NOT NULL AUTO_INCREMENT,
    `Real_amount` INT NOT NULL,
    `Ing_ID` INT NOT NULL,
    `Staff_ID` INT NOT NULL,
    `Report_date` DATE NOT NULL,
    PRIMARY KEY (`Report_ID`),
    FOREIGN KEY (`Ing_ID`) REFERENCES `INGREDIENT`(`Ing_ID`),
    FOREIGN KEY (`Staff_ID`) REFERENCES `STAFF`(`Staff_ID`)
);

DROP TABLE IF EXISTS `SUPPLIER_PHONE`;
CREATE TABLE `SUPPLIER_PHONE`(
    `Supplier_ID` INT NOT NULL,
	`Phone` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`Supplier_ID`, `Phone`)
);

DROP TABLE IF EXISTS `CUSTOMER`;
CREATE TABLE `CUSTOMER`(
	`Customer_ID` INT NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(255) NOT NULL,
    `Address` VARCHAR(255) NOT NULL,
    `Sex` VARCHAR(255) NOT NULL,
    `Birth_date` VARCHAR(255) NOT NULL,
    `Phone` VARCHAR(255) NOT NULL,
    `Rank` VARCHAR(255) NOT NULL,
    `Rank_ID` INT NOT NULL,
    `Points` INT NOT NULL,
    PRIMARY KEY(`Customer_ID`)
);

DROP TABLE IF EXISTS `TABLE_COMMON`;
CREATE TABLE `TABLE_COMMON`(
	`Table_ID` INT NOT NULL AUTO_INCREMENT,
    `Number_of_chairs` INT NOT NULL,
    `Status` VARCHAR(255) NOT NULL,
    `Max_People` INT NOT NULL,
    `Min_people` INT NOT NULL,
    `Area_name` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`Table_ID`)
);

DROP TABLE IF EXISTS `VIP_TABLE`;
CREATE TABLE `VIP_TABLE`(
	`Vtable_ID` INT NOT NULL,
    `Charges` BIGINT NOT NULL,
    PRIMARY KEY(`Vtable_ID`),
    FOREIGN KEY(`Vtable_ID`) REFERENCES `TABLE_COMMON`(`Table_ID`)
);

DROP TABLE IF EXISTS `NORMAL_TABLE`;
CREATE TABLE `NORMAL_TABLE`(
	`Ntable_ID` INT NOT NULL,
    `Time_limit` INT NOT NULL,
    PRIMARY KEY(`Ntable_ID`)
);

DROP TABLE IF EXISTS `SERVICE`;
CREATE TABLE `SERVICE`(
    `Service_ID` INT NOT NULL AUTO_INCREMENT,
    `Service_name` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`Service_ID`)
);

DROP TABLE IF EXISTS `VIP_TABLE_SERVICE`;
CREATE TABLE `VIP_TABLE_SERVICE`(
    `Vtable_ID` INT NOT NULL,
    `Service_ID` INT NOT NULL,
    PRIMARY KEY(`Vtable_ID`)
);

DROP TABLE IF EXISTS `RANK_DISCOUNT`;
CREATE TABLE `RANK_DISCOUNT`(
    `Rank` INT NOT NULL,
    `Discount` FLOAT NOT NULL
);

DROP TABLE IF EXISTS `SUPPLY`;
CREATE TABLE `SUPPLY`(
    `Sbill_ID` INT NOT NULL,
    `Supplier_ID` INT NOT NULL,
	`ing_ID` INT NOT NULL,
    `Price` INT NOT NULL,
    `Amount` INT NOT NULL,
    PRIMARY KEY (`Ing_ID`,`Supplier_ID`,`Sbill_ID`)
);

DROP TABLE IF EXISTS `DISH_INGREDIENTS`;
CREATE TABLE `DISH_INGREDIENTS`(
    `Dish_ID` INT NOT NULL,
	`Ing_ID` INT NOT NULL,
    `Amount` FLOAT NOT NULL,
    PRIMARY KEY(`Dish_ID`,`Ing_ID`)
);

DROP TABLE IF EXISTS `PAY`;
CREATE TABLE `PAY`(
	`Bill_ID` INT NOT NULL,
    `Customer_ID` INT NOT NULL,
    PRIMARY KEY(`Bill_ID`)
);

DROP TABLE IF EXISTS `BILL_TABLES`;
CREATE TABLE `BILL_TABLES`(
    `Bill_ID` INT NOT NULL,
	`Table_ID` INT NOT NULL,
    PRIMARY KEY (`Bill_ID`,`Table_ID`)
);

DROP TABLE IF EXISTS `BOOK`;
CREATE TABLE `BOOK`(
	`Booking_ID` INT NOT NULL,
    `Table_ID` INT NOT NULL,
    PRIMARY KEY(`Booking_ID`,`Table_ID`)
);

DROP TABLE IF EXISTS `BILL_DISHES`;
CREATE TABLE `BILL_DISHES`(
    `Bill_ID` INT NOT NULL,
	`Dish_ID` INT NOT NULL,
    `Amount` INT NOT NULL,
    PRIMARY KEY(`Bill_ID`,`Dish_ID`)
);


ALTER TABLE `AREA`
    ADD FOREIGN KEY (`Supervisor_ID`) REFERENCES `STAFF`(`Staff_ID`);

ALTER TABLE `STAFF`
    ADD FOREIGN KEY (`Area_name`) REFERENCES `AREA`(`Area_name`);

ALTER TABLE `SUPPLY`
    ADD CONSTRAINT `supply_ing_id` FOREIGN KEY (`Ing_ID`) REFERENCES `INGREDIENT`(`Ing_ID`),
    ADD CONSTRAINT `supplier_id` FOREIGN KEY (`Supplier_ID`) REFERENCES `SUPPLIER` (`Supplier_ID`),
    ADD CONSTRAINT `supply_bill_id` FOREIGN KEY (`Sbill_ID`) REFERENCES `SUPPLY_BILL` (`Sbill_ID`);

ALTER TABLE `DISH_INGREDIENTS`
    ADD CONSTRAINT `dish_ing_id` FOREIGN KEY (`Ing_ID`) REFERENCES `INGREDIENT` (`Ing_ID`),
    ADD CONSTRAINT `dish_id` FOREIGN KEY (`Dish_ID`) REFERENCES `DISH` (`Dish_ID`);

ALTER TABLE `PAY`
	ADD CONSTRAINT `pay_bill_id` FOREIGN KEY (`Bill_ID`) REFERENCES `BILL`(`Bill_ID`),
    ADD CONSTRAINT `pay_cus_id` FOREIGN KEY (`Customer_ID`) REFERENCES `CUSTOMER`(`Customer_ID`);

ALTER TABLE `BILL_TABLES`
	ADD CONSTRAINT `bill_table_id` FOREIGN KEY (`Table_ID`) REFERENCES `TABLE_COMMON`(`Table_ID`),
    ADD CONSTRAINT `bill_id` FOREIGN KEY (`Bill_ID`) REFERENCES `BILL`(`Bill_ID`);

ALTER TABLE `BOOK`
	ADD CONSTRAINT `booking_id` FOREIGN KEY (`Booking_ID`) REFERENCES `BOOKING`(`Booking_ID`),
    ADD CONSTRAINT `table_id` FOREIGN KEY (`Table_ID`) REFERENCES `TABLE_COMMON`(`Table_ID`);

ALTER TABLE `BILL_DISHES`
	ADD CONSTRAINT `bill_dish_id` FOREIGN KEY (`Dish_ID`) REFERENCES `DISH`(`Dish_ID`),
    ADD CONSTRAINT `dish_bill_id` FOREIGN KEY (`Bill_ID`) REFERENCES `BILL`(`Bill_ID`);

ALTER TABLE `SUPPLIER_PHONE`
	ADD CONSTRAINT `supplier_phone_id` FOREIGN KEY (`Supplier_ID`) REFERENCES `SUPPLIER` (`Supplier_ID`);

ALTER TABLE `VIP_TABLE_SERVICE`
    ADD CONSTRAINT `vip_table_service_id` FOREIGN KEY(`Service_ID`) REFERENCES `SERVICE`(`Service_ID`),
    ADD CONSTRAINT `vts_vtable_id` FOREIGN KEY(`Vtable_ID`) REFERENCES `VIP_TABLE`(`Vtable_ID`);

ALTER TABLE `TABLE_COMMON`
	ADD CONSTRAINT `tb_area_name` FOREIGN KEY (`Area_name`) REFERENCES `AREA`(`Area_name`);

ALTER TABLE `VIP_TABLE`
	ADD CONSTRAINT `vip_table_id` FOREIGN KEY (`Vtable_ID`) REFERENCES `TABLE_COMMON`(`Table_ID`);

ALTER TABLE `NORMAL_TABLE`
	ADD CONSTRAINT `normal_table_id` FOREIGN KEY (`Ntable_ID`) REFERENCES `TABLE_COMMON`(`Table_ID`);
    
ALTER TABLE `INGREDIENT` 
	MODIFY Remain_amount FLOAT;
ALTER TABLE `SUPPLY`
	MODIFY Amount FLOAT;
-- Thêm dữ liệu vào bảng AREA
INSERT INTO area (`Area_name`, `Number_of_staff`, `Supervisor_ID`) VALUES
    ('Khu lễ tân',         4,  15),
    ('Phòng chờ',          25, 10),
    ('Phòng quản lý',      30, 1),
    ('Nhà bếp',            20, 17),
    ('Phòng bảo trì',      17, 8),
    ('Phòng ăn A',         15, 13),
    ('Phòng ăn B',         15, 7),
    ('Phòng ăn VIP',       15, 2),
    ('Phòng event',        28, 19),
    ('Phòng dịch vụ',      22, 6),
    ('Khu vực ngoài trời', 23, 9);
SET FOREIGN_KEY_CHECKS = 1;

-- Thêm dữ liệu vào bảng STAFF
ALTER TABLE `STAFF`
	DROP CONSTRAINT `staff_ibfk_1`;

INSERT INTO staff (`Staff_name`, `Staff_address`, `Sphone`, `Sex`, `Area_name`) VALUES
    ('Trương Hoàng Nhật',    'KTX B',    '0905554869', 'Nam', 'Phòng quản lý'),
    ('Võ Ngọc Thành Nhân',   'KTX B',    '0905555432', 'Nam', 'Phòng ăn VIP'),
    ('Vũ Xuân Mai Trung',    'KTX A',    '0905556543', 'Nữ', 'Phòng chờ'),
    ('Nguyễn Thái Thời',     'KTX B',    '0905557654', 'Nữ', 'Khu lễ tân'),
    ('Kim Nhật Thành',       'KTX A',    '0905558765', 'Nam', 'Phòng ăn VIP'),
    ('Trần Thanh Trọng Tín', 'KTX A',    '0905559876', 'Nam', 'Phòng dịch vụ'),
    ('Lê Nguyễn Hải Đăng',   'KTX A',    '0905550987', 'Nam', 'Phòng ăn B'),
    ('Lê Nguyên Chương',     'Biên Hòa', '0905551098', 'Nam', 'Phòng bảo trì'),
    ('Nguyễn Minh Điềm',     'KTX A',    '0905552109', 'Nam', 'Khu vực ngoài trời'),
    ('Nguyễn Trung Vương',   'Thủ Đức',  '0905553210', 'Nữ', 'Phòng chờ'),
    ('Trần Anh Khoa',        'Biên Hòa', '0905551234', 'Nam', 'Phòng bảo trì'),
    ('Nguyễn Ngọc Khánh My', 'Quận 9',   '0905552345', 'Nữ', 'Nhà bếp'),
    ('Thái Ngọc Rạng',       'Quận 9',   '0905553456', 'Nam', 'Phòng ăn A'),
    ('Nguyễn Đức Anh Tuấn',  'Bcons',    '0905554567', 'Nam', 'Phòng event'),
    ('Bùi Phước Ban',        'KTX A',    '0905555678', 'Nam', 'Khu lễ tân'),
    ('Đoàn Minh Hiếu',       'Bcons',    '0905556789', 'Nam', 'Phòng quản lý'),
    ('Phạm Đức Thắng',       'Tân Bình', '0905557890', 'Nam', 'Nhà bếp'),
    ('Phạm Châu Thanh Tùng', 'KTX B',    '0905558901', 'Nam', 'Khu vực ngoài trời'),
    ('Phan Lê Nhật Minh',    'Quận 9',   '0905559012', 'Nam', 'Phòng event'),
    ('Lê Đình Huy',          'KTX A',    '0905550123', 'Nam', 'Phòng dịch vụ');

ALTER TABLE `STAFF`
    ADD foreign key (`Area_name`) references `AREA`(`Area_name`);

-- Thêm dữ liệu vào bảng INGREDIENT
INSERT INTO ingredient (`Ing_name`, `Ing_unit`, `Ing_description`, `Remain_amount`) VALUES
    ('Đường',       'Kg',   'Đường kính trắng',           30),
    ('Muối',        'Kg',   'Muối ăn tinh khiết',         16),
    ('Bơ',          'Hộp',  'Bơ nguyên chất',             80),
    ('Phô mai',     'Kg',   'Phô mai Cheddar',            10),
    ('Dầu ô liu',   'Chai', 'Dầu ô liu Extra Virgin',     50),
    ('Thịt gà',     'Kg',   'Thịt gà không xương',        20),
    ('Ba chỉ lợn',  'Kg',   'Ba chỉ lợn chất lượng cao',  17),
    ('Thịt bò xay', 'Kg',   'Bò xay đóng hộp chất lượng', 45),
    ('Tôm',         'Kg',   'Tôm tươi nhập khẩu',         5),
    ('Mực',         'Kg',   'Mực tươi',                   5),
    ('Bột mì',      'Kg',   'Bột mì đa dụng',             50),
    ('Bột nở',      'Gói',  'Bột nở không nhôm',          30),
    ('Mì ống',      'Gói',  'Mì ống nguyên hạt',          70),
    ('Mì gói',      'Gói',  'Mì Miliket không dầu',       150),
    ('Trứng',       'Quả',  'Trứng gà ta giàu protein',   50),
    ('Sữa',         'Lít',  'Sữa tươi',                   20),
    ('Vani',        'Chai', 'Chất tạo vani tinh khiết',   40),
    ('Chocolate',   'Kg',   'Chocolate chips ngọt vừa',   27),
    ('Tỏi',         'Kg',   'Tỏi tép lớn chất lượng',     10),
    ('Húng quế',    'Kg',   'Lá húng quế tươi',           15),
    ('Xà lách',     'Cây',  'Xà lách tươi',               35),
    ('Lá giang',    'Kg',   'Lá giang chất lượng',        12),
    ('Hành tây',    'Kg',   'Hành tây vàng',              7),
    ('Rau diếp',    'Kg',   'Rau diếp Iceberg',           15),
    ('Ớt chuông',   'Kg',   'Ớt chuông nhiều màu',        5),
    ('Cà chua',     'Kg',   'Cà chua Roma',               60),
    ('Bông cải',    'Kg',   'Bông cải xanh tươi',         20),
    ('Coca Cola',   'Chai', 'Nước giải khát Coca Cola',   250),
    ('Sprite',      'Chai', 'Nước giải khát Sprite',      180),
    ('Sting',       'Chai', 'Nước tăng lực Sting',        135),
    ('Bia',         'Lon',  'Bia Sài Gòn',                300),
    ('Nước suối',   'Chai', 'Nước suối Aquafina',         130),
    ('Nước mắm',    'Chai', 'Nước mắm Nam Ngư Đệ Nhị',    40),
    ('Dầu ăn',      'Kg',   'Dầu ăn Tường An',            30),
    ('Nước tương',  'Chai', 'Nước tương Tam Thái Tử',     60),
    ('Mắm nêm',     'Chai', 'Mắm nêm Dì Cẩn',             27),
    ('Tương ớt',    'Kg',   'Tương ớt Cholimex',          30),
    ('Nấm',         'Kg',   'Nấm hương cao cấp',          10),
    ('Mật ong',     'Lít',  'Mật ong rừng nguyên chất',   8),
    ('Gạo',         'Kg',   'Gạo hút chân không',         30);

-- Thêm dữ liệu vào bảng SUPPLIER
INSERT INTO supplier (`Supplier_name`, `Sup_address`, `EMAIL`) VALUES
    ('Công ty rau',       'Tp. Thủ Đức',        'thubabrvt@gmail.com'),
    ('Công ty mì',        'Tp. Thủ Đức',        'colusa@comifood.com'),
    ('Công ty hải sản',   'Q. Tân Phú',         'info@sacofoods.vn'),
    ('Công ty bánh kẹo',  'Q. Gò Vấp',          'ganafarmchocolate.com'),
    ('Công ty sữa',       'Biên Hòa, Đồng Nai', 'lothamilkco@gmail.com'),
    ('Công ty trứng',     'Tp. Thủ Đức',        'info@bahuan.vn'),
    ('Công ty thực phẩm', 'Q. 1',               'info@lasicilia.com.vn'),
    ('Công ty thịt',      'Q. 3',               'info@nguyenhafood.vn'),
    ('Công ty giải khát', 'Q. 7',               'info@thp.com.vn'),
    ('CÔNG ty phô mai',   'Q. Bình Thạnh',      'customerservice-vn@groupe-bel.com');

-- Thêm dữ liệu vào bảng SUPPLY_BILL
INSERT INTO supply_bill (`Date_of_buying`, `Total_payment`, `Staff_ID`) VALUES
    ('2023-07-03 10:15:00', 1550000,  12),
    ('2023-07-05 10:30:00', 24000000, 17),
    ('2023-08-03 10:45:00', 5700000,  5),
    ('2023-09-12 10:00:00', 5300000,  12),
    ('2023-09-12 10:45:00', 9000000,  2),
    ('2023-09-15 10:00:00', 900000,   7),
    ('2023-09-18 10:45:00', 12250000, 17),
    ('2023-10-02 10:15:00', 9700000,  2),
    ('2023-10-04 10:30:00', 4500000,  12),
    ('2023-10-10 10:00:00', 1250000,  17),
    ('2023-11-19 10:45:00', 450000,   5),
    ('2023-11-20 10:20:00', 16100000, 12),
    ('2023-11-25 10:00:00', 14280000, 2);

-- Thêm dữ liệu vào bảng BILL
INSERT INTO bill (Start_time, End_time, Num_of_people, Total_discount, Total_payment, Staff_ID) VALUES
    ('2023-03-23 14:00:00', '2023-03-23 15:30:00', 3,  0, 562000, 2),
    ('2023-07-18 17:00:00', '2023-07-18 19:00:00', 3,  15000, 419000, 13),
    ('2023-09-02 18:15:00', '2023-09-02 21:00:00', 6,  130000, 890000, 19),
    ('2023-09-02 19:00:00', '2023-09-02 22:00:00', 6,  160000, 1037000, 6),
    ('2023-10-03 18:00:00', '2023-10-03 21:30:00', 10, 0, 1472000, 5),
    ('2023-12-02 18:00:00', '2023-12-02 22:00:00', 12, 160000, 2372000, 19);

-- Thêm dữ liệu vào bảng DISH
INSERT INTO dish (`Price`, `Category`, `Dname`, `Thumbnail`) VALUES
    (59000,  'Món khai vị',     'Gỏi cuốn tôm thịt',        'goi_cuon_tom_thit.jpg'),
    (79000,  'Món khai vị',     'Salad rau diếp',           'salad_rau_diep.jpg'),
    (79000,  'Món khai vị',     'Salad cà chua',            'salad_ca_chua.jpg'),
    (59000,  'Món khai vị',     'Canh cà chua trứng',       'canh_ca_chua_trung.jpg'),
    (89000,  'Món chính',       'Mì Ý Bolognese',           'mi_y_bolognese.jpg'),
    (109000, 'Món chính',       'Mì Ý Carbonara',           'mi_y_carbonara.jpg'),
    (79000,  'Món chính',       'Salad trứng cao cấp',      'salad_trung_cao_cap.jpg'),
    (119000, 'Món chính',       'Thịt gà xào nấm',          'thit_ga_xao_nam.jpg'),
    (159000, 'Món chính',       'Lẩu gà lá giang',          'lau_ga_la_giang.jpg'),
    (179000, 'Món chính',       'Gà nướng mật ong',         'ga_nuong_mat_ong.jpg'),
    (39000,  'Món chính',       'Bánh mì gà nướng mật ong', 'banh_mi_ga_nuong_mat_ong.jpg'),
    (159000, 'Món chính',       'Pizza hải sản',            'pizza_hai_san.jpg'),
    (79000,  'Món chính',       'Cơm chiên hải sản',        'com_chien_hai_san.jpg'),
    (69000,  'Món chính',       'Mì xào hải sản',           'mi_xao_hai_san.jpg'),
    (19000,  'Món tráng miệng', 'Kem Chocolate',            'kem_chocolate.jpg'),
    (39000,  'Món tráng miệng', 'Bánh Chocolate Chip',      'banh_chocolate_chip.jpg'),
    (39000,  'Món tráng miệng', 'Bánh Mousse Chocolate',    'banh_mousse_chocolate.jpg'),
    (29000,  'Món tráng miệng', 'Bánh Flan Caramel',        'flan_caramel.jpg'),
    (69000,  'Món tráng miệng', 'Cheesecake Vani',          'cheesecake_vani.jpg'),
    (19000,  'Món tráng miệng', 'Kem vani Hạ Long',         'kem_vani_ha_long.jpg'),
    (15000,  'Nước giải khát',  'Coca Cola',                'coca-cola.jpg'),
    (15000,  'Nước giải khát',  'Sprite',                   'sprite.jpg'),
    (15000,  'Nước giải khát',  'Sting',                    'sting.jpg'),
    (20000,  'Nước giải khát',  'Bia Sài Gòn',              'bia-sai-gon.jpg'),
    (10000,  'Nước giải khát',  'Nước suối',                'nuoc-suoi.jpg');

-- Thêm dữ liệu vào bảng DISCOUNT
INSERT INTO discount (`Discount_value`, `Start_time`, `End_time`, `Dish_ID`) VALUES
    (30000, '2023-01-20 00:00:00', '2023-01-27 23:59:59', 10),
    (30000, '2023-02-27 00:00:00', '2023-03-01 23:59:59', 6),
    (10000, '2023-06-01 00:00:00', '2023-06-01 23:59:59', 1),
    (15000, '2023-07-15 00:00:00', '2023-07-30 23:59:59', 12),
    (20000, '2023-08-01 00:00:00', '2023-08-05 23:59:59', 6),
    (20000, '2023-09-01 00:00:00', '2023-09-03 23:59:59', 10),
    (10000, '2023-09-01 00:00:00', '2023-09-30 23:59:59', 6),
    (30000, '2023-09-02 00:00:00', '2023-09-02 23:59:59', 19),
    (10000, '2023-11-29 00:00:00', '2023-12-05 23:59:59', 18),
    (20000, '2023-12-01 00:00:00', '2023-12-05 23:59:59', 8);

-- Thêm dữ liệu vào bảng BOOKING
INSERT INTO booking (`Customer_name`, `Phone`, `Appointment_time`, `Number_of_table`) VALUES
    ('Hoàng Thị Hương',  '0945566778', '2023-01-12 19:00:00', 2),
    ('Bùi B',            '0990011223', '2023-03-10 20:00:00', 1),
    ('Lê Thị Thu Hà',    '0923344556', '2023-03-18 18:00:00', 3),
    ('Alexander K',      '0911122334', '2023-04-22 19:00:00', 1),
    ('Phạm Thị D',       '0934455667', '2023-05-05 18:30:00', 3),
    ('Đỗ Quang M',       '0933344556', '2023-05-08 18:30:00', 2),
    ('Trần Minh Hoàng',  '0912233445', '2023-06-20 19:30:00', 2),
    ('Hồ Văn N',         '0944455667', '2023-07-14 19:00:00', 1),
    ('Hải Dương Lê',     '0989900112', '2023-09-02 13:30:00', 2),
    ('Trần Minh G',      '0967899870', '2023-09-02 14:30:00', 1),
    ('Huỳnh Văn H',      '0975979001', '2023-09-02 15:00:00', 2),
    ('Nguyễn Lê F',      '0956243889', '2023-09-02 16:30:00', 1),
    ('Nguyễn Thị Hương', '0901122334', '2023-09-02 18:00:00', 1),
    ('Nông Văn L',       '0922233445', '2023-11-05 20:30:00', 1),
    ('Trần Văn Hùng',    '0901122335', '2023-12-10 21:00:00', 3),
    ('Ngọc Anh Đỗ',      '0956677889', '2023-12-22 19:30:00', 2),
    ('Phan Thị Hằng',    '0934455668', '2023-12-25 20:00:00', 1),
    ('Quốc Anh Trần',    '0978899001', '2023-12-30 18:30:00', 2),
    ('Lê Thanh Tâm',     '0945566779', '2023-12-31 19:00:00', 1);

-- Thêm dữ liệu vào bảng REPORT
INSERT INTO report (`Real_amount`, `Ing_ID`, `Staff_ID`, `Report_date`) VALUES
    (19,  6,  12, '2023-09-28'),
    (156, 14, 17, '2023-06-25'),
    (42,  6,  17, '2023-10-29'),
    (20,  11, 12, '2023-09-28'),
    (6,   10, 17, '2023-10-29'),
    (4,   17, 2,  '2023-11-30'),
    (23,  17, 7,  '2023-06-25'),
    (12,  18, 2,  '2023-07-26'),
    (11,  4,  5,  '2023-07-26'),
    (28,  1,  12, '2023-02-26'),
    (12,  4,  2,  '2023-11-30');

-- Thêm dữ liệu vào bảng SUPPLIER_PHONE
INSERT INTO supplier_phone (`Supplier_ID`, `Phone`) VALUES
    (1, '0933903109'),
    (2, '0338966835'),
    (2, '0337201423'),
    (3, '0338165488'),
    (3, '0944868800'),
    (4, '0335898090'),
    (4, '0335898091'),
    (5, '0313511328'),
    (6, '0906860759'),
    (7, '0902241338'),
    (8, '0913906653'),
    (8, '0913906654'),
    (9, '0898760066'),
    (9, '0898760067'),
    (10, '0335668842');

-- Thêm dữ liệu vào bảng CUSTOMER
INSERT INTO customer (`Name`, `Address`, `Sex`, `Birth_date`, `Phone`, `Rank`, `Rank_ID`, `Points`) VALUES
    ('Nguyễn Thị Thủy',  'Q. Tân Bình',   'Nữ',  '1987-06-25', '0967789002', 'Vàng',  1, 280),
    ('Nguyễn Văn Hoa',   'Q. Bình Thạnh', 'Nam', '1996-08-28', '0923344557', 'Vàng',  1, 270),
    ('Minh Anh Nguyễn',  'Q. 7',          'Nam', '1993-07-08', '0967788990', 'Vàng',  1, 260),
    ('Lê Thị Thu Hà',    'Q. 5',          'Nữ',  '1992-03-10', '0923344556', 'Vàng',  1, 250),
    ('Võ Văn Tuấn',      'Q. Tân Phú',    'Nam', '1993-04-18', '0978899113', 'Bạc',   2, 180),
    ('Bùi Ngọc Minh',    'Q. Bình Thạnh', 'Nam', '1988-09-10', '0956677890', 'Bạc',   2, 150),
    ('Phan Thị Hằng',    'Q. Tân Bình',   'Nữ',  '1997-03-05', '0934455668', 'Bạc',   2, 120),
    ('Quốc Anh Trần',    'Q. 8',          'Nam', '1991-02-14', '0978899001', 'Bạc',   2, 100),
    ('Đỗ Thị Mai',       'Q. Bình Thạnh', 'Nữ',  '1989-01-15', '0912233446', 'Bạc',   2, 180),
    ('Trần Thị Hồng',    'Q. 9',          'Nữ',  '1992-11-01', '0989900224', 'Bạc',   2, 150),
    ('Hoàng Thị Hương',  'Q. 3',          'Nữ',  '1995-06-12', '0945566778', 'Bạc',   2, 150),
    ('Thu Hà Vũ',        'Q. 1',          'Nữ',  '1986-10-18', '0990011233', 'Bạc',   2, 120),
    ('Lê Thanh Tâm',     'Q. Gò Vấp',     'Nam', '1995-12-20', '0945566779', 'Bạc',   2, 120),
    ('Nguyễn Thị Hương', 'Q. 10',         'Nữ',  '1990-05-15', '0901122334', 'Bạc',   2, 100),
    ('Trần Văn Hùng',    'Q. 10',         'Nam', '1994-04-02', '0901122335', 'Bạc',   2, 170),
    ('Hải Dương Lê',     'Q. 3',          'Nam', '1987-11-30', '0989900112', 'Bạc',   2, 150),
    ('Phạm Văn Tuấn',    'Q. 4',          'Nam', '1988-12-05', '0934235667', 'Đồng',  3, 80),
    ('Ngọc Anh Đỗ',      'Q. 1',          'Nam', '1998-09-25', '0956677889', 'Đồng',  3, 80),
    ('Trần Minh Hoàng',  'Q. 1',          'Nam', '1985-08-20', '0912233445', 'Đồng',  3, 50),
    ('Nguyễn Văn Đức',   'Q. Gò Vấp',     'Nam', '1986-07-15', '0990011335', 'Không', 0, 20);

-- Thêm dữ liệu vào bảng TABLE_COMMON
INSERT INTO table_common (`Number_of_chairs`, `Status`, `Max_People`, `Min_people`, `Area_name`) VALUES
    (2, 'Sẵn sàng',       2, 1, 'Phòng ăn VIP'),
    (8, 'Sẵn sàng',       8, 4, 'Phòng ăn VIP'),
    (4, 'Không sẵn sàng', 4, 2, 'Phòng ăn A'),
    (6, 'Sẵn sàng',       6, 4, 'Phòng ăn B'),
    (2, 'Sẵn sàng',       2, 1, 'Phòng event'),
    (6, 'Không sẵn sàng', 6, 2, 'Phòng event'),
    (2, 'Sẵn sàng',       2, 1, 'Phòng dịch vụ'),
    (2, 'Sẵn sàng',       2, 1, 'Phòng dịch vụ'),
    (4, 'Không sẵn sàng', 4, 2, 'Phòng dịch vụ'),
    (6, 'Sẵn sàng',       6, 4, 'Phòng dịch vụ'),
    (6, 'Không sẵn sàng', 6, 2, 'Phòng dịch vụ'),
    (8, 'Sẵn sàng',       8, 6, 'Phòng dịch vụ'),
    (4, 'Sẵn sàng',       4, 2, 'Phòng ăn A'),
    (4, 'Không sẵn sàng', 4, 2, 'Phòng ăn A'),
    (4, 'Sẵn sàng',       4, 1, 'Phòng ăn B'),
    (6, 'Không sẵn sàng', 6, 4, 'Phòng ăn B'),
    (6, 'Không sẵn sàng', 6, 4, 'Khu vực ngoài trời'),
    (8, 'Sẵn sàng',       8, 6, 'Khu vực ngoài trời'),
    (4, 'Không sẵn sàng', 4, 2, 'Phòng event'),
    (8, 'Không sẵn sàng', 8, 6, 'Phòng event');

-- Thêm dữ liệu vào bảng VIP_TABLE
INSERT INTO vip_table (`Vtable_ID`, `Charges`) VALUES
    (1, 50000),
    (2, 100000),
    (3, 50000),
    (4, 80000),
    (5, 120000),
    (6, 200000),
    (7, 120000),
    (8, 120000),
    (9, 150000),
    (10, 160000),
    (11, 160000),
    (12, 180000);

-- Thêm dữ liệu vào bảng NORMAL_TABLE
INSERT INTO normal_table (`Ntable_ID`, `Time_limit`) VALUES
    (13, 120),
    (14, 120),
    (15, 120),
    (16, 180),
    (17, 240),
    (18, 300),
    (19, 360),
    (20, 480);

-- Thêm dữ liệu vào bảng SERVICE
INSERT INTO service (`Service_name`) VALUES
    ('Không giới hạn thời gian'),
    ('Có nhân viên phục vụ riêng'),
    ('Hỗ trợ tổ chức sự kiện'),
    ('Xem phim trên màn hình chiếu'),
    ('Khu vui chơi cho trẻ em'),
    ('Nhạc acoustic'),
    ('Thực đơn đặc biệt');

-- Thêm dữ liệu vào bảng VIP_TABLE_SERVICE
INSERT INTO vip_table_service (`Vtable_ID`, `Service_ID`) VALUES
    (1, 1),
    (2, 1),
    (3, 2),
    (4, 2),
    (5, 3),
    (6, 3),
    (7, 4),
    (8, 4),
    (9, 5),
    (10, 6),
    (11, 6),
    (12, 7);

-- Thêm dữ liệu vào bảng RANK_DISCOUNT
INSERT INTO rank_discount (`Rank`, `Discount`) VALUES 
	(0, 0),
    (1, 0.15),
    (2,  0.10),
    (3, 0.05);

-- Thêm dữ liệu vào bảng SUPPLY
INSERT INTO supply (`Sbill_ID`, `Supplier_ID`, `ing_ID`, `Price`, `Amount`) VALUES
    (1,  1,  22, 3000,   50),
    (1,  1,  24, 3000,   50),
    (1,  1,  26, 30000,  30),
    (1,  1,  27, 35000,  10),
    (2,  8,  6,  40000,  100),
    (2,  8,  7,  80000,  100),
    (3,  10, 3,  10000,  300),
    (3,  10, 4,  90000,  30),
    (4,  7,  1,  7000,   150),
    (4,  7,  2,  5000,   100),
    (4,  7,  5,  150000, 25),
    (5,  4,  11, 10000,  100),
    (5,  4,  17, 20000,  100),
    (5,  4,  18, 120000, 50),
    (6,  4,  11, 10000,  50),
    (6,  4,  12, 2000,   200),
    (7,  2,  13, 25000,  250),
    (7,  2,  14, 2000,   3000),
    (8,  10, 3,  10000,  250),
    (8,  10, 4,  90000,  80),
    (9,  3,  9,  200000, 15),
    (9,  3,  10, 150000, 10),
    (10, 6,  15, 2500,   500),
    (11, 5,  16, 30000,  15),
    (12, 8,  7,  80000,  120),
    (12, 8,  8,  130000, 50),
    (13, 9,  28, 7000,   600),
    (13, 9,  29, 7000,   600),
    (13, 9,  30, 7000,   600),
    (13, 9,  32, 3500,   480);

-- Thêm dữ liệu vào bảng DISH_INGREDIENTS
INSERT INTO dish_ingredients (`Dish_ID`, `Ing_ID`, `Amount`) VALUES
    (1, 7, 0.1),    (1, 9, 0.09),   (1, 21, 0.5),   (1, 36, 0.1),
    (2, 7, 0.1),    (2, 15, 2),     (2, 21, 1),     (2, 23, 0.15),  (2, 24, 0.5),   (2, 26, 0.3),
    (3, 9, 0.05),   (3, 15, 2),     (3, 21, 1),     (3, 23, 0.15),  (3, 26, 0.6),
    (4, 2, 0.005),  (4, 15, 2),     (4, 26, 0.8),
    (5, 2, 0.005),  (5, 3, 0.01),   (5, 4, 0.05),   (5, 5, 0.01),   (5, 8, 0.2),    (5, 13, 0.5),  (5, 19, 0.01), (5, 20, 0.01),
    (6, 2, 0.005),  (6, 3, 0.01),   (6, 4, 0.05),   (6, 5, 0.01),   (6, 7, 0.2),    (6, 13, 0.5),  (6, 19, 0.01), (6, 20, 0.01),
    (7, 7, 0.1),    (7, 15, 4),     (7, 21, 1),     (7, 23, 0.15),  (7, 26, 0.5),
    (8, 2, 0.008),  (8, 3, 0.01),   (8, 6, 0.8),    (8, 19, 0.02),  (8, 23, 0.1),   (8, 34, 0.01), (8, 38, 0.2),
    (9, 2, 0.01),   (9, 6, 1),      (9, 22, 0.3),
    (10, 2, 0.01),  (10, 3, 0.05),  (10, 6, 2),     (10, 39, 0.08),
    (11, 2, 0.005), (11, 3, 0.03),  (11, 6, 0.5),   (11, 11, 0.3),  (11, 39, 0.02),
    (12, 1, 0.005), (12, 2, 0.01),  (12, 3, 0.01),  (12, 4, 0.25),  (12, 9, 0.2),   (12, 10, 0.15), 
    (12, 11, 0.25), (12, 12, 0.5),  (12, 23, 0.1),  (12, 25, 0.1),  (12, 26, 0.1),  (12, 37, 0.1),
    (13, 1, 0.005), (13, 2, 0.005), (13, 3, 0.01),  (13, 9, 0.15),  (13, 10, 0.15), (13, 15, 2), 
    (13, 19, 0.02), (13, 23, 0.05), (13, 26, 0.05), (13, 27, 0.05), (13, 34, 0.01), (13, 40, 0.2),
    (14, 1, 0.005), (14, 2, 0.005), (14, 3, 0.01),  (14, 9, 0.15),  (14, 10, 0.15), (14, 14, 2),
    (14, 15, 2),    (14, 19, 0.02), (14, 23, 0.05), (14, 26, 0.05), (14, 27, 0.05), (14, 34, 0.01),
    (15, 1, 0.05),  (15, 16, 0.1),  (15, 17, 0.05), (15, 18, 0.02),
    (16, 1, 0.05),  (16, 11, 0.02), (16, 12, 0.1),  (16, 16, 0.1),  (16, 17, 0.05), (16, 18, 0.02),
    (17, 1, 0.07),  (17, 12, 0.05), (17, 15, 1),    (17, 16, 0.1),  (17, 17, 0.05), (17, 18, 0.02),
    (18, 1, 0.05),  (18, 3, 0.01),  (18, 15, 1),    (18, 16, 0.15), (18, 17, 0.05),
    (19, 1, 0.05),  (19, 4, 0.05),  (19, 15, 1),    (19, 16, 0.05), (19, 17, 0.05),
    (20, 1, 0.05),  (20, 16, 0.1),  (20, 17, 0.05),
    (21, 28, 1),
    (22, 29, 1),
    (23, 30, 1),
    (24, 31, 1),
    (25, 32, 1);

-- Thêm dữ liệu vào bảng PAY
INSERT INTO pay (`Bill_ID`, `Customer_ID`) VALUES
    (1, 5),
    (3, 8),
    (4, 1),
    (6, 3);

-- Thêm dữ liệu vào bảng BILL_TABLES
INSERT INTO bill_tables (`Bill_ID`, `Table_ID`) VALUES
    (1, 2),
    (2, 13),
    (3, 6),
    (4, 10),
    (5, 1), (5, 2),
    (6, 19), (6, 20);

-- Thêm dữ liệu vào bảng BOOK
INSERT INTO book (`Booking_ID`, `Table_ID`) VALUES
    (1, 1),
    (1, 2),
    (2, 13),
    (3, 9),
    (3, 10),
    (3, 11),
    (4, 19),
    (5, 7),
    (5, 8),
    (5, 9),
    (6, 17),
    (6, 18),
    (7, 13),
    (7, 14),
    (8, 3),
    (9, 17),
    (9, 18),
    (10, 1),
    (11, 15),
    (11, 16),
    (12, 4),
    (13, 20),
    (14, 19),
    (15, 10),
    (15, 11),
    (15, 12),
    (16, 1),
    (16, 2),
    (17, 5),
    (18, 19),
    (18, 20),
    (19, 6);

-- Thêm dữ liệu vào bảng BILL_DISHES
INSERT INTO bill_dishes (`Bill_ID`, `Dish_ID`, `Amount`) VALUES
    (1, 3, 1), (1, 9, 1), (1, 10, 1), (1, 21, 3),
    (2, 1, 1), (2, 8, 1), (2, 12, 1), (2, 20, 3), (2, 21, 2),  (2, 25, 1),
    (3, 3, 2), (3, 6, 2), (3, 10, 1), (3, 13, 2), (3, 19, 3),  (3, 21, 3),  (3, 23, 1), (3, 24, 2),
    (4, 3, 2), (4, 4, 2), (4, 10, 2), (4, 14, 3), (4, 19, 4),  (4, 22, 3),  (4, 23, 1), (4, 25, 2),
    (5, 1, 2), (5, 9, 2), (5, 10, 2), (5, 14, 2), (5, 17, 10), (5, 23, 10),
    (6, 3, 4), (6, 4, 4), (6, 5,  4), (6, 8,  2), (6, 9,  2),  (6, 18, 12), (6, 24, 36);


SET FOREIGN_KEY_CHECKS = 0;
