CREATE TABLE public.pizza_sales(
	pizza_id INT PRIMARY KEY,
	order_id INT,
	pizza_name_id VARCHAR(50),
	quantity INT,
	order_date TEXT,
	order_time TIME,
	unit_price FLOAT,
	total_price FLOAT,
	pizza_size VARCHAR(50),
	pizza_category VARCHAR(50),
	pizza_ingredients VARCHAR(200),
	pizza_name VARCHAR(50)
);


-- Mengubah tipe data kolom dari TEXT ke DATE
ALTER TABLE Public.pizza_sales
ALTER COLUMN order_date TYPE DATE
USING TO_DATE(order_date, 'DD-MM-YYYY');

--Mencari Total Revenue
SELECT SUM(total_price) AS Total_Revenue
FROM public.pizza_sales

--Mencari rata-rata Order Value
SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS Average_OrderValue
FROM public.pizza_sales

--Mencari Total Quantity
SELECT SUM(quantity) AS Total_Penjualan
FROM public.pizza_sales

--Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Order
FROM public.pizza_sales

--AVG Pizza per Order
SELECT SUM(quantity)/COUNT(DISTINCT order_id) AS AVG_perOrder
FROM public.pizza_sales
--Memunculkan angka decimal (2 angka)
SELECT ROUND(CAST(SUM(quantity) AS DECIMAL(10,2))/CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)),2) AS AVG_perOrder
FROM public.pizza_sales

--Berapa banyak pesanan dalam masing-masing hari
SELECT TO_CHAR(order_date, 'Day') AS order_day, COUNT(DISTINCT order_id) AS Total_Order
FROM public.pizza_sales
GROUP BY TO_CHAR(order_date, 'Day'), EXTRACT(DOW FROM order_date)
ORDER BY Total_Order DESC

--Ini berdasarkan Bulan
SELECT TO_CHAR(order_date, 'Month') AS order_month, COUNT(DISTINCT order_id) AS Total_Order
FROM public.pizza_sales
GROUP BY TO_CHAR(order_date, 'Month'), EXTRACT(MONTH FROM order_date)
ORDER BY Total_Order DESC

--Persentase Penjualan berdasarkan Category
SELECT pizza_category, SUM(total_price) AS Total_Sales, SUM(total_price)*100/(SELECT SUM(total_price)FROM pizza_sales) AS Persentase_Sales
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 1
GROUP BY pizza_category
ORDER BY Persentase_Sales DESC

--Persentase Penjualan berdasarkan Size
SELECT pizza_size, 
	CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales, 
	CAST(SUM(total_price)*100/(SELECT SUM(total_price)FROM pizza_sales WHERE EXTRACT(QUARTER FROM order_date) = 1) AS DECIMAL(10,2)) AS Persentase_Sales
FROM pizza_sales
WHERE EXTRACT(QUARTER FROM order_date) = 1
GROUP BY pizza_size
ORDER BY Persentase_Sales DESC

--Total Pizza terjual berdasarkan Category
SELECT pizza_category, SUM(quantity) AS Total_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Sold DESC

--Melihat Top 5 dan Terbawah 5 pada Penjualan Berdasarkan Nama
SELECT pizza_name, 
	SUM(total_price) AS Total_Revenue,
	SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC 
LIMIT 5;

SELECT * FROM Public.pizza_sales