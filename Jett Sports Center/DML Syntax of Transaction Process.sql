-- JettSportsCenter's Query of Transactions Processes
INSERT INTO [RentalTransactionHeader]
VALUES
('RT016', '2022-04-10', 'ST011', 'CU010'),
('RT017', '2022-05-12', 'ST003', 'CU005'),
('RT018', '2022-04-19', 'ST001', 'CU003'),
('RT019', '2022-04-25', 'ST011', 'CU009'),
('RT021', '2022-12-13', 'ST013', 'CU013'),
('RT020', '2022-12-12', 'ST012', 'CU011'),
('RT023', '2022-12-15', 'ST002', 'CU002'),
('RT022', '2022-12-14', 'ST012', 'CU011')


INSERT INTO RentalTransactionDetail
VALUES
('RT016', 'SF003', 5),
('RT017', 'SF012', 6),
('RT018', 'SF009', 3),
('RT019', 'SF014', 10),
('RT021', 'SF006', 10),
('RT020', 'SF004', 3),
('RT023', 'SF017', 5),
('RT022', 'SF016', 4)

INSERT INTO ProductTransactionHeader (ProductTransactionID,ProductTransactionDate, StaffID, CustomerID) 
VALUES 
('PT016', '2022-04-28', 'ST003', 'CU008'),
('PT017', '2022-05-03', 'ST006', 'CU007'),
('PT018','2022-05-15', 'ST004', 'CU011'),
('PT019', '2022-06-02', 'ST003', 'CU015'),
('PT020','2022-06-12','ST001','CU001'),
('PT021', '2022-11-20', 'ST005', 'CU012'),
('PT022', '2022-07-08', 'ST008', 'CU001')

INSERT INTO ProductTransactionDetail(ProductTransactionID,ProductID, ProductQuantity) 
VALUES 
('PT016','PR014', 8),
('PT017','PR006', 7),
('PT018','PR011', 3),
('PT019','PR004', 5),
('PT020', 'PR003', 50),
('PT021', 'PR010', 60)