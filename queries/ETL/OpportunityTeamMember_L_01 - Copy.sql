--  OpportunityTeamMember_L_01.sql -- Load #01 query for OpportunityTeamMember object
USE SALESFORCE

SELECT DISTINCT TOP 1 PERCENT
--    Id -- lookup in OpportunityTeamMember_L_02
    C.Id AS "OpportunityId" -- lookup via Opportunity in OpportunityTeamMember_L_01
    ,A.PACE_OpportunityID__c
    ,CAST(C.[Name] AS VARCHAR(120)) AS "Name"-- R/O reference field value, lookup via Opportunity in OpportunityTeamMember_L_01 
    ,B.Id As UserId -- lookup via User in OpportunityTeamMember_L_01
    ,A.CorpEmplId__c
    ,CAST(B.Title AS VARCHAR(25)) AS "Title" -- R/O reference field value, lookup via User in OpportunityTeamMember_L_01
    ,Primary__c
    ,TeamMemberRole -- using existing configured values that correspond to Primary__c; possible future User.Role__c based?

--  INTO sfdc.OpportunityTeamMember_L_01
--  DROP TABLE sfdc.OpportunityTeamMember_L_01
FROM sfdc.OpportunityTeamMember_T AS A

LEFT JOIN sfdc.[Id_User_fullData_230424-1346] AS B
ON A.CorpEmplId__c = B.CorpEmplId__c AND B.CorpEmplId__c IS NOT NULL AND B.title <> 'MOCK-01'

LEFT JOIN sfdc.[Id_Opportunity_fullData_230428-1733] AS C
ON A.PACE_OpportunityID__c = C.PACE_OpportunityID__c 
WHERE A.PACE_OpportunityID__c IS NOT NULL AND B.CorpEmplId__c IS NOT NULL AND C.PACE_OpportunityID__c IS NOT NULL
ORDER BY A.PACE_OpportunityID__c, OpportunityId, A.CorpEmplId__c
