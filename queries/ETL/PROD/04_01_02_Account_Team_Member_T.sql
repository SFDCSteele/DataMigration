-- Accont_Team_Member_T.sql Account RT Account target object view transformation query to table Account_Account_T
USE Salesforce

/*
DECLARE 
    @RecordCount AS INT = NULL


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_02_1'
	,'Account_Team_Member T (Transform)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
-- Account RT Account Primary owner

  DROP TABLE sfdc.Account_Team_Member_Primary_T
SELECT  -- TOP 0.1 PERCENT 
    UserId
    ,territory
    ,SecondaryTerritoryNumber__c
	,'true' AS PrimaryAccountOwner__c
    ,AIMSAccount__c

  INTO sfdc.Account_Team_Member_Primary_T
FROM sfdc.Account_Team_Member_Primary_E
/*
--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Primary_T)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_02_1';

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_02_2'
	,'Account_Team_Member T (Transform)'
	,'Extract Account Secondary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
-- Account RT Account Secondary owner

  DROP TABLE sfdc.Account_Team_Member_Secondary_T
SELECT  -- TOP 0.1 PERCENT 
    UserId
    ,territory
	,PrimaryTerritoryNumber__c
    ,SecondaryTerritoryNumber__c
	,'false' AS PrimaryAccountOwner__c
    ,AIMSAccount__c

  INTO sfdc.Account_Team_Member_Secondary_T
FROM sfdc.Account_Team_Member_Secondary_E

/*
--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Secondary_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_02_2';


-- Account RT Location Primary owner
Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_02_3'
	,'Account_Team_Member T (Transform)'
	,'Extract Account Location Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
-- Account RT Location Primary owner

  DROP TABLE sfdc.Account_Team_Member_Location_Primary_T
SELECT  -- TOP 0.1 PERCENT 
    UserId
    ,territory
    ,SecondaryTerritoryNumber__c
	,'true' AS PrimaryAccountOwner__c
    ,AIMS_LOC


  INTO sfdc.Account_Team_Member_Location_Primary_T
FROM sfdc.Account_Team_Member_Location_Primary_E

-- Account RT Location Secondary owner
/*
Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_01_4'
	,'Account_Team_Member T (Transform)'
	,'Transform Account Location Secondary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
  DROP TABLE sfdc.Account_Team_Member_Location_Secondary_T
SELECT  -- TOP 0.1 PERCENT 
    UserId
    ,territory
    ,SecondaryTerritoryNumber__c
	,'false' AS PrimaryAccountOwner__c
    ,AIMS_LOC


  INTO sfdc.Account_Team_Member_Location_Secondary_T
FROM sfdc.Account_Team_Member_Location_Secondary_E

/*
--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Location_Secondary_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_02_4';
*/