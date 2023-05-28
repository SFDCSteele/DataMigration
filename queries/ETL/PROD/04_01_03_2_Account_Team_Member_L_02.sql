--  Account_Team_Member_LocationL_02.sql Account Team Member target object view load query to tableAccount_Team_Member_LocationL
USE Salesforce

    @ABTSupportId AS VARCHAR(18) = NULL,
    @AcctRecordTypeId AS VARCHAR(18) = NULL,
    @RecordCount AS INT = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData]
    WHERE Alias = 'ABTSuppt')

--  MANUAL VALUE ENTRIES PER ENVIRONMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--  org-specific RecordTypeId values:    
SET @AcctRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

DROP TABLE sfdc.[Id_User_Reference_fullData];

SELECT
    Id
    ,Username
    ,CorpEmplID__c
    ,CONCAT (District__c,'-',Territory__c) as District_Territory_key
	,Title
	,IsActive
INTO sfdc.[Id_User_Reference_fullData]

FROM [sfdc].[Id_User_fullData]
where CorpEmplID__c IS NOT NULL AND IsActive = 'true' AND Alias <> 'Corp01'
order by Id

create index District_Territory_Index
    on sfdc.[Id_User_Reference_fullData](District_Territory_key);

-- Account RT Location Primary owner
DROP TABLE sfdc.Account_Team_Member_Location_Primary_L_02_1
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
    ,C.[AIMSAccountLocation__c]
    ,'Primary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'


  INTO sfdc.Account_Team_Member_Location_Primary_L_02_1
FROM sfdc.Account_Team_Member_Location_Primary_T AS A
LEFT JOIN sfdc.[Id_User_Reference_fullData] AS B -- for OwnerId
ON A.territory = B.District_Territory_key

LEFT JOIN sfdc.[Id_Account_fullData] AS C-- for OwnerId, Account__c
ON A.AIMS_LOC = C.[AIMSAccountLocation__c] AND C.RecordTypeId=@AcctRecordTypeId

where  C.Id is not null

order by C.Id

-- Account RT Location Secondary owner
DROP TABLE sfdc.Account_Team_Member_Location_Secondary_L_02_2
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
    ,C.[AIMSAccountLocation__c]
    ,'Secondary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'


  INTO sfdc.Account_Team_Member_Location_Secondary_L_02_2
FROM sfdc.Account_Team_Member_Location_Secondary_T AS A
LEFT JOIN sfdc.[Id_User_Reference_fullData] AS B -- for OwnerId
ON A.territory = B.District_Territory_key

LEFT JOIN sfdc.[Id_Account_fullData] AS C-- for OwnerId, Account__c
ON A.AIMS_LOC = C.[AIMSAccountLocation__c] AND C.RecordTypeId=@AcctRecordTypeId

where  C.Id is not null

order by C.Id
