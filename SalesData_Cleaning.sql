
-- STRUCTURE OF TABLE

EXEC sp_help 'dbo.Sales'

SELECT *
FROM Sales_Data_Cleaning.dbo.Sales

-- SINCE DATA IS MERGED FROM DIFFERENT FILES THERE IS A POSIBILITY THAT HEADER MIGHT GET ADDED MULTIPLE TIMES.
-- DELETING THE MULTIPLE HEADER

-- CHECKING IF HEADER IS GETTED ADDED MULTIPLE TIME OR NOT

SELECT *
FROM Sales_Data_Cleaning.dbo.Sales WHERE [Order ID] = 'Order ID'

-- DELETING MULTIPLE HEADER WHICH GET ADDED WHILE MERGING FILE

SELECT *
FROM Sales_Data_Cleaning.dbo.Sales
WHERE [Order ID] = 'Order ID'
--SUBSTRING([Order ID], 1, 4) = 'Orde'

DELETE FROM Sales_Data_Cleaning.dbo.Sales WHERE [Order ID] = 'Order ID'

-- DELETE FROM Sales_Data_Cleaning.dbo.Sales WHERE SUBSTRING([Order ID], 1, 4) = 'Orde'


-- CHECKING IF HEADER GOT REMOVED OR NOT
SELECT *
FROM Sales_Data_Cleaning.dbo.Sales
WHERE [Order ID] = 'Order ID'

------------------------------------------------------------------------

-- DELETING NULL VALUES & Duplicate Values

/* This clause divides the result set into partitions (groups) 
based on the columns specified. Each partition is numbered separately, 
so the row numbers will reset for each new*/

WITH RowNumCTE as(
SELECT *,
ROW_NUMBER()OVER(
PARTITION BY [Order ID],
			Product,
			[Quantity Ordered],
			[Price Each],
			[Order Date],
			[Purchase Address]
			ORDER BY [Order ID]
			) row_num
FROM Sales_Data_Cleaning.dbo.Sales
)

/*
SELECT *
FROM RowNumCTE
WHERE ROW_NUM > 1 
ORDER BY [Order ID]
*/

DELETE
FROM RowNumCTE
WHERE ROW_NUM > 1

-- CHECKING IS ANY NULL VALUE REMAINED
SELECT *
FROM Sales_Data_Cleaning.dbo.Sales WHERE [Order ID] is NULL

DELETE FROM Sales WHERE [Order ID] is NULL

SELECT * 
FROM Sales_Data_Cleaning.dbo.Sales

----------------------------------------------------------------------------------------------

-- CONVERTING INTO PROPER DATA TYPE

-- CONVERTING 'ORDER ID' TO int DATA TYPE

ALTER TABLE Sales_Data_Cleaning.dbo.Sales
ALTER COLUMN [ORDER ID] int

UPDATE Sales_Data_Cleaning.dbo.Sales
SET [ORDER ID] = CONVERT(int, [ORDER ID])

-- CONVERTING 'Quantity Ordered' TO int DATA TYPE

ALTER TABLE Sales_Data_Cleaning.dbo.Sales
ALTER COLUMN [Quantity Ordered] int

UPDATE Sales_Data_Cleaning.dbo.Sales
SET [Quantity Ordered] = CONVERT(int, [Quantity Ordered])

-- CONVERTING 'Price Each' TO float DATA TYPE

ALTER TABLE Sales_Data_Cleaning.dbo.Sales
ALTER COLUMN [Price Each] FLOAT

UPDATE Sales_Data_Cleaning.dbo.Sales
SET [Price Each] = CONVERT(float, [Price Each])

-- CONVERTING 'ORDER DATE' TO DATE DATA TYPE

ALTER TABLE Sales_Data_Cleaning.dbo.Sales
ALTER COLUMN [Order Date] smalldatetime

UPDATE Sales_Data_Cleaning.dbo.Sales
SET [Order Date] = CONVERT(smalldatetime, [Order Date])

EXEC sp_help 'dbo.Sales'

SELECT *
FROM Sales_Data_Cleaning.dbo.Sales

-------------------------------------------------------
-- FILTERING 'PURCHASE ADDRESS' COLUMN & ADDING CITY COLUMN

/*
SELECT [Purchase Address], PARSENAME(REPLACE([Purchase Address],',','.'),2),
PARSENAME(REPLACE([Purchase Address],',','.'),1),
SUBSTRING(PARSENAME(REPLACE([Purchase Address],',','.'),1),1, 3)
FROM Sales_Data_Cleaning.dbo.Sales
*/

SELECT CONCAT(PARSENAME(REPLACE([Purchase Address],',','.'),2),
'(',SUBSTRING(PARSENAME(REPLACE([Purchase Address],',','.'),1),2, 2),')') AS concatenated
FROM Sales_Data_Cleaning.dbo.Sales

ALTER TABLE Sales_Data_Cleaning.dbo.Sales
ADD City NVARCHAR(500)

UPDATE Sales_Data_Cleaning.dbo.Sales
SET City = CONCAT(PARSENAME(REPLACE([Purchase Address],',','.'),2),
'(',SUBSTRING(PARSENAME(REPLACE([Purchase Address],',','.'),1),2, 2),')')

SELECT *
FROM Sales_Data_Cleaning.dbo.Sales

-- EXTRACTING MONTH FROM ORDER DATE

SELECT [Order Date], DATENAME(MONTH, [Order Date]) AS order_month
FROM Sales_Data_Cleaning.dbo.Sales

ALTER TABLE Sales_Data_Cleaning.dbo.Sales
ADD [Month] VARCHAR(100)

UPDATE Sales_Data_Cleaning.dbo.Sales
SET [Month] =  DATENAME(MONTH, [Order Date])

SELECT *
FROM Sales_Data_Cleaning.dbo.Sales

-- ADDING COLUMN 'Sales'

SELECT [Quantity Ordered], [Price Each], ([Quantity Ordered] * [Price Each]) AS Sale
FROM Sales_Data_Cleaning.dbo.Sales

ALTER TABLE Sales_Data_Cleaning.dbo.Sales
ADD Sale FLOAT

UPDATE Sales_Data_Cleaning.dbo.Sales
SET Sale = [Quantity Ordered] * [Price Each]

SELECT *
FROM Sales_Data_Cleaning.dbo.Sales

-- ADDING 'HOUR' COLUMN

SELECT [Order Date], DATEPART(HOUR, [Order Date]) AS Hour
FROM Sales_Data_Cleaning.dbo.Sales

ALTER TABLE Sales_Data_Cleaning.dbo.Sales
ADD [Hour]  INT

UPDATE Sales_Data_Cleaning.dbo.Sales
SET [Hour] = DATEPART(HOUR, [Order Date])

SELECT *
FROM Sales_Data_Cleaning.dbo.Sales

