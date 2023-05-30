-- Opportunity_L_01.sql Base load to Opportunity_L_01
--  LAST RUN:  230517 prod

USE Salesforce

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'08_01_03_1'
	,'Opportunity L (Load)'
	,'Load for Insert'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

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
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  MANUAL VALUE ENTRIES PER ENVIRONMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--  org-specific RecordTypeId values:    
SET @AcctRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')
SET @OptyCrossSellRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Cross Sell' AND IsActive = 'true')
SET @OptyExpandRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Expand' AND IsActive = 'true')
SET @OptyNewRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'New' AND IsActive = 'true')
SET @OptyRetainRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Retain' AND IsActive = 'true')
--  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  DROP TABLE sfdc.Opportunity_L_01

SELECT --TOP 10000
    A.[Name]
    ,F.Id -- lookup in Opportunity_L_03
--    ,ContactId-- lookup from OpportunityTeamMember in Opportunity_L_02 ### DEPRECATED?????
    ,A.PACE_OpportunityID__c
    ,A.PACE_OpportunityRevenueId__c
--	,A.PACE_OpportunityRevenueId__c -- for deployment in MOCK-03
    ,A.[Type] -- Picklist
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
    ,A.CreatedDate
 	,CASE
        WHEN A.LastModifiedById IS NULL OR A.LastModifiedDate IS NULL THEN NULL
		WHEN E.Alias IS NULL OR A.LastModifiedById = 'ABTSupport' THEN @ABTSupportId
		ELSE E.Id
		END
		AS 'LastModifiedById' -- lookup in Opportunity_L_01
    ,A.LastModifiedDate
    ,A.CloseDate 
--    ,f(CloseDate) AS "Fiscal" -- associated fiscal qtr or period -- depends on Fiscal Year decision DM
    ,A.StageName -- Picklist
    ,A.StatusCode__c -- Picklist
    ,A.ReasonWonLostCode__c -- Picklist -- see PK discussion via email on PL values
    ,A.WinLossDescription__c
    ,A.PrimaryCompetitor__c -- Picklist -- Source & Target values identical, no transform needed
    ,A.Amount
    ,A.Probability
    ,A.BusinessType__c -- Picklist
    ,A.LeadSource -- Picklist
    ,A.RelatedToA3PL__c  -- Checkbox
 --   ,X3PL__c -- not in scope for this project phase
    ,A.RelatedToRetail__c  -- Checkbox
    ,A.Retailer__c  -- Picklist
    ,A.CustomerServiceReqs__c -- MultiSelect
    ,A.InternalType__c -- not a Picklist per PK 230301
    ,A.RetailPlus__c  -- Checkbox
    ,A.RetailPlusRetailers__c -- MultiSelect -- Source & Target values idential, no transform needed
    ,A.DecisionMakerIdentifiedFlag__c -- Checkbox
    ,A.LevelofRisk__c -- Picklist
    ,A.Solution__c -- Picklist
    ,A.InvoicingEmail__c
    ,A.InvoicingPreferences__c -- Picklist
    ,A.TechnicalRequirements__c -- Picklist
    ,A.NextStep -- roughly formatted values, but not a picklist
    ,A.LegalRequirements__c -- Picklist
    ,A.RetainType__c -- Picklist
    ,A.Geographies__c -- Picklist
    ,A.Equipment__c -- Picklist
    ,A.ArcBestNew__c -- Checbox
    ,A.NewSolution__c -- Checkbox
    ,A.AccountShipmentDate__c
    ,A.ProposalId__c

  INTO sfdc.Opportunity_L_01
FROM sfdc.Opportunity_T AS A

LEFT JOIN sfdc.[Id_Account_prod] AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = @AcctRecordTypeId

LEFT JOIN sfdc.[Id_User_prod] AS C -- for OwnerId, 
ON A.OwnerCorpEmplId__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS D -- for CreatedById
ON A.CreatedById = D.Alias AND D.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS E -- for LastModifiedById
ON A.LastModifiedById = E.Alias AND E.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_Opportunity_prod] AS F -- for Opportunity.Id in Opportunity_L_03
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c 
    AND A.PACE_OpportunityRevenueId__c = F.PACE_OpportunityRevenueId__c


WHERE F.Id is null
/*
-- for L_03:
LEFT JOIN sfdc.[Id_Opportunity_prod] AS F -- for Opportunity.Id in Opportunity_L_03
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c 
    AND A.PACE_OpportunityRevenueId__c = F.PACE_OpportunityRevenueId__c 
    AND F.PACE_OpportunityRevenueId__c IS NOT NULL
*/
--  WHERE 
ORDER BY AccountId, PACE_OpportunityID__c, PACE_OpportunityRevenueId__c --AccountId is B.Id




DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Opportunity_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '08_01_03_1';
