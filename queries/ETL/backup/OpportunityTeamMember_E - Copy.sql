--  OpportunityTeamMember_E.sql -- Extract query for OpportunityTeamMember object
USE SALESFORCE

SELECT TOP 1 PERCENT
--    Id -- lookup in OpportunityTeamMember_L_02
    A.Id AS "OpportunityId"
    ,A.PACE_OpportunityID__c AS "PACE_OpportunityID__c"
    ,C.Id AS "UserId" 
    ,C.CorpEmplId__c AS "CorpEmplId__c"
    ,B.PrimaryFlag AS TeamMemberRole -- picklist set in OpportunityTeamMember_T
    ,B.PrimaryFlag AS "Primary__c"

--  INTO sfdc.OpportunityTeamMember_E
--  DROP TABLE sfdc.OpportunityTeamMember_E
from sfdc.[Id_Opportunity_fullData_230503-0833] AS A
LEFT OUTER JOIN osc.OPPORTUNITY_TEAM_SEED AS B
ON A.PACE_OpportunityID__c = B.OptyId
LEFT OUTER JOIN sfdc.[Id_User_fullData_230424-1346] AS C
ON B.CorpEmplID__c = C.CorpEmplID__c AND C.CorpEmplId__c IS NOT NULL AND C.title <> 'MOCK-01'
WHERE C.Id IS NOT NULL
ORDER BY A.PACE_OpportunityID__c, A.Id, C.Id, C.CorpEmplID__c, B.PrimaryFlag
