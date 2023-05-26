--	Task_E.sql Task target object view extraction query to table Task_E
USE Salesforce;
 --DROP TABLE sfdc.Task_E
SELECT ---TOP 1000--TOP 0.1 PERCENT
    ActivityId AS 'PACE_ActivityId__c'
    , AIMS_ACCT AS 'AIMSAccount__c' 
    , ActivityDescription AS 'Description' 
    , ActivityFunctionCode AS 'ActivityFunctionCode' 
    , StatusCode AS 'Status' 
    , StatusCode AS 'IsClosed' 
    , LEFT(ActivityEndDate, 19) AS "CompletedDateTime" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , [Subject] AS 'Subject' 
    , LEFT(ActivityStartDate, 19) AS "StartDateTime" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , ActivityTypeCode AS 'Type' 
    , CreatedBy AS 'CreatedById' 
    , LEFT(CreationDate, 19) AS "CreatedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , LEFT(DueDate, 19) AS "ActivityDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , LEFT(LastUpdateDate, 19) AS "LastModifiedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , LastUpdatedBy AS 'LastModifiedById' 
    , OpportunityId AS 'WhatId' 
    , OpportunityId AS 'PACE_OpportunityId__c' 
    , OwnerCorpEmplId AS 'OwnerId' 
    , OwnerCorpEmplId AS 'OwnerCorpEmplId__c' 
    , PrimaryContactId AS 'PrimaryContactId__c' 
    , PrimaryContactId AS 'WhoId' 
    , PriorityCode AS 'Priority' 
    , TemplateId AS 'PACE_TemplateId__c' 
    , WebDemo_c AS 'WebDemo__c' 
    , LEFT(DiscussionTopics_c, 80) AS 'DiscussionTopics__c' 
    , InternalType_c AS 'InternalType__c' 
    , AIMSLocations_c AS 'AIMS_Location__c' 
    , ChurnQuestion2_c AS 'ChurnQuestion2__c' 
    , ChurnQuestion4_c AS 'ChurnQuestion4__c'

 --INTO sfdc.Task_E
FROM osc.ACTIVITY_SEED 
    Where ActivityFunctionCode = 'TASK' AND StatusCode <> 'CANCELED' AND InternalType_c != 'CUSTOMER_CHURN'