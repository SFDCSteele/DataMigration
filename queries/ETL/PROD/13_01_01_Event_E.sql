--	Event_E.sql Account RT Account target object view extraction query to table Event_E
USE Salesforce;


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'13_01_01'
	,'Event E (Extract)'
	,'Extract'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

 DROP TABLE sfdc.Event_E
SELECT --TOP 100 
    ActivityId AS 'PACE_ActivityId__c' 
    , AIMS_ACCT AS 'AIMSAccount__c' 
    , ActivityDescription AS 'Description' 
    , ActivityFunctionCode AS 'ActivityFunctionCode' 
    , StatusCode AS 'Status' 
    , StatusCode AS 'IsClosed' 
    , LEFT(ActivityEndDate, 19) AS "EndDateTime" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , [Subject] AS 'Subject' 
    , LEFT(ActivityStartDate, 19) AS "StartDateTime" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , ActivityTypeCode AS 'Type' 
    , CreatedBy AS 'CreatedById' 
    , LEFT(CreationDate, 19) AS "CreatedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
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
    --, LEFT(ApptEndTime, 19) AS "EndDateTime" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    --, LEFT(ApptStartTime, 19) AS "StartDateTime" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    --, StatusCode AS 'Status' 
    , WebDemo_c AS 'WebDemo__c' 
    , LEFT(DiscussionTopics_c, 80) AS 'DiscussionTopics__c' 
    , InternalType_c AS 'InternalType__c' 
    , AIMSLocations_c AS 'AIMS_Location__c' 
    , ChurnQuestion2_c AS 'ChurnQuestion2__c' 
    , ChurnQuestion4_c AS 'ChurnQuestion4__c' 

 INTO sfdc.Event_E
FROM osc.ACTIVITY_SEED 
--FROM oscd.ACTIVITY_SEED 
    Where ActivityFunctionCode = 'APPOINTMENT' AND StatusCode <> 'CANCELED'


DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Event_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '13_01_01';    