--  Contact_L_09.sql Contact target object view load query to Contact_L
USE Salesforce



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

  DROP TABLE sfdc.Contact_L_09_A

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT --TOP (1000) 
		A.[ID]
      ,A.[ACCOUNTID]
      ,A.[CONTACTADDRINTEGRATIONID_C]
      ,A.[CONTACTINTEGRATIONID_C]
	  ,CONCAT(A.ACCOUNTID,'/',A.CONTACTINTEGRATIONID_C) AS OptyKey
      ,A.[FIRSTNAME]
      ,A.[LASTNAME]
      ,A.[EMAIL]
      ,A.[PHONE]
      ,A.[CREATEDDATE]
      ,A.[MAILINGCITY]
      ,A.[MAILINGCOUNTRY]
      ,A.[MAILINGCOUNTRYCODE]
      ,A.[MAILINGLATITUDE]
      ,A.[MAILINGLONGITUDE]
      ,A.[MAILINGPOSTALCODE]
      ,A.[MAILINGSTATE]
      ,A.[MAILINGSTATECODE]
      ,A.[MAILINGSTREET]


	  INTO sfdc.Contact_L_09_A
  FROM [sfdc].[contact all] AS A

where A.[CONTACTINTEGRATIONID_C] is NOT NULL

  DROP TABLE sfdc.Contact_L_09_B
SELECT --TOP (1000) 
		A.[ID]
      ,A.[ACCOUNTID]
      ,A.[CONTACTADDRINTEGRATIONID_C]
      ,A.[CONTACTINTEGRATIONID_C]
	  ,OptyKey
	  ,ROW_NUMBER()over(partition by OptyKey order by OptyKey) as [DuplicateIndicator]
      ,A.[FIRSTNAME]
      ,A.[LASTNAME]
      ,A.[EMAIL]
      ,A.[PHONE]
      ,A.[CREATEDDATE]
      ,A.[MAILINGCITY]
      ,A.[MAILINGCOUNTRY]
      ,A.[MAILINGCOUNTRYCODE]
      ,A.[MAILINGLATITUDE]
      ,A.[MAILINGLONGITUDE]
      ,A.[MAILINGPOSTALCODE]
      ,A.[MAILINGSTATE]
      ,A.[MAILINGSTATECODE]
      ,A.[MAILINGSTREET]


	  INTO sfdc.Contact_L_09_B
  FROM [sfdc].[Contact_L_09_A] AS A


  DROP TABLE sfdc.Contact_L_09
SELECT --TOP (1000) 
		A.[ID]
      ,A.[ACCOUNTID]
      ,A.[CONTACTADDRINTEGRATIONID_C]
      ,A.[CONTACTINTEGRATIONID_C]
	  ,OptyKey
	  ,[DuplicateIndicator]
      ,A.[FIRSTNAME]
      ,A.[LASTNAME]
      ,A.[EMAIL]
      ,A.[PHONE]
      ,A.[CREATEDDATE]
      ,A.[MAILINGCITY]
      ,A.[MAILINGCOUNTRY]
      ,A.[MAILINGCOUNTRYCODE]
      ,A.[MAILINGLATITUDE]
      ,A.[MAILINGLONGITUDE]
      ,A.[MAILINGPOSTALCODE]
      ,A.[MAILINGSTATE]
      ,A.[MAILINGSTATECODE]
      ,A.[MAILINGSTREET]


	  INTO sfdc.Contact_L_09
  FROM [sfdc].[Contact_L_09_B] AS A

where [DuplicateIndicator] > 1

/*
LEFT JOIN sfdc.[Id_User_prod] AS B -- for OwnerId
ON A.OwnerCorpEmplId__c = B.CorpEmplId__c AND A.OwnerCorpEmplId__c is not null AND A.OwnerCorpEmplId__c != '' AND B.CorpEmplId__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS C -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(C.Alias) and C.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS D -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(D.Alias) and D.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Contact_L_09_A] AS E-- for Account__c
ON TRIM(A.ContactIntegrationId__c) = TRIM(E.[ContactIntegrationId__c]) 

LEFT JOIN sfdc.[Id_Contact_prod] AS F-- for Contact record Id values
ON TRIM(A.ContactIntegrationId__c) = TRIM(F.[ContactIntegrationId__c]) 

where F.Id is NOT NULL
order by E.AccountId


*/