CREATE DATABASE HOSPITAL_PROCEDURES
USE HOSPITAL_PROCEDURES

/*Objectives
Create a hospital procedures dashboard for 2022 that provides insights into the following:
1.	Total % of patients undergoing hospital procedures, stratified by:
a.) Age
b.) Race
c.) County (On a map)
d.) Overall
2.	Running Total of Procedures performed over the course of 2022
3.	Total number of procedures conducted in 2022
4.	List of Patients with corresponding procedures and reasons
5.	Top 10 most frequently performed procedures (based on the DESCRIPTION column)
6.	Top 10 most common reasons for procedures (based on the REASONDESCRIPTION column)
7.	Average cost per procedure type, stratified by reason
Requirements:
•Patients must have been "Active at our hospital"
•Only include procedures with a START date in 2022 */


SELECT * FROM Patients
SELECT * FROM Procedures
SELECT * FROM Immunizations
SELECT * FROM Encounters




/*SELECT Description, Base_Cost, ReasonDescription,
       CAST(Start AS DATE) AS StartDate,
       CAST(Stop AS DATE) AS StopDate
FROM Procedures
WHERE (
    -- Case 1: Started before 2022 and ended in 2022
    CAST(Start AS DATE) < '2022-01-01' AND CAST(Stop AS DATE) BETWEEN '2022-01-01' AND '2022-12-31'
    
    OR
    
    -- Case 2: Started in 2022 and ended after 2022
    CAST(Start AS DATE) BETWEEN '2022-01-01' AND '2022-12-31' AND CAST(Stop AS DATE) > '2022-12-31'
    
    OR
    
    -- Case 3: Started and ended in 2022
    CAST(Start AS DATE) BETWEEN '2022-01-01' AND '2022-12-31' AND CAST(Stop AS DATE) BETWEEN '2022-01-01' AND '2022-12-31'
); */

WITH ActivePatients AS (
    SELECT DISTINCT Patient
    FROM Encounters as Enc
	JOIN Patients AS Pat
	on Enc.Patient = Pat.Id
	WHERE Start BETWEEN '2022-01-01 00:00' AND '2024-12-31 23:59'
	AND Pat.DeathDate IS NULL
),
Proceduresin2024 AS (
    SELECT Patient, Description, Base_Cost, ReasonDescription, 
           CAST(Start AS DATE) AS StartDate, 
           CAST(Stop AS DATE) AS StopDate
    FROM Procedures
    WHERE CAST(Start AS DATE) >= '2024-01-01 00:00' AND CAST(Stop AS DATE) <= '2024-12-31 23:59'
)

SELECT  
	Pat.Id, 
	Pat.First, 
	Pat.Last, 
	Pat.Birthdate, 
	DATEDIFF(YEAR, Pat.Birthdate, '2024-12-31') AS Age, 
	Pat.Gender,
	Pat.Race, 
	Pat.County,
	Prod.Patient,
	Prod.Description, 
	Prod.Base_Cost,
	Prod.ReasonDescription,
	Prod.StartDate,
	Prod.StopDate, 
	CASE WHEN Prod.Patient IS NOT NULL THEN 1 ELSE 0 END AS Proceduresin2024
FROM Patients AS Pat
LEFT JOIN Proceduresin2024 AS Prod
	ON Pat.Id = Prod.Patient
WHERE Pat.Id IN (SELECT * FROM ActivePatients)


