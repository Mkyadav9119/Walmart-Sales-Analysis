-----------------------------------------------------------------------------------------------------------------------------------------
CREATE DATABASE walmart;
-----------------------------------------------------------------------------------------------------------------------------------------
use walmart;
------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1));
------------------------------------------------------------------------------------------------------------------------------------------
    
-- 1st
Alter table sales 
Add time_of_day varchar(50) ;
UPDATE sales
SET time_of_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);
------------------------------------------------------------------------------------------------------------------------------------------

-- 2nd
Alter table sales
 Add day_name varchar(50) ;
UPDATE sales
SET day_name = CASE 
                    WHEN DAYOFWEEK(date) = 1 THEN 'Sun'
                    WHEN DAYOFWEEK(date) = 2 THEN 'Mon'
                    WHEN DAYOFWEEK(date) = 3 THEN 'Tue'
                    WHEN DAYOFWEEK(date) = 4 THEN 'Wed'
                    WHEN DAYOFWEEK(date) = 5 THEN 'Thu'
                    WHEN DAYOFWEEK(date) = 6 THEN 'Fri'
                    WHEN DAYOFWEEK(date) = 7 THEN 'Sat'
              END;
------------------------------------------------------------------------------------------------------------------------------------------

-- 3rd
Alter table sales Add month_name varchar(50)  ;
UPDATE sales
SET month_name = CASE 
                    WHEN MONTH(date) = 1 THEN 'Jan'
                    WHEN MONTH(date) = 2 THEN 'Feb'
                    WHEN MONTH(date) = 3 THEN 'Mar'
                    WHEN MONTH(date) = 4 THEN 'Apr'
                    WHEN MONTH(date) = 5 THEN 'May'
                    WHEN MONTH(date) = 6 THEN 'Jun'
                    WHEN MONTH(date) = 7 THEN 'Jul'
                    WHEN MONTH(date) = 8 THEN 'Aug'
                    WHEN MONTH(date) = 9 THEN 'Sep'
                    WHEN MONTH(date) = 10 THEN 'Oct'
                    WHEN MONTH(date) = 11 THEN 'Nov'
                    WHEN MONTH(date) = 12 THEN 'Dec'
              END;
------------------------------------------------------------------------------------------------------------------------------------------
    
-- 1. How many unique cities does the data have?
SELECT DISTINCT city
from sales;
------------------------------------------------------------------------------------------------------------------------------------------

-- 2. In which city is each branch?
    SELECT DISTINCT city, branch
    from sales;
------------------------------------------------------------------------------------------------------------------------------------------    
    
    use walmart;
    select * from sales;
------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------
---------- Sales Performance----------
--------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
-- 1.What are the total sales for each branch?
Select branch, sum(total) as Total_sales
from sales
group by branch;
------------------------------------------------------------------------------------------------------------------------------------------
-- 2.What is the total quantity of products sold in each city?
Select city, sum(quantity) as Total_Quantity
from sales
group by city;
------------------------------------------------------------------------------------------------------------------------------------------
-- 3.What are the monthly sales trends?
Select month_name, sum(total) as Total_Sales
from sales 
group by month_name;
------------------------------------------------------------------------------------------------------------------------------------------
-- 4.What are the top 10 days with the highest sales?
Select date, sum(total) as Daily_Sales
from sales
group by date
order by Daily_Sales desc
limit 10;
------------------------------------------------------------------------------------------------------------------------------------------
-- 5.What are the total sales by each payment method?
Select payment, sum(total) as Total_Sales
from sales
group by payment
order by Total_Sales desc;
------------------------------------------------------------------------------------------------------------------------------------------
-- 6.What is the average sales amount per transaction?
Select avg(total) as Average_Sales
from sales;
------------------------------------------------------------------------------------------------------------------------------------------
-- 7.Number of sales made in each time of the day per weekday.
	Select product_line,time_of_day 
    from sales 
	group by time_of_day,product_line;
 
 -- OR

SELECT time_of_day,
COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
------------------------------------------------------------------------------------------------------------------------------------------
-- 8.Which of the customer types brings the most revenue?
Select customer_type, sum(total) as Revenue
from sales group by customer_type
order by Revenue desc;
------------------------------------------------------------------------------------------------------------------------------------------
-- 9.Which city has the largest tax percent/ VAT (**Value Added Tax**)?
Select city , max(tax_pct) as VAT 
from sales 
group by city 
order by VAT desc;
-- OR
SELECT city,
ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;
--------------------------------------------------------------------------------------------------------------------------------------------
-- 10.Which customer type pays the most in VAT?
Select customer_type, avg(tax_pct) as VAT
from sales 
group by customer_type
order by VAT desc;

------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------
--------------- Customer-----------------
------------------------------------------------------------------------------------------------------------------------------------------

-- 1.How are sales distributed among different customer types?
Select customer_type, sum(total) as Sales 
from sales 
group by customer_type;
------------------------------------------------------------------------------------------------------------------------------------------
-- 2.What are the total sales made to male and female customers?
Select gender, sum(total) as Total_Sales
from sales 
group by gender
order by Total_Sales desc;
------------------------------------------------------------------------------------------------------------------------------------------
-- 3.What is the average purchase value for each customer type?
Select customer_type, avg(total) as Average_Purchage
from sales
group by customer_type;

-- 4.How many transactions are made by each customer type?
Select customer_type , count(total) as Transaction_
from sales 
group by customer_type;

-- 5.What is the average purchase value by gender?
Select gender, avg(total) as Avg_Purchase
from sales 
group by gender;

-- 6.How many unique customer types does the data have?
Select Customer_type,count(*) as Total_customer 
from sales
group by customer_type;
 
 -- 7.  How many unique payment methods does the data have?
 Select payment,count(payment) as Unique_Payment
 from sales 
 group by payment;
 
-- 8.What is the most common customer type?
Select customer_type, count(customer_type) as Common_customer_Type
from sales 
group by customer_type
order by Common_customer_Type desc;
 
-- 9.Which customer type buys the most?
Select customer_type, sum(quantity) as total_purchase
from sales 
group by customer_type
order by total_purchase desc;


-- 10.What is the gender of most of the customers?
Select gender, count(gender) as Total
from sales
group by gender
order by Total desc;

-- OR

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- 11. What is the gender distribution per branch?
Select gender, count(*) as Total
from sales 
where branch = 'A' 
group by gender;


-- 12.Which time of the day do customers give most ratings?
Select time_of_day, avg(rating) as Rating
from sales 
group by time_of_day
order by Rating desc
limit 3;

-- 13.Which time of the day do customers give most ratings per branch?
select branch,time_of_day,avg(rating) as Rating
from sales
where branch = 'A'
group by time_of_day
order by Rating desc
limit 1;
  -- Similarly do for B and c.
  
  
-- 14.Which day fo the week has the best avg ratings?
select day_name, avg(rating) as Average_Rating
from sales 
group by day_name 
order by Average_Rating desc
Limit 1;

-- 15.Which day of the week has the best average ratings per branch?
Select day_name, branch,avg(rating) as Average_Rating
from sales 
where branch = 'A'
group by day_name
order by Average_Rating desc
limit 1;
-- Similary do for B and C.

-------------------------------------------------------------------------------------------------------------------

--------------------------------------
-- ----------Product Analysis --------
--------------------------------------

-- 1.What is the top-selling product lines?
Select product_line, sum(total) as Total_SAles 
from sales 
group by product_line 
order by Total_sales desc;

-- 2.What is the total quantity sold for each product line?
Select product_line , sum(quantity) as Total_Quantity
from sales
group by product_line 
order by Total_Quantity desc;

-- 3.What is the average unit price for each product line?
Select product_line, avg(unit_price) As Avg_unit_price
from sales 
group by product_line
order by Avg_unit_price desc;

-- 4.What are the total sales for each product line by gender?
Select product_line , gender, sum(total) as Total_Sales
from sales 
group by product_line,gender
order by product_line;

-- 5.Which products generate the highest gross income?
Select product_line, sum(gross_income) as Income
from sales 
group by product_line 
order by Income desc;

-- 6.How many unique product lines does the data have?
Select distinct product_line from sales ;
    
-- 7.What is the most common payment method?
Select payment,count(payment) as count
from sales 
group by payment
order by count desc;
    
-- 8.What is the most selling product line?
select product_line , 
quantity , total from sales 
order by total desc
limit 2;

-- 9.What is the total revenue by month?  
Select month_name, max(gross_income) as Total_revenue
from sales
group by month_name;
    
    
-- 10.What month had the largest COGS?
Select month_name,max(cogs) as maximum_cogs 
from sales
group by month_name
order by maximum_cogs desc;
        
-- 11.What product line had the largest revenue?
Select product_line , 
quantity ,unit_price,tax_pct, total from sales 
order by total desc
limit 1;
    
-- 12.What is the city with the largest revenue?
Select city , max(total) as maximum_revenue
from sales
group by city 
order by maximum_revenue desc ;
    
-- 13.What product line had the largest VAT?
Select product_line , max(tax_pct) as VAT
from sales 
group by product_line 
order by VAT
limit 1;
    
-- 14.Fetch each product line and add a column to those product line 
-- showing "Good", "Bad". Good if its greater than average sales
SELECT avg(total)
FROM sales;
SELECT product_line,total,
    CASE 
        WHEN total > 322.948 THEN 'Good'
        ELSE 'Bad'
    END AS sales_quality
    FROM sales;

-- 15.Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- 16. What is the most common product line by gender?
Select product_line,gender,
count(product_line) as Common_Product_line 
from sales 
group by gender,product_line
order by Common_Product_line desc;

-- 17.What is the average rating of each product line?
Select product_line,Avg(rating) as Average_Rating
from sales group by product_line;

---------------------------------------------------------------------------------------------------------------------

----------------------------------------
-- ------------Financial-----------------
----------------------------------------

-- 1.What is the total gross income generated by each branch?
Select branch , sum(gross_income) as Total_Income
from sales 
group by branch;

-- 2.What is the average gross margin percentage for each product line?
Select product_line , avg(gross_margin_pct) as Gross_Margin_Percentage
from sales 
group by product_line ;

-- 3.What is the total cost of goods sold (COGS) for each branch?    
Select branch , sum(cogs) as Total_COGS
from sales 
group by branch;

-- 4.What is the ratio of gross income to total sales?
Select sum(gross_income)/sum(total) as ratio_of_gross_income_to_total_sales
from sales;    

-- 5.How do the gross margins compare across branches?
Select branch, sum(gross_margin_pct) as Gross_Margin
from sales
group by branch;
Select * from  sales;        
-- 6.What is the monthly financial performance in terms of gross income and COGS?
Select month_name, sum(gross_income), sum(cogs)
from sales 
group by month_name
order by month_name desc;
    
------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------    
------------------------------------------------------ Time Based Analysis ---------------------------------------------------------------    
------------------------------------------------------------------------------------------------------------------------------------------

-- 1.What are the monthly sales trends?
Select month_name , sum(total) as Monthly_Sales
from sales 
group by month_name; 

-- 2.How are sales distributed across different hours of the day?
Select extract(hour from time) as hours, sum(total)
from sales 
group by extract(hour from time)
order by hours;

-- 3.What are the sales trends by day of the week?
Select day_name, sum(total) as Sales
from sales 
group by day_name;

-- 4.How do sales compare across different years?
Select extract( year from date), sum(total)
from sales 
group by extract( year from date);

-- 5.What are the sales trends by season?
 SELECT CASE 
WHEN EXTRACT(MONTH FROM date) IN (12, 1, 2) THEN 'Winter'
WHEN EXTRACT(MONTH FROM date) IN (3, 4, 5) THEN 'Spring'
WHEN EXTRACT(MONTH FROM date) IN (6, 7, 8) THEN 'Summer'
ELSE 'Fall'
END AS Season,
SUM(total) AS Total_Sales
FROM sales
GROUP BY Season;