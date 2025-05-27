--create database
create database OnlineBookStore;

-- Switch to the database
\c OnlineBookStore;

--create books table
drop table if exists Books;
create table Books (
	Book_ID serial primary key,
	Title varchar(100),	
	Author varchar(100),	
	Genre varchar(50),	
	Published_Year int,	
	Price numeric(10,2),
	Stock int
)

select * from Books;

--create customers table
drop table if exists customers;
create table customers (
	Customer_ID serial primary key,	
	Name varchar(100),	
	Email varchar(100),	
	Phone varchar(15),
	City varchar(50),	
	Country varchar(150)
)

select * from customers;

--create orders table
drop table if exists orders;
create table orders (
	Order_ID serial primary key,	
	Customer_ID int references customers(customer_id),	
	Book_ID int references Books(book_id),	
	Order_Date date,	
	Quantity int,	
	Total_Amount numeric(10,2)
)

select * from orders;

--import books data
copy Books(Book_ID,	Title,	Author,	Genre,	Published_Year,	Price, Stock)
from 'C:\Program Files\PostgreSQL\17\Books.csv'
csv header;

--import customers data
copy customers(Customer_ID,	Name,	Email,	Phone,	City,	Country)
from 'C:\Program Files\PostgreSQL\17\Customers.csv'
csv header;

--import orders data
copy orders(Order_ID,	Customer_ID,	Book_ID,	Order_Date,	Quantity,	Total_Amount)
from 'C:\Program Files\PostgreSQL\17\Orders.csv'
csv header;

-- 1) Retrieve all books in the "Fiction" genre:
select * from Books
where genre = 'Fiction';

-- 2) Find books published after the year 1950:
select * from Books
where Published_year>1950;

-- 3) List all customers from the Canada:
select * from Customers
where country = 'Canada';

-- 4) Show orders placed in November 2023:
select * from orders
where order_date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
select sum(stock) as total_stock
from books;

-- 6) Find the details of the most expensive book:
select * from books;

select * from books
order by price desc
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders;

select * from orders where quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders
where total_amount>20;

-- 9) List all genres available in the Books table:
select distinct genre from books;

-- 10) Find the book with the lowest stock:
select * from books
order by stock
limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount) as total_revenue
from orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select * from orders;
select * from books;
select * from customers;

select b.genre, sum(o.quantity) as total_books_sold
from orders o
join books b on o.book_id = b.book_id
group by b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as average_price
from books
where genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:
select o.customer_id, c.name, count(o.order_id) as order_count
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id, c.name
having count(order_id) >=2;

-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;


-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;