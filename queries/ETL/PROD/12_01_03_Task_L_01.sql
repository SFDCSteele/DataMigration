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
	'12_01_03_1'
	,'Task L (Load)'
	,'Load for Insert'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @RecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @RecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

	DROP TABLE sfdc.Task_L_01

SELECT --top 1000--TOP 0.3 PERCENT
	A.PACE_ActivityId__c
	, X.Id
	--, 'NULL' as Id
	, A.AIMSAccount__c 
	, A.[Description] 
	, A.ActivityFunctionCode 
	, A.[Status]
	, A.IsClosed
	, A.CompletedDateTime 
	, A.[Subject] 
	, A.StartDateTime 
	, A.[Type]
	, CASE
		WHEN B.Alias IS NULL THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'CreatedById' 
	, A.CreatedDate 
	, A.ActivityDate 
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
	, A.PACE_OpportunityId__c AS 'PACEOpportunityId__c'
	, CASE
		WHEN D2.Alias IS NULL THEN @ABTSupportId
		ELSE D2.Id
		END
		AS 'OwnerId' 
	, D1.CorpEmplID__c AS 'OwnerCorpEmployeeID__c'
	, D1.[PrimaryFlag] AS 'PrimaryFlag__c'
	, A.PrimaryContactId__c 
	, E2.Id AS 'WhoId' --- contact
	, A.Priority
	, A.PACE_TemplateId__c 
	, A.WebDemo__c
	, A.DiscussionTopics__c 
	, A.InternalType__c AS 'Internal_Type__c'
	, A.AIMS_Location__c 
	, A.ChurnQuestion2__c 
	, A.ChurnQuestion4__c

  INTO sfdc.Task_L_01
FROM sfdc.Task_T AS A

LEFT JOIN sfdc.[Id_User_prod] AS B -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(B.Alias) AND B.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS C -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(C.Alias) AND C.CorpEmplID__c IS NOT NULL

--LEFT JOIN osc.[activity_team_seed] AS D1
LEFT JOIN oscall.activity_missing_team_seed AS D1
ON A.PACE_ActivityId__c = D1.ActivityId AND D1.[PrimaryFlag] = 1
LEFT JOIN sfdc.[Id_User_prod] AS D2 -- for OwnerId
ON TRIM(D1.CorpEmplID__c) = TRIM(D2.CorpEmplID__c) AND D2.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_Account_prod] AS G-- for Account__c
ON TRIM(A.AIMSAccount__c) = TRIM(G.AIMSAccount__c) AND G.RecordTypeId = @RecordTypeId

--LEFT JOIN osc.activity_contact_seed AS E1 -- for contact
--LEFT JOIN oscd.activity_contact_seed AS E1 -- for contact
LEFT JOIN oscall.activity_missing_contact_seed AS E1 -- for contact
ON A.PACE_ActivityId__c = E1.ActivityId AND E1.PrimaryFlag = 1
LEFT JOIN sfdc.[Id_Contact_prod] AS E2 -- for contact
ON E1.ContactIntegrationId = e2.CONTACTINTEGRATIONID__C  AND G.Id = E2.ACCOUNTID 

LEFT JOIN sfdc.[Id_Opportunity_prod_prime] AS F
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c 


LEFT JOIN sfdc.[Id_Task_prod] AS X-- for activity record Id values
ON A.PACE_ActivityId__c = X.[PACE_ACTIVITYID__C] 

--WHERE E1.ActivityId IS NOT NULL
where X.Id is null
--where X.Id is NOT null

order by A.AIMSAccount__c,A.PACE_OpportunityID__c
--order by A.PACE_ActivityId__c
/*
DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Task_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '12_01_03_1';
*/