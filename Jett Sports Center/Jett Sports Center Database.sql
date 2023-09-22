-- Database of JettSportsCenter
CREATE DATABASE JettSC
GO
USE JettSC
GO

CREATE TABLE Staff (
	StaffID VARCHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(50) CHECK (LEN(StaffName) > 4) NOT NULL,
	StaffGender VARCHAR(10) CHECK (StaffGender LIKE 'Male' OR StaffGender LIKE 'Female') NOT NULL,
	StaffSalary INT CHECK (StaffSalary >= 1000000) NOT NULL,
);

CREATE TABLE Customer(
	CustomerID VARCHAR (5) PRIMARY KEY CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR (255) NOT NULL CHECK (LEN(CustomerName) > 2),
	CustomerAge INT NOT NULL CHECK (CustomerAge > 6),
	CustomerPhoneNumber VARCHAR(10) NOT NULL CHECK (LEN(CustomerPhoneNumber) = 10)
);

 CREATE TABLE Product (
    ProductID VARCHAR(5) PRIMARY KEY CHECK(ProductID LIKE 'PR[0-9][0-9][0-9]'),
    ProductName VARCHAR(255) CHECK(LEN(ProductName) >=4) NOT NULL,
    ProductPrice INT CHECK (ProductPrice >= 10000 AND ProductPrice <= 1000000) NOT NULL
)

CREATE TABLE SportsField (
    SportsFieldID VARCHAR(5) PRIMARY KEY CHECK(SportsFieldID LIKE 'SF[0-9][0-9][0-9]'),
    SportsFieldName VARCHAR(255) CHECK(SportsFieldName LIKE '% Field') NOT NULL,
    SportsFieldAddress VARCHAR(255) CHECK(SportsFieldAddress LIKE '% Street') NOT NULL,
    RentingFee INT CHECK (RentingFee >= 10000 AND RentingFee <= 100000) NOT NULL
)

CREATE TABLE [ProductTransactionHeader] (
    ProductTransactionID VARCHAR(5) PRIMARY KEY CHECK (ProductTransactionID LIKE 'PT[0-9][0-9][0-9]'),
    ProductTransactionDate DATE CHECK(YEAR(ProductTransactionDate) = YEAR(GETDATE())) NOT NULL,
    StaffID VARCHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    CustomerID VARCHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL
);

CREATE TABLE [ProductTransactionDetail] (
    ProductTransactionID VARCHAR(5) FOREIGN KEY REFERENCES ProductTransactionHeader(ProductTransactionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    ProductID VARCHAR(5) FOREIGN KEY REFERENCES Product(ProductID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    ProductQuantity INT CHECK(ProductQuantity >= 1) NOT NULL,
    PRIMARY KEY(ProductTransactionID, ProductID)
);

CREATE TABLE [RentalTransactionHeader] (
    RentalTransactionID VARCHAR(5) PRIMARY KEY CHECK (RentalTransactionID LIKE 'RT[0-9][0-9][0-9]'),
    RentalTransactionDate DATE CHECK(YEAR(RentalTransactionDate) = YEAR(GETDATE())) NOT NULL,
    StaffID VARCHAR(5) FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    CustomerID VARCHAR(5) FOREIGN KEY REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL
)

CREATE TABLE [RentalTransactionDetail] (
    RentalTransactionID VARCHAR(5) FOREIGN KEY REFERENCES RentalTransactionHeader(RentalTransactionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    SportsFieldID VARCHAR(5) FOREIGN KEY REFERENCES SportsField(SportsFieldID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    RentalLength INT CHECK(RentalLength >= 1) NOT NULL,
    PRIMARY KEY(RentalTransactionID, SportsFieldID)
)