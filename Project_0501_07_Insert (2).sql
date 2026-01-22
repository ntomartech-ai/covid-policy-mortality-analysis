USE BUDT702_Project_0501_07

-- ==========================
-- 1. Insert into Location
-- ==========================
INSERT INTO [IPD.Location] VALUES
	(1, NULL, 'Adelphi Rd'),
	(2, NULL, 'University Blvd'),
	(3, 7500, 'Girard Ave'),
	(4, 7500, 'Baltimore Ave'),
	(5, NULL, 'Stadium Dr'),
	(6, 4200, 'Valley Dr'),
	(7, 7400, 'Dartmouth Ave'),
	(8, 4200, 'Stadium Dr'),
	(9, 7900, 'Regents Dr'),
	(10, NULL, 'Campus Dr'),
	(11, NULL, 'Baltimore Ave'),
	(12, 8100, 'Regents Dr'),
	(13, 3400, 'Tulane Dr'),
	(14, 3900, 'Denton Service Ln'),
	(15, 4200, 'Valley Dr'),
	(16, 4200, 'Lehigh Rd'),
	(17, 4100, 'Campus Dr'),
	(18, 7500, 'Calvert Service Ln'),
	(19, 8200, 'Paint Branch Dr'),
	(20, 7500, 'Mowatt Ln')

-- ==========================
-- 2. Insert into Crime
-- ==========================
INSERT INTO [IPD.Crime] VALUES
	(1, 'DWI/DUI'),
	(2, 'Assist Other Agency'),
	(3, 'Dept Property Damage/Loss'),
	(4, 'Recovered Stolen Motor Vehicle'),
	(5, 'Theft'),
	(6, 'Injured/Sick Person'),
	(7, 'Recovered Stolen Property'),
	(8, 'Hazardous Condition'),
	(9, 'Lost Property'),
	(10, 'Damage to State Property'),
	(11, 'Disorderly Conduct'),
	(12, 'Injured Officer'),
	(13, 'Vandalism'),
	(14, 'Harassment/Stalking'),
	(15, 'Other Incident')

-- ==========================
-- 3. Insert into Disposition
-- ==========================
INSERT INTO [IPD.Disposition] VALUES
	(1, 'Arrest'),
	(2, 'CBE'),
	(3, 'Unfounded'),
	(4, 'Investigation Pending'),
	(5, 'Active/Pending'),
	(6, 'Summons Issued'),
	(7, 'Juvenile Arrest'),
	(8, 'Warrant Issued')

-- ==========================
-- 4. Insert into Incident
-- ==========================
INSERT INTO [IPD.Incident] VALUES
	('202500000044', '01-01-2025', '01:10', 1),
	('202500000056', '01-01-2025', '01:49', 2),
	('202500003694', '01-07-2025', '15:51', 1),
	('202500009937', '01-16-2025', '10:40', 4),
	('202500011513', '01-18-2025', '13:56', 5),
	('202500022189', '02-01-2025', '01:23', 2),
	('202500026440', '02-05-2025', '15:06', 3),
	('202500029206', '02-08-2025', '13:37', 8),
	('202500037069', '02-17-2025', '10:17', 2),
	('202500038701', '02-19-2025', '01:50', 1),
	('202500055613', '03-08-2025', '10:43', 6),
	('202500059660', '03-12-2025', '21:46', 7),
	('202500060977', '03-14-2025', '11:19', 2),
	('202500062473', '03-16-2025', '00:32', 1),
	('202500078387', '04-01-2025', '16:42', 2),
	('202500079658', '04-03-2025', '00:34', 1),
	('202500080092', '04-03-2025', '11:28', 6),
	('202500085088', '04-08-2025', '23:59', 1),
	('202500088597', '04-13-2025', '06:17', 4),
	('202500092001', '04-17-2025', '03:37', 5)

-- ==========================
-- 5. Insert into Occur
-- ==========================
INSERT INTO [IPD.Occur] VALUES
	(1, 1, '202500000044', '01-01-2025', '01:10:00'),
	(3, 2, '202500000056', '01-01-2025', '01:49:00'),
	(8, 5, '202500003694', '01-07-2025', '15:51:00'),
	(19, 5, '202500009937', '01-15-2025', '10:30:00'),
	(4, 12, '202500011513', '01-18-2025', '13:56:00'),
	(20, 10, '202500022189', '01-31-2025', '23:31:00'),
	(17, 5, '202500026440', '02-04-2025', '15:15:00'),
	(18, 5, '202500029206', '02-07-2025', '14:00:00'),
	(6, 6, '202500037069', '02-17-2025', '09:30:00'),
	(5, 1, '202500038701', '02-19-2025', '01:50:00'),
	(16, 5, '202500055613', '03-07-2025', '20:00:00'),
	(13, 15, '202500059660', '03-12-2025', '21:46:00'),
	(17, 6, '202500060977', '03-14-2025', '11:05:00'),
	(2, 1, '202500062473', '03-16-2025', '00:32:00'),
	(4, 15, '202500078387', '04-01-2025', '16:42:00'),
	(1, 1, '202500079658', '04-03-2025', '00:34:00'),
	(14, 5, '202500080092', '04-02-2025', '12:00:00'),
	(2, 1, '202500085088', '04-08-2025', '23:59:00'),
	(9, 13, '202500088597', '04-12-2025', '21:10:00'),
	(7, 2, '202500092001', '04-17-2025', '03:37:00')

-- ==========================
-- 6. Insert into Arrest
-- ==========================
INSERT INTO [IPD.Arrest] VALUES
	(24332, '01-01-2025', '01:10', 'Male', 30, '202500000044'),
	(24338, '01-07-2025', '15:56', 'Male', 24, '202500003694'),
	(24393, '02-19-2025', '02:10', 'Female', 36, '202500038701'),
	(24428, '03-16-2025', '00:55', 'Male', 21, '202500062473'),
	(24449, '04-03-2025', '00:59', 'Male', 27, '202500079658'),
	(24452, '04-09-2025', '00:19', 'Male', 43, '202500085088')

-- ==========================
-- 7. Insert into Charge
-- ==========================
INSERT INTO [IPD.Charge] VALUES
	(24332, 1, '(Driving, Attempting to drive) veh. while impaired by alcohol; (Driving, Attempting to drive) veh. while under the influence of alcohol; (Driving, Attempting to drive) veh. while under the influence of alcohol per se'),
	(24338, 2, 'CDS: POSS PARAPHERNALIA; THEFT: $100 TO UNDER $1,500-All Other'),
	(24393, 1, '(Driving, Attempting to drive) veh. while impaired by alcohol; (Driving, Attempting to drive) veh. while under the influence of alcohol'),
	(24428, 3, '(Driving, Attempting to drive) veh. while under the influence of (alcohol, alcohol per se) while transporting a minor; (Driving, Attempting to drive) veh. while under the influence of alcohol; (Driving, Attempting to drive) veh. while under the influence of alcohol per se'),
	(24449, 1, '(Driving, Attempting to drive) veh. while impaired by alcohol; (Driving, Attempting to drive) veh. while under the influence of alcohol; (Driving, Attempting to drive) veh. while under the influence of alcohol per se'),
	(24452, 1, '(Driving, Attempting to drive) veh. while impaired by alcohol; (Driving, attempting to drive) veh. while so far impaired by (drug(s) or drug(s) and alcohol) cannot drive safely; (Driving, Attempting to drive) veh. while under the influence of alcohol; (Driving, Attempting to drive) veh. while under the influence of alcohol per se')
