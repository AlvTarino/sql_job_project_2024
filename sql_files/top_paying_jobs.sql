/*
    What are the top paying data analyst jobs?
        -Identify the top 10 highest paying data analyst roles that are available remotely
        -Focus on job postings with salaries (remove NULLs)
        -Why ?? --Highlight top paying jobs for data analysts and offer insights
*/

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
LIMIT 10