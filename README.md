# Sales-Data-Cleaning-Using-SQL
This GitHub repository contains the SQL Data File and resources for the Sales Analysis Data Cleaning project.

## Table Of Contents

- [Project Overview](#project-overview)
- [Data Source](#data-source)
- [Utilized SQL Queries](#utilized-sql-queries)
- [Data Cleaning/Preparation](#data-cleaningpreparation)
- [References](#references)

### Project Overview
The primary objective of this project is to harness SQL's capabilities for efficient data cleaning tasks.

```
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
```

```
-- FILTERING 'PURCHASE ADDRESS' COLUMN & ADDING CITY COLUMN

SELECT [Purchase Address], PARSENAME(REPLACE([Purchase Address],',','.'),2) AS City,
PARSENAME(REPLACE([Purchase Address],',','.'),1) AS State,
SUBSTRING(PARSENAME(REPLACE([Purchase Address],',','.'),1),1, 3) AS State_code
FROM Sales_Data_Cleaning.dbo.Sales
```

### Data Source
Sales Data: The main dataset utilized for analysis is the "Sales.xlsx" file, encompassing comprehensive information regarding each sale conducted by the company across multiple months.

### Utilized SQL Queries
- SELECT: Used for data retrieval and viewing
- DELETE: Employed for eliminating redundant or erroneous data entries
- Common Table Expressions (CTEs): Utilized for constructing temporary result sets, aiding in complex data manipulations.
- CONVERT: Applied for altering the data type of specific columns
- PARSENAME: Used for parsing relevant information from columns.
- DATENAME: Employed to extract specific components like month from date columns
- DATEPART: Used for extracting specific parts of a date, such as hour
- ALTER: Utilized for modifying table structures
- UPDATE: Employed to make alterations to existing table records

### Data Cleaning/Preparation
During the initial data preparation phase, the following tasks were executed:

- Removal of multiple headers resulting from file merging.
- Elimination of NULL values and duplicates
- Adjustment of column data types using CONVERT Query
- Addition of a 'City' Column by parsing the 'Purchase Address' column
- Extraction of month from the 'Order Date' column
- Inclusion of a 'Sales' column calculated as the product of 'Quantity Ordered' and 'Price Each'.
- Addition of an 'Hour' column for analyzing sales trends based on time.


### References

- [SQL Server Documentations](https://learn.microsoft.com/en-us/sql/tools/overview-sql-tools?view=sql-server-ver16)
