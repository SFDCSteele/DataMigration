--  OpportunityContactRole_T.sql -- Transform query for OpportunityContactRole object
--  LAST RUN:  230523 prod
USE SALESFORCE

SELECT --TOP 1 PERCENT
--    Id -- lookup in OpportunityContactRole_L_02
    OpportunityId -- lookup via Opportunity in OpportunityContactRole_L_01
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
    ,ContactId -- lookup via Contact in OpportunityContactRole_L_01
    ,ContactIntegrationId__c
    ,CASE	
        WHEN IsPrimary = '1' THEN 'true'
        WHEN IsPrimary = '0' THEN 'false'
        ELSE 'false'
        END
        AS "IsPrimary" -- Checkbox
--    ,'???' AS Role -- no data in source table

--  INTO sfdc.OpportunityContactRole_T
--  DROP TABLE sfdc.OpportunityContactRole_T
FROM sfdc.OpportunityContactRole_E
