USE BUDT702_Project_0501_07;
GO

/* =========================================================
1) Is there a pattern between the type of crime committed
   and WHEN it is committed?
   - Time-of-day buckets (Morning/Afternoon/Evening/Night)
   - Also include an hour-of-day heatmap if you want finer detail
========================================================= */

-- 1A) Crime type by time-of-day bucket
SELECT c.crimeType AS TypeofCrime,
    CASE
        WHEN DATEPART(HOUR, o.occurTime) BETWEEN 5  AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, o.occurTime) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, o.occurTime) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS TimeofDay,
    COUNT(DISTINCT o.incidentId) AS CountofIncidents
FROM [IPD.Occur] AS o JOIN [IPD.Crime]  AS c ON c.crimeId  = o.crimeId
GROUP BY c.crimeType,
    CASE
        WHEN DATEPART(HOUR, o.occurTime) BETWEEN 5  AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, o.occurTime) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, o.occurTime) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END
ORDER BY c.crimeType, TimeofDay;

-- 1B) (Optional) Hour-of-day heatmap (0–23)
SELECT c.crimeType AS TypeofCrime, DATEPART(HOUR, o.occurTime) AS HourofDay,
    COUNT(DISTINCT o.incidentId) AS CountofIncidents
FROM [IPD.Occur] AS o JOIN [IPD.Crime]  AS c ON c.crimeId  = o.crimeId
GROUP BY c.crimeType,DATEPART(HOUR, o.occurTime)
ORDER BY c.crimeType, HourofDay;


 /* =========================================================
2) Which locations have higher incident counts?
   - Count DISTINCT incidents per location (Occur → Location)
========================================================= */

SELECT CONCAT(l.locationBlock,' ',l.locationStreet) AS LocationofIncident,
    COUNT(DISTINCT o.incidentId) AS CountofIncidents
FROM [IPD.Occur] AS o JOIN [IPD.Location] AS l ON l.locationId = o.locationId
GROUP BY l.locationBlock,l.locationStreet
ORDER BY CountofIncidents DESC, l.locationStreet, l.locationBlock;


 /* =========================================================
3) Which type of incidents are more frequent?
   - Count DISTINCT incidents per crime type
========================================================= */

SELECT c.crimeType AS TypeofCrime, COUNT(DISTINCT o.incidentId) AS CountofIncidents
FROM [IPD.Occur] AS o JOIN [IPD.Crime]  AS c ON c.crimeId = o.crimeId
GROUP BY c.crimeType
ORDER BY CountofIncidents DESC, c.crimeType;


 /* =========================================================
4) What profile (gender, age) has the highest and lowest arrest rate?
   - We compute distribution of arrests by (Gender, AgeGroup)
   - “Rate” here = share of arrests (count / total arrests)
========================================================= */

WITH ArrestsByProfile AS (
    SELECT a.arrestGender AS Gender,
        CASE
            WHEN a.arrestAge BETWEEN 10 AND 17 THEN '10–17'
            WHEN a.arrestAge BETWEEN 18 AND 25 THEN '18–25'
            WHEN a.arrestAge BETWEEN 26 AND 40 THEN '26–40'
            WHEN a.arrestAge BETWEEN 41 AND 60 THEN '41–60'
            WHEN a.arrestAge > 60            THEN '60+'
            ELSE 'Unknown'
        END AS AgeGroup,
        COUNT(*) AS CountofArrests
    FROM [IPD.Arrest] AS a
    GROUP BY a.arrestGender,
        CASE
            WHEN a.arrestAge BETWEEN 10 AND 17 THEN '10–17'
            WHEN a.arrestAge BETWEEN 18 AND 25 THEN '18–25'
            WHEN a.arrestAge BETWEEN 26 AND 40 THEN '26–40'
            WHEN a.arrestAge BETWEEN 41 AND 60 THEN '41–60'
            WHEN a.arrestAge > 60            THEN '60+'
            ELSE 'Unknown'
        END
),
Total AS (
    SELECT SUM(CountofArrests) AS TotalArrests
    FROM ArrestsByProfile
)
SELECT p.Gender, p.AgeGroup, p.CountofArrests,
    CAST(100.0 * p.CountofArrests / NULLIF(t.TotalArrests, 0) AS DECIMAL(5,2)) AS ArrestPercentage
FROM ArrestsByProfile p CROSS JOIN Total t
ORDER BY p.CountofArrests DESC, p.Gender, p.AgeGroup;

---- (Optional) Highest and lowest share, pulled out:
WITH ArrestsByProfile AS (
    SELECT a.arrestGender AS Gender,
        CASE
            WHEN a.arrestAge BETWEEN 10 AND 17 THEN '10–17'
            WHEN a.arrestAge BETWEEN 18 AND 25 THEN '18–25'
            WHEN a.arrestAge BETWEEN 26 AND 40 THEN '26–40'
            WHEN a.arrestAge BETWEEN 41 AND 60 THEN '41–60'
            WHEN a.arrestAge > 60            THEN '60+'
            ELSE 'Unknown'
        END AS AgeGroup,
        COUNT(*) AS CountofArrests
    FROM [IPD.Arrest] AS a
    GROUP BY a.arrestGender,
        CASE
            WHEN a.arrestAge BETWEEN 10 AND 17 THEN '10–17'
            WHEN a.arrestAge BETWEEN 18 AND 25 THEN '18–25'
            WHEN a.arrestAge BETWEEN 26 AND 40 THEN '26–40'
            WHEN a.arrestAge BETWEEN 41 AND 60 THEN '41–60'
            WHEN a.arrestAge > 60            THEN '60+'
            ELSE 'Unknown'
        END
),
Total AS (
    SELECT SUM(CountofArrests) AS TotalArrests
    FROM ArrestsByProfile
),
Ranked AS (
    SELECT p.Gender, p.AgeGroup, p.CountofArrests,
        CAST(100.0 * p.CountofArrests / NULLIF(t.TotalArrests, 0) AS DECIMAL(5,2)) AS ArrestPercentage,
        DENSE_RANK() OVER (ORDER BY p.ArrestCount DESC) AS rnk_desc,
        DENSE_RANK() OVER (ORDER BY p.ArrestCount ASC)  AS rnk_asc
    FROM ArrestsByProfile p CROSS JOIN Total t
)
SELECT 'Highest' AS 'Rank', Gender, AgeGroup, CountofArrests, ArrestPercentage
FROM Ranked
WHERE rnk_desc = 1
UNION ALL
SELECT 'Lowest'  AS 'Rank', Gender, AgeGroup, CountofArrests, ArrestPercentage
FROM Ranked
WHERE rnk_asc = 1
ORDER BY 'Rank' DESC, ArrestPercentage DESC;



 /* =========================================================
5) What percent of crimes were committed under the influence of alcohol?
   Two views:
   A) Conservative: Crime type indicates DUI/DWI
   B) Inclusive: Crime type OR any related Charge mentions alcohol/DUI
========================================================= */

-- 5A) Conservative: incidents with crimeType like DUI/DWI
WITH AllIncidents AS (
    SELECT COUNT(*) AS TotalIncidents
    FROM [IPD.Incident]
),
AlcoholIncidentsConservative AS (
    SELECT COUNT(DISTINCT o.incidentId) AS AlcoholIncidents
    FROM [IPD.Occur] AS o JOIN [IPD.Crime] AS c ON c.crimeId = o.crimeId
    WHERE c.crimeType LIKE '%DUI%' OR c.crimeType LIKE '%DWI%'
)
SELECT CAST(100.0 * a.AlcoholIncidents / NULLIF(t.TotalIncidents, 0) AS DECIMAL(5,2)) AS ConservativeAlcoholRelatedPercentage
FROM AlcoholIncidentsConservative a CROSS JOIN AllIncidents t;

-- 5B) Inclusive: crime type OR any charge text mentions alcohol/dui
WITH AlcoholIncidentsInclusive AS (
    SELECT DISTINCT i.incidentId AS IncidentId
    FROM [IPD.Incident] AS i
    LEFT JOIN [IPD.Occur]   AS o  ON o.incidentId = i.incidentId
    LEFT JOIN [IPD.Crime]   AS c  ON c.crimeId    = o.crimeId
    LEFT JOIN [IPD.Arrest]  AS a  ON a.incidentId = i.incidentId
    LEFT JOIN [IPD.Charge]  AS ch ON ch.arrestId  = a.arrestId
    WHERE (c.crimeType LIKE '%DUI%' OR c.crimeType LIKE '%DWI%')
        OR (ch.chargeDescription LIKE '%alcohol%' OR ch.chargeDescription LIKE '%DUI%')
)
SELECT CAST(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM [IPD.Incident]), 0) AS DECIMAL(5,2))
        AS InclusiveAlcoholRelatedPercentage
FROM AlcoholIncidentsInclusive;
