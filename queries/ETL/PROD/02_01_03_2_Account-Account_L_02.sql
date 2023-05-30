--  Account-Account_L_02.sql Insert delta load Account RT Account target object view load query to table Account_Account_L_02
--  LAST RUN:   230524 prod delta

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
	'02_01_03_2'
	,'Account RT Account L (Load)'
	,'Load Account RT Account - Parent Account Id'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

SELECT   --TOP 10000
    A.AIMSAccount__c
    ,AccountNumber
    ,[Name]
	,CASE  -- 230509 to respond to discovery of OwnerCorpEmplId__c values not in RESOURCE_SEED
		WHEN B.Alias IS NULL THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'OwnerId'
    ,A.OwnerCorpEmplId__c
--    ,PrimaryContactId__c -- will lookup Contact from PACEPrimaryContactPartyId__c  in Account-Account_L_04.sql
    ,A.PACEPrimaryContactPartyId__c -- lookup Contact
--  lookup from PAR_AIMS_ACCT__c (leave empty for IsParent = true?)    L_03
/*    ,CASE
        WHEN (E.AIMSAccount__c IS NOT NULL) AND A.AIMSAccount__c <> A.PAR_AIMS_ACCT__c THEN E.Id
        END
		AS 'ParentId'
*/
    ,A.PAR_AIMS_ACCT__c -- lookup Account RT Account
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
		AS 'CreatedById' -- comment out in Account-Account_L_02_U.sql
    ,CreatedDate -- comment out in Account-Account_L_02_U.sql
	,CASE
		WHEN D.Alias IS NULL THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'LastModifiedById' -- comment out in Account-Account_L_02_U.sql
    ,LastModifiedDate -- comment out in Account-Account_L_02_U.sql
    ,Phone
    ,Website
    ,TFAirSpend__c
    ,Alias__c
    ,EntityActivity__c
    ,EntityType__c
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
--    ,F.Id -- Account.Id restore in Account-Account_L_02_U.sql
    ,@RecordTypeId AS RecordTypeId


--  INTO sfdc.Account_Account_L_02
--	DROP TABLE sfdc.Account_Account_L_02
FROM sfdc.Account_Account_T AS A
LEFT JOIN sfdc.[Id_User_prod] AS B -- for OwnerId
ON A.OwnerCorpEmplId__c = B.CorpEmplId__c AND B.CorpEmplId__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS C -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(C.Alias) AND C.CorpEmplId__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS D -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(D.Alias) AND D.CorpEmplId__c IS NOT NULL
/*
LEFT JOIN sfdc.[Id_Account_prod] AS E -- for Parent Account.Id
ON TRIM(A.PAR_AIMS_ACCT__c) = TRIM(E.AIMSAccount__c) AND F.RecordTypeId = '@RecordTypeId'
*/
LEFT JOIN sfdc.[Id_Account_prod] AS F -- for Account.Id
ON A.AIMSAccount__c = F.AIMSAccount__c AND F.RecordTypeId = @RecordTypeId

WHERE F.Id IS NULL


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Account_L_02)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '02_01_03_2';


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