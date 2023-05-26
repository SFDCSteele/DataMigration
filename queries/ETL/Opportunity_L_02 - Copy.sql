-- Opportunity_L_02.sql -- StageName field history event

USE Salesforce

SELECT --top 1000 
    Id
    ,'Closed Lost' AS StageName

--  INTO sfdc.Opportunity_L_02
--  DROP TABLE sfdc.Opportunity_L_02
FROM sfdc.[Id_Opportunity_fullData_230428-1733]
WHERE StatusCode__c = 'Lost' AND Id IS NOT NULL
