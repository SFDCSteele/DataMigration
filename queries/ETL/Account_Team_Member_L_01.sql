--  Account_Team_Member_L_01.sql Account Team Member target object view load query to tableAccount_Team_Member_L
USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230516-1405]
    WHERE Alias = 'ABTSuppt')

DROP TABLE sfdc.[Id_User_Reference_fullData_230223-1245];

SELECT
    Id
    ,Username
    ,CorpEmplID__c
    ,CONCAT (District__c,'-',Territory__c) as District_Territory_key
	,Title
	,IsActive
INTO sfdc.[Id_User_Reference_fullData_230223-1245]

FROM [sfdc].[Id_User_fullData_230516-1405]
where CorpEmplID__c IS NOT NULL AND IsActive = 'true' AND Alias <> 'Corp01'
order by Id

create index District_Territory_Index
    on sfdc.[Id_User_Reference_fullData_230223-1245](District_Territory_key);

-- Account RT Account Primary owner
DROP TABLE sfdc.Account_Team_Member_Primary_L_01_1

SELECT --TOP 0.3 PERCENT
	CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'UserId'
		,B.Title
    ,PrimaryAccountOwner__c
    ,territory as 'TerritoryNumber__c'
    ,SecondaryTerritoryNumber__c
    ,C.Id AS Account__c -- set via AIMSAccount__c
    ,'Primary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'


  INTO sfdc.Account_Team_Member_Primary_L_01_1
FROM sfdc.Account_Team_Member_Primary_T AS A
LEFT JOIN sfdc.[Id_User_Reference_fullData_230223-1245] AS B -- for OwnerId
ON A.territory = B.District_Territory_key

LEFT JOIN sfdc.[Id_Account_fullData_230518-1535] AS C-- for OwnerId, Account__c
ON A.AIMSAccount__c = C.AIMSAccount__c AND C.RecordTypeId='012770000004LOvAAM'

order by C.Id

-- Account RT Account Secondary owner
DROP TABLE sfdc.Account_Team_Member_Secondary_L_01_2

SELECT --TOP 0.3 PERCENT
	CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'UserId'
		,B.Title
    ,PrimaryAccountOwner__c
    ,territory as 'TerritoryNumber__c'
    ,SecondaryTerritoryNumber__c
    ,C.Id AS Account__c -- set via AIMSAccount__c
    ,'Secondary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'


  INTO sfdc.Account_Team_Member_Secondary_L_01_2
FROM sfdc.Account_Team_Member_Secondary_T AS A
LEFT JOIN sfdc.[Id_User_Reference_fullData_230223-1245] AS B -- for OwnerId
ON A.territory = B.District_Territory_key

LEFT JOIN sfdc.[Id_Account_fullData_230518-1535] AS C-- for OwnerId, Account__c
ON A.AIMSAccount__c = C.AIMSAccount__c  AND C.RecordTypeId='012770000004LOvAAM'

order by C.Id
