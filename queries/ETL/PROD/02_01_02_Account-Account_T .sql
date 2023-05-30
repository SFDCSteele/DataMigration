-- Account-Account_T.sql Account RT Account target object view transformation query to table Account_Account_T
--	LAST RUN:  230524 prod delta
USE Salesforce


DECLARE 
    @RecordCount AS INT = NULL


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'02_01_02'
	,'Account T (Transform)'
	,'Transform Account'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
  DROP TABLE sfdc.Account_Account_T

SELECT  -- TOP 0.1 PERCENT 
    AIMSAccount__c
    ,AccountNumber
    ,[Name]
    ,OwnerId -- will lookup User from OwnerCorpEmplId__c
    ,OwnerCorpEmplId__c -- lookup User
    ,PrimaryContactId__c -- will lookup Contact from PACEPrimaryContactPartyId__c
    ,PACEPrimaryContactPartyId__c -- lookup Contact
    ,ParentId -- will lookup Account  RT Account from PAR_AIMS_ACCT__c !! leave empty for IsParent = true???
    ,PAR_AIMS_ACCT__c -- lookup Account RT Account
    ,PrimaryAccountOwner__c
    ,REPLACE(AccountOwners__c, ';',',') AS AccountOwners__c -- 230509 per Kyle Cox request
    ,YearStarted__c
    ,CreditRating__c
    ,WomanOwned__c -- these are configured as Text and apparently populated by integrations
    ,MinorityOwned__c -- these are configured as Text and apparently populated by integrations
    ,EmployeesTotal__c
    ,CreatedById
    ,CreatedDate
    ,LastModifiedDate
    ,LastModifiedById
    ,Phone
    ,Website
    ,TFAirSpend__c
    ,Alias__c
	,CASE
		WHEN EntityActivity__c = 'Churned' THEN 'Churned'
		WHEN EntityActivity__c = 'Churning' THEN 'Churning'
		WHEN EntityActivity__c = 'Expanding' THEN 'Expanding'
		WHEN EntityActivity__c = 'Stable' THEN 'Stable'
		ELSE NULL -- decision made to handle small number of composite values from previous MS picklist in PACE as NULL
		END
		AS "EntityActivity__c"
	,CASE
		WHEN EntityType__c = 'Active' THEN 'Active'
		WHEN EntityType__c = 'Inactive' THEN 'Inactive'
		WHEN EntityType__c = 'Transient' THEN 'Transient'
		ELSE NULL -- decision made to handle small number of composite values from previous MS picklist in PACE as NULL
		END
		AS "EntityType__c"
	--  begin checkboxes Y = true, N= false, NULL = false
	,CASE	
		WHEN ArcBestNew__c = 'Y' THEN 'true'
		WHEN ArcBestNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "ArcBestNew__c"
	,CASE	
		WHEN ExpediteNew__c = 'Y' THEN 'true'
		WHEN ExpediteNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "ExpediteNew__c"
	,CASE	
		WHEN FinalMileNew__c = 'Y' THEN 'true'
		WHEN FinalMileNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "FinalMileNew__c"
	,CASE	
		WHEN IntermodalNew__c = 'Y' THEN 'true'
		WHEN IntermodalNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "IntermodalNew__c"
	,CASE	
		WHEN InternationalAirNew__c = 'Y' THEN 'true'
		WHEN InternationalAirNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "InternationalAirNew__c"
	,CASE	
		WHEN InternationalOceanNew__c = 'Y' THEN 'true'
		WHEN InternationalOceanNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "InternationalOceanNew__c"
	,CASE	
		WHEN LTLNew__c = 'Y' THEN 'true'
		WHEN LTLNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "LTLNew__c"
	,CASE	
		WHEN ManagedTransportationNew__c = 'Y' THEN 'true'
		WHEN ManagedTransportationNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "ManagedTransportationNew__c"
	,CASE	
		WHEN ProductLaunchNew__c = 'Y' THEN 'true'
		WHEN ProductLaunchNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "ProductLaunchNew__c"
	,CASE	
		WHEN RetailNew__c = 'Y' THEN 'true'
		WHEN RetailNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "RetailNew__c"
	,CASE	
		WHEN TimeCriticalNew__c = 'Y' THEN 'true'
		WHEN TimeCriticalNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "TimeCriticalNew__c"
	,CASE	
		WHEN DedicatedTruckloadNew__c = 'Y' THEN 'true'
		WHEN DedicatedTruckloadNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "DedicatedTruckloadNew__c"
	,CASE	
		WHEN TradeShowNew__c = 'Y' THEN 'true'
		WHEN TradeShowNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "TradeShowNew__c"
	,CASE	
		WHEN TruckloadNew__c = 'Y' THEN 'true'
		WHEN TruckloadNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "TruckloadNew__c"
	,CASE	
		WHEN WarehousingNew__c = 'Y' THEN 'true'
		WHEN WarehousingNew__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "WarehousingNew__c"
	,CASE	
		WHEN ArcBestNewAccount__c = 'Y' THEN 'true'
		WHEN ArcBestNewAccount__c = 'N' THEN 'false'
		ELSE 'false'
		END
		AS "ArcBestNewAccount__c"
	,CASE	
		WHEN ThirdPartyLogisticsFlag__c = '1' THEN 'true'
		WHEN ThirdPartyLogisticsFlag__c = '0' THEN 'false'
		ELSE 'false'
		END
		AS "ThirdPartyLogisticsFlag__c"
		,LTLDynamicEligibility__c
	,CASE
		WHEN LTLDynamicCourtesy__c = 'Yes' THEN 'true'
		WHEN LTLDynamicCourtesy__c = 'No' THEN 'false'
		ELSE 'false'
		END
		AS "LTLDynamicCourtesy__c"
	,CASE
		WHEN ABFCredit__c = 'Yes' THEN 'true'
		WHEN ABFCredit__c = 'No' THEN 'false'
		ELSE 'false'
		END
		AS "ABFCredit__c"
	,CASE
		WHEN AssetLightCredit__c = 'Yes' THEN 'true'
		WHEN AssetLightCredit__c = 'No' THEN 'false'
		ELSE 'false'
		END
		AS "AssetLightCredit__c"
    ,ABFCreditLimit__c
    ,AssetLightCreditLimit__c
    ,TMS__c
	,CASE	
		WHEN DecisionMakingStructure__c = 'BLENDED' THEN 'Blended'
		WHEN DecisionMakingStructure__c = 'CENTRALIZED' THEN 'Centralized'
		WHEN DecisionMakingStructure__c = 'DECENTRALIZED' THEN 'Decentralized'
		ELSE NULL -- NULL handling
		END
		AS "DecisionMakingStructure__c"	-- picklist
    ,LTLBrokerageEligibility__c
    ,OpenAmount__c
    ,InvoicesPastDue__c
    ,PastDueAmount__c
    ,OpenAmountPast60__c
    ,AnnualSales__c
	,CASE	
		WHEN TFRailSpend__c IS NULL THEN  '0'
		WHEN CAST(TFRailSpend__c AS bigint)  < 0  THEN  '0'
		ELSE TFRailSpend__c
		END
		AS "TFRailSpend__c"
	,CASE	
		WHEN TFLTLSpend__c IS NULL THEN  '0'
		WHEN CAST(TFLTLSpend__c AS bigint)  < 0  THEN  '0'
		ELSE TFLTLSpend__c
		END
		AS "TFLTLSpend__c"
	,CASE	
		WHEN TFTLSpend__c IS NULL THEN  '0'
		WHEN CAST(TFTLSpend__c AS bigint)  < 0  THEN  '0'
		ELSE TFTLSpend__c
		END
		AS "TFTLSpend__c"
	,CASE -- RC230425 tested value map OK
		WHEN OrganizationTier__c IS NULL THEN 'Undetermined'
		WHEN OrganizationTier__c = '0' THEN 'Undetermined'
		WHEN OrganizationTier__c = '1' THEN 'Enterprise'
		WHEN OrganizationTier__c = '2' THEN 'Middle-Market'
		WHEN OrganizationTier__c = '3' THEN 'Small to Mid-Size Business'
		WHEN OrganizationTier__c = '4' THEN 'Undetermined'
		END
		AS "OrganizationTier__c"-- 230424 picklist
	,ABCreditAppStatus__c -- picklost with correct values in source
	,ALCreditAppStatus__c -- picklost with correct values in source

  INTO sfdc.Account_Account_T
FROM sfdc.Account_Account_E


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Account_T)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '02_01_02';
