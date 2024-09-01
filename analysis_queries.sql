SELECT *
FROM dailyActivity

SELECT *
FROM sleepDay

SELECT *
FROM weightLogInfo



--changing datatype of date columns from nvarchar(255) to date

ALTER TABLE GoogleCapstone..dailyActivity
ALTER COLUMN Activitydate date

ALTER TABLE GoogleCapstone..sleepDay
ALTER COLUMN SleepDay date

ALTER TABLE GoogleCapstone..weightLogInfo
ALTER COLUMN Date date


--sedentary minutes = 1440 i.e. 24 hours
SELECT *
FROM dailyActivity
WHERE SedentaryMinutes = 1440
--GROUP BY Id




--total number of people used in the data = 33
SELECT COUNT(Distinct Id) as num_usersample
FROM dailyActivity




--total time the device was worn = sum(minutes)
SELECT *, (VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes+SedentaryMinutes)/60 as hours_worn
FROM dailyActivity
WHERE SedentaryMinutes != 1440
--1440 sedentary minutes would mean they didn't wear the device



--discrepancies in the data- Sedentary minutes= 1440 and still steps,distance!=0
Create view 
discrepancies as
SELECT *
FROM dailyActivity
WHERE SedentaryMinutes=1440
and TotalSteps != 0

SELECT COUNT(*) as num_discrepancies
FROM discrepancies
--rate of error = (7/940)


SELECT *
FROM sleepDay



--how many users wore the device to sleep =24/33
SELECT Id, COUNT(Id) as count_sleep_wear
FROM sleepDay
GROUP BY Id

SELECT COUNT(DISTINCT(Id))
FROM sleepDay




SELECT  AVG(TotalSleepRecords) as avg_times_sleptperday, AVG(TotalMinutesAsleep)/60 as avg_TotalHoursAsleep, AVG(TotalTimeInBed)/60 as avg_TotalHoursInBed,
MAX(TotalSleepRecords) as max_times_sleptperday, MAX(TotalMinutesAsleep)/60 as max_HoursAsleep, MAX(TotalTimeInBed)/60 as max_TimeInBed,
MIN(TotalSleepRecords) as min_times_sleptperday, MIN(TotalMinutesAsleep)/60 as min_HoursAsleep, MIN(TotalTimeInBed)/60 as min_TimeInBed
FROM sleepDay
--GROUP BY Id


SELECT *
FROM weightLogInfo

SELECT Id, COUNT(Id) as timesWeightLogged
FROM weightLogInfo
GROUP by Id


--number of users who logged their weight
--SELECT COUNT(DISTINCT(Id))
--FROM weightLogInfo


-- number of users who manually reported their weight
SELECT COUNT(Id) as timesWeightLoggedManually
FROM weightLogInfo
WHERE IsManualReport=1

SELECT COUNT(DISTINCT Id) 
FROM weightLogInfo
WHERE IsManualReport=1


--weightstats
SELECT Id, AVG(WeightKg) as avg_weight,  (MAX(WeightKg)-MIN(WeightKg)) as weightlost, AVG(BMI) as avg_bmi
FROM weightLogInfo
GROUP BY Id


--number of people who used sleep and weight tracking both
SELECT DISTINCT act.Id, AVG(Calories), AVG(TotalSleepRecords), AVG(WeightKg)
FROM dailyActivity as act
INNER JOIN sleepDay as sle
ON act.Id = sle.Id
AND act.ActivityDate = sle.SleepDay
INNER JOIN weightLogInfo as wei
ON wei.Date = sle.SleepDay
AND wei.Id = sle.Id
GROUP BY act.Id



--number of days sleep was tracked
SELECT COUNT(DISTINCT Id)
FROM sleepDay

SELECT Id, COUNT(sleepDay) 
FROM sleepDay
GROUP BY Id



--
SELECT Id, COUNT(Id) as times_device_used
FROM dailyActivity
GROUP BY Id




SELECT Id,  AVG(TotalSteps) as avg_steps, AVG(TotalDistance) as avg_distance, AVG(Calories) as avg_calories, AVG(VeryActiveMinutes) as avg_vactive_mins
FROM dailyActivity
GROUP BY Id


CREATE VIEW 
sleep as 
SELECT Id, COUNT(SleepDay) as timedeviceusedforsleep
FROM sleepDay
GROUP BY Id
SELECT AVG(timedeviceusedforsleep)
FROM sleep


create view
activity as
SELECT Id, COUNT(ActivityDate) as datess
FROM dailyActivity
GROUP BY Id
SELECT AVG(datess)
FROM activity


create view
weights as
SELECT Id, COUNT(Date) as datess
FROM weightLogInfo
GROUP BY Id
SELECT AVG(datess)
FROM weights


SELECT Id, AVG(TotalMinutesAsleep) as avg_time_slept, AVG(TotalTimeInBed) as avg_time_in_bed 
FROM sleepDay
GROUP BY Id