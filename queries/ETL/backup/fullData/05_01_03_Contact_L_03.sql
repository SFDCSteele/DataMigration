--  Contact_L_03.sql Contact target object view load query to Contact_L
USE Salesforce

  DROP TABLE sfdc.Contact_L_03_A
  
DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230501-1801]
    WHERE Alias = 'Corp01' AND CorpEmplID__c IS NOT NULL)

SELECT   --TOP 0.1 PERCENT 
	--count(*)
	 A.ContactIntegrationId__c 
	, E.Id AS 'AccountId' 
	
  INTO sfdc.Contact_L_03_A
FROM sfdc.Contact_T AS A
LEFT JOIN sfdc.Account_Contact_Relation_T AS B-- for Account__c
ON TRIM(A.ContactIntegrationId__c) = TRIM(B.ContactIntegrationId__c) 

LEFT JOIN sfdc.[Id_Account_fullData_230502-1300] AS E-- for Account__c
ON TRIM(B.AIMSAccount__c) = TRIM(E.[AIMSAccount__c]) AND E.RecordTypeId = '012770000004LOvAAM'

where B.Primary__c = 'true'
--order by E.Id
group by A.ContactIntegrationId__c, E.Id

  DROP TABLE sfdc.Contact_L_03

SELECT  -- TOP 0.1 PERCENT
	F.ID
	--,F.[CONTACTINTEGRATIONID__C]
	,E.AccountId 
	,CASE
		WHEN A.OwnerCorpEmplId__c = '' THEN 'ABTSupport'
		ELSE A.OwnerCorpEmplId__c
		END
		AS 'OwnerCorpEmplId__c'
	,CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'OwnerId'
	
  INTO sfdc.Contact_L_03
FROM sfdc.Contact_T AS A

LEFT JOIN sfdc.[Id_User_fullData_230501-1801] AS B -- for OwnerId
ON TRIM(A.OwnerCorpEmplId__c) = TRIM(B.Alias) and B.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Contact_L_03_A] AS E-- for Account__c
ON TRIM(A.ContactIntegrationId__c) = TRIM(E.[ContactIntegrationId__c]) --AND E.RecordTypeId = '012770000004LOvAAM'

LEFT JOIN [sfdc].[Id_Contact_fullData] AS F -- for contact Id
ON TRIM(A.[CONTACTINTEGRATIONID__C]) = TRIM(F.[CONTACTINTEGRATIONID__C])

Where F.Id is not null AND E.AccountId is not null
order by E.AccountId
