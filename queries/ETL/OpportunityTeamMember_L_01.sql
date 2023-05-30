--  OpportunityTeamMember_L_01.sql -- Load #01 query for OpportunityTeamMember object
--  LAST RUN:   230522 fulldata
USE SALESFORCE

  DROP TABLE sfdc.OpportunityTeamMember_L_01
SELECT DISTINCT --TOP 1 PERCENT
--    Id -- lookup in OpportunityTeamMember_L_02
    C.Id AS "OpportunityId" -- lookup via Opportunity in OpportunityTeamMember_L_01
    ,A.PACE_OpportunityID__c
    ,A.PACE_OpportunityRevenueId__c -- for deployment in MOCK-03
    ,CAST(C.[Name] AS VARCHAR(120)) AS "Name"-- R/O reference field value, lookup via Opportunity in OpportunityTeamMember_L_01 
    ,B.Id As UserId -- lookup via User in OpportunityTeamMember_L_01
    ,A.CorpEmplId__c
    ,CAST(B.Title AS VARCHAR(25)) AS "Title" -- R/O reference field value, lookup via User in OpportunityTeamMember_L_01
    ,Primary__c
    ,TeamMemberRole -- using existing configured values that correspond to Primary__c; possible future User.Role__c based?

  INTO sfdc.OpportunityTeamMember_L_01
FROM sfdc.OpportunityTeamMember_T AS A

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS B -- lookup User.Id as UserId
ON A.CorpEmplId__c = B.CorpEmplId__c AND B.CorpEmplId__c IS NOT NULL

LEFT JOIN sfdc.[Id_Opportunity_fullData_230518-1111] AS C -- lookup Opportunity.Id AS OpportunityId
ON A.PACE_OpportunityID__c = C.PACE_OpportunityID__c AND A.PACE_OpportunityRevenueId__c = C.PACE_OpportunityRevenueId__c 

ORDER BY A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c, A.Primary__c DESC, A.CorpEmplId__c
