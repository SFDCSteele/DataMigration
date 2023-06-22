--  OpportunityContactRole_E.sql -- Extract query for OpportunityContactRole object
--  LAST RUN:  230523 fulldata
USE SALESFORCE

SELECT
--    Id -- lookup in OpportunityContactRole_L_02
    A.Id AS "OpportunityId" -- lookup via Opportunity in OpportunityContactRole_L_01
    ,A.PACE_OpportunityID__c
    ,A.PACE_OpportunityRevenueId__c
    ,C.Id AS "ContactId" -- lookup via Contact in OpportunityContactRole_L_01
    ,B.ContactIntegrationId AS "ContactIntegrationId__c"
    ,B.PrimaryFlag AS "IsPrimary" -- Checkbox
--    ,'???' AS Role -- no data in source table

--  INTO sfdc.OpportunityContactRole_E
--  DROP TABLE sfdc.OpportunityContactRole_E
FROM sfdc.[Id_Opportunity_fullData_230518-1111] AS A
LEFT OUTER JOIN osc.OPPORTUNITY_CONTACT_SEED AS B
ON A.PACE_OpportunityID__c = B.OptyId
LEFT OUTER JOIN sfdc.[Id_Contact_fullData_230518-0928] AS C
ON B.ContactIntegrationId = C.ContactIntegrationId__c
WHERE C.Id IS NOT NULL AND B.ContactIntegrationId IS NOT NULL
ORDER BY A.PACE_OpportunityID__c, A.Id, C.Id, B.ContactIntegrationId, B.PrimaryFlag
