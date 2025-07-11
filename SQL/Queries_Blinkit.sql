SELECT * FROM blinkit_db.blinkit_grocery_data;
-- select count(*) from blinkit_db.blinkit_grocery_data;

-- // ---> DATA CLEANING <--- ////
UPDATE blinkit_db.blinkit_grocery_data
SET Item_Fat_Content =
CASE
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END;

-- // ---> To check how many distinct columns are there in Item_Fat_Content; <---/////
SELECT DISTINCT(Item_Fat_Content) FROM blinkit_db.blinkit_grocery_data;



-- // ---> KPI requirements: <--- /////

-- // ---> 1) Total Sales: the overall revenue generated from all of its items sold <-- //
select cast(sum(sales)/ 1000000  as DECIMAL(10,2)) as Total_sales_Millions
from blinkit_db.blinkit_grocery_data

-- // ----> 2) Average Sales: Average sales revenue per sale: <--- ///
select cast(AVG(sales)  AS DECIMAL(10,0)) as Avg_sales
from blinkit_db.blinkit_grocery_data

-- // -->  3) Number of items: the total count of items sold; <-- //
SELECT count(*) as No_of_Items 
FROM blinkit_db.blinkit_grocery_data;
-- OR
select cast(AVG(sales)  AS DECIMAL(10,0)) as Avg_sales
from blinkit_db.blinkit_grocery_data
where Item_Fat_Content= 'Low fat';

-- // ---> 4) Average Rating : The average customer rating for items sold: <-- ///
select cast(avg(Rating) as DECIMAL(10,2)) as Avg_rating 
from blinkit_db.blinkit_grocery_data;


-- GRANULAR REQUIREMENTS:
-- // ---> 1) Total sales by fats content: <-- ///
select Item_Fat_Content, 
    cast(sum(Sales)/1000 as decimal(10,2) )as Total_sales_Thousands,
    cast(AVG(sales)  AS DECIMAL(10,0)) as Avg_sales,
    count(*) as No_of_Items,
    cast(avg(Rating) as DECIMAL(10,2)) as Avg_rating
from blinkit_db.blinkit_grocery_data
where Outlet_Establishment_Year= 2020
group by Item_Fat_Content
order by Total_sales_Thousands

-- // ---> 2) Tota; sales by item Type: <-- ///
select Item_Type, 
    cast(sum(Sales) as decimal(10,2) )as Total_sales,
    cast(AVG(sales)  AS DECIMAL(10,0)) as Avg_sales,
    count(*) as No_of_Items,
    cast(avg(Rating) as DECIMAL(10,2)) as Avg_rating
from blinkit_db.blinkit_grocery_data
where Outlet_Establishment_Year= 2020
group by Item_Type
order by Total_sales desc
limit 5


-- // ---> 3) Fat content by outlet for total sales: <-- ///
select  Outlet_Location_Type, Item_Fat_Content,
    cast(sum(Sales) as decimal(10,2) )as Total_sales,
    cast(AVG(sales)  AS DECIMAL(10,0)) as Avg_sales,
    count(*) as No_of_Items,
    cast(avg(Rating) as DECIMAL(10,2)) as Avg_rating
from blinkit_db.blinkit_grocery_data
group by Outlet_Location_Type, Item_Fat_Content
order by Total_sales asc;

-- CORRECTED ONE:

SELECT 
    Outlet_Location_Type,
    CAST(IFNULL(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Sales ELSE 0 END), 0) AS DECIMAL(10,2)) AS Low_Fat,
    CAST(IFNULL(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Sales ELSE 0 END), 0) AS DECIMAL(10,2)) AS Regular
FROM blinkit_db.blinkit_grocery_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;


-- // ---> 4) Total sales by outlet establishment: <-- ///
select  Outlet_Establishment_Year,
    cast(sum(Sales) as decimal(10,2) )as Total_sales,
    cast(AVG(sales)  AS DECIMAL(10,0)) as Avg_sales,
    count(*) as No_of_Items,
    cast(avg(Rating) as DECIMAL(10,2)) as Avg_rating
from blinkit_db.blinkit_grocery_data
group by Outlet_Establishment_Year 
order by Outlet_Establishment_Year asc;


-- // ---> 5) Percentage of sales by outlet size:: <-- ///
SELECT
     Outlet_Size,
     CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
     CAST((SUM(Sales) * 100.0 / (SELECT SUM(Sales) FROM blinkit_db.blinkit_grocery_data)) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_db.blinkit_grocery_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


-- // ---> 6) Sales by outlet Location: <-- ///
select  Outlet_Location_Type,
    cast(sum(Sales) as decimal(10,2) )as Total_sales,
    cast(AVG(sales)  AS DECIMAL(10,0)) as Avg_sales,
    count(*) as No_of_Items,
    cast(avg(Rating) as DECIMAL(10,2)) as Avg_rating
from blinkit_db.blinkit_grocery_data
group by Outlet_Location_Type 
order by Total_sales asc;


-- // ---> 7) All metrices by outlet type: <-- ///
select  Outlet_Type,
    cast(sum(Sales) as decimal(10,2) )as Total_sales,
    cast(AVG(sales)  AS DECIMAL(10,0)) as Avg_sales,
    CAST((SUM(Sales) * 100.0 / (SELECT SUM(Sales) FROM blinkit_db.blinkit_grocery_data)) AS DECIMAL(10,2)) AS Sales_Percentage,
    count(*) as No_of_Items,
    cast(avg(Rating) as DECIMAL(10,2)) as Avg_rating
from blinkit_db.blinkit_grocery_data
-- where Outlet_Establishment_Year = 2020
group by Outlet_Type 
order by Total_sales asc;



