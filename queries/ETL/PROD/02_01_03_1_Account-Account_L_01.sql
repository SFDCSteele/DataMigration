--  Account-Account_L_01.sql Account RT Account target object view load query to table Account_Account_L
--  Lookup of B.OwnerId, C.CreatedById, and D.LastModifiedById for respective org.User
--  lAST RUN:   230516 prod

USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @RecordTypeId AS VARCHAR(20) = NULL,
    @RecordCount AS INT = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @RecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'02_01_03_1'
	,'Account RT Account L (Load)'
	,'Load Account RT Account'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

	DROP TABLE sfdc.Account_Account_L_01
SELECT  --TOP 10000
    AIMSAccount__c
    ,AccountNumber
    ,[Name]
	,CASE  -- 230509 to respond to discovery of OwnerCorpEmplId__c values not in RESOURCE_SEED
		WHEN B.Alias IS NULL THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'OwnerId'
    ,OwnerCorpEmplId__c
--    ,PrimaryContactId__c -- will lookup Contact from PACEPrimaryContactPartyId__c  in Account-Account_L_04.sql
    ,PACEPrimaryContactPartyId__c -- lookup ContactId in Account-Account_L_03
--    ,ParentId -- will lookup from PAR_AIMS_ACCT__c in Account-Account_L_02.sql (leave empty for IsParent = true?)    
    ,PAR_AIMS_ACCT__c -- lookup Account RT Account
    ,PrimaryAccountOwner__c
    ,AccountOwners__c
    ,YearStarted__c
    ,CreditRating__c
    ,WomanOwned__c
    ,MinorityOwned__c
    ,EmployeesTotal__c
	,CASE
		WHEN C.Alias IS NULL THEN @ABTSupportId
		ELSE C.Id
		END
		AS 'CreatedById'
    ,CreatedDate
	,CASE
		WHEN D.Alias IS NULL THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'LastModifiedById'
    ,LastModifiedDate
    ,Phone
    ,Website
    ,TFAirSpend__c
    ,Alias__c
    ,EntityActivity__c --  picklist 230421
    ,EntityType__c --  picklist 230421
    ,ArcBestNew__c
    ,ExpediteNew__c
    ,FinalMileNew__c
    ,IntermodalNew__c
    ,InternationalAirNew__c
    ,InternationalOceanNew__c
    ,LTLNew__c
    ,ManagedTransportationNew__c
    ,ProductLaunchNew__c
    ,RetailNew__c
    ,TimeCriticalNew__c
    ,DedicatedTruckloadNew__c
    ,TradeShowNew__c
    ,TruckloadNew__c
    ,WarehousingNew__c
    ,ArcBestNewAccount__c
    ,ThirdPartyLogisticsFlag__c
    ,LTLDynamicEligibility__c
    ,LTLDynamicCourtesy__c
    ,ABFCredit__c
    ,AssetLightCredit__c
    ,ABFCreditLimit__c
    ,AssetLightCreditLimit__c
    ,TMS__c
    ,DecisionMakingStructure__c
    ,LTLBrokerageEligibility__c
    ,OpenAmount__c
    ,InvoicesPastDue__c
    ,PastDueAmount__c
    ,OpenAmountPast60__c
    ,AnnualSales__c
    ,TFRailSpend__c
    ,TFLTLSpend__c
    ,TFTLSpend__c
    ,OrganizationTier__c-- 230424 picklist
    ,ABCreditAppStatus__c
    ,ALCreditAppStatus__c
--    ,Id -- to be added in Account-Account_L_02.sql
    ,@RecordTypeId AS RecordTypeId


  INTO sfdc.Account_Account_L_01
FROM sfdc.Account_Account_T AS A
LEFT JOIN sfdc.[Id_User_prod] AS B -- for OwnerId
ON A.OwnerCorpEmplId__c = B.CorpEmplId__c AND B.CorpEmplId__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS C -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(C.Alias) AND TRIM(C.CorpEmplId__c) IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS D -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(D.Alias) AND TRIM(D.CorpEmplId__c) IS NOT NULL


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Account_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '02_01_03_1';

/*


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
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

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
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

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
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

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
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

*/