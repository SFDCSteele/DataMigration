--  OpportunityTeamMember_T.sql -- Transform query for OpportunityTeamMember object
--  LAST RUN:   2305
USE SALESFORCE

  DROP TABLE sfdc.OpportunityTeamMember_T
SELECT --TOP 1 PERCENT
--    Id -- lookup in OpportunityTeamMember_L_02
    OpportunityId -- lookup via Opportunity in OpportunityTeamMember_L_01
    ,PACE_OpportunityID__c
	,PACE_OpportunityRevenueId__c -- for deployment in MOCK-03
    ,UserId -- lookup via User in OpportunityTeamMember_L_01
    ,CorpEmplId__c
    ,CASE	
        WHEN Primary__c = '1' THEN 'true'
        WHEN Primary__c = '0' THEN 'false'
        ELSE 'false'
        END
        AS "Primary__c" -- Checkbox
    ,CASE	
        WHEN TeamMemberRole = '1' THEN 'Primary Owner'
        WHEN TeamMemberRole = '0' THEN 'Secondary Owner'
        ELSE 'Other'
        END
        AS "TeamMemberRole" -- picklist

  INTO sfdc.OpportunityTeamMember_T
FROM sfdc.OpportunityTeamMember_E
ORDER BY PACE_OpportunityID__c, CorpEmplId__c, Primary__c
