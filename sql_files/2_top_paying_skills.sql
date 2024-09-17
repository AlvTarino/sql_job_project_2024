/*
What skills are required for the top paying data analyst jobs?
--Use the top 10 highest paying data analyst jobs
--Add specific skills required
--Provide insight for the data received
*/

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
    LIMIT 10 
)

SELECT tj.*, skills
FROM top_paying_jobs tj
INNER JOIN skills_job_dim sk
ON tj.job_id = sk.job_id
INNER JOIN skills_dim sd
ON sk.skill_id = sd.skill_id
ORDER BY salary_year_avg DESC


