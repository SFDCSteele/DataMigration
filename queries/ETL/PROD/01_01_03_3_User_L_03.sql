--	User_L_03.sql table User_T tranformation query to table User_L_03
--  1. Set latest value for sfdc.Id_UserRole_env_datetime
--  2. BE SURE TO FILTER OUT ArcBest System Accounts -- see last line here and System_Users_Load.xlsx
--  see System_Users_Load.xlsx
--  LAST RUN:  230501

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
	'01_01_03_3'
	,'User L (Load)'
	,'User Set IsActive'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

	DROP TABLE sfdc.User_L_03
SELECT
    A.IsActive
    ,B.Id -- via JOIN w/User Id values on updates

	INTO sfdc.User_L_03
FROM sfdc.User_T AS A
--  INSERT CORRECT JOIN TABLE NAMES FOR ENVIRONMENT AND DATE
LEFT JOIN sfdc.[Id_User_prod] AS B -- lookup matching User Id
ON A.CorpEmplID__c = B.CorpEmplID__c AND B.CorpEmplID__c IS NOT NULL

--  Filter out ARCB System Users
WHERE SUBSTRING(A.Username,1,12) <> 'arcbest-corp'  AND A.IsActive = 'true'


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_03)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3';


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
    FROM sfdc.User_L_03)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3';

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_3'
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
    FROM sfdc.User_L_03)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3';


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_3'
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
    FROM sfdc.User_L_03)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3';

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_3'
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
    FROM sfdc.User_L_03)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_3';

*/