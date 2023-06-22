-- Task_T.sql Task target object view transformation query to table Account_Account_T
USE Salesforce

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
	'12_01_02'
	,'Task T (Transform)'
	,'Transform'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
  DROP TABLE sfdc.Task_T
SELECT  -- TOP 0.1 PERCENT 
	PACE_ActivityId__c 
	, AIMSAccount__c 
	, [Description] 
	, ActivityFunctionCode 
	,CASE
		WHEN [Status] IN ('IN_PROGRESS', 'NOT_STARTED', 'ON_HOLD') THEN 'Open'
		ELSE 'Completed'
		END
		AS 'Status'
	,CASE
		WHEN [Status] = 'COMPLETE' THEN 'true'
		ELSE 'false'
		END
		AS 'IsClosed'
	, CompletedDateTime 
	, [Subject] 
	, StartDateTime 
	,CASE
			WHEN [Type] = 'CALL' THEN 'Phone Call / Voicemail'
			WHEN [Type] = 'Digital Face to Face Meeting' THEN 'Digital Face to Face Meeting'
			WHEN [Type] = 'Digital Messaging' THEN 'Digital Messaging'
			WHEN [Type] = 'EMAIL' THEN 'Email'
			WHEN [Type] = 'Face to Face Meeting' THEN 'Face to Face Meeting'
			WHEN [Type] = 'Internal Communication' THEN 'Internal Communication'
		ELSE ''
		END
		AS 'Type'
	, CreatedById 
	, CreatedDate 
	, ActivityDate 
	, LastModifiedDate 
	, LastModifiedById 
	, WhatId 
	, PACE_OpportunityId__c 
	, OwnerId 
	, OwnerCorpEmplId__c 
	, PrimaryContactId__c 
	, WhoId 
	,CASE
		WHEN Priority = 1 THEN 'High'
		ELSE 'Normal'
		END
		AS 'Priority'
	, PACE_TemplateId__c 
	,CASE
		WHEN WebDemo__c = 0 THEN 'false'
		ELSE 'true'
		END
		AS 'WebDemo__c'
	, DiscussionTopics__c 
	, InternalType__c 
	, AIMS_Location__c 
	, ChurnQuestion2__c 
	, ChurnQuestion4__c

  INTO sfdc.Task_T
FROM sfdc.Task_E;

/*
DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Task_T)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '12_01_02';
*/