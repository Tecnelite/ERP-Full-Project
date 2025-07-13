create database market
use market
CREATE TABLE Departments (dept_id INT PRIMARY KEY,dept_name VARCHAR(100));
select *from Departments;
 CREATE TABLE Employees (emp_id INT PRIMARY KEY,emp_name VARCHAR(100),dept_id INT,join_date DATE,salary INT,
 FOREIGN KEY (dept_id) REFERENCES Departments(dept_id));
 select *from Employees;
CREATE TABLE Attendance (att_id INT PRIMARY KEY,emp_id INT,date DATE,status VARCHAR(20),FOREIGN KEY (emp_id) REFERENCES Employees(emp_id));
select *from Attendance;
 CREATE TABLE Projects (project_id INT PRIMARY KEY,project_name VARCHAR(100),start_date DATE,end_date DATE);
 select *from projects;
 CREATE TABLE Employee_Project (emp_id INT,project_id INT,PRIMARY KEY (emp_id, project_id),FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
 FOREIGN KEY (project_id) REFERENCES Projects(project_id));
select *from Employee_Project;
CREATE TABLE Finance (txn_id INT PRIMARY KEY,emp_id INT,type VARCHAR(20),amount INT,txn_date DATE,FOREIGN KEY (emp_id) REFERENCES Employees(emp_id));
select *from Finance;
CREATE TABLE Products (prod_id INT PRIMARY KEY,prod_name VARCHAR(100),category VARCHAR(50),unit_price INT);
select*from Products;
CREATE TABLE Inventory (inv_id INT PRIMARY KEY,prod_id INT,quantity INT,location VARCHAR(100),FOREIGN KEY (prod_id) REFERENCES Products(prod_id));
select*from Inventory;
CREATE TABLE Vendors (vendor_id INT PRIMARY KEY,vendor_name VARCHAR(100),contact_person VARCHAR(100),phone VARCHAR(15));
select*from Vendors;
 CREATE TABLE Procurement (proc_id INT PRIMARY KEY,prod_id INT,vendor_id INT,quantity INT,cost_price INT,proc_date DATE,
            FOREIGN KEY (prod_id) REFERENCES Products(prod_id),FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id));
select*from Procurement;
CREATE TABLE Customers (cust_id INT PRIMARY KEY,cust_name VARCHAR(100),email VARCHAR(100),city VARCHAR(50));
select*from Customers;
CREATE TABLE Sales (sale_id INT PRIMARY KEY,cust_id INT,prod_id INT,quantity INT,sale_date DATE,
        FOREIGN KEY (cust_id) REFERENCES Customers(cust_id),
        FOREIGN KEY (prod_id) REFERENCES Products(prod_id));
select*from Sales;  




     
        



            
        


        



 

 


 








