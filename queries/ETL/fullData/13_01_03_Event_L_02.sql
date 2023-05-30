--  Event_L_02.sql Event target object view load query to table Event_L
USE Salesforce

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'13_01_03_2'
	,'Task L (Load)'
	,'Load for Update'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @RecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @AccountAccountRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

	--DROP TABLE sfdc.Event_L_02

SELECT --TOP 0.3 PERCENT
	A.PACE_ActivityId__c 
	, X.Id
	, A.AIMSAccount__c 
	, A.[Description] 
	, A.ActivityFunctionCode 
	, A.[Status]
	, A.EndDateTime 
	, A.[Subject] 
	, A.StartDateTime 
	, A.[Type]
	, CASE
		WHEN B.Alias IS NULL THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'CreatedById' 
	, A.CreatedDate 
	--, A.ActivityDate 
	, A.LastModifiedDate 
	, CASE
		WHEN C.Alias IS NULL THEN @ABTSupportId
		ELSE C.Id
		END
		AS 'LastModifiedById' 
	, CASE
		WHEN F.Id IS NULL THEN G.Id
		ELSE F.Id
		END
		AS 'WhatId' --- opportunity OR Account
	, A.PACE_OpportunityId__c 
	, CASE
		WHEN D2.Alias IS NULL THEN @ABTSupportId
		ELSE D2.Id
		END
		AS 'OwnerId' 
	, E2.Id AS "WhoId" --- contact
	, A.Priority
	, A.WebDemo__c
	, A.DiscussionTopics__c 
	, A.InternalType__c 
	, A.AIMS_Location__c 
	, A.ChurnQuestion2__c 
	, A.ChurnQuestion4__c

  --INTO sfdc.Event_L_02
FROM sfdc.Event_T AS A

LEFT JOIN sfdc.[Id_User_fullData] AS B -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(B.Alias) AND B.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData] AS C -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(C.Alias) AND C.CorpEmplID__c IS NOT NULL

--LEFT JOIN osc.activity_team_seed AS D1 -- for OwnerId
LEFT JOIN osc.[activity_team_seed] AS D1
ON A.PACE_ActivityId__c = D1.ActivityId AND D1.[PrimaryFlag] = 1
LEFT JOIN sfdc.[Id_User_fullData] AS D2 -- for OwnerId
ON TRIM(D1.CorpEmplID__c) = TRIM(D2.CorpEmplID__c) AND D2.CorpEmplID__c IS NOT NULL

LEFT JOIN osc.activity_contact_seed AS E1 -- for contact
ON A.PACE_ActivityId__c = E1.ActivityId AND E1.PrimaryFlag = 1
LEFT JOIN sfdc.[Id_Contact_fullData] AS E2 -- for contact
ON TRIM(E1.ContactIntegrationId) = TRIM(e2.CONTACTINTEGRATIONID__C)

LEFT JOIN sfdc.[Id_Opportunity_fullData] AS F
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c 

LEFT JOIN sfdc.[Id_Account_fullData] AS G-- for Account__c
ON TRIM(A.AIMSAccount__c) = TRIM(G.AIMSAccount__c) AND G.RecordTypeId = @RecordTypeId

LEFT JOIN sfdc.[Id_Event_fullData] AS X-- for activity record Id values
ON TRIM(A.A.PACE_ActivityId__c) = TRIM(X.[ActivityId]) 


WHERE 	X.Id is null

--WHERE E1.ActivityId IS NOT NULL
order by A.AIMSAccount__c,A.PACE_OpportunityID__c
--order by A.PACE_ActivityId__c

DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Event_L_02)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '13_01_03_2';