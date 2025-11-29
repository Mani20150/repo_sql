--*** examples for Recursive CTE ***
--*** Common Table Expression ***
 create table amazon_employee (
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int
    );

 insert into amazon_employee values (1, 'Mani', 100, 30000);
 insert into amazon_employee values (2, 'Rajini', 100, 20000);
 insert into amazon_employee values (3, 'Kamal', 101, 15000);
 insert into amazon_employee values (4, 'Ilayaraja', 101, 17000);
 insert into amazon_employee values (5, 'Bharathiraja', 102, 10000);
 
create table department (
  dept_id int,
  dept_name varchar(20)
  );
 
 insert into department values (100, 'Editing');
 insert into department values (101, 'Music');
 insert into department values (102, 'Direction');
 insert into department values (103, 'Story Development');
 
 with dept_wise_salary as (select dept_id, sum(salary) as total_salary
   from amazon_employee group by dept_id)
   
   select d.dept_name, tmp.total_salary
   from dept_wise_salary tmp
   inner join department d on tmp.dept_id = d.dept_id;

Output:
+-----------+--------------+
| dept_name | total_salary |
+-----------+--------------+
| Editing   |        50000 |
| Music     |        32000 |
| Direction |        10000 |
+-----------+--------------+

--*** Recursive examples ***

with recursive generate_numbers as 
(
  select 1 as n
  union
  select n+1 from generate_numbers where n <= 10
)
select * from generate_numbers;

Output:
+------+
| n    |
+------+
|    1 |
|    2 |
|    3 |
|    4 |
|    5 |
|    6 |
|    7 |
|    8 |
|    9 |
|   10 |
|   11 |
+------+

create table emp_mgr
( 
  id int,
  name varchar(50),
  manager_id int,
  designation varchar(50),
  primary key (id)
);

insert into emp_mgr values (1, 'Danush', null, 'CEO');
insert into emp_mgr values (2, 'Silambarasan', 5, 'SDE');
insert into emp_mgr values (3, 'Mohan', 5, 'DA');
insert into emp_mgr values (4, 'Ramarajan', 5, 'DS');
insert into emp_mgr values (5, 'Prakash', 7, 'Manager');
insert into emp_mgr values (6, 'Ravi', 7, 'Architect');
insert into emp_mgr values (7, 'Emi', 1, 'CTO');
insert into emp_mgr values (8, 'Nivas', 1, 'Manager');

with recursive emp_hir as 
(
  select id, name, manager_id, designation, 1 as lvl from emp_mgr where manager_id is null
  union
  select em.id, em.name, em.manager_id,  em.designation, eh.lvl+1 from emp_hir eh inner join emp_mgr em on eh.id = em.manager_id 
)

select * from emp_hir;

Output:
+------+--------------+------------+-------------+------+
| id   | name         | manager_id | designation | lvl  |
+------+--------------+------------+-------------+------+
|    1 | Danush       |       NULL | CEO         |    1 |
|    7 | Emi          |          1 | CTO         |    2 |
|    8 | Nivas        |          1 | Manager     |    2 |
|    5 | Prakash      |          7 | Manager     |    3 |
|    6 | Ravi         |          7 | Architect   |    3 |
|    2 | Silambarasan |          5 | SDE         |    4 |
|    3 | Mohan        |          5 | DA          |    4 |
|    4 | Ramarajan    |          5 | DS          |    4 |
+------+--------------+------------+-------------+------+

