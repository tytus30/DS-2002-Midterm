CREATE DATABASE `chinook_DW`;

USE chinook_DW;

#creating dimmension tables and fact table

CREATE TABLE `dim_customer` (
  `CustomerId` int NOT NULL,
  `FirstName` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LastName` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Company` varchar(80) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Address` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `City` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `State` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Country` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PostalCode` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Phone` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Fax` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Email` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SupportRepId` int DEFAULT NULL,
  PRIMARY KEY (`CustomerId`),
  KEY `IFK_CustomerSupportRepId` (`SupportRepId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE `dim_employee` (
  `EmployeeId` int NOT NULL,
  `LastName` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FirstName` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Title` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ReportsTo` int DEFAULT NULL,
  `BirthDate` datetime DEFAULT NULL,
  `HireDate` datetime DEFAULT NULL,
  `Address` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `City` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `State` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Country` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PostalCode` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Phone` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Fax` varchar(24) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Email` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`EmployeeId`),
  KEY `IFK_EmployeeReportsTo` (`ReportsTo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE `dim_track` (
  `TrackId` int NOT NULL,
  `Name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AlbumId` int DEFAULT NULL,
  `MediaTypeId` int NOT NULL,
  `GenreId` int DEFAULT NULL,
  `Composer` varchar(220) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Milliseconds` int NOT NULL,
  `Bytes` int DEFAULT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`TrackId`),
  KEY `IFK_TrackAlbumId` (`AlbumId`),
  KEY `IFK_TrackGenreId` (`GenreId`),
  KEY `IFK_TrackMediaTypeId` (`MediaTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE `dim_album` (
  `AlbumId` int NOT NULL,
  `Title` varchar(160) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ArtistId` int NOT NULL,
  PRIMARY KEY (`AlbumId`),
  KEY `IFK_AlbumArtistId` (`ArtistId`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



#combined the invoice and invoice line tables
CREATE TABLE `fact_invoice` ( 
  `fact_InvoiceId_key` int NOT NULL,
  `InvoiceLineId` int NOT NULL, #from invoiceline
  `TrackId` int NOT NULL, #from invoiceline
  `UnitPrice` decimal(10,2) NOT NULL, #from invoiceline
  `Quantity` int NOT NULL, #from invoiceline
  `CustomerId` int NOT NULL,
  `InvoiceDate` datetime NOT NULL,
  `BillingAddress` varchar(70) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BillingCity` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BillingState` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BillingCountry` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BillingPostalCode` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`fact_InvoiceId_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



#Populating the tables with data

#populate customer
INSERT INTO `chinook_dw`.`dim_customer`
(`CustomerId`,
`FirstName`,
`LastName`,
`Company`,
`Address`,
`City`,
`State`,
`Country`,
`PostalCode`,
`Phone`,
`Fax`,
`Email`,
`SupportRepId`)
SELECT `customer`.`CustomerId`,
    `customer`.`FirstName`,
    `customer`.`LastName`,
    `customer`.`Company`,
    `customer`.`Address`,
    `customer`.`City`,
    `customer`.`State`,
    `customer`.`Country`,
    `customer`.`PostalCode`,
    `customer`.`Phone`,
    `customer`.`Fax`,
    `customer`.`Email`,
    `customer`.`SupportRepId`
FROM `chinook`.`customer`;



#populate dim_employee
INSERT INTO `chinook_dw`.`dim_employee`
(`EmployeeId`,
`LastName`,
`FirstName`,
`Title`,
`ReportsTo`,
`BirthDate`,
`HireDate`,
`Address`,
`City`,
`State`,
`Country`,
`PostalCode`,
`Phone`,
`Fax`,
`Email`)
SELECT `employee`.`EmployeeId`,
    `employee`.`LastName`,
    `employee`.`FirstName`,
    `employee`.`Title`,
    `employee`.`ReportsTo`,
    `employee`.`BirthDate`,
    `employee`.`HireDate`,
    `employee`.`Address`,
    `employee`.`City`,
    `employee`.`State`,
    `employee`.`Country`,
    `employee`.`PostalCode`,
    `employee`.`Phone`,
    `employee`.`Fax`,
    `employee`.`Email`
FROM `chinook`.`employee`;



#populate dim_track
INSERT INTO `chinook_dw`.`dim_track`
(`TrackId`,
`Name`,
`AlbumId`,
`MediaTypeId`,
`GenreId`,
`Composer`,
`Milliseconds`,
`Bytes`,
`UnitPrice`)
SELECT `track`.`TrackId`,
    `track`.`Name`,
    `track`.`AlbumId`,
    `track`.`MediaTypeId`,
    `track`.`GenreId`,
    `track`.`Composer`,
    `track`.`Milliseconds`,
    `track`.`Bytes`,
    `track`.`UnitPrice`
FROM `chinook`.`track`;



#populate dim_album
INSERT INTO `chinook_dw`.`dim_album`
(`AlbumId`,
`Title`,
`ArtistId`)
SELECT `album`.`AlbumId`,
    `album`.`Title`,
    `album`.`ArtistId`
FROM `chinook`.`album`;



#populate fact_invoice
INSERT INTO `chinook_dw`.`fact_invoice`
(`fact_InvoiceId_key`,
`InvoiceLineId`,
`TrackId`,
`UnitPrice`,
`Quantity`,
`CustomerId`,
`InvoiceDate`,
`BillingAddress`,
`BillingCity`,
`BillingState`,
`BillingCountry`,
`BillingPostalCode`,
`Total`)
SELECT `invoice`.`InvoiceId`,
`invoiceline`.`InvoiceLineId`,
    `invoiceline`.`TrackId`,
    `invoiceline`.`UnitPrice`,
    `invoiceline`.`Quantity`,
    `invoice`.`CustomerId`,
    `invoice`.`InvoiceDate`,
    `invoice`.`BillingAddress`,
    `invoice`.`BillingCity`,
    `invoice`.`BillingState`,
    `invoice`.`BillingCountry`,
    `invoice`.`BillingPostalCode`,
    `invoice`.`Total`
    FROM `chinook`
    INNER JOIN `chinook`.`invoice` 
    ON `invoice`.`invoiceID` = `invoiceline`.`invoiceID`;
    
    
#FROM `chinook`.`invoice`;
#FROM `chinook`.`invoiceline`;







INSERT INTO `northwind_dw`.`fact_orders`
(`order_key`,
`employee_key`,
`customer_key`,
`product_key`,
`shipper_id`,
`ship_name`,
`ship_address`,
`ship_city`,
`ship_state_province`,
`ship_zip_postal_code`,
`ship_country_region`,
`quantity`,
`order_date`,
`shipped_date`,
`unit_price`,
`discount`,
`shipping_fee`,
`taxes`,
`payment_type`,
`paid_date`,
`tax_rate`,
`order_status`,
`order_details_status`)
SELECT `orders`.`id`,
`orders`.`employee_id`, 
`orders`.`customer_id`, 
`orders`.`product_id`, 
`orders`.`order_date`,
`orders`.`shipped_date`,
`orders`.`shipper_id`,
`orders`.`ship_name`,
`orders`.`ship_address`,
`orders`.`ship_city`,
`orders`.`ship_state_province`,
`orders`.`ship_zip_postal_code`,
`orders`.`ship_country_region`,
`orders`.`shipping_fee`,
`orders`.`paid_date`,
`order_details`.`quantity`,
`order_details`.`unit_price`,
`order_details`.`discount`,
`orders`.`tax_rate`,
`orders`.`tax_status_id`,
`order_status`.`status_name`,
`order_details_status`.`status_name`
FROM `northwind`
INNER JOIN `northwind`.`orders_status` 
ON `orders`.`status_id` = `order_status`.`id`
RIGHT OUTER JOIN `northwind`.`order_details`
ON `orders`.`id` = `order_details`.`order_id`
INNER JOIN `northwind`.`order_details_status`
ON `order_details`.`status_id` = `order_details_status`.`id`;
