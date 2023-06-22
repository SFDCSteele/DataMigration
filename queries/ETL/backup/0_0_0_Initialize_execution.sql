-- sample sql to get standard default data items

USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @AccountAccountRecordTypeId AS VARCHAR(20) = NULL,
    @AccountLocationRecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
    FROM sfdc.[Id_User_fullData_230516-1405]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @AccountAccountRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')
SET @AccountLocationRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'Location' AND IsActive = 'true')

Select 
       [DEVELOPERNAME]
      ,[ID]
      ,[ISACTIVE]
      ,[NAME]
      ,[SOBJECTTYPE]
      ,@ABTSupportId  AS ABTSupportId
      ,@AccountAccountRecordTypeId AS AccountAccountRecordType
      ,@AccountLocationRecordTypeId AS AccountLocationRecordType

From [sfdc].[Id_RecordType_fullData]