# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores top paying jobs, in demand skills, and where high demand meets high salaries in data analytics.

SQL queries? Check them out here: [sql_files folder]{/sql_files/}.

# Background
Driven by the need to navigate the data analyst job market more effectively, this project was born from a desire to pin-point top-paid and in-demand skills, making it easier for other aspirants to find optimal job opportunities

Data source is [SQL Course]{https://lukebarousse.com/sql}.
It's packed with insights on different job titles, salaries, locations and essential skills needed.

# Main Questions answered during my analysis
1. What are the highest paying data analyst jobs?
2. What skills are required for these high paying data analyst jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the optimal skills to learn?

# Tools I Used
- **SQL:** Major tool used in my analysis. Enabled me to query the database and make proper insights.
- **PostgreSQL:** Database Managemen System
- **Visual Studio Code:** Code Editor and database management to execute SQL queries
- **Git and GitHub:** Version control and sharing my SQL scripts and analysis for project tracking and collaboration.

# The Analysis
Here is how I approached each question during my analysis:

### 1. Top Paying Data Analyst jobs
Here I filtered data analyst positions by average yearly salary and location, mainly focusing on remote jobs. 
The Query is attached below.

``` SQL
SELECT
    j.job_id, c.name, j.job_title, j.job_location,
    j.job_schedule_type, j.salary_year_avg, j.job_posted_date
FROM
    job_postings_fact j
LEFT JOIN company_dim c
ON j.company_id = c.company_id
WHERE
    j.job_title_short = 'Data Analyst' AND
    j.job_location = 'Anywhere' AND
    j.salary_year_avg IS NOT NULL
ORDER BY
    j.salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst jobs have salaries ranging from $184,000 to $650,000, indicating significant salary potential in the sector.
- **Diverse Employers:** Companies like Meta, AT&T, SamrtAsset are among those offering high salaries, indicating a broad interest acrose different industries amd sectors.
- **Job Title Variety:** There's a high diversity in job titles, from data analyst to Director of Analytics, reflecting multiple roles and specializations with data analytics.


### 2. Skills Required for the Top Paying Data Analyst jobs
Here I filtered data analyst positions by average yearly salary, location and the skills required, mainly focusing on remote jobs. 
The Query is attached below.

```SQL
WITH top_paying_jobs AS (
    
    SELECT j.job_id, c.name, j.job_title, j.salary_year_avg
    FROM
        job_postings_fact j
    LEFT JOIN company_dim c
    ON j.company_id = c.company_id
    WHERE
        j.job_title_short = 'Data Analyst' AND
        j.job_location = 'Anywhere' AND
        j.salary_year_avg IS NOT NULL
    ORDER BY
        j.salary_year_avg DESC
    LIMIT 10;
)

SELECT tj.*, skills
FROM top_paying_jobs tj
INNER JOIN skills_job_dim sk
ON tj.job_id = sk.job_id
INNER JOIN skills_dim sd
ON sk.skill_id = sd.skill_id
ORDER BY salary_year_avg DESC;
```
Here's the breakdown of the skills required for top paying data analyst jobs in 2023:
- **Skills with high demand:** SQL and Python are the most common, however specialized tools like Databricks, Snowflake and AWS are also appearing in the result set, suggesting that expertise in these areas could lead to a higher pay/salary


### 3. Popular/In demand skills for Data Analyst jobs
Here I filtered data analyst positions by total number of times a specific skill is required per job for example 
how many jobs require knowledge in SQL ?, mainly focusing on remote jobs.

```SQL
SELECT skills, COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 10;
```
Here's the breakdown of the top in demand skills needed for data analyst jobs in 2023:
- **Top Skills in Demand:** SQL leads the way with 7291 requests showing its crucial importance in data management and analysis. 
This is closely followed by Excel and Python with 4611 and 4330 respectively.
- **Data Analysis Tools:** Statistical tools like R and SAS, both having a low demand compared to Python could suggest that companies could be prioritizing programming skills over statistical analysis.


### 4. Skills Associated with High Salaries in Data Analytics
To answer this question, I filtered using the skill required, total demand for each skill and the average salary related to each skill.
SQL query attached below;

```SQL
SELECT skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 30;
```
Here's the breakdown:
- **Salary Insights:** PySpark stands out with an average salary of $208,172 despite a lower demand count of 2. This suggests it’s a niche skill that is highly valued.
Skills like Pandas and Databricks have significant demand (9 and 10, respectively) with average salaries around $151,821 and $141,907, suggesting these are solid skills to have in a data analyst's toolkit.
Confluence and Crystal also appear frequently, indicating they are common tools in team collaboration and reporting, with average salaries in the $120,000 range.
Databricks and Airflow are also on the rise, indicating trends toward data engineering and orchestration tools in data workflows.
- **Skill Set Recommendations:** For job seekers in data analytics or data engineering, focusing on skills with high demand like Go, Hadoop, Pandas, and Databricks could enhance employability.
Additionally, acquiring specialized skills such as PySpark and Bitbucket could lead to lucrative opportunities.



### 5. What are the best skills to learn in order to get a job in Data Analysis?
To answer this question, I filtered using the total demand and the avarage salary of each skill.
SQL Query attached below:

```SQL
WITH skills_demand AS (
    SELECT skills, skills_dim.skill_id,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
    --ORDER BY demand_count DESC
    --LIMIT 10
), 
average_salary AS (
    SELECT skills,
        skills_dim.skill_id,
        --COUNT(skills_job_dim.job_id) AS demand_count,
        ROUND(AVG(salary_year_avg),0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
    --ORDER BY avg_salary DESC
    --LIMIT 30
)

SELECT skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary
ON skills_demand.skill_id = average_salary.skill_id
ORDER BY demand_count DESC, avg_salary DESC
LIMIT 30;
```
Here's the breakdown of the best skills to learn to be a data analyst in 2023:
- **Best Optimal Skills to Learn:** SQL leads with a count of 398, followed by Excel(256) and Python(236).
- **Demand vs Salary:** High demand skills like SQL and Excel offer solid salaries ($97,237 and $87,288), suggesting a balanced relationship between demand and compensation. However,some lower demand skills, like SPSS and VBA, have decent average salaries ($92,170 and $88,783), indicating niche markets or specialized roles that value these skills. 
- **Emerging Skills:** Looker has a low demand count (49) but a relatively high average salary ($103,795). This might signal an emerging trend in data visualization tools. Azure and Power BI also reflect similar trends, suggesting they could be areas for potential growth in demand.
Tools like Hadoop, Redshift, and BigQuery have lower demand counts (22, 16, and 13, respectively), but still offer competitive salaries, which may indicate specialized roles or industries requiring these skills.

# What I Learned
During this analysis, I have improved my understanding of SQL:
- **Writing queries:** I have gotten familiar with using advanced SQL queries like CTE's and JOINS like a pro.
- **Data Aggregation:** Got more familiar with GROUP BY, COUNT & AVG and actively using them in my analysis.
- **Meaningful Insights:** Improved on my ability to communicate and give insights on data analysed.

# Conclusions
### Insights
1. **Top Paying Data Analyst Jobs:** The highest paying jobs in Data Analytics that allow remote work offer a range of salaries ranging from $186,000 to $650,000
2. **Skills for Top Paying jobs:** The highest paying data analyst jobs require proficiency in SQL.
3. **Most In Demand Skills:** SQL is also the most demanded skill in the data analyst job market, making it crucial for job seekers
4. **Skills with Higher Salaries:** Specialized skills are seen to be linked with very high salaries for example Solidity.
5. **Optimal Skills for the Job Market:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn.

### Closing Thoughts
This project has enhanced my understanding and skillset in SQL and also provided very important insights into the data analyst job market.
As an aspiring data analyst I can better position my self for the high demand, high paying skills in data analytics and other related fields.

