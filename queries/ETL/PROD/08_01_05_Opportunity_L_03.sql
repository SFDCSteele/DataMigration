-- Opportunity_L_03.sql Update to Opportunity_L_03
--  LAST RUN:   230502

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
	'08_01_03_3'
	,'Opportunity L (Load)'
	,'Load for Update'
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
    FROM sfdc.[Id_User_fullData]
    WHERE Alias = 'ABTSuppt')

--  MANUAL VALUE ENTRIES PER ENVIRONMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--  org-specific RecordTypeId values:    
SET @AcctRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')
SET @OptyCrossSellRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'Cross Sell' AND IsActive = 'true')
SET @OptyExpandRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'Expand' AND IsActive = 'true')
SET @OptyNewRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'New' AND IsActive = 'true')
SET @OptyRetainRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_fullData]
    WHERE DeveloperName = 'Retain' AND IsActive = 'true')
--  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

SELECT TOP 10000
    A.[Name]
    ,F.Id -- lookup in Opportunity_L_03
--    ,ContactId-- lookup from OpportunityTeamMember in Opportunity_L_02
    ,A.PACE_OpportunityID__c
    ,A.PACE_OpportunityRevenueId__c
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
    ,A.StageName -- Picklist
    ,A.StatusCode__c -- Picklist
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

--  INTO sfdc.Opportunity_L_03
--  DROP TABLE sfdc.Opportunity_L_03
FROM sfdc.Opportunity_T AS A

LEFT JOIN sfdc.[Id_Account_fullData] AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = @AcctRecordTypeId

LEFT JOIN sfdc.[Id_User_fullData] AS C -- for OwnerId, 
ON A.OwnerCorpEmplId__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData] AS D -- for CreatedById
ON A.CreatedById = D.Alias AND D.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData] AS E -- for LastModifiedById
ON A.LastModifiedById = E.Alias AND E.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_Opportunity_fullData] AS F -- for Opportunity.Id in Opportunity_L_03
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c 
    AND A.PACE_OpportunityRevenueId__c = F.PACE_OpportunityRevenueId__c
WHERE -- Filter to exclude duplicate Opportunity_Seed PK values in 230414 refresh dataset - DELETE FOR SUBSEQUENT !!!
    CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) <> '300001278345897300001278345901'
    AND CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) <> '300000759186132300000772749477'
    AND CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) <> '300000759186132300000759186161'
    AND CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) <> '300001278345897300001339558208'

ORDER BY AccountId, PACE_OpportunityID__c, PACE_OpportunityRevenueId__c --AccountId is B.Id




DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Opportunity_L_03)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '08_01_03_3';
