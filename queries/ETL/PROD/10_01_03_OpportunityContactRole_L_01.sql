--  OpportunityContactRole_L_01.sql -- Load #01 query for OpportunityContactRole object
--  LAST RUN:  230523 prod

USE SALESFORCE

  DROP TABLE sfdc.OpportunityContactRole_L_01_A
SELECT
--    Id -- lookup in OpportunityContactRole_L_02
    OpportunityId -- lookup via Opportunity in OpportunityContactRole_L_01
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
    ,ContactId -- lookup via Contact in OpportunityContactRole_L_01
    ,ContactIntegrationId__c
    ,IsPrimary -- Checkbox
	  ,ROW_NUMBER()over(partition by OptyKey order by OptyKey) as [PrimaryIndicator3]
--    ,'???' AS Role -- no data in source table

  INTO sfdc.OpportunityContactRole_L_01_A
FROM sfdc.OpportunityContactRole_T


  DROP TABLE sfdc.OpportunityContactRole_L_01
SELECT
--    Id -- lookup in OpportunityContactRole_L_02
    OpportunityId -- lookup via Opportunity in OpportunityContactRole_L_01
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
    ,ContactId -- lookup via Contact in OpportunityContactRole_L_01
    ,ContactIntegrationId__c
    ,IsPrimary -- Checkbox
	,[PrimaryIndicator3]
--    ,'???' AS Role -- no data in source table

  INTO sfdc.OpportunityContactRole_L_01
FROM sfdc.OpportunityContactRole_L_01_A
Where   [PrimaryIndicator3] = 1 --AND [PACE_OpportunityID__c] = '300001167400412'
--AND [PACE_OpportunityID__c] = '300000026865344'
--order by PACE_OpportunityID__c
order by [PACE_OpportunityID__c],[PACE_OpportunityRevenueId__c],[ContactIntegrationId__c]
