/* ============================
          Data import 
   ============================*/

create database amazon;
use amazon;
create table amazon_sales(OrderID varchar(20), OrderDate date, CustomerID varchar(20), CustomerName varchar(20), ProductID varchar(20), ProductName varchar(100), Category varchar(100), Brand varchar(50), Quantity int, UnitPrice Decimal(10,2), TotalCost Decimal(10,2),Discount int,TotalSales Decimal(15,2), Tax Decimal(10,2), shippingCost Decimal(12,2),TotalExpenses decimal(10,2), TotalProfit Decimal(15,2), PaymentMethod varchar(50), OrderStatus varchar(30), City Varchar(100), State_Name varchar(100), Country varchar(100), SellerID varchar(20)); 
desc amazon_sales;
Load data local infile "C:/Users/HP/Desktop/Riya/IGNOU Project/Dataset.csv"
into table amazon_sales
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;
select count(*) from amazon_sales;
select * from amazon_sales;

/* ================================
       SQL Analysis
   Amazon Sales Data Analysis 
   ============================== */
   # 1.Find Total No. of Orders
select count(distinct OrderID) as Total_Orders from amazon_sales;

# 2.Total No. of Unique Customer
select count(distinct CustomerID) as Unique_Customers from amazon_sales;

# 3.Calcualte Total Sales
select sum(TotalSales) as total_sales from amazon_sales;

#  4.Calculate Total Profit
select sum(TotalProfit) as total_sales from amazon_sales;

# 5.Calcualte total quantity Sold
select sum(quantity) as total_quantity from amazon_sales;

# 6.Calcuate average order value
select OrderID ,round(avg(TotalSales),2) as average_Order from Amazon_sales
group by OrderId
Order by Average_Order desc;

# 7.Calculate total Expenses
select sum(TotalExpenses) as total_tax from amazon_sales;

# 8.Profit Margin
select ((sum(totalProfit)/sum(totalSales))*100)as Profit_Margin from amazon_sales;

# 9.Top 10 product
select ProductId, ProductName, sum(TotalSales) as Total_sales, sum(TotalProfit) as Total_Profit from amazon_sales
group by ProductId, ProductName
order by total_sales desc, Total_Profit desc limit 10;

# 10.Bottom 10 products 
select ProductId, ProductName, sum(TotalSales) as total_sales, sum(TotalProfit) as Total_Profit from amazon_sales
group by ProductId, ProductName
order by total_sales asc,Total_Profit asc limit 10;

# 11.Sales & profit by product category
select category, sum(TotalSales) as total_sales, sum(TotalProfit) as Total_Profit from amazon_sales
group by category
order by total_sales desc, Total_Profit desc;

# 12.Country wise sales & Profit
select Country,sum(TotalSales) as Total_sales, sum(TotalProfit) as Total_Profit from amazon_sales
group by country
order by Total_Sales desc,Total_Profit desc;

# 13.State wise sales
select State_Name,sum(TotalAmount) as Total_sales from amazon_sales
group by State_Name
order by Total_Sales desc;

# 14.City wise sales
select City,sum(TotalAmount) as Total_sales from amazon_sales
group by City
order by Total_Sales desc;

# 15.Sales & Profit by payment method
select paymentMethod, sum(TotalSales) as total_sales, sum(TotalProfit) as total_Profit from amazon_sales
group by paymentMethod
order by total_sales desc, total_Profit desc;

# 16.Most used PaymentMethod
select paymentMethod, count(orderID) as Number_OF_Orders from amazon_sales
group by paymentMethod
order by Number_OF_Orders desc limit 1;

# 17.Calculate order count and sales by Order Status
select OrderStatus, count(orderID) as OrderCount, sum(TotalSales) as Total_sales, Sum(TotalProfit) as Total_Profit from amazon_sales
group by OrderStatus
order by Total_sales desc,Total_Profit desc;

# 16.Top 10 seller by revenue
select sellerID, sum(TotalSales) as Total_Sales,sum(TotalProfit) as Total_Profit from Amazon_sales
group by sellerID
order by Total_Sales desc,Total_Profit desc limit 10;

# 18.Seller-Wise order count
select sellerID, count(orderID) as Order_Count from Amazon_sales
group by sellerID
order by Order_Count desc ;

# 19.Seller with the highest revenue
select sellerID, sum(TotalSales) as Total_Sales, sum(TotalProfit) as Total_Profit from Amazon_sales
group by sellerID
order by Total_Sales desc,Total_Profit desc limit 1;

#20.Find products whose sales are higher than the average product sales
select ProductID,ProductName, sum(TotalSales) as Total_sales from Amazon_sales
group by ProductID,ProductName
having sum(TotalSales) > (select avg(Product_sales) from (select ProductID, sum(TotalSales) as Product_sales from amazon_sales
group by ProductID
) as Product_summary
)
order by Total_sales desc; 

# 21.Rank products based on total sales
select ProductID,ProductName, Total_sales, rank() over (order by Total_sales desc) as Sales_Rank
from (
select ProductId,ProductName, sum(TotalSales) as total_Sales from Amazon_sales
group by ProductID,ProductName
) as Product_sales
order by Sales_rank;

# 22.Top 3 Product in each Category
select ProductID, ProductName, Category, Product_Rank, Total_sales
from(
select ProductID, ProductName, category, sum(TotalSales) as total_sales,
row_number() over
(partition by category
order by sum(TotalSales) desc, sum(TotalProfit) desc
) as Product_Rank
from amazon_sales
group by category, productId, ProductName) as ranked_Products
where Product_Rank<=3
order by category, Product_Rank;



