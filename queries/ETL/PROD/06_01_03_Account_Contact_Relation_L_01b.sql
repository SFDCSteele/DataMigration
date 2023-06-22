--  Account_Contact_Relation_L_01.sql Account Contact Relationship target object view load query to table Account_Contact_Relation_L

-- this uses [Id_AccountContactRelation_prod] to create the proper update for Salesforce

USE Salesforce

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'06_01_03_1b'
	,'Account Contact Relation L (Load)'
	,'Load for Update'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
 
DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @AccountAccountRecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @AccountAccountRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

	DROP TABLE sfdc.Account_Contact_Relation_L_01

SELECT --TOP,  0.3 PERCENT
		A.[ID]
      ,A.[ACCOUNTID]
	  --,B.[ID]
	  ,B.[AIMSACCOUNT__C]
      --,A.[AIMSACCOUNT__C]
      ,A.[CONTACTID]
	  ,C.[ID]
      ,C.[CONTACTINTEGRATIONID__C]
	  --,A.[CONTACTINTEGRATIONID__C]
      ,A.[ISACTIVE]
      ,A.[ISDIRECT]
      ,A.[ISDIRECT__C]
      ,'CONTACT_TO_ACCOUNT' AS [RELATIONSHIPDIRECTION__C]

      INTO sfdc.Account_Contact_Relation_L_01

  FROM [sfdc].[Id_AccountContactRelation_prod] AS A
  
  Left join sfdc.[Id_Account_prod] as B
  on A.ACCOUNTID = B.[ID]

  Left join sfdc.[Id_Contact_prod] as C
  ON A.[CONTACTID] = C.[ID]
order by A.Id, C.Id

/*
DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Contact_Relation_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '06_01_03_1';
*/