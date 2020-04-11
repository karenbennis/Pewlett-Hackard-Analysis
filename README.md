# Pewlett-Hackard-Analysis
## Project Overview
The following repository includes SQL queeries of the Pewlett-Hackard raw data files.

The first queeries performed were to create schema from the raw data files, as shown in the file schema.sql and below in the following ERD:

![](https://github.com/karenbennis/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png)

While the above ERD makes the relationships clear between tables, this database would have been better designed if each table had a serial primary key (in lieu of assigning the primary key to data columns).

Throughout the anlysis of this data, queeries were performed to assemble tables including but not limited to the following:
* the table of employees eligible to retire based on birth date and hire date
* the number of employees eligible to retire
* the table of current employees
* the number of employees per department
* the list of managers per department
* the list of current employees per department
* the list of employees on the Sales team who are eligible for retirement
* the list of employees on the Sales and Development teams who are eligible for retirement

Queeries are documented in the file Queeries/queeries.sql.

Exported CSV files based on the queeries are located in the Data folder.


## Challenge
To further expand on the analysis described above, Pewlett-Hackard wanted a deeper understanding related to the employees eligible for retirement and its impact on Pewlett-Hackard's workforce.

Pewlett-Hackard's first request was a list of current employees eligible for retirement which includes the following information:
* Employee number
* First and last name
* Title
* Start date
* Salary

Their second request was to partition the data such that the list of employees eligible for retirement did not contain any duplicates.

The third request was to determine the counts for the titles that were eligible for retirement and create a new table with these counts.

Finally, the last request was a list of employees born in 1965 who could become mentors to more junior employees, including the following information:
* Employee number
* First and last name
* Title
* Start date and end date

Queeries for these additional deliverables are documented in the file Queeries/challenge.sql.

Exported CSV files based on the queeries are located in the Data folder.


## Resources
* Data Sources: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv
* Software/Tools: pgAdmin 4 (v 4.19), Quick DBD (quickdatabasediagrams.com)
* Databases: PostgreSQL 11
* Languages: SQL


## Summary
### Assumptions
To carry out the analysis, the following assumptions were made:
1. Retirement eligibility criteria for the first new table is as follows:
    * year of birth = 1952-1955 inclusive
    * year hired = 1985-1988 inclusive
2. The data in the table of employees eligible for retirement must be sorted by start date in descending order so that when duplicates are removed, the row representing current information is not
3. The frequency count table, after deleting the duplicate information for employees, contains the following 2 columns:
    * count of titles
    * title
4. Employees born in 1965 are those which can be mentors to more junior employees, since they are not eligible for retirement, but are in their final working years.

### Analysis of Results
The table of employees eligible to retire returned 65,427 rows. This dataset (shown in titles_retiring.csv) includes duplicate entries for some employees, and as such, this table does not give an accurate number of the employees eligible for retirement.

The reason for duplication is that over the course of a person's career, each time the employee's title changed, another entry was created so that the entire trajectory of their career would be on file. Any title with an end date of something other than '9999-01-01' is not a current title.

As such, the data was queeried further to remove the duplicate employee information, where the title was not a current title. This dataset (current_titles_retiring.csv) contains 41,380 rows; therefore, there are 41,380 employees who are eligible for retirement.

The data was queeried again from here, to count the number of titles where employees are eligible for retirement. The results of that analysis (titles_retiring_counts.csv) are shown below:

| Number of employees eligible to retire | Title |
|----------------------------------------|-------|
| 4,692 | Engineer |
| 15,600 | Senior Engineer |
| 2 | Manager |
| 501 | Assistant Engineer |
| 3,837 | Staff |
| 14,735 | Senior Staff |
| 2,013 | Technique Leader |

Based on this breakdown, it seems that vast majority of employees eligible to retire are either senior engineers or senior staff.

It follows that not everyone who is eligible for retirement would indeed retire at the same time; however, Pewlett-Hackard needs to be prepared for a high volume of retirements over the next half decade.

Perhaps, in planning for this influx, the idea for peer mentorship was borne out.

Queerying the data for employees born in 1965, who could mentor more junior employees seemed like a nice practical idea.

In reality, there are only 1,549 current employees born in 1965; therefore, even if all agreed to be mentors, this would hardly brace for the impact of losing such a sizable portion of workforce to retirement in the coming years.

### Conclusion
Taken as a whole, there is a disportionately large number of employees eligible for retirement at Pewlett-Hackard. This could likely be accounted for by demographic factors, in that is also a larger population born in 1952-1955 than in other years. Regardless, Pewlett-Hackard needs to hire a considerable number of new employees to offset the impact that the mass retirement inevitably will have. Based on the breakdown, these new employees would need to be more senior in their competencies. Pewlett-Hackard may look to promote current employees into more senior roles and hire more junior employees.

Having the employees born in 1965 act as mentors seemed like a creative solution to this problem; however, there simply aren't enough of them, and this list of employees includes all job titles. It is not likely that each employee born in 1965 is indeed actually qualified to mentor another employee on the basis of their job title. Perhaps Pewlett-Hackard may want to consider allowing employees of all ages to mentor more junior employees; further, they may consider investing in training the younger workforce to offset the loss of the senior retirees.

Finally, further analysis is recommended. It might also be worthwhile to conduct process analyses and look for was to maximize operational efficiencies such that the same work could be carried out by fewer individuals, for example. Regardless of the actions taken, the people change managment aspect as it relates to the inevitable mass retirement must be taken seriously and planned for rigorously.
