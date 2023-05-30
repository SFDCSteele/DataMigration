--  Account-Account_L_01.sql Account RT Account target object view load query to table Account_Account_L
--  Lookup of B.OwnerId, C.CreatedById, and D.LastModifiedById for respective org.User
--  lAST RUN:   230516 prod

USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @AccountAccountRecordTypeId AS VARCHAR(20) = NULL,
    @AccountLocationRecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @AccountAccountRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')
SET @AccountLocationRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
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

From [sfdc].[Id_RecordType_prod]