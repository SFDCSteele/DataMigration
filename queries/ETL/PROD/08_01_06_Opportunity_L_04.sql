-- Opportunity_L_04.sql Base load to Opportunity_L_04
--  LAST RUN:  230517 prod

USE Salesforce

  DROP TABLE sfdc.Opportunity_L_04_A

SELECT --TOP 1000
    F.Id -- lookup in Opportunity_L_03
    --,A.ReasonWonLostCode__c AS 'ClosedReason__c' -- Picklist -- see PK discussion via email on PL values
    ,A.PACE_OpportunityID__c
    ,A.PACE_OpportunityRevenueId__c
    ,CASE
        WHEN F.[PrimaryContactId] IS NULL THEN G.[ContactId]
        WHEN G.[ContactId] IS NOT NULL THEN G.[ContactId]
        ELSE F.[PrimaryContactId]
        END
        AS 'Primary_Contact__c'

    --,F.[PrimaryContactId]
	--,A.PACE_OpportunityID__c
	--,F.PACE_OpportunityID__c
	--,G.PACE_OpportunityID__c
      --,G.[ContactIntegrationId__c]
      --,G.[IsPrimary]
      --,G.[PrimaryIndicator3]

  INTO sfdc.Opportunity_L_04_A
FROM sfdc.Opportunity_T AS A

LEFT JOIN sfdc.[Id_Opportunity_prod_prime] AS F -- for Opportunity.Id in Opportunity_L_03
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c 

LEFT JOIN [sfdc].[OpportunityContactRole_L_01] as G
ON A.PACE_OpportunityID__c = G.[PACE_OpportunityID__c] AND A.[PACE_OpportunityRevenueId__c] = G.[PACE_OpportunityRevenueId__c] AND G.[PrimaryIndicator3] = 1
WHERE F.Id is NOT null
--where A.ReasonWonLostCode__c is not null

Order by F.[PrimaryContactId],F.Id

  DROP TABLE sfdc.Opportunity_L_04_B

SELECT --TOP 1000
    Id
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
    ,Primary_Contact__c
    ,CONCAT(PACE_OpportunityId__c,'/',Primary_Contact__c) AS OptyKey

  INTO sfdc.Opportunity_L_04_B
FROM sfdc.Opportunity_L_04_A AS A
Order by PACE_OpportunityID__c,Primary_Contact__c


  DROP TABLE sfdc.Opportunity_L_04_C

SELECT --TOP 1000
    Id
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
    ,Primary_Contact__c
	,ROW_NUMBER()over(partition by OptyKey order by OptyKey) as [PrimaryIndicator]

  INTO sfdc.Opportunity_L_04_C
FROM sfdc.Opportunity_L_04_B AS A
Order by PACE_OpportunityID__c,Primary_Contact__c

  DROP TABLE sfdc.Opportunity_L_04

SELECT --TOP 1000
    Id
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
	,'NULL' AS 'ClosedReason__c'
    ,Primary_Contact__c

  INTO sfdc.Opportunity_L_04
FROM sfdc.Opportunity_L_04_C AS A
where [PrimaryIndicator] = 1
