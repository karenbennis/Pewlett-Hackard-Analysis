-- The following queeries were completed as part of the module, but are prerequisites for the challenge.
-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR(4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no, dept_no)
);

-- CHALLENGE:
 -- "Number of [titles] Retiring"
    -- Create a new table using an INNER JOIN that contains the following information:
        -- Employee number
        -- First and last name
        -- Title
        -- from_date
        -- Salary
    -- Export the data as a CSV. [titles_retiring.csv]
    -- Reference your ERD to help determine which tables you’ll use to complete this join.

SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	s.salary
INTO titles_retiring
FROM salaries as s
	INNER JOIN titles as t
		ON (s.emp_no = t.emp_no)
	INNER JOIN employees as e
		ON (t.emp_no = e.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31');



 -- "Only the Most Recent Titles"
    -- Exclude the rows of data containing duplicate names. (This is tricky.) Hint: Refer to Partitioning Your Data (Links to an external site.) for help.
    -- Export the data as a CSV. [current_titles_retiring.csv]

-- This block shows the counts of duplicate info but doesn't remove anything
SELECT
	emp_no,
	first_name,
	last_name,
	count(*)
FROM titles_retiring
GROUP BY
	emp_no,
	first_name,
	last_name
HAVING count(*) > 1;

SELECT * FROM
	(SELECT *, count(*)
	 OVER
	 (PARTITION BY
	 	emp_no,
	 	first_name,
	 	last_name
	 ) AS count
	 FROM titles_retiring) tableWithCount
	 WHERE tableWithCount.count > 1;

-- Adding a serial id
ALTER TABLE titles_retiring ADD id SERIAL;

-- Deleting the data that does not pertain to a current title
WITH current_titles AS
(SELECT id, emp_no, first_name, last_name, title, from_date, salary
	FROM
	(SELECT id, emp_no, first_name, last_name, title, from_date, salary,
     	ROW_NUMBER() OVER 
(PARTITION BY (emp_no) ORDER BY from_date DESC) rn
   		FROM titles_retiring
  	) tmp WHERE rn = 1)
DELETE FROM titles_retiring WHERE titles_retiring.id NOT IN (SELECT id FROM current_titles);

    -- In descending order (by date), list the frequency count of employee titles (i.e., how many employees share the same title?).
    -- Export the data as a CSV. [titles_retiring_counts.csv]

-- Creating the table with title counts from the table of employees eligible for retirement
SELECT COUNT(tr.title) as title_count, title
INTO titles_retiring_counts
FROM titles_retiring as tr
GROUP BY tr.title;
SELECT * FROM titles_retiring_counts;

 -- "Who’s Ready for a Mentor?""
    -- Create a new table that contains the following information:
        -- Employee number
        -- First and last name
        -- Title
        -- from_date and to_date
        -- Note: The birth date needs to be between January 1, 1965 and December 31, 1965. Also, make sure only current employees are included in this list.

    -- Export the data as a CSV. [mentors.csv]

SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO mentors
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
	WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND t.to_date = ('9999-01-01');