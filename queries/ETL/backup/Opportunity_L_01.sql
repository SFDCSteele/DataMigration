-- Opportunity_L_01.sql Base load to Opportunity_L_01
--  LAST RUN:  230517 fulldata

USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @AcctRecordTypeId AS VARCHAR(18) = NULL,
    @OptyCrossSellRecordTypeId AS VARCHAR(18) = NULL,
    @OptyExpandRecordTypeId AS VARCHAR(18) = NULL,
    @OptyNewRecordTypeId AS VARCHAR(18) = NULL,
    @OptyRetainRecordTypeId AS VARCHAR(18) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230516-1405]
    WHERE Alias = 'ABTSuppt')

--  MANUAL VALUE ENTRIES PER ENVIRONMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--  org-specific RecordTypeId values:    
SET @AcctRecordTypeId = '012770000004LOvAAM' -- fullData Account RT Account  
SET @OptyCrossSellRecordTypeId = '012770000004LOxAAM' -- fullData 012770000004LOxAAM
SET @OptyExpandRecordTypeId = '012770000004LOyAAM' -- fullData 012770000004LOyAAM
SET @OptyNewRecordTypeId = '012770000004LOzAAM' -- fullData 012770000004LOzAAM
SET @OptyRetainRecordTypeId = '012770000004LP0AAM' -- fullData 012770000004LP0AAM
--  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

SELECT --TOP 10000
    [Name]
--    ,F.Id -- lookup in Opportunity_L_03
--    ,ContactId-- lookup from OpportunityTeamMember in Opportunity_L_02 ### DEPRECATED?????
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
--	,A.PACE_OpportunityRevenueId__c -- for deployment in MOCK-03
    ,[Type] -- Picklist
    ,CASE
        WHEN [Type] = 'Cross Sell' THEN @OptyCrossSellRecordTypeId
        WHEN [Type] = 'Expand' THEN @OptyExpandRecordTypeId
        WHEN [Type] = 'New Customer' THEN @OptyNewRecordTypeId
        WHEN [Type] = 'Retain' THEN @OptyRetainRecordTypeId
        ELSE @OptyNewRecordTypeId -- 33K NULL values -- confirmed PK230315
        END
        AS 'RecordTypeId'
    ,B.Id AS "AccountId" -- lookup in Opportunity_L_01
    ,A.AIMSAccount__c
    ,CASE
        WHEN C.Alias IS NULL OR A.OwnerCorpEmplId__c = 'ABTSupport' THEN @ABTSupportId
        ELSE C.Id
        END
        AS 'OwnerId' -- lookup in Opportunity_L_01
    ,A.OwnerCorpEmplId__c
	,CASE
		WHEN D.Alias IS NULL OR A.CreatedById = 'ABTSupport' THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'CreatedById' -- lookup in Opportunity_L_01
    ,CreatedDate
 	,CASE
        WHEN A.LastModifiedById IS NULL OR A.LastModifiedDate IS NULL THEN NULL
		WHEN E.Alias IS NULL OR A.LastModifiedById = 'ABTSupport' THEN @ABTSupportId
		ELSE E.Id
		END
		AS 'LastModifiedById' -- lookup in Opportunity_L_01
    ,LastModifiedDate
    ,CloseDate 
--    ,f(CloseDate) AS "Fiscal" -- associated fiscal qtr or period -- depends on Fiscal Year decision DM
    ,StageName -- Picklist
    ,StatusCode__c -- Picklist
    ,ReasonWonLostCode__c -- Picklist -- see PK discussion via email on PL values
    ,WinLossDescription__c
    ,PrimaryCompetitor__c -- Picklist -- Source & Target values identical, no transform needed
    ,Amount
    ,Probability
    ,BusinessType__c -- Picklist
    ,LeadSource -- Picklist
    ,RelatedToA3PL__c  -- Checkbox
 --   ,X3PL__c -- not in scope for this project phase
    ,RelatedToRetail__c  -- Checkbox
    ,Retailer__c  -- Picklist
    ,CustomerServiceReqs__c -- MultiSelect
    ,InternalType__c -- not a Picklist per PK 230301
    ,RetailPlus__c  -- Checkbox
    ,RetailPlusRetailers__c -- MultiSelect -- Source & Target values idential, no transform needed
    ,DecisionMakerIdentifiedFlag__c -- Checkbox
    ,LevelofRisk__c -- Picklist
    ,Solution__c -- Picklist
    ,InvoicingEmail__c
    ,InvoicingPreferences__c -- Picklist
    ,TechnicalRequirements__c -- Picklist
    ,NextStep -- roughly formatted values, but not a picklist
    ,LegalRequirements__c -- Picklist
    ,RetainType__c -- Picklist
    ,Geographies__c -- Picklist
    ,Equipment__c -- Picklist
    ,ArcBestNew__c -- Checbox
    ,NewSolution__c -- Checkbox
    ,AccountShipmentDate__c
    ,ProposalId__c

  INTO sfdc.Opportunity_L_01
--  DROP TABLE sfdc.Opportunity_L_01
FROM sfdc.Opportunity_T AS A

LEFT JOIN sfdc.[Id_Account_fullData_230517-0925] AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = @AcctRecordTypeId

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS C -- for OwnerId, 
ON A.OwnerCorpEmplId__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS D -- for CreatedById
ON A.CreatedById = D.Alias AND D.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS E -- for LastModifiedById
ON A.LastModifiedById = E.Alias AND E.CorpEmplID__c IS NOT NULL

/*
-- for L_03:
LEFT JOIN sfdc.[Id_Opportunity_fullData_230428-1733] AS F -- for Opportunity.Id in Opportunity_L_03
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c 
    AND A.PACE_OpportunityRevenueId__c = F.PACE_OpportunityRevenueId__c 
    AND F.PACE_OpportunityRevenueId__c IS NOT NULL
*/
--  WHERE 
ORDER BY AccountId, PACE_OpportunityID__c, PACE_OpportunityRevenueId__c --AccountId is B.Id