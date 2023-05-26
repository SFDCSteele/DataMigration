--  Account_Contact_Relation_L_01.sql Account Contact Relationship target object view load query to table Account_Contact_Relation_L
USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @RecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230516-1405]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @RecordTypeId = '012770000004LOvAAM' -- fullData RT Account

	DROP TABLE sfdc.Account_Contact_Relation_L_01

SELECT --TOP,  0.3 PERCENT
	E.ID
	, C.Id AS 'AccountId'
    , A.AIMSAccount__c     
    --, E.AIMSAccount__c     
    , A.ContactIntegrationId__c 
    --, E.ContactIntegrationId__c 
	, D.Id AS 'ContactId'
    , A.RelationshipDirection__c 
    , A.IsDirect 
    , A.Primary__c 
    , A.Roles 
    , A.Role__c 

  INTO sfdc.Account_Contact_Relation_L_01
FROM sfdc.Account_Contact_Relation_T AS A

LEFT JOIN sfdc.[Id_Account_fullData_230516-1655] AS C-- for Account__c
ON TRIM(A.AIMSAccount__c) = TRIM(C.AIMSAccount__c)  AND C.RecordTypeId = '012770000004LOvAAM'

LEFT JOIN sfdc.[Id_Contact_fullData_230518-0928] AS D-- for Contact__c
ON TRIM(A.ContactIntegrationId__c) = TRIM(D.ContactIntegrationId__c)

LEFT JOIN sfdc.[Id_AccountContactRelation_fullData_230518-1139] AS E
ON D.Id = E.CONTACTID AND C.Id = E.ACCOUNTID


Where C.Id Is NOT NULL AND D.Id Is NOT NULL 
		--AND C.Id LIKE '07k77000008tvFl%' OR D.Id LIKE '07k77000008tvFl%' OR E.Id LIKE '07k77000008tyqg' --'07k77000008tvWw'
		--AND E.ID is not null AND A.Primary__c = 'true'  --comment this is for updating the primary (record Id is NOT null)
		AND E.ID is null AND A.Primary__c = 'false'  --comment this is for inserting the secondary (record Id is null)
WHERE IsDirect__c = 'true' AND RelationshipDirection__c = 'CONTACT_TO_ACCOUNT' --alternative to 'ACCOUNT_TO_CONTACT'
--order by C.Id, D.Id
order by D.Id, C.Id

