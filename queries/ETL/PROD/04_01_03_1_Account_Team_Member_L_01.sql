--  Account_Team_Member_L_01.sql Account Team Member target object view load query to tableAccount_Team_Member_L
USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @PAONotInSalesforceId AS VARCHAR(18) = NULL,
    @AcctRecordTypeId AS VARCHAR(18) = NULL,
    @RecordCount AS INT = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')
--	Obtain User.Id value for User.Alias = 'Corp30'
SET @PAONotInSalesforceId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'Corp30')

--  MANUAL VALUE ENTRIES PER ENVIRONMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--  org-specific RecordTypeId values:    
SET @AcctRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

DROP TABLE sfdc.[Id_User_Reference_prod];

SELECT
    Id
    ,Username
    ,CorpEmplID__c
    ,CONCAT (District__c,'-',Territory__c) as District_Territory_key
	,Title
	,IsActive
INTO sfdc.[Id_User_Reference_prod]

FROM [sfdc].[Id_User_prod]
where CorpEmplID__c IS NOT NULL AND IsActive = 'true' AND Alias <> 'Corp01'
order by Id

create index District_Territory_Index
    on sfdc.[Id_User_Reference_prod](District_Territory_key);

-- Account RT Account Primary owner

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_03_1'
	,'Account_Team_Member L (Load)'
	,'Load Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

DROP TABLE sfdc.Account_Team_Member_Primary_L_01_1

SELECT --TOP 0.3 PERCENT
	CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @PAONotInSalesforceId
		ELSE B.Id
		END
		AS 'UserId'
		,B.Title
    ,A.PrimaryAccountOwner__c
    ,A.territory as 'TerritoryNumber__c'
    ,A.SecondaryTerritoryNumber__c
    ,C.Id AS Account__c -- set via AIMSAccount__c
    ,'Primary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'


  INTO sfdc.Account_Team_Member_Primary_L_01_1
FROM sfdc.Account_Team_Member_Primary_T AS A
LEFT JOIN sfdc.[Id_User_Reference_prod] AS B -- for OwnerId
ON A.territory = B.District_Territory_key

LEFT JOIN sfdc.[Id_Account_prod] AS C-- for OwnerId, Account__c
ON A.AIMSAccount__c = C.AIMSAccount__c AND C.RecordTypeId=@AcctRecordTypeId

order by C.Id


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Primary_L_01_1)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_03_1';

-- Account RT Account Secondary owner

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_03_2'
	,'Account_Team_Member L (Load)'
	,'Load Account Secondary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

DROP TABLE sfdc.Account_Team_Member_Secondary_L_01_2

SELECT --TOP 0.3 PERCENT
	CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'UserId'
		,B.Title
    ,A.PrimaryAccountOwner__c
    ,A.territory as 'TerritoryNumber__c'
    ,A.SecondaryTerritoryNumber__c
    ,C.Id AS Account__c -- set via AIMSAccount__c
    ,'Secondary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'


  INTO sfdc.Account_Team_Member_Secondary_L_01_2
FROM sfdc.Account_Team_Member_Secondary_T AS A
LEFT JOIN sfdc.[Id_User_Reference_prod] AS B -- for OwnerId
ON A.territory = B.District_Territory_key

LEFT JOIN sfdc.[Id_Account_prod] AS C-- for OwnerId, Account__c
ON A.AIMSAccount__c = C.AIMSAccount__c  AND C.RecordTypeId=@AcctRecordTypeId

order by C.Id

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Secondary_L_01_2)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_03_2';
