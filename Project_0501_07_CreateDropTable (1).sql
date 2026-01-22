USE BUDT702_Project_0501_07

DROP TABLE IF EXISTS [IPD.Charge]
DROP TABLE IF EXISTS [IPD.Arrest]
DROP TABLE IF EXISTS [IPD.Occur]
DROP TABLE IF EXISTS [IPD.Incident]
DROP TABLE IF EXISTS [IPD.Disposition]
DROP TABLE IF EXISTS [IPD.Crime]
DROP TABLE IF EXISTS [IPD.Location]

CREATE TABLE [IPD.Location] (
	locationId CHAR(5) NOT NULL,
	locationBlock VARCHAR(5),
	locationStreet VARCHAR(50)
	CONSTRAINT pk_Location_locationId PRIMARY KEY (locationId)
)

CREATE TABLE [IPD.Crime] (
	crimeId CHAR(5) NOT NULL,
	crimeType VARCHAR(50)
	CONSTRAINT pk_Crime_crimeId PRIMARY KEY (crimeId)
)

CREATE TABLE [IPD.Disposition] (
	dispositionId CHAR(5) NOT NULL,
	dispositionName VARCHAR(30)
	CONSTRAINT pk_Disposition_dispositionId PRIMARY KEY (dispositionId)
)

CREATE TABLE [IPD.Incident] (
	incidentId CHAR(13) NOT NULL,
	incidentReportedDate DATE,
	incidentReportedTime TIME(0),
	dispositionId CHAR(5) NOT NULL
	CONSTRAINT pk_Incident_incidentId PRIMARY KEY (incidentId)
	CONSTRAINT fk_Incident_dispositionId FOREIGN KEY (dispositionId)
		REFERENCES [IPD.Disposition] (dispositionId)
		ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE [IPD.Occur] (
	locationId CHAR(5) NOT NULL,
	crimeId CHAR(5) NOT NULL,
	incidentId CHAR(13) NOT NULL,
	occurDate DATE,
	occurTime TIME(0)
	CONSTRAINT pk_Occur_locationId_crimeId_incidentId PRIMARY KEY(locationId, crimeId, incidentId),
	CONSTRAINT fk_Occur_locationId FOREIGN KEY (locationId)
		REFERENCES [IPD.Location] (locationId)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Occur_crimeId FOREIGN KEY (crimeId)
		REFERENCES [IPD.Crime] (crimeId)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Occur_incidentId FOREIGN KEY (incidentId)
		REFERENCES [IPD.Incident] (incidentId)
		ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE [IPD.Arrest] (
	arrestId CHAR(5) NOT NULL,
	arrestDate DATE,
	arrestTime TIME(0),
	arrestGender VARCHAR(6),
	arrestAge INT,
	incidentId CHAR(13) NOT NULL
	CONSTRAINT pk_Arrest_arrestId PRIMARY KEY (arrestId),
	CONSTRAINT fk_Arrest_incidentId FOREIGN KEY (incidentId)
		REFERENCES [IPD.Incident] (incidentId)
		ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE [IPD.Charge] (
	arrestId CHAR(5) NOT NULL,
	chargeId CHAR(5) NOT NULL,
	chargeDescription VARCHAR(MAX)
	CONSTRAINT pk_Charge_arrestId_chargeId PRIMARY KEY (arrestId, chargeId),
	CONSTRAINT fk_Charge_arrestId FOREIGN KEY (arrestId)
		REFERENCES [IPD.Arrest] (arrestId)
		ON DELETE CASCADE ON UPDATE CASCADE
)