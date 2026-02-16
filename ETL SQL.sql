-- E-Commerce API Data Warehouse Project
-- Skills: Data Modeling, ETL (Extract, Transform, Load), Star Schema Design, Aggregations, Multi-Table Joins
-- Focus: Customer and product-level insights
-- Tool: PostgreSQL (loaded via SQLAlchemy from Python)


-- 1. Total Revenue --

select sum(ci.quantity * p.price) as total_revenue
from cart_items ci 
join products p 
on ci.product_id = p.id ;

-- 2. Total Orders --

select COUNT(distinct id) as total_orders
from carts c ;

-- 3. Total Customers --

select COUNT(*) as total_customers
from users u ;

-- 4. Revenue by Product --

select p.title, SUM(p.price * ci.quantity) as product_revenue
from products p 
join cart_items ci 
on p.id = ci.product_id
group by p.title
order by product_revenue desc ;

-- 5. Revenue by Category -- 

select p.category, SUM(p.price * ci.quantity) as category_revenue
from products p 
join cart_items ci 
on p.id = ci.product_id
group by p.category
order by category_revenue desc;

-- 6. Top Customers by Revenue -- 

select u.id, u.fname, u.lname, SUM(p.price * ci.quantity) as customer_revenue
from users u 
join carts c 
on u.id = c."userId"
join cart_items ci 
on c.id = ci.cart_id
join products p 
on ci.product_id = p.id 
group by u.id, u.fname, u.lname
order by customer_revenue desc;

-- 7. Orders per Customer --

select u.id, u.lname, COUNT(c.id) as total_customer_orders
from users u 
join carts c
on u.id = c."userId"
group by u.id, u.lname
order by total_customer_orders desc;

-- 8. Average Order Value --

select c.id, sum(ci.quantity * p.price) as order_total
from carts c 
join cart_items ci 
on c.id = ci.cart_id
join products p 
on ci.product_id = p.id
group by c.id;

select round(avg(order_total)::numeric, 2) as avg_order_value
from (
		select c.id, sum(ci.quantity * p.price) as order_total
		from carts c 
		join cart_items ci 
		on c.id = ci.cart_id
		join products p 
		on ci.product_id = p.id
		group by c.id
	) sub;

-- 9. Top 5 Best-Selling Products by Quantity --

select p.title, sum(ci.quantity) as total_quantity_sold
from cart_items ci 
join products p 
on product_id = p.id
group by p.title
order by total_quantity_sold desc 
limit 5;

-- 10. Products Never Purchased --

select p.title
from products p 
left join cart_items ci 
on p.id = ci.product_id
where ci.product_id is null;


