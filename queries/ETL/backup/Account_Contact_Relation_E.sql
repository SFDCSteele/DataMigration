--	Account_Contact_Relation_E.sql Account Contact Relation target object view extraction query to table Account_Contact_Relation_E
USE Salesforce;
 DROP TABLE sfdc.Account_Contact_Relation_E
SELECT --TOP 0.1 PERCENT
    AIMS_ACCT AS 'AccountId' 
    , AIMS_ACCT AS 'AIMSAccount__c' 
    , ContactIntegrationId AS 'ContactIntegrationId__c' 
    , ContactIntegrationId AS 'ContactId' 
    , Relationship AS 'RelationshipDirection__c' 
    , PrimaryFlag AS 'IsDirect' 
    , PrimaryFlag AS 'Primary__c' 
    , Role AS 'Roles' 
    , Role AS 'Role__c' 
    
 INTO sfdc.Account_Contact_Relation_E
--FROM osc.CONTACT_RELATIONSHIP_SEED;  -- base load tables
FROM oscd.CONTACT_RELATIONSHIP_SEED; -- delta load tables
