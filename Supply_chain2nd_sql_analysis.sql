#sku:stock keeping unit
show databases;
use Supply_chain_management;
show tables;
select count(*) from supplychain2nd;
select * from supplychain2nd limit 10;
#check columns and their dataypes
describe supplychain2nd;
#data quality check 
select count(*) from supplychain2nd where `Product type` is NULL;
#check distinct product type
select distinct `Product type` from supplychain2nd;
#count unique suppliers
select count(Distinct `supplier name`)from supplychain2nd;
#check misssing values
select count(*)as total_records,sum(`Product type` is null)as missing_product_type,
sum(`Supplier name`is null)as missing_supplier_name,sum(`Stock levels`is null)as missing_stock_levels,
sum(`Lead times`is null)as missing_lead_times from supplychain2nd;

select * from supplychain2nd limit 10;
#inventaory analysis
#inventory summary and stock type
select `Product type`,sum(`stock levels`)as total_stock_levels,
sum(`Number of products sold`)as total_sold,sum(`Revenue generated`)as total_revenue,avg(`Price`)as Average_price from supplychain2nd
group by `Product type` order by total_revenue DESC;
#which product tye contributes the most revenue annd sales;
#top 10 sellong products
select `SKU`,`Product type`,sum(`Number of products sold`)as total_sold from supplychain2nd group by `SKU`,`Product type` order by total_sold DESC limit 10;
#whick product has higgest sales volume

select `SKU`,`Product type`,sum(`Stock levels`)as total_stock from supplychain2nd group by `SKU`,`Product type` order by total_stock DESC limit 5;
#which product hold the higgest inventory

#product-wise revenue contribution
select `Product type`,sum(`Revenue generated`)as total_revenue,
round(sum(`Revenue generated`)*100/NULLIF((select sum(`Revenue generated`)from supplychain2nd),0),2)as revenue_percentage from supplychain2nd group by`Product type` order by total_revenue DESC;

#inventory classification
select `SKU`,`product type`,case when `Stock levels`<50 then 'Low stock'
when `Stock levels` between 50 and 150 then 'Medium stock' else 'High Stock'
end as stock_status from supplychain2nd;


select * from supplychain2nd limit 3;
#supplier analysis
select `Supplier name`,count(*) as total_records,sum(`Production volumes`)as total_production,
avg(`Lead times`)as average_lead_time,avg(`Defect rates`)as average_defect_rates,sum(`Manufacturing costs`)as total_manufacturing_cost
from supplychain2nd group by `Supplier name` order by total_production DESC;

#supplier with higest manugacturing
select `Supplier name`,sum(`Manufacturing costs`)as total_manufacturing_cost from supplychain2nd group by `Supplier name` order by total_manufacturing_cost DESC;

#inspection performance
select `Supplier name`,`Inspection results`,count(*)as inspection_count
from supplychain2nd group by `Supplier name`,`Inspection results` order by `Supplier name`;

#supplier cost efficiency
select `Supplier Name`,sum(`Revenue generated`)as revenue_generated,
sum(`Manufacturing costs`)as manufacturing_cost,
round(sum(`Revenue generated`)*100/nullif((select sum(`Manufacturing costs`)from supplychain2nd),0),2)as revenue_cost_ratio
from supplychain2nd group by `Supplier name` order by revenue_cost_ratio;

#Create Sql Views
#Create Inventory View Analysis
CREATE OR REPLACE VIEW  InventoryAnalysis as select `Product type`,sum(`Revenue generated`)as total_revenue,sum(`Number of products sold`)as total_sold ,
avg(`Price`)as Average_price from supplychain2nd group by `Product type` order by total_revenue DESC;
select * from InventoryAnalysis;

#Create Supplier View Analysis
create or replace view SupplierAnalysis as select `Supplier Name`,sum(`Revenue generated`)as revenue_generated,sum(`Manufacturing costs`)as total_manufacturing_cost,
avg(`Lead times`)as average_lead_time,avg(`Defect rates`)as average_defect_rates from supplychain2nd group by `Supplier Name` order by total_manufacturing_cost DESC;
select * from InventoryAnalysis;

show tables;