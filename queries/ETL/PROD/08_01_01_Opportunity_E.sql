-- Opportunity_E.sql
--  LAST RUN:  230517

USE Salesforce
/*
Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'08_01_01'
	,'Opportunity E (Extract)'
	,'Extract'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
  DROP TABLE sfdc.Opportunity_E 

SELECT --TOP .1 PERCENT
    [Name] AS "Name"
--    ,Id -- lookup from Opportunity in Opportunity_L_02
--    ,ContactId-- lookup from OpportunityTeamMember in Opportunity_L_02
    ,OptyId AS "PACE_OpportunityID__c"
    ,RevnId AS "PACE_OpportunityRevenueId__c"
    ,OpportunityTypeCode AS "Type" -- Picklist
    ,AIMS_ACCT AS "AccountId" -- lookup in Opportunity_L_01
    ,AIMS_ACCT AS "AIMSAccount__c"
    ,OwnerCorpEmplId AS "OwnerId" -- lookup in Opportunity_L_01
    ,OwnerCorpEmplId AS "OwnerCorpEmplId__c" -- lookup in Opportunity_L_01
    ,CreatedBy AS "CreatedById" -- lookup in Opportunity_L_01
    ,LEFT(CreationDate, 19) AS "CreatedDate"
    ,LastUpdatedBy AS "LastModifiedById" -- lookup in Opportunity_L_01
    ,LEFT(LastUpdateDate, 19) AS "LastModifiedDate"
    ,LEFT(closeDate, 19) AS "CloseDate"
--    ,f(CloseDate) AS "Fiscal" -- associated fiscal qtr or period -- depends on Fiscal Year decision DM
    ,SalesStage AS "StageName" -- Picklist
    ,StatusCode AS "StatusCode__c" -- Picklist
    ,ReasonWonLostCode AS "ReasonWonLostCode__c" -- Picklist -- see PK discussion via email on PL values
    ,WinLossDescription_c AS "WinLossDescription__c"
    ,CompetitorPartyName AS "PrimaryCompetitor__c" -- Picklist -- see J. Rego 230227-1500 Slack for missing PL values
    ,Revenue AS "Amount"
    ,WinProb AS "Probability"
    ,BusinessType_c AS "BusinessType__c" -- Picklist
    ,CASE
        WHEN LeadSource_c IS NULL AND Source_c IS NOT NULL THEN Source_c
        ELSE LeadSource_c
        END
        AS "LeadSource" -- Picklist
    ,RelatedToA3PL_c AS "RelatedToA3PL__c"  -- Checkbox
    ,PL_c AS "X3PL__c"
    ,RelatedToRetail_c AS "RelatedToRetail__c"  -- Checkbox
    ,Retailer_c AS "Retailer__c"  -- Picklist
    ,CustomerServiceRequirements_c AS "CustomerServiceReqs__c" -- MultiSelect
    ,InternalType_c AS "InternalType__c" -- Picklist
    ,RetailPlus_c AS "RetailPlus__c"  -- Checkbox
    ,RetailPlusRetailers_c AS "RetailPlusRetailers__c" -- MultiSelect
    ,DecisionMakerIdentified_c AS "DecisionMakerIdentifiedFlag__c" -- Picklist
    ,LevelOfRisk_c AS "LevelofRisk__c"
    ,Solution_c AS "Solution__c" -- Picklist
    ,EInvoicingEmail_c AS "InvoicingEmail__c"
    ,InvoicingPreference_c AS "InvoicingPreferences__c" -- Picklist
    ,TechnicalRequirements_c AS "TechnicalRequirements__c"
    ,NextSteps_c AS "NextStep" -- roughly formatted values, but not a picklist
    ,LegalRequirements_c AS "LegalRequirements__c" -- Picklist
    ,RetainType_c AS "RetainType__c" -- Picklist
    ,Geographies_c AS "Geographies__c" -- Picklist
    ,Equipment_c AS "Equipment__c" -- Picklist
    ,ArcBestNew_c AS "ArcBestNew__c" -- Checbox
    ,NewSolution_c AS "NewSolution__c" -- Checkbox
    ,LEFT(AccountShipmentDate_c, 19) AS "AccountShipmentDate__c"
    ,ProposalId_c AS "ProposalId__c"

  INTO sfdc.Opportunity_E
FROM osc.opportunity_seed_missing_sfdc_vs_pace_20230619
--FROM osc.[opportunity_seed_missing_sfdc_vs_pace_20230615]
--FROM oscall.opportunity_seed_missing
--FROM oscall.OPPORTUNITY_SEED
--FROM osc.OPPORTUNITY_SEED
--FROM oscd.OPPORTUNITY_SEED
ORDER BY AIMS_ACCT, OptyId, RevnId

/*
DECLARE 
    @RecordCount AS INT = NULL


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Opportunity_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '08_01_01';
*/