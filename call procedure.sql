-- store procedure

-- List all department names in alphabetical order.

Delimiter $$
Create Procedure list_departments()
begin
    select *from Departments ORDER BY dept_name;
end $$


-- Show departments with more than 3 employees.

Delimiter $$
create procedure departments_with_more_than(IN emp_count INT)
begin
	select d.dept_name, COUNT(e.emp_id) AS total
    from Departments d
    left join Employees e ON d.dept_id = e.dept_id
    GROUP BY d.dept_name
    having total > emp_count; 
    
end$$    

-- List departments that have no employees assigned.

Delimiter $$
create procedure departments_no_employee()
begin
    select d.dept_name
    from Departments d
    left join Employees e ON d.dept_id = e.dept_id
    WHERE e.emp_id is null ;
end $$

-- Display all employees along with their department names.

Delimiter $$
create procedure employee_with_names()
begin
    select e.emp_name, d.dept_name
    from Employees as e
	inner join Departments as d on e.dept_id=d.dept_id;
end $$    

-- Show employees who joined before 2023 and earn above ₹40,000.

Delimiter $$
create procedure employee_year_salary(in srange INT,in jdate DATE)
begin
    select emp_name,join_date,salary
    from Employees where salary > srange and join_date < jdate;
end $$


-- List employees not assigned to any project.

Delimiter $$
create procedure employee_without_project()
begin
     select emp_name
	 from Employees
     where emp_id not in (select emp_id from Employee_Project);
end $$    


-- Count how many days each employee was present.

Delimiter $$
create procedure employee_present()
begin
     select emp_id,count(*) as present_days 
     from Attendance where status='present'
     GROUP BY emp_id;
end $$
  
-- Find employees who were absent more than 3 times

Delimiter $$
create procedure employee_absent(in abs_threshold INT)
begin
     select emp_id, COUNT(*) AS absent_days
	from Attendance
    where status = 'Absent'
    GROUP BY emp_id
    HAVING absent_days > abs_threshold;
end $$ 


-- Show attendance details for employees in the "Sales" department.

Delimiter $$
create procedure attendance_by_department(in dept_name VARCHAR(50))     
begin
    select e.emp_name, a.date, a.status
    from Attendance a
    inner join Employees e ON a.emp_id = e.emp_id
	inner join Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
end $$


-- List all active projects (end date is in the future).

Delimiter $$
create procedure active_projects()
begin
   select*from Projects WHERE end_date > CURDATE();
end $$   


-- Show projects and number of employees assigned to each.

Delimiter $$
create procedure project_assign_employee()
begin
    select p.project_name, COUNT(ep.emp_id) as total_employees
    from Projects p
    left join Employee_Project ep ON p.project_id = ep.project_id
    GROUP BY p.project_name;
end $$


-- Find the longest-running project (based on start and end date).

Delimiter $$
create procedure longest_project()
begin
     select project_name,DATEDIFF(end_date,start_date) as duration
     from projects
     ORDER BY duration DESC
     LIMIT 1;
end $$     

-- List employees along with their assigned project names.

Delimiter $$
create procedure employee_assign_projects()
begin 
	select e.emp_name, p.project_name
    from Employee_Project as ep
    inner join Employees e ON ep.emp_id = e.emp_id
    inner join Projects p ON ep.project_id = p.project_id;
end $$    


-- Find employees working on multiple projects.

Delimiter $$
create procedure employee_multiple_projects()
begin
	select emp_id, COUNT(project_id) AS total_projects
    from Employee_Project
    GROUP BY emp_id
    HAVING total_projects > 1;
end $$    

-- List projects that have no employees assigned.

delimiter $$
create procedure employee_no_project()
begin 
     select p.project_name
     from Projects p
	 left join Employee_Project ep ON p.project_id = ep.project_id
     WHERE ep.emp_id is null;
end $$


-- Show total income and expense recorded.

delimiter $$ 
create procedure total_income_expense()
begin
     select type, SUM(amount) AS total
     from Finance
    GROUP BY type;
end $$


-- List all finance transactions for employees in the “HR” department.

delimiter $$
create procedure finance_by_department(in dept_name VARCHAR(50))
begin
	select f.*
	from Finance f
    inner join Employees e ON f.emp_id = e.emp_id
    inner join Departments d ON e.dept_id = d.dept_id
    WHERE d.dept_name = dept_name;
end $$


-- Show the highest transaction amount and the employee who handled it.

delimiter $$
create procedure highest_transaction_employee()
begin
    select e.emp_name, f.amount
    from Finance f
    inner join Employees e ON f.emp_id = e.emp_id
    ORDER BY f.amount DESC
    limit 1;
end$$

-- Display all product names with their category and price.

delimiter $$
create procedure list_products()
begin
    select prod_name, category, unit_price from Products;
end $$

-- Find the most expensive product in each category.

delimiter $$
create procedure max_price_per_category()
begin
    select category, prod_name, unit_price
    from Products p
    where unit_price = (
        select MAX(p2.unit_price)
        from Products p2
        where p2.category = p.category
    );
end $$

-- Show products not involved in any sales.

delimiter $$
create procedure products_without_sales()
begin
    select prod_name from Products
    where prod_id NOT IN (select distinct prod_id from Sales);
end $$

-- List all products with their stock quantity and location.

delimiter $$
create procedure inventory_status()
begin
    select p.prod_name, i.quantity, i.location
    from Inventory i
    inner join Products p ON i.prod_id = p.prod_id;
end $$

-- Show products where quantity is less than 10.

delimiter $$
create procedure low_stock_products()
begin
    select p.prod_name, i.quantity
    from Inventory i
    inner join Products p ON i.prod_id = p.prod_id
    where i.quantity < 10;
end $$

-- Find the location with the highest total inventory quantity.

delimiter $$
create procedure top_inventory_location()
begin
    select location, SUM(quantity) as total_quantity
    from Inventory
    GROUP BY location
    ORDER BY total_quantity DESC
    limit 1;
end $$

-- List all vendors and the products they supplied.

delimiter $$
create procedure vendor_supplied_products()
begin
    select v.vendor_name, p.prod_name, pr.quantity
    from Procurement pr
    inner join Vendors v ON pr.vendor_id = v.vendor_id
    inner join Products p ON pr.prod_id = p.prod_id;
end $$

-- Find vendors who haven’t supplied any product.

delimiter $$
create procedure vendors_without_procurement()
begin
    select vendor_name from Vendors
    where vendor_id not in  (select distinct vendor_id from Procurement);
end $$

-- Show total quantity and cost of products supplied by each vendor.

delimiter $$
create procedure vendor_procurement_summary()
begin
    select v.vendor_name, SUM(p.quantity) as total_quantity, SUM(p.quantity * p.cost_price) AS total_cost
    from Procurement p
    inner join Vendors v on p.vendor_id = v.vendor_id
    GROUP BY v.vendor_name;
end $$

-- Show total procurement cost per product.

delimiter $$
create procedure product_procurement_cost()
begin
    select prod_id, SUM(quantity * cost_price) as total_cost
    from Procurement
    GROUP BY prod_id;
end $$

-- List all procurements made after January 1, 2025

delimiter $$
create procedure recent_procurements()
begin
    select *from Procurement WHERE proc_date > '2025-01-01';
end $$

-- Show products procured from more than one vendor.

delimiter $$
create procedure multi_vendor_products()
begin
    select prod_id
    from Procurement
    GROUP BY prod_id
    HAVING COUNT(distinct vendor_id) > 1;
end $$

-- List all customers from "Chennai".

delimiter $$
create procedure customers_from_city(in city_name varchar(50))
begin
    select * from Customers WHERE city = city_name ;
end $$

-- Show customers who made purchases in June 2025.

delimiter $$
create procedure customers_purchased_month()
begin
    select distinct c.cust_name
    from Sales s
    inner join Customers c on s.cust_id = c.cust_id
    WHERE MONTH(s.sale_date) = 6 AND YEAR(s.sale_date) = 2025;
end $$


-- Count how many customers exist in each city.

delimiter $$
create procedure customer_count_per_city()
begin
    select city, COUNT(*) AS total_customers
    from Customers
    GROUP BY city;
end $$

-- Show product-wise total sales quantity and amount

delimiter $$
create procedure sales_summary_per_product()
begin
	select s.prod_id, SUM(s.quantity) AS total_qty, SUM(s.quantity * p.unit_price) AS total_sales
	from Sales s
	inner join Products p ON s.prod_id = p.prod_id
    GROUP BY s.prod_id;
end $$

-- List all sales with customer name and product name.

delimiter $$
create procedure sales_detailed_list()
begin
    select s.sale_id, c.cust_name, p.prod_name, s.quantity,  (s.quantity * p.unit_price) as total_amount
    from Sales s
    inner join Customers c ON s.cust_id = c.cust_id
    inner join Products p ON s.prod_id = p.prod_id;
end $$

-- Find the most sold product category by quantity.

delimiter $$
create procedure top_selling_category()
begin
    select p.category, SUM(s.quantity) as total_qty
    from Sales s
    inner join Products p ON s.prod_id = p.prod_id
    GROUP BY p.category
    ORDER BY total_qty DESC
    limit 1;
end $$

DELIMITER ;


    
    
   




