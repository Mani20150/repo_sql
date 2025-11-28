CREATE TABLE daily_sales (
    sales_date DATE,
    sales_amount DECIMAL(10,2)
);

insert into daily_sales values ('2022-03-11',400);
insert into daily_sales values ('2022-03-12',500);
insert into daily_sales values ('2022-03-13',300);
insert into daily_sales values ('2022-03-14',600);
insert into daily_sales values ('2022-03-15',500);
insert into daily_sales values ('2022-03-16',500);

select * from daily_sales;
Output:
+------------+--------------+
| sales_date | sales_amount |
+------------+--------------+
| 2022-03-11 |       400.00 |
| 2022-03-12 |       500.00 |
| 2022-03-13 |       300.00 |
| 2022-03-14 |       600.00 |
| 2022-03-15 |       500.00 |
| 2022-03-16 |       500.00 |
+------------+--------------+

***Using LAG***
select *, lag(sales_amount, 1, 0) over(order by sales_date) as pre_day_sales from daily_sales;
Output:
+------------+--------------+---------------+
| sales_date | sales_amount | pre_day_sales |
+------------+--------------+---------------+
| 2022-03-11 |       400.00 |          0.00 |
| 2022-03-12 |       500.00 |        400.00 |
| 2022-03-13 |       300.00 |        500.00 |
| 2022-03-14 |       600.00 |        300.00 |
| 2022-03-15 |       500.00 |        600.00 |
| 2022-03-16 |       500.00 |        500.00 |
+------------+--------------+---------------+

select *, lag(sales_amount, 2) over(order by sales_date) as pre_day_sales from daily_sales;
Output:
+------------+--------------+---------------+
| sales_date | sales_amount | pre_day_sales |
+------------+--------------+---------------+
| 2022-03-11 |       400.00 |          NULL |
| 2022-03-12 |       500.00 |          NULL |
| 2022-03-13 |       300.00 |        400.00 |
| 2022-03-14 |       600.00 |        500.00 |
| 2022-03-15 |       500.00 |        300.00 |
| 2022-03-16 |       500.00 |        600.00 |
+------------+--------------+---------------+

select *, lag(sales_amount, 2, 0) over(order by sales_date) as pre_day_sales from daily_sales;
Output:
+------------+--------------+---------------+
| sales_date | sales_amount | pre_day_sales |
+------------+--------------+---------------+
| 2022-03-11 |       400.00 |          0.00 |
| 2022-03-12 |       500.00 |          0.00 |
| 2022-03-13 |       300.00 |        400.00 |
| 2022-03-14 |       600.00 |        500.00 |
| 2022-03-15 |       500.00 |        300.00 |
| 2022-03-16 |       500.00 |        600.00 |
+------------+--------------+---------------+

select sales_date, sales_amount as current_day_sales, 
  lag(sales_amount, 1, 0) over(order by sales_date) as pre_day_sales, 
  (sales_amount - lag(sales_amount, 1, 0) over(order by sales_date)) as sales_diff from daily_sales;
 Output:
+------------+-------------------+---------------+------------+
| sales_date | current_day_sales | pre_day_sales | sales_diff |
+------------+-------------------+---------------+------------+
| 2022-03-11 |            400.00 |          0.00 |     400.00 |
| 2022-03-12 |            500.00 |        400.00 |     100.00 |
| 2022-03-13 |            300.00 |        500.00 |    -200.00 |
| 2022-03-14 |            600.00 |        300.00 |     300.00 |
| 2022-03-15 |            500.00 |        600.00 |    -100.00 |
| 2022-03-16 |            500.00 |        500.00 |       0.00 |
+------------+-------------------+---------------+------------+

***Using LEAD***
select *, lead(sales_amount, 1, 0) over(order by sales_date) as pre_day_sales from daily_sales;
Output:
+------------+--------------+---------------+
| sales_date | sales_amount | pre_day_sales |
+------------+--------------+---------------+
| 2022-03-11 |       400.00 |        500.00 |
| 2022-03-12 |       500.00 |        300.00 |
| 2022-03-13 |       300.00 |        600.00 |
| 2022-03-14 |       600.00 |        500.00 |
| 2022-03-15 |       500.00 |        500.00 |
| 2022-03-16 |       500.00 |          0.00 |
+------------+--------------+---------------+

***Using PRECEDING and FOLLOWING***

select *, sum(sales_amount) over (order by sales_date rows between 1 preceding and 1 following) as prev_plus_next_sales_sum from daily_sales;
Output:
+------------+--------------+----------------+
| sales_date | sales_amount | prev_plus_next |
+------------+--------------+----------------+
| 2022-03-11 |       400.00 |         900.00 |
| 2022-03-12 |       500.00 |        1200.00 |
| 2022-03-13 |       300.00 |        1400.00 |
| 2022-03-14 |       600.00 |        1400.00 |
| 2022-03-15 |       500.00 |        1600.00 |
| 2022-03-16 |       500.00 |        1000.00 |
+------------+--------------+----------------+

select *, sum(sales_amount) over (order by sales_date rows between 1 preceding and current row) as prev_plus_next_sales_sum from daily_sales;
Output:
+------------+--------------+--------------------------+
| sales_date | sales_amount | prev_plus_next_sales_sum |
+------------+--------------+--------------------------+
| 2022-03-11 |       400.00 |                   400.00 |
| 2022-03-12 |       500.00 |                   900.00 |
| 2022-03-13 |       300.00 |                   800.00 |
| 2022-03-14 |       600.00 |                   900.00 |
| 2022-03-15 |       500.00 |                  1100.00 |
| 2022-03-16 |       500.00 |                  1000.00 |
+------------+--------------+--------------------------+

select *, sum(sales_amount) over (order by sales_date rows between current row and 1 following) as prev_plus_next_sales_sum from daily_sales;
Output:
+------------+--------------+--------------------------+
| sales_date | sales_amount | prev_plus_next_sales_sum |
+------------+--------------+--------------------------+
| 2022-03-11 |       400.00 |                   900.00 |
| 2022-03-12 |       500.00 |                   800.00 |
| 2022-03-13 |       300.00 |                   900.00 |
| 2022-03-14 |       600.00 |                  1100.00 |
| 2022-03-15 |       500.00 |                  1000.00 |
| 2022-03-16 |       500.00 |                   500.00 |
+------------+--------------+--------------------------+

select *, sum(sales_amount) over (order by sales_date rows between 2 preceding and 1 following) as prev_plus_next_sales_sum from daily_sales;
Output:
+------------+--------------+--------------------------+
| sales_date | sales_amount | prev_plus_next_sales_sum |
+------------+--------------+--------------------------+
| 2022-03-11 |       400.00 |                   900.00 |
| 2022-03-12 |       500.00 |                  1200.00 |
| 2022-03-13 |       300.00 |                  1800.00 |
| 2022-03-14 |       600.00 |                  1900.00 |
| 2022-03-15 |       500.00 |                  1900.00 |
| 2022-03-16 |       500.00 |                  1600.00 |
+------------+--------------+--------------------------+

select *, sum(sales_amount) over (order by sales_date rows between unbounded preceding and current row) as prev_plus_next_sales_sum from daily_sales;
Output:
+------------+--------------+--------------------------+
| sales_date | sales_amount | prev_plus_next_sales_sum |
+------------+--------------+--------------------------+
| 2022-03-11 |       400.00 |                   400.00 |
| 2022-03-12 |       500.00 |                   900.00 |
| 2022-03-13 |       300.00 |                  1200.00 |
| 2022-03-14 |       600.00 |                  1800.00 |
| 2022-03-15 |       500.00 |                  2300.00 |
| 2022-03-16 |       500.00 |                  2800.00 |
+------------+--------------+--------------------------+

select *, sum(sales_amount) over (order by sales_date rows between unbounded preceding and unbounded following) as prev_plus_next_sales_sum from daily_sales;
Output:
+------------+--------------+--------------------------+
| sales_date | sales_amount | prev_plus_next_sales_sum |
+------------+--------------+--------------------------+
| 2022-03-11 |       400.00 |                  2800.00 |
| 2022-03-12 |       500.00 |                  2800.00 |
| 2022-03-13 |       300.00 |                  2800.00 |
| 2022-03-14 |       600.00 |                  2800.00 |
| 2022-03-15 |       500.00 |                  2800.00 |
| 2022-03-16 |       500.00 |                  2800.00 |
+------------+--------------+--------------------------+

insert into daily_sales values ('2022-03-20',900);
insert into daily_sales values ('2022-03-23',200);
insert into daily_sales values ('2022-03-25',300);
insert into daily_sales values ('2022-03-29',250);

select *, sum(sales_amount) over(order by sales_date range between interval '6' day preceding and current row) as running_weekly_sales from daily_sales;
