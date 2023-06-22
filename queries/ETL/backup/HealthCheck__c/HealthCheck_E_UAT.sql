--	HealthCheck_E.sql HealthCheck target object view extraction query to table HealthCheck_E
USE Salesforce;
 --DROP TABLE sfdc.HealthCheck_E_UAT
SELECT ---TOP 1000--TOP 0.1 PERCENT
    AIMS_ACCT AS 'Account__c' 
    , AIMS_ACCT AS 'AIMSAccount__c' 
    , ActivityFunctionCode AS 'ActivityFunctionCode' 
    , CreatedBy AS 'CreatedById' 
    , LEFT(CreationDate, 19) AS "CreatedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , ChurnQuestion2_c AS 'CurrentRisk__c' 
    , LEFT(DueDate, 19) AS "DueDate__c" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , LastUpdatedBy AS 'LastModifiedById' 
    , LEFT(LastUpdateDate, 19) AS "LastModifiedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , AIMSLocations_c AS 'Locations__c' 
    , ChurnQuestion4_c AS 'Mitigation__c' 
    , [Subject] AS 'Name' 
    , OwnercorpEmplId AS 'OwnerId' 
    , OwnercorpEmplId AS 'OwnerCorpEmplId__c' 
    , ActivityId AS 'PACEActivityId__c' 
    , StatusCode AS 'Status__c' 
    , InternalType_c AS 'Type__c'
    
 --INTO sfdc.HealthCheck_E_UAT
FROM osc.ACTIVITY_SEED 
    Where ActivityFunctionCode = 'TASK' AND StatusCode <> 'CANCELED' AND InternalType_c = 'CUSTOMER_CHURN'
