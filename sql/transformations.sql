/*=========================================================
    GYM DATA WAREHOUSE
    Create Tables + Load Data + Transformations
=========================================================*/


/*=========================================================
                    EMPLOYEES
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.Employees (
    EmployeeKey INT,
    EmployeeName VARCHAR(100),
    JobTitle VARCHAR(100),
    RegionKey INT,
    HireDate DATE,
    BaseSalary DECIMAL(10,2),
    CommissionRate DECIMAL(5,2)
);

COPY INTO GYM_DB.PUBLIC.Employees
FROM @GYM_DB.PUBLIC.AZURE_STAGE/Employees.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                    GEOGRAPHY
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.Geography (
    GeographyKey INT,
    CityName VARCHAR(100),
    StateCode VARCHAR(10),
    StateName VARCHAR(100),
    CountryCode VARCHAR(10),
    CountryName VARCHAR(100),
    RegionKey INT
);

COPY INTO GYM_DB.PUBLIC.Geography
FROM @GYM_DB.PUBLIC.AZURE_STAGE/Geography.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                    PRODUCT
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.Product (
    ProductKey INT,
    ProductSubcategoryKey INT,
    ProductName VARCHAR(150),
    Size VARCHAR(50),
    Detail VARCHAR(100)
);

COPY INTO GYM_DB.PUBLIC.Product
FROM @GYM_DB.PUBLIC.AZURE_STAGE/Product.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                PRODUCT COST HISTORY
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.Productcosthistory (
    Year INT,
    MonthNo INT,
    CountryCode VARCHAR(10),
    ProductKey INT,
    UnitCost DECIMAL(10,3)
);

COPY INTO GYM_DB.PUBLIC.Productcosthistory
FROM @GYM_DB.PUBLIC.AZURE_STAGE/Productcosthistory.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                PRODUCT SUBCATEGORY
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.ProductSubcategory (
    ProductSubcategoryKey INT,
    SubcategoryName VARCHAR(100),
    CategoryName VARCHAR(100)
);

COPY INTO GYM_DB.PUBLIC.ProductSubcategory
FROM @GYM_DB.PUBLIC.AZURE_STAGE/ProductSubcategory.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                    REGION
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.Region (
    RegionKey INT,
    RegionName VARCHAR(100),
    Country VARCHAR(100),
    Continent VARCHAR(100)
);

COPY INTO GYM_DB.PUBLIC.Region
FROM @GYM_DB.PUBLIC.AZURE_STAGE/Region.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                SALES DETAILS
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.SalesDetails (
    SalesDetailsKey INT,
    SalesHeaderKey INT,
    SalesOrderNumber VARCHAR(50),
    ProductKey INT,
    ProductSubcategoryKey INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(10,4),
    ExtendedAmount DECIMAL(10,4)
);

COPY INTO GYM_DB.PUBLIC.SalesDetails
FROM @GYM_DB.PUBLIC.AZURE_STAGE/SalesDetails.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                SALES HEADER
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.SalesHeader (
    SalesDetailsID INT,
    SalesOrderNumber VARCHAR(50),
    OrderDate DATE,
    DueDate DATE,
    ShipDate DATE,
    CustomerKey INT,
    RegionKey INT,
    DiscountAmount DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    SalesAmount DECIMAL(10,2),
    EmployeeKey INT
);

COPY INTO GYM_DB.PUBLIC.SalesHeader
FROM @GYM_DB.PUBLIC.AZURE_STAGE/SalesHeader.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                SALES RETURNS
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.SalesReturns (
    ReturnKey INT,
    ReturnDate DATE,
    OrderDate DATE,
    SalesOrderNumber VARCHAR(50),
    CustomerKey INT,
    ProductKey INT,
    ReturnQuantity INT,
    UnitPrice DECIMAL(10,3),
    ReturnAmount DECIMAL(10,3)
);

COPY INTO GYM_DB.PUBLIC.SalesReturns
FROM @GYM_DB.PUBLIC.AZURE_STAGE/SalesReturns.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                    CUSTOMERS
=========================================================*/

CREATE TABLE GYM_DB.PUBLIC.Customers (
    CustomerKey INT,
    GeographyKey INT,
    BusinessType VARCHAR(100),
    Customer VARCHAR(150),
    NumberEmployees INT,
    AnnualRevenue DECIMAL(15,2),
    YearOpened INT
);

COPY INTO GYM_DB.PUBLIC.Customers
FROM @GYM_DB.PUBLIC.AZURE_STAGE/Customers.csv
FILE_FORMAT = (FORMAT_NAME = 'GYM_DB.PUBLIC.MY_CSV_FORMAT');


/*=========================================================
                TRANSFORMATIONS
=========================================================*/

/* Product Sales Summary */

CREATE OR REPLACE TABLE GYM_DB.PUBLIC.PRODUCT_SALES_SUMMARY AS
SELECT
    P.ProductKey,
    P.ProductName,
    SUM(SD.OrderQuantity) AS TotalQuantity,
    SUM(SD.ExtendedAmount) AS TotalSales,
    AVG(SD.UnitPrice) AS AveragePrice
FROM GYM_DB.PUBLIC.SalesDetails SD
JOIN GYM_DB.PUBLIC.Product P
ON SD.ProductKey = P.ProductKey
GROUP BY
    P.ProductKey,
    P.ProductName;


/* Monthly Sales */

CREATE OR REPLACE TABLE GYM_DB.PUBLIC.MONTHLY_SALES AS
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(SalesAmount) AS MonthlyRevenue
FROM GYM_DB.PUBLIC.SalesHeader
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate);


/* Region Sales */

CREATE OR REPLACE TABLE GYM_DB.PUBLIC.REGION_SALES AS
SELECT
    R.RegionName,
    SUM(SH.SalesAmount) AS TotalSales,
    COUNT(DISTINCT SH.SalesOrderNumber) AS TotalOrders
FROM GYM_DB.PUBLIC.SalesHeader SH
JOIN GYM_DB.PUBLIC.Region R
ON SH.RegionKey = R.RegionKey
GROUP BY
    R.RegionName;


/* Customer Summary */

CREATE OR REPLACE TABLE GYM_DB.PUBLIC.CUSTOMER_SUMMARY AS
SELECT
    C.CustomerKey,
    C.Customer,
    COUNT(SH.SalesOrderNumber) AS NumberOfOrders,
    SUM(SH.SalesAmount) AS TotalSpent
FROM GYM_DB.PUBLIC.Customers C
LEFT JOIN GYM_DB.PUBLIC.SalesHeader SH
ON C.CustomerKey = SH.CustomerKey
GROUP BY
    C.CustomerKey,
    C.Customer;


/* Employee Performance */

CREATE OR REPLACE TABLE GYM_DB.PUBLIC.EMPLOYEE_PERFORMANCE AS
SELECT
    E.EmployeeName,
    COUNT(SH.SalesOrderNumber) AS OrdersHandled,
    SUM(SH.SalesAmount) AS TotalSales
FROM GYM_DB.PUBLIC.Employees E
JOIN GYM_DB.PUBLIC.SalesHeader SH
ON E.EmployeeKey = SH.EmployeeKey
GROUP BY
    E.EmployeeName;


/* Category Performance */

CREATE OR REPLACE TABLE GYM_DB.PUBLIC.CATEGORY_PERFORMANCE AS
SELECT
    PS.CategoryName,
    SUM(SD.ExtendedAmount) AS Revenue,
    SUM(SD.OrderQuantity) AS QuantitySold
FROM GYM_DB.PUBLIC.SalesDetails SD
JOIN GYM_DB.PUBLIC.Product P
ON SD.ProductKey = P.ProductKey
JOIN GYM_DB.PUBLIC.ProductSubcategory PS
ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
GROUP BY
    PS.CategoryName;


/* Return Analysis */

CREATE OR REPLACE TABLE GYM_DB.PUBLIC.RETURN_ANALYSIS AS
SELECT
    ProductKey,
    SUM(ReturnQuantity) AS TotalReturned,
    SUM(ReturnAmount) AS TotalReturnValue
FROM GYM_DB.PUBLIC.SalesReturns
GROUP BY
    ProductKey;