--  Account_Team_Member_LocationL_02.sql Account Team Member target object view load query to tableAccount_Team_Member_LocationL
USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @PAONotInSalesforceId AS VARCHAR(18) = NULL,
    @SAONotInSalesforceId AS VARCHAR(18) = NULL,
    @AcctRecordTypeId AS VARCHAR(18) = NULL,
    @RecordCount AS INT = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')
SET @SAONotInSalesforceId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'Corp29')
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


-- Account RT Account Secondary owner
 DROP TABLE sfdc.Account_Team_Member_Secondary_E_3
SELECT --TOP 1000 --0.1 PERCENT
    [OWNERCORPEMPLID__C] AS "UserId"
    ,[PRIMARYACCOUNTOWNER__C] AS "PrimaryTerritoryNumber__c"
    ,[ACCOUNTOWNERS__C] AS "SecondaryTerritoryNumber__c"
	,value territory
    ,[AIMSACCOUNT__C]
    ,[AIMSACCOUNTLOCATION__C]
	,'false' AS PrimaryAccountOwner__c


 INTO sfdc.Account_Team_Member_Secondary_E_3
FROM sfdc.Id_Account_prod 
	CROSS APPLY STRING_SPLIT([ACCOUNTOWNERS__C],',')
Where ACCOUNTOWNERS__C is not null And ACCOUNTOWNERS__C != ''
--WHERE ACCOUNTOWNERS__C != ''
  --   AND ACCOUNTOWNERS__C != 'null'
--    AND CorpEmplID__c = '00767509'
--AND OrganizationDEO_ABFFreightLocal_c like '%DX1-07%'
/*
Account RT Account

SELECT Id, Name, Type, RecordTypeId, RecordTypeName__c, AIMSAccount__c, AIMSAccountLocation__c, AccountOwners__c, PrimaryAccountOwner__c 
FROM Account
Where RecordTypeName__c = 'Account' AND AccountOwners__c != NULL AND AccountOwners__c != ''
*/

-- Account RT Accont Team Member Secondary Owner Load file

DROP TABLE sfdc.Account_Team_Member_Secondary_L_01

SELECT --TOP 0.3 PERCENT
	CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @SAONotInSalesforceId
		ELSE B.Id
		END
		AS 'UserId'
		,CAST(B.Title as nvarchar(50)) AS 'Title'
    ,A.PrimaryAccountOwner__c
    ,CAST(A.territory AS nvarchar(50)) as 'TerritoryNumber__c'
    ,CAST(A.SecondaryTerritoryNumber__c AS nvarchar(50)) AS 'SecondaryTerritoryNumber__c'
    ,C.Id AS Account__c -- set via AIMSAccount__c
    ,'Secondary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'
    --,A.[AIMSACCOUNT__C]
    --,A.[AIMSACCOUNTLOCATION__C]
    --,B.[Username]
    --,B.[CorpEmplID__c]


  INTO sfdc.Account_Team_Member_Secondary_L_01
FROM sfdc.Account_Team_Member_Secondary_E_3 AS A
LEFT JOIN sfdc.[Id_User_Reference_prod] AS B -- for OwnerId
ON A.territory = B.District_Territory_key

LEFT JOIN sfdc.[Id_Account_prod] AS C-- for OwnerId, Account__c
ON A.AIMSAccount__c = C.AIMSAccount__c AND C.RecordTypeId=@AcctRecordTypeId

--where B.Id = '0058V00000DCEtmQAH'
Where B.Id is null
--    AND A.territory != null
order by C.Id


-- Account RT Location Secondary owner

 DROP TABLE sfdc.Account_Team_Member_Location_Secondary_E_3

SELECT --TOP 1000 --0.1 PERCENT
    [OWNERCORPEMPLID__C] AS "UserId"
    ,[PRIMARYACCOUNTOWNER__C] AS "PrimaryTerritoryNumber__c"
    ,[ACCOUNTOWNERS__C] AS "SecondaryTerritoryNumber__c"
	,value territory
    ,[AIMSACCOUNT__C] --AS "AIMSAccount__c1"
    ,[AIMSACCOUNTLOCATION__C]
	--, A.AIMS_ACCT AS "AIMSAccount__c1"
	--,B.AIMS_ACCT AS "AIMSAccount__c2"
	--,a.AIMS_LOC
	--,B.


 INTO sfdc.Account_Team_Member_Location_Secondary_E_3
FROM sfdc.Id_Account_prod AS A

--LEFT JOIN sfdc.ACCOUNT_ACCOUNT_T AS B
--ON A.AIMS_ACCT = B.AIMSAccount__c
CROSS APPLY STRING_SPLIT(A.ACCOUNTOWNERS__C,',')
WHERE ACCOUNTOWNERS__C != ''
     AND ACCOUNTOWNERS__C IS NOT NULL
     --AND ACCOUNTOWNERS__C != 'null'
     AND A.AIMSACCOUNTLOCATION__C != ''
     AND A.AIMSACCOUNTLOCATION__C IS NOT NULL
--    AND CorpEmplID__c = '00767509'



DROP TABLE sfdc.Account_Team_Member_Location_Secondary_L_02
SELECT --TOP 0.3 PERCENT
	CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @SAONotInSalesforceId
		ELSE B.Id
		END
		AS 'UserId'
    ,CAST(B.Title as nvarchar(50)) AS 'Title'
	,C.Id
	,'false' AS PrimaryAccountOwner__c
    --,A.PrimaryAccountOwner__c
    ,CAST(A.territory AS nvarchar(50)) as 'TerritoryNumber__c'
    ,CAST(A.SecondaryTerritoryNumber__c AS nvarchar(50)) AS 'SecondaryTerritoryNumber__c'
    ,C.Id AS Account__c -- set via AIMSAccount__c
    ,C.[AIMSAccountLocation__c]
    ,'Secondary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'
    --,A.[AIMSACCOUNT__C]
    --,A.[AIMSACCOUNTLOCATION__C]


  INTO sfdc.Account_Team_Member_Location_Secondary_L_02
FROM sfdc.Account_Team_Member_Location_Secondary_E_3 AS A
LEFT JOIN sfdc.[Id_User_Reference_prod] AS B -- for OwnerId
ON A.territory = B.District_Territory_key

LEFT JOIN sfdc.[Id_Account_prod] AS C-- for OwnerId, Account__c
ON A.AIMSACCOUNTLOCATION__C = C.[AIMSAccountLocation__c] --AND C.RecordTypeId=@AcctRecordTypeId

where B.Id is null
    AND A.territory != 'null'
--where  C.Id is not null
---where B.Id = '0058V00000DCEtmQAH'

order by C.Id


/*
location - sfdc
SELECT Id, Name, Type, RecordTypeId, RecordTypeName__c, AIMSAccount__c, AIMSAccountLocation__c, AccountOwners__c, PrimaryAccountOwner__c 
FROM Account
Where AIMSAccountLocation__c != NULL AND AccountOwners__c != NULL
*/
