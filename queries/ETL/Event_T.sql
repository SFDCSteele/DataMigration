-- Event_T.sql Event target object view transformation query to table Event_T
USE Salesforce
  --DROP TABLE sfdc.Event_T
SELECT 
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
	, EndDateTime 
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
	--, ActivityDate 
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
	--, EndDateTime 
	--, StartDateTime 
	, DiscussionTopics__c 
	, InternalType__c 
	, AIMS_Location__c 
	, ChurnQuestion2__c 
	, ChurnQuestion4__c 
	
  --INTO sfdc.Event_T
FROM sfdc.Event_E;
