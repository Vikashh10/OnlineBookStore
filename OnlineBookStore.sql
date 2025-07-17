create database OnlineBookStore;

-- create tables
drop table if exists Books;
create table Books (
       Book_id serial primary key,
       Title varchar(100),
       Author varchar(100),
       Genre varchar(50),
       Published_year int,
       Price numeric(10,2),
       Stock int
);
drop table if exists Customers;
create table Customers (
		Customer_id serial primary key,
        name  varchar(100),
        Email  varchar(100),
        Phone  varchar(50),
        City  varchar(100),
        Country  varchar(150)
);
drop table if exists Orders;
create table Orders (
         Order_id serial primary key,
         Customer_id int references Customers(Customer_id),
         Book_id int references Books(Book_id),
         Order_Date date,
         Quantity int,
         Total_Amount numeric(10,2)
);         
        
select * from books;
select * from customers;
select * from Orders;

-- import data into Books table
-- import data into customer table
-- import data into orders table


-- business insight queries

-- Q1.Retrieve the total number of books sold for each genre.
select b.Genre, sum(o.Quantity) as Total_Books_Sold
from orders o 
join books b on o.Book_id = b.Book_id
group by b.Genre;

-- Q2.Find the average price of books in the "fantasy" genre. 
select avg(Price) as Average_Price
from books
where Genre = "Fantasy";

-- Q3.List Customers who have placed at least 2 orders. 
select Customer_id, count(Order_id) as ORDER_COUNT
from orders
group by Customer_id
having count(Order_id) >= 2; 

-- Q4.Find the most frequently ordered book.
select o.Book_id, count(o.Order_id) as ORDER_COUNT
from orders o 
group by Book_id
order by ORDER_COUNT desc limit 1; 

-- Q5.Show the top 3 most expensive books of "fantasy" genre. 
select * from books
where Genre = "Fantasy"
 order by price desc limit 3;      
 
 -- Q6.Retrieve the total quantity of books sold by each author. 
 select b.author, sum(o.quantity) as Total_Books_Sold
 from orders o 
 join books b on o.Book_id = b.Book_id
 group by b.Author;
 
 -- Q7.List the cities where customers who spent over 30 dollar are located. 
 select distinct c.city, total_amount
 from orders o 
 join customers c on o.customer_id = c.customer_id
 where o.total_amount > 30;
 
-- Q8.Find the customer who spent the most on order.
select c.customer_id, c.name, sum(o.total_amount) as Total_spent
from orders o 
join customers c on o.Customer_id = c.Customer_id
group by c.Customer_id, c.name
order by total_spent desc limit 1;

-- Q9.Calculate the stock remaining after fulfilling all orders.
select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as Order_quantity,
b.stock -  coalesce(sum(o.quantity),0) as Remaining_quantity
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id;