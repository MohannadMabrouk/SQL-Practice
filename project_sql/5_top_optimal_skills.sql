/*
Question: What are the most optimal skills to learn?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles.
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security and financial benefits,
    offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
         skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
),average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg),0) AS salary_avg
    FROM
        job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
         job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id   
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    salary_avg
FROM
    skills_demand    
INNER JOIN average_salary ON skills_demand.skill_id =  average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    salary_avg DESC,
    demand_count DESC
LIMIT 25         