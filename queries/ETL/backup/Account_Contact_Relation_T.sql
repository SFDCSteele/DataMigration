-- Account_Contact_Relation_T.sql  Account Contact Relation target object view transformation query to table Account_Contact_Relation_T
USE Salesforce
  DROP TABLE sfdc.Account_Contact_Relation_T
SELECT  -- TOP 0.1 PERCENT 
	AccountId 
	, AIMSAccount__c 
	, ContactIntegrationId__c 
	, ContactId 
	, RelationshipDirection__c 
	,CASE	
		WHEN IsDirect = 1 THEN 'true'
		WHEN IsDirect = 0 THEN 'false'
		ELSE 'false'
		END
		AS "IsDirect"
	,CASE	
		WHEN Primary__c = 1 THEN 'true'
		WHEN Primary__c = 2 THEN 'false'
		ELSE 'false'
		END
		AS "Primary__c"
	, Roles 
	, Role__c

  INTO sfdc.Account_Contact_Relation_T
FROM sfdc.Account_Contact_Relation_E;    
