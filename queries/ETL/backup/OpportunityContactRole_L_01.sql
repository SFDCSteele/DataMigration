--  OpportunityContactRole_L_01.sql -- Load #01 query for OpportunityContactRole object
--  LAST RUN:  230523 fulldata

USE SALESFORCE

  DROP TABLE sfdc.OpportunityContactRole_L_01
SELECT
--    Id -- lookup in OpportunityContactRole_L_02
    OpportunityId -- lookup via Opportunity in OpportunityContactRole_L_01
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
    ,ContactId -- lookup via Contact in OpportunityContactRole_L_01
    ,ContactIntegrationId__c
    ,IsPrimary -- Checkbox
--    ,'???' AS Role -- no data in source table

  INTO sfdc.OpportunityContactRole_L_01
FROM sfdc.OpportunityContactRole_T