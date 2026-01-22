DROP VIEW IF EXISTS MultiChargeArrest
GO
CREATE VIEW MultiChargeArrest AS
SELECT a.arrestId AS 'Arrest Id', a.arrestDate AS 'Arrest Date', COUNT(c.chargeId) AS 'Number of Charges'
FROM [IPD.Arrest] a
JOIN [IPD.Charge] c ON a.arrestId = c.arrestId
GROUP BY a.arrestId, a.arrestDate
HAVING COUNT(c.chargeId) > 1
WITH CHECK OPTION
GO
SELECT * FROM MultiChargeArrest;

DROP VIEW IF EXISTS RecentIncidents
GO
CREATE VIEW RecentIncidents AS
SELECT i.incidentId AS 'Incident Id', i.incidentReportedDate AS 'Incident Reported Date', i.incidentReportedTime AS 'Incident Reported Time', d.dispositionName AS 'Disposition Name'
FROM [IPD.Incident] i
JOIN [IPD.Disposition] d ON i.dispositionId = d.dispositionId
WHERE i.incidentReportedDate >= DATEADD(DAY, -30, GETDATE())
WITH CHECK OPTION
GO
SELECT * FROM RecentIncidents;
