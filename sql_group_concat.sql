create table orders_data
   (
      cust_id int,
      order_id int,
      country varchar(50),
      state varchar(50)
    );

insert into orders_data values(1,100,'USA','Texas');
insert into orders_data values(2,101,'INDIA','UP');
insert into orders_data values(2,103,'INDIA','Bihar');
insert into orders_data values(4,108,'USA','Washington');
insert into orders_data values(5,109,'UK','London');
insert into orders_data values(4,110,'USA','Washington');
insert into orders_data values(3,120,'INDIA','AP');
insert into orders_data values(2,121,'INDIA','Goa');
insert into orders_data values(1,131,'USA','Texas');
insert into orders_data values(6,142,'USA','Texas');
insert into orders_data values(7,150,'USA','Texas');

--Example for GROUP_CONCAT
select 
  country,
  count(*) as total_orders,
  GROUP_CONCAT(state) as list_of_states
from orders_data
group by country;

select 
  country,
  count(*) as total_orders,
  GROUP_CONCAT(distinct state order by state) as list_of_states
from orders_data
group by country;

select 
  country,
  count(*) as total_orders,
  GROUP_CONCAT(distinct state order by state separator ' | ') as list_of_states
from orders_data
group by country;

create table payment (payment_amount decimal(8,2),
  payment_date date,
  store_id int);
  
insert into payment
  values
  (1200.99, '2018.01.08',1),
  (189.23, '2018.02.15',1),
  (33.43, '2018.03.03',3),
  (7382.10, '2019.01.11',2),
  (382.92, '2019.02.18',1),
  (322.34, '2019.03.29',2),
  (2929.14, '2020.01.03',2),
  (499.02, '2020.02.19',3),
  (994.11, '2020.03.14',1),
  (394.93, '2021.01.22',2),
  (3332.23, '2021.02.23',3),
  (9499.49, '2021.03.10',3),
  (3002.43, '2018.02.25',2),
  (100.99, '2019.03.07',1),
  (211.65, '2020.02.02',1),
  (1500.73, '2021.01.06',3);

-- Example for ROLLUP
select sum(payment_amount),
  year(payment_date) as 'Payment Year',
  store_id as 'Store'
from payment 
group by year(payment_date), store_id with ROLLUP

order by year(payment_date), store_id;
