BEGIN;
---------------------------------------- CREATE TABLE---------------------------------------
-- create Financial table
CREATE TABLE Financial (
    id SERIAL PRIMARY KEY,
    segment_ID INTEGER,
	country_ID INTEGER,
	product_ID INTEGER,
	discountBand_ID INTEGER,
    Units_Sold FLOAT,
    Manufacturing_Price FLOAT,
    Sale_Price FLOAT,
	Gross_Sales FLOAT,
	Discounts FLOAT,
	Sales FLOAT,
	COGS FLOAT,
	Profit FLOAT,
	Tanggal DATE,
	Month_Number INTEGER,
	Month_Name VARCHAR (100) NOT NULL,
	Tahun INTEGER
);

-- Create 'Segment' table
CREATE TABLE Segment (
    segment_ID serial PRIMARY KEY,
    segment VARCHAR (100) NOT NULL
);

-- Create 'Country' table
CREATE TABLE Country (
    country_ID serial PRIMARY KEY,
    country VARCHAR (100) NOT NULL
);

-- Create 'Product' table
CREATE TABLE Product (
    product_ID serial PRIMARY KEY,
    product_ VARCHAR (100) NOT NULL
);

-- Create 'DiscountBand' table
CREATE TABLE DiscountBand (
    discountBand_ID serial PRIMARY KEY,
    discount_Band VARCHAR (100) NOT NULL
);

--------------------------------------------------------------------------------------------
ROLLBACK;


----------------------------------------INPUTASI COPY TABLE---------------------------------------

COPY Segment(segment_ID,segment)
FROM 'E:\Hacktiv8\Phase 0\GC\p0-ftds004-bsd-g2-KevinDHS\segment.csv'
DELIMITER ','
CSV HEADER;

COPY Country(country_ID,country)
FROM 'E:\Hacktiv8\Phase 0\GC\p0-ftds004-bsd-g2-KevinDHS\country.csv'
DELIMITER ','
CSV HEADER;

COPY Product(product_ID,product)
FROM 'E:\Hacktiv8\Phase 0\GC\p0-ftds004-bsd-g2-KevinDHS\product.csv'
DELIMITER ','
CSV HEADER;

COPY discountband(discountband_ID,discount_Band)
FROM 'E:\Hacktiv8\Phase 0\GC\p0-ftds004-bsd-g2-KevinDHS\discountband.csv'
DELIMITER ','
CSV HEADER;

COPY financial(segment_ID,country_ID,product_ID, discountBand_ID, Units_Sold,
    Manufacturing_Price, Sale_Price, Gross_Sales, Discounts,
    Sales, COGS, Profit, Tanggal, Month_Number, Month_Name, Tahun)
FROM 'E:\Hacktiv8\Phase 0\GC\p0-ftds004-bsd-g2-KevinDHS\Financial.csv'
DELIMITER ','
CSV HEADER;
---------------------------------------------------------------------------------------------

---------------------------------------- DCL TABLE---------------------------------------
-- Connect to PostgreSQL and run the following SQL statements
CREATE USER user1 WITH PASSWORD '123456';
CREATE USER user2 WITH PASSWORD '123456';

-- Grant necessary privileges (replace 'your_database' with the actual database name)
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO user1;
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO user2;

-- Grant SELECT access to user1
GRANT SELECT ON ALL TABLES IN SCHEMA public TO user1;

-- Grant all privileges to user2 (admin)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO user2;

--grant other necessary privileges
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO user1;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO user2;
--------------------------------------------------------------------------------------------

UPDATE segment
SET segment = 'Government'
where segment_id = 1;

SAVEPOINT sp1;

UPDATE segment
SET segment = 'INCOPERATION'
where segment_id = 6;

ROLLBACK TO SAVEPOINT sp1;

COMMIT;

ROLLBACK;
---------------------------------------- TESTING TABLE---------------------------------------
SELECT  financial.segment_id, SUM(financial.profit) AS total_profit
FROM financial
WHERE financial.discounts > 0
GROUP BY financial.segment_id;


SELECT financial.country_id,
	   MIN(financial.sales) as Minimum_Sales,
	   MAX(financial.sales) as Maximum_Sales,
	   AVG(financial.sales) as Average_sales
FROM financial
GROUP BY financial.country_id;

-------------------------------------- DQL -----------------------------------------------
SELECT * FROM FINANCIAL;
SELECT * FROM segment;
SELECT * FROM country;
SELECT * FROM product;
SELECT * FROM discountband;

set role postgres;
SET ROLE user2;
--------------------------------------------------------------------------------------------