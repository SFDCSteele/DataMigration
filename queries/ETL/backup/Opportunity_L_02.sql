-- Opportunity_L_02.sql -- StageName field history event
--  LAST RUN:  230523 fulldata

USE Salesforce

SELECT --top 1000 
    Id
    ,'Closed Lost' AS StageName

--  INTO sfdc.Opportunity_L_02
--  DROP TABLE sfdc.Opportunity_L_02
FROM sfdc.[Id_Opportunity_fullData_230518-1111]
WHERE StatusCode__c = 'Lost' AND Id IS NOT NULL
    AND (StageName = 'Needs Analysis'
        OR StageName = 'Negotiation' 
        OR StageName = 'Discovery' 
        OR StageName = 'Onboarding'
        OR StageName = 'Qualify'
        OR StageName = 'Initial Evaluation'
        OR StageName = 'Closed Won') 
        
                