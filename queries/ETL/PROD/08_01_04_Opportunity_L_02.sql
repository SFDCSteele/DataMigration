-- Opportunity_L_02.sql -- StageName field history event
--  LAST RUN:  230523 fulldata

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
	'08_01_03_2'
	,'Opportunity L (Load)'
	,'Load StageName'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
SELECT --top 1000 
    Id
    ,'Closed Lost' AS StageName

--  INTO sfdc.Opportunity_L_02
--  DROP TABLE sfdc.Opportunity_L_02
FROM sfdc.[Id_Opportunity_fullData]
WHERE StatusCode__c = 'Lost' AND Id IS NOT NULL
    AND (StageName = 'Needs Analysis'
        OR StageName = 'Negotiation' 
        OR StageName = 'Discovery' 
        OR StageName = 'Onboarding'
        OR StageName = 'Qualify'
        OR StageName = 'Initial Evaluation'
        OR StageName = 'Closed Won') 
        

DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Opportunity_L_02)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '08_01_03_2';
                