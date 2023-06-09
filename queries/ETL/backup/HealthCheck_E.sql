--	HealthCheck_E.sql HealthCheck target object view extraction query to table HealthCheck_E
--  LAST RUN:   230518 fulldata

USE Salesforce;
SELECT
--  Id -- lookup in L_02
     ActivityId AS 'PACEActivityId__c' -- PK for this table
    ,AIMS_ACCT AS 'Account__c' 
    ,AIMS_ACCT AS 'AIMSAccount__c' 
    ,CreatedBy AS 'CreatedById' 
    ,LEFT(CreationDate, 19) AS "CreatedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    ,ChurnQuestion2_c AS 'CurrentRisk__c' -- MS picklist
    ,LEFT(DueDate, 19) AS "DueDate__c" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    ,LastUpdatedBy AS 'LastModifiedById' 
    ,LEFT(LastUpdateDate, 19) AS "LastModifiedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    ,AIMSLocations_c AS 'Locations__c' 
    ,ChurnQuestion4_c AS 'Mitigation__c' 
    ,[Subject] AS 'Name' -- Text(80) max len observed = 54
    ,OwnercorpEmplId AS 'OwnerId' 
    ,OwnercorpEmplId AS 'OwnerCorpEmplId__c' 
    ,StatusCode AS 'Status__c' -- picklist
    ,InternalType_c AS 'Type__c'
    
--  INTO sfdc.HealthCheck_E
--  DROP TABLE sfdc.HealthCheck_E
    FROM osc.ACTIVITY_SEED 
    Where ActivityFunctionCode = 'TASK' AND StatusCode <> 'CANCELED' AND InternalType_c = 'CUSTOMER_CHURN'
