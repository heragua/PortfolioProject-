/*
data sience salary Data Exploration 
*/
/*Breakdown of Work Models by Current Count */
SELECT work_models, COUNT(*) AS current_number
FROM WORK_MOD
GROUP BY work_models
ORDER BY current_number DESC;

/*Employee Data Sorted by Work Year and Job Title*/
SELECT job_title, work_year, employee_residence ,company_location ,company_size
FROM DATA_EMP
ORDER BY 2,1;

/* Popular Job Titles by Company Location and Size" :*/
SELECT job_title,company_location, company_size, COUNT(*) AS nombre_populaire
FROM data_emp
GROUP BY  job_title, company_location, company_size
order by nombre_populaire desc;

/* Most Frequent Job Titles and Experience Levels in Salary Data */
SELECT e.job_title, m.experience_level, COUNT(*) AS modeplusfréquent
FROM WORK_MOD e
JOIN salary_data m ON e.job_title = m.job_title
GROUP BY e.job_title, m.experience_level
ORDER BY modeplusfréquent desc;

/* Average Salary in USD by Job Title */
SELECT job_title, ROUND(AVG(salary_in_usd)) AS average_salaryinusd
FROM salary_data
GROUP BY job_title;

/*Average Salary in USD for Senior-level Full-time Positions by Job Title*/
SELECT job_title, experience_level, employment_type, ROUND(AVG(salary_in_usd)) AS average_salary_usd
FROM Salary_data
WHERE experience_level = 'Senior-level'  -- Facultatif : filtre par niveau d'expérience
AND employment_type = 'Full-time' -- Facultatif : filtre par type d'emploi
GROUP BY job_title, experience_level, employment_type;

/*Average Salary in USD for Entry-level and Mid-level Positions in Data-related Roles */
SELECT job_title, experience_level, AVG(salary_in_usd) AS average_salary_usd
FROM SALARY_DATA
WHERE job_title IN ('Data Scientist', 'Data Engineer', 'Data Analyst', 'Machine Learning Engineer')
AND experience_level IN ('Entry-level' , 'Mid-level')  
GROUP BY job_title , experience_level
Order by average_salary_usd DESC;
 
 /*Average Salary in USD for Entry-level and Mid-level Positions in Data-related Roles, by Job Title, Experience Level, and Work Year (2020 and 2024)*/
SELECT b.job_title, b.experience_level, p.work_year, ROUND(AVG(b.salary_in_usd)) as salaire_moyenne
FROM SALARY_DATA b 
JOIN DATA_EMP p ON b.job_title = p.job_title
WHERE b.job_title IN ('Data Scientist', 'Data Engineer', 'Data Analyst', 'Machine Learning Engineer')
AND b.experience_level IN ('Entry-level', 'Mid-level')  
AND p.work_year IN(2020,2024)
GROUP BY b.job_title, b.experience_level, p.work_year
HAVING ROUND(AVG(b.salary_in_usd)) > 20000
ORDER BY salaire_moyenne DESC ;

 /*Number of Employees by Job Title, Work Model, and Company Location*/

SELECT e.job_title , s.work_models , e.company_location, COUNT(e.company_location) as nombre 
FROM DATA_EMP e
JOIN WORK_MOD s ON e.job_title = s.job_title 
GROUP BY e.job_title, e.company_location, s.work_models 
ORDER BY nombre DESC;

/*Adjusted Salary for Mid-level Positions based on Job Title */
SELECT job_title ,experience_level ,salary_in_usd,
CASE 
   WHEN job_title = 'Data Scientist' THEN salary_in_usd + (Salary_in_usd *.10)
   WHEN job_title = 'AI Engineer' THEN salary_in_usd + (Salary_in_usd *.05)
   WHEN job_title = 'BI Developer' THEN salary_in_usd + (Salary_in_usd *.0001)
   ELSE Salary_IN_USD + (salary_in_usd *.03)
END AS salaryafterraise
FROM SALARY_DATA 
WHERE experience_level in ('Mid-level'); 

/* Distinct Job Titles, Experience Levels, Employment Types, and Employee Residence Count*/
SELECT distinct(e.Job_title), 
       e.experience_Level, 
       e.employment_type, 
       s.employee_residence,
       COUNT(e.Job_title) OVER (PARTITION BY e.job_title) As totaljob_title 
FROM salary_data e 
JOIN data_emp s ON e.Job_title = s.Job_title
ORDER BY totaljob_title DESC;

/*Job Titles and Company Details for Employees with Salaries over $400,000 */
SELECT job_title , company_location ,company_size
FROM data_emp WHERE job_title in( SELECT job_title  FROM SALARY_DATA  Where salary_in_usd > 400000);
 
/* Details of Employees, Salary, Experience Level, Employment Type, and Work Models for BI Developers and Data Analysts */ 
Select e.* , m.experience_level, m.employment_type ,m.salary , s.work_models
from data_emp e
inner join salary_data m on e.job_title = m.job_title 
inner join work_mod s on e.job_title = s.job_title 
where e.job_title IN('BI Developer','Data analyst' );

/*Creating a View 'salaryy' to Combine Employee, Salary, Experience Level, and Work Models Information */
create view salaryy AS
SELECT e.*, s.experience_level, s.salary_in_usd, m.work_models
FROM DATA_EMP e
INNER JOIN SALARY_data s ON e.job_title = s.job_title
INNER JOIN work_mod m ON e.job_title = m.job_title;

/* Creating Temporary Employee Table and Calculating Average Salary by Job Title, Experience Level, and Residence */
DECLARE
  table_count NUMBER;
BEGIN
  -- Vérifier si la table existe
  SELECT COUNT(*) INTO table_count FROM user_tables WHERE table_name = 'TEMP_EMPLOYEEE';
  
  -- Si la table existe, alors la supprimer
  IF table_count > 0 THEN
    EXECUTE IMMEDIATE 'DROP TABLE TEMP_EMPLOYEEE';
  END IF;
END;
/

CREATE TABLE Temp_employeee (
    Job_title VARCHAR(100), 
    AVGSALARYINUSD INT, 
    EXPERIENCELEVEL VARCHAR(50), 
    RESIDENCEEMP VARCHAR(50)
);
INSERT INTO Temp_employeee
SELECT e.job_title , AVG(e.salary_in_usd) , e.experience_level , s.EMPLOYEE_RESIDENCE
FROM SALARY_DATA e join DATA_EMP s ON e.job_title = s.job_title
GROUP BY e.job_title ,e.experience_level , s.EMPLOYEE_RESIDENCE;
SELECT * from Temp_employeee;

/* Employee Details with Highest Average Salary by Job Title, Experience Level, and Residence  */
WITH CTE_Employee AS (
    SELECT distinct(e.job_title),e.experience_level,e.salary_in_usd, s.EMPLOYEE_RESIDENCE,
        AVG(e.salary_in_usd) OVER (PARTITION BY e.job_title) AS moyennesalary 
        FROM  SALARY_DATA e JOIN DATA_EMP s ON e.job_title = s.job_title 
        WHERE e.salary_in_usd > 45000)
    SELECT  job_title,experience_level, EMPLOYEE_RESIDENCE, moyennesalary
    FROM CTE_Employee WHERE moyennesalary  = (SELECT Max(moyennesalary) FROM CTE_Employee);

/* Ranking of Salary by Job Title and Experience Level */
SELECT job_title ,experience_level , SALARY_IN_USD, 
       DENSE_RANK() OVER (ORDER BY salary_in_usd ) AS SalaryRank 
       FROM SALARY_DATA
       ORDER BY job_title , experience_level;

/*Dividing Salary Ranks into 30 Percentiles by Job Title and Experience Level)*/  
SELECT job_title , experience_level ,SALARY_IN_USD ,
      NTILE(30) OVER (ORDER BY salary_in_usd) AS SalaryRank 
      FROM SALARY_DATA;

/*Combining Employee Residence and Work Models by Job Title*/
SELECT e.job_title, e.employee_residence, s.work_models,
       e.employee_residence || ' ,  ' || s.work_models AS combinevalue 
       FROM DATA_EMP e 
       JOIN work_mod s ON e.job_title = s.job_title;

/*Removing Duplicates in Employee Data Based on Job Title+*/
WITH ROWNUMCTE AS(
SELECT  job_title , Work_year , Employee_residence, Company_location, Company_size ,
        ROW_NUMBER()OVER (ORDER BY job_title DESC) as row_num
        FROM DATA_EMP
        ORDER BY job_title
)
---Delete
select * From ROWNUMCTE
Where row_num > 1
ORDER BY employee_residence;
                    


