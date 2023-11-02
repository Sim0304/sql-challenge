--Create Tables
CREATE TABLE Employees (
	emp_no SERIAL PRIMARY KEY,	
	emp_title_id VARCHAR REFERENCES Titles(title_id),
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex	VARCHAR,
	hire_date DATE NOT NULL
);

CREATE TABLE Departments (
    dept_no VARCHAR PRIMARY KEY,
    dept_name VARCHAR NOT NULL
);

CREATE TABLE Dep_emp (
	emp_no INTEGER REFERENCES Employees(emp_no),	
	dept_no VARCHAR REFERENCES Departments(dept_no)
);

CREATE TABLE Dep_mgr (
    dept_no VARCHAR REFERENCES Departments(dept_no),
    emp_no SERIAL REFERENCES Employees(emp_no),
    PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE Salaries (
	emp_no SERIAL REFERENCES Employees(emp_no),	
	salary INTEGER NOT NULL
);

CREATE TABLE Titles (
	title_id VARCHAR PRIMARY KEY,	
	title VARCHAR NOT NULL
);

--List the employee number, last name, first name, sex, and salary of each employee
SELECT
    Employees.emp_no,
    Employees.last_name,
    Employees.first_name,
    Employees.sex,
    Salaries.salary
FROM Employees
JOIN Salaries ON Employees.emp_no = Salaries.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986
SELECT
	Employees.first_name,
	Employees.last_name,
	Employees.hire_date
FROM Employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

--List the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT 
	Departments.dept_no,
	Departments.dept_name,
	Employees.emp_no,
	Employees.last_name,
	Employees.first_name
FROM Employees
JOIN Dep_mgr ON Employees.emp_no = Dep_mgr.emp_no
JOIN Departments ON Dep_mgr.dept_no = Departments.dept_no

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT
	Employees.emp_no,
	Employees.last_name,
	Employees.first_name,
	Departments.dept_no,
	Departments.dept_name
FROM Employees
JOIN Dep_emp ON Employees.emp_no = Dep_emp.emp_no
JOIN Departments on Dep_emp.dept_no = Departments.dept_no;

--List the first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT 
	first_name,
	last_name,
	sex
FROM Employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name
SELECT
	Employees.emp_no,
	Employees.last_name,
	Employees.first_name
FROM Employees
JOIN Dep_emp ON Employees.emp_no = Dep_emp.emp_no
JOIN Departments on Dep_emp.dept_no = Departments.dept_no
WHERE Departments.dept_name = 'Sales';

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
	Employees.emp_no,
	Employees.last_name,
	Employees.first_name
FROM Employees
JOIN Dep_emp ON Employees.emp_no = Dep_emp.emp_no
JOIN Departments on Dep_emp.dept_no = Departments.dept_no
WHERE Departments.dept_name = 'Sales' OR Departments.dept_name = 'Development';

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
SELECT last_name, COUNT(*) AS frequency
FROM Employees
GROUP BY last_name
ORDER BY frequency DESC, last_name;