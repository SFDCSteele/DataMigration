--	User_L_04.sql table User_T tranformation query to table User_L_04 to apply ManagerId to User
--  1. Set latest value for sfdc.Id_UserRole_env_datetime
--  2. BE SURE TO FILTER OUT ArcBest System Accounts -- see last line here and System_Users_Load.xlsx
--  see System_Users_Load.xlsx
--  LAST RUN:  230518

USE Salesforce;

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
	'01_01_03_4'
	,'User L (Load)'
	,'User ManagerId'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

	DROP TABLE sfdc.User_L_04

SELECT
    B.Id -- User.Id to update
    ,C.Id AS ManagerId -- User.ManagerId
--  ,A.CorpEmplID__c -- test only
--  ,A.MgrCorpEmplID__c -- test only

	INTO sfdc.User_L_04
FROM sfdc.User_T AS A
--  INSERT CORRECT JOIN TABLE NAMES FOR ENVIRONMENT AND DATE
LEFT JOIN sfdc.[Id_User_prod] AS B -- lookup matching User Id
ON A.CorpEmplID__c = B.CorpEmplID__c AND B.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS C -- lookup Manager's User.Id value
ON A.MgrCorpEmplID__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL

--  Filter out ARCB System Users
WHERE 
	SUBSTRING(A.Username,1,12) <> 'ArcBest-Corp'  AND A.IsActive = 'true'
    AND B.MgrCorpEmplID__c <> ''


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_04)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_4';

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
	'01_01_03_3_1'
	,'User (Export)'
	,'Export'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_04)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3_2';


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_3_3'
	,'User (Insert)'
	,'Data Loader Insert'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_04)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3_3';

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_3_4'
	,'User (Export)'
	,'Data Loader Export Keys'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_04)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3_4';

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_3_5'
	,'User (Import)'
	,'MS SQL Import Keys'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_04)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3_5';


*/