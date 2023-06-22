--	Account_Contact_Relation_E.sql Account Contact Relation target object view extraction query to table Account_Contact_Relation_E
USE Salesforce;

/*
Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'06_01_01'
	,'Account Contact Relation E (Extract)'
	,'Extract'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
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
FROM oscall.CONTACT_RELATIONSHIP_SEED;  -- base load tables
--FROM osc.CONTACT_RELATIONSHIP_SEED;  -- base load tables
--FROM oscd.CONTACT_RELATIONSHIP_SEED; -- delta load tables

/*
DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Contact_Relation_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '06_01_01';
*/