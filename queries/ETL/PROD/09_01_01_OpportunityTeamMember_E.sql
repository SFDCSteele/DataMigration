--  OpportunityTeamMember_E.sql -- Extract query for OpportunityTeamMember object
--  LAST RUN:   230522

USE SALESFORCE

  DROP TABLE sfdc.OpportunityTeamMember_E
SELECT --TOP 1 PERCENT
--    Id -- lookup in OpportunityTeamMember_L_02
    A.Id AS "OpportunityId"
    ,A.PACE_OpportunityID__c
	,A.PACE_OpportunityRevenueId__c -- for deployment in MOCK-03
    ,C.Id AS "UserId" 
    ,C.CorpEmplId__c AS "CorpEmplId__c"
    ,B.PrimaryFlag AS TeamMemberRole -- picklist set in OpportunityTeamMember_T
    ,B.PrimaryFlag AS "Primary__c"

  INTO sfdc.OpportunityTeamMember_E
from sfdc.[Id_Opportunity_prod] AS A -- make sure this is "fresh"
LEFT OUTER JOIN osc.[opportunity_team_seed_missing_sfdc_vs_pace_20230619] AS B
--LEFT OUTER JOIN oscall.opportunity_team_seed_missing AS B
--LEFT OUTER JOIN oscall.OPPORTUNITY_TEAM_SEED AS B
--LEFT OUTER JOIN osc.OPPORTUNITY_TEAM_SEED3 AS B
--LEFT OUTER JOIN oscd.OPPORTUNITY_TEAM_SEED3 AS B
ON A.PACE_OpportunityID__c = B.OptyId
LEFT OUTER JOIN sfdc.[Id_User_prod] AS C
ON B.CorpEmplID__c = C.CorpEmplID__c AND C.CorpEmplId__c IS NOT NULL and B.CorpEmplID__c != ''
WHERE C.Id IS NOT NULL
ORDER BY A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c, B.PrimaryFlag
