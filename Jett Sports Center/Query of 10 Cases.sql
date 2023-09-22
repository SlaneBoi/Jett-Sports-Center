-- JettSportsCenter's Query of 10 Cases
-- 1
SELECT 
    [ProductID] = 'Product ID' + SUBSTRING(ptd.ProductID,CHARINDEX('R', ptd.ProductID)+1, LEN(ptd.ProductID) - CHARINDEX('R', ptd.ProductID)),
    [Total Item Sold] = CAST(SUM(ProductQuantity) AS VARCHAR) + ' Pcs' 
FROM 
    Product pr JOIN ProductTransactionDetail ptd on pr.ProductID = ptd.ProductID 
    JOIN ProductTransactionHeader pth ON ptd.ProductTransactionID = pth.ProductTransactionID
    JOIN Staff st ON pth.StaffID = st.StaffID
WHERE 
    StaffGender = 'Female' AND StaffSalary > 4000000
GROUP BY ptd.ProductID

-- 2
SELECT 
    ptd.ProductTransactionID, 
    [Total Product Type] = COUNT(ProductID)
FROM ProductTransactionDetail ptd 
JOIN ProductTransactionHeader pth ON ptd.ProductTransactionID = pth.ProductTransactionID
WHERE DATEPART(MONTH, ProductTransactionDate) >= 6
GROUP BY ptd.ProductTransactionID

-- 3
SELECT 
[Sports Field ID] = 'Sport Field ' + SUBSTRING(sf.SportsFieldID,3,5),
[Field Adress] = REPLACE(SportsFieldAddress,'Street','St.'),
[Highest Transaction] = 'Rp. ' + CONVERT(VARCHAR(100),MAX(RentingFee * RentalLength)),
[Lowest Transaction] = 'Rp. ' + CONVERT(VARCHAR(100),MIN(RentingFee * RentalLength))
FROM SportsField sf
JOIN RentalTransactionDetail rtd ON sf.SportsFieldID = rtd.SportsFieldID
WHERE RentingFee < 50000 AND CAST(SUBSTRING(sf.SportsFieldID,3,5) AS int) % 2 = 1
GROUP BY sf.SportsFieldID, SportsFieldAddress

-- 4
SELECT DISTINCT
sf.SportsFieldID,
[Staff Salary Deviation] = CONCAT('Rp. ',x.[Staff Salary Deviation]) 
FROM SportsField sf
JOIN RentalTransactionDetail rtd ON rtd.SportsFieldID = sf.SportsFieldID
JOIN RentalTransactionHeader rth ON rtd.RentalTransactionID = rth.RentalTransactionID
JOIN Staff st ON st.StaffID = rth.StaffID,
(SELECT 
[Staff Salary Deviation] = (MAX(StaffSalary) - MIN(StaffSalary))
FROM Staff) as x
WHERE [Staff Salary Deviation] >= 1000000 AND CONVERT(int,SUBSTRING(sf.SportsFieldID,CHARINDEX('SF',sf.SportsFieldID)+2,3)) % 2 != 0

-- 5
SELECT 
    [Staff Id] = LOWER(st.StaffID),
    [Staff Name] = UPPER(StaffName),
    [Staff Gender] = SUBSTRING(st.StaffGender, 1, 1),
    [Rental Transaction Id] = RentalTransactionID,
    [Customer Name] = CustomerName
FROM 
    Staff st JOIN  RentalTransactionHeader rth ON st.StaffID = rth.StaffID
    JOIN Customer c ON rth.CustomerID = c.CustomerID, (
        SELECT [Salary] = MAX(StaffSalary) FROM Staff WHERE StaffSalary NOT IN (SELECT MAX(StaffSalary) FROM Staff)
) AS x
GROUP BY rth.RentalTransactionID, x.Salary, c.CustomerName, st.StaffID, st.StaffName, st.StaffGender
HAVING MAX(StaffSalary) > x.Salary AND st.StaffGender = 'Female'

-- 6
SELECT DISTINCT
	c.CustomerID,
	c.CustomerName,
	[Customer Age] = CONVERT(VARCHAR, CustomerAge) + ' years old',
	[Customer Phone] = '+62' + SUBSTRING(CustomerPhoneNumber, 3, LEN(CustomerPhoneNumber)-2)
FROM Customer c
JOIN ProductTransactionHeader pth ON c.CustomerID = pth.CustomerID
JOIN ProductTransactionDetail ptd ON pth.ProductTransactionID = ptd.ProductTransactionID, (
	SELECT DISTINCT
		[Youngest Customer] = MIN(CustomerAge) 
		FROM Customer
	) AS x,
	(SELECT DISTINCT
		ProductID,
		[Purchased Product Quantity] = ProductQuantity
	FROM ProductTransactionDetail
	) AS y
WHERE 
	[Purchased Product Quantity] < 50
GROUP BY c.CustomerID, x.[Youngest Customer], c.CustomerName, c.CustomerAge, c.CustomerPhoneNumber
HAVING CustomerAge = x.[Youngest Customer]

-- 7
SELECT 
[Category] = 'Most Expensive Product',
[ProductName] = UPPER(ProductName),
[ProductPrice] = 'Rp. '+ CONVERT(varchar,ProductPrice)
FROM Product pr,
(SELECT [plgmahal] = MAX(ProductPrice)
FROM Product) as x
WHERE plgmahal = ProductPrice AND CONVERT(int,SUBSTRING(pr.ProductID,3,2)) % 2 != 0
UNION
SELECT
[Category] = 'Most Affordabble Product',
[ProductName] = UPPER(ProductName),
[ProductPrice] = 'Rp. '+ CONVERT(varchar,ProductPrice)
FROM Product pr,
(SELECT [plgmrh] = MIN(ProductPrice)
FROM Product) as y
WHERE plgmrh = ProductPrice AND CONVERT(int,SUBSTRING(pr.ProductID,3,2)) % 2 != 0

-- 8
SELECT
[ProductTransactionID] = 'Product Transaction Id ' + SUBSTRING(ProductTransactionID,CHARINDEX('PT',ProductTransactionID,0)+2,3),
[Date] = CONVERT(VARCHAR,ProductTransactionDate,107),
pth.CustomerID,
[CustomerName] = UPPER(cs.CustomerName),
st.StaffID,
[StaffGender] = LEFT(StaffGender,1)
FROM ProductTransactionHeader pth
JOIN Customer cs ON pth.CustomerID = cs.CustomerID
JOIN Staff st ON st.StaffID = pth.StaffID,
(SELECT
[MAXAGE] = MAX(CustomerAge)
FROM Customer
) as x
,(SELECT
[AVGSALARY] = AVG(StaffSalary)
FROM Staff
) as y
WHERE MAXAGE <= CustomerAge AND StaffSalary> AVGSALARY

-- 9
CREATE VIEW [annualMonthlyRentalReport]
AS
SELECT
    [Yearly Rental Revenue] = SUM(RentalLength * RentingFee),
    [Average Rental Revenue] = AVG(RentalLength * RentingFee)
FROM RentalTransactionDetail rtd JOIN SportsField sf ON rtd.SportsFieldID = sf.SportsFieldID
    JOIN RentalTransactionHeader rth ON rtd.RentalTransactionID = rth.RentalTransactionID
WHERE DATEPART(month, RentalTransactionDate) = 12 AND RentingFee > 60000

-- 10
CREATE VIEW [annualMonthlyProductReport]
AS
SELECT
    [Yearly Product Revenue] = SUM(ProductQuantity * ProductPrice),
    [Average Product Revenue] = AVG(ProductQuantity * ProductPrice)
FROM ProductTransactionDetail ptd JOIN Product p ON ptd.ProductID = p.ProductID
    JOIN ProductTransactionHeader pth ON pth.ProductTransactionID = ptd.ProductTransactionID
WHERE DATEPART(month, ProductTransactionDate) = 1 AND ProductPrice > 60000