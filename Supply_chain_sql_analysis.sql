CREATE DATABASE Supply_chain_management;
use Supply_chain_management;
show databases;
SELECT * FROM Supply_chain LIMIT 10;
SELECT COUNT(*) FROM supply_chain;
SELECT COUNT(*) as table_rows FROM supply_chain;
describe supply_chain;
show tables;
select* from supply_chain;
SELECT * FROM Supply_chain LIMIT 10;
DESCRIBE supply_chain;
show columns from supply_chain;

#data quality check
select count(*) from supply_chain WHERE 'Days for shipping (real)' IS NULL;
select count(*) null_count from supply_chain WHERE 'Days for shipping (real)' IS NULL;
select count(*) null_count from supply_chain WHERE 'Days for shipment (scheduled)' IS NULL;
select count(*) null_count from supply_chain WHERE 'Shipping delays days' IS NULL;
SELECT COUNT('Days for shipment (scheduled)') FROM supply_chain;
SELECT COUNT('Days for shipping (real)') FROM supply_chain;
SELECT COUNT('Shipping delays days') FROM supply_chain;
select count(*) as total_rows,
sum('Days for shipment (scheduled)' is null)as missing_scheduled_days,
sum('Days for shipping (real)' is null)as missing_actual_days,
sum('Late Delivery Risk' is null)as missing_delivery_risk,
sum('Sales' is null)as missing_sales from supply_chain;
#check duplicates records
select count(*) as total_rows,count(distinct `Order Id`)as unique_orders from supply_chain;
#check distinct values
select distinct `Shipping Mode` From supply_chain;#count unique shipping mode
select distinct `Order Region` from supply_chain;
describe supply_chain;
#count orders for each shipping mode
select `Order Region`,count(*)as RegionOrder from supply_chain group by `Order Region` Order by `RegionOrder` DESC;
select `Shipping Mode`,count(*)as total_orders from supply_chain group by`Shipping Mode` Order by total_orders DESC;
SELECT * FROM supply_chain WHERE 'Shipping Mode' IS NULL;
select 'Shipping Mode', LENGTH('Shipping Mode')as text_length,count(*)as total_orders  from supply_chain group by binary'Shipping Mode' ;
select Min(Sales) as minimum_sales,Max(Sales) as maximun_sales,Avg(Sales) as Average_sales,Sum(Sales) as total_sales from supply_chain;
Alter Table supply_chain drop column `a`;#backticks use
select `Shipping Mode` from supply_chain limit 2;
select * from supply_chain;
select Min(`Order Item Quantity`)as MinimumOrderQuantity,Max(`Order Item Quantity`)as MaximumOrderQuantity,Sum(`Order Item Quantity`)as totalOrderQuantity,Avg(`Order Item Quantity`)as AverageOrderQuantity from supply_chain;
select Min(`Order Item Discount`)as MinOrderItemDiscount,Max(`Order Item Discount`)as MaximumOrderItemDiscount,Avg(`Order Item Discount`)as AverageOrderItemDiscount,Sum(`Order Item Discount`)as TotalOrderItemDiscount from supply_chain;
select Min(`Benefit per order`)as MinBenefitPerOrder,Max(`Benefit per order`)as MaximumBenefitPerOrder,Avg(`Benefit per order`)as AverageBenefitPerOrder,Sum(`Benefit per order`)as TotalBenefitPerOrder from supply_chain;
select Min(`Benefit per order`)as MinBenefitPerOrder,Max(`Benefit per order`)as MaximumBenefitPerOrder,Avg(`Benefit per order`)as AverageBenefitPerOrder,Sum(`Benefit per order`)as TotalBenefitPerOrder from supply_chain;
#check negative sales
select * from supply_chain Where Sales<0;
#check profit
select * from supply_chain where `Order Item Profit Ratio`<0;

#phase 3:Demand Analysis
select distinct `Product Name` from supply_chain;
select `Product Name`, sum(`Sales`)as total_sales,sum(`Order Item Quantity`)as Quantity from supply_chain group by `Product Name` order by Total_sales Desc;
#total sales by region
select `Order Region`,sum(`Sales`) as total_sales from supply_chain group by `Order Region` Order by total_sales DESC;
#Sales by product Category
select `Category Name` ,sum(`Sales`) as total_sales from supply_chain group by `Category Name` Order by total_sales DESC;
#top 10 products by sales
select `Product Name` ,sum(`Sales`)as total_sales from supply_chain group by `Product Name` Order By total_sales DESC Limit 10;
#monthly sales trend
select `Order Year` as order_year,`Order Month Name`as order_month ,sum(Sales)as monthly_sales from supply_chain group by order_month,order_year order by order_month,order_year DESC;

#Phase 4:Transportation Analysis
select * from supply_chain;
#Orders by shipping mode
select `Shipping Mode` ,count(*) as total_records,avg(`Days for shipping (real)`) as avg_shipping_days from supply_chain group by `Shipping Mode`;
#actual vs scheduled shipping time
select avg(`Days for shipping (real)`)as actual_shipping_days ,avg(`Days for shipment (scheduled)`)as scheduled_shipping_days from supply_chain;
#calculate shipping dealys
select avg(`Days for shipping (real)`-`Days for shipment (scheduled)`)as avg_delays from supply_chain;
#shipping performance by region
select `Order Region`,`Shipping Performance`,count(`Order Item Quantity`)as shippingbyregion from supply_chain Group by `Order Region`,`Shipping Performance`;

#Phase 5:Deliverry Performance Analysis
select * from supply_chain;
#Late vs On-time Deliveries
select `Delivery Status`,count(*)as total_deliveries from supply_chain group by `Delivery Status` order by total_deliveries DESC;
#Late delivery Percantage
select count(*)as total_records,sum(`Late Delivery Risk`)as late_risk_deliveries ,round(sum(`Late Delivery Risk`)*100.0/count(*),2)as late_delivery_percentage from supply_chain;
#late delivery risk by shipping mode
select `Shipping Mode`,count(*)as total_records,sum(`Late Delivery Risk`)as risk_records from supply_chain group by `Shipping Mode` order by risk_records DESC;
#late delivery risk by region
select `Order Region`,count(*)as total_records,sum(`Late Delivery Risk`)as risks_records from supply_chain group by `Order Region` order by risks_records DESC;

#Phase 5:Advanced Analysis
select * from supply_chain;
#use case when
select `Order Id`,`Days for shipping (real)`,CASE WHEN `Days for shipping (real)`<=2 THEN 'FAST DELIVERY' WHEN `Days for shipping (real)`<=5 THEN 'NORMAL DELIVERY' ELSE 'SLOW DELIVERY' END AS Delivey_category from supply_chain;
#use having
select `Category Name`,round(sum(`Sales`),2)as total_sales from supply_chain group by `Category Name` Having total_sales>1000000;
#Use subquery
select `Product Name`,sum(Sales)as total_sales from supply_chain Group by `Product Name` Having sum(Sales)>(
select avg(product_sales) from (select sum(Sales)as product_sales from supply_chain group by `Product Name`)as product_summary);
#use CTE
with category_sales as(select `Category Name`,sum(Sales)as total_sales from supply_chain group by `Category Name`) select * from category_sales order by total_sales DESC;

#use window function
select `Product Name`,sum(Sales)as total_sales,RANK() OVER(ORDER BY SUM(Sales)DESC)as supply_rank from supply_chain group by `Product Name`;

#Phase 7:Create Sql Views
#Create Demand View Analysis
show tables;
drop View demand_analysis;
CREATE VIEW demand_analysis as select `Category Name`,`Order Region`,sum(Sales)as total_sales,count(Distinct `Order Id`)as total_orders from supply_chain Group by `Category Name`,`Order Region`;

#Phase 8:Performance and final preparation
SHOW INDEX from supply_chain;
#FOR SUPPLY CHAIN PROJECT CRAETE INDESXES ON COLUMNS WHRE WE USE WHERE,GROUP BY,JOIN OPERATIONS FREQUENTLY
CREATE INDEX idx_category ON supply_chain(`Category Name`(50));
CREATE INDEX idx_region ON supply_chain(`Order region`(50));