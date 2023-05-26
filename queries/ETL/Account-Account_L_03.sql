--  Account-Account_L_03.sql Account RT Account update ParentId
--  Lookup Account.Id value for Update / Upsert 
--  Lookup and add ParentId value where PAR_AIMS_ACCT__c <> null in Account-Account_L_03
--  ALSO MUST run L_04 to add PrimaryContactId__c
--  LAST RUN:  230522 fulldata

USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @RecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230516-1405]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @RecordTypeId = '012770000004LOvAAM' -- fullData RT Account

SELECT   --TOP 10000
/*    A.AIMSAccount__c
    ,AccountNumber
    ,[Name]
    ,B.Id AS 'OwnerId'
    ,A.OwnerCorpEmplId__c
--    ,PrimaryContactId__c -- will lookup Contact from PACEPrimaryContactPartyId__c  in Account-Account_L_03.sql
    ,A.PACEPrimaryContactPartyId__c -- lookup Contact
--  lookup from PAR_AIMS_ACCT__c (leave empty for IsParent = true?)    L_03
    ,*/CASE
        WHEN (E.AIMSAccount__c IS NOT NULL) AND A.AIMSAccount__c <> A.PAR_AIMS_ACCT__c THEN E.Id
        ELSE NULL
        END
		AS 'ParentId'
/*    ,A.PAR_AIMS_ACCT__c -- lookup Account RT Account
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
	,OrganizationTier__c-- 230424 picklist    ,ABCreditAppStatus__c
    ,ABCreditAppStatus__c
    ,ALCreditAppStatus__c
*/    ,F.Id
--    ,@RecordTypeId AS RecordTypeId


  INTO sfdc.Account_Account_L_03
--	DROP TABLE sfdc.Account_Account_L_03
FROM sfdc.Account_Account_T AS A
/*LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS B -- for OwnerId
ON A.OwnerCorpEmplId__c = B.CorpEmplId__c

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS C -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(C.Alias)

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS D -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(D.Alias)
*/
LEFT JOIN sfdc.[Id_Account_fullData_230518-1535] AS E -- lookup Parent Account Id value 
ON TRIM(A.PAR_AIMS_ACCT__c) = TRIM(E.AIMSAccount__c) AND E.RecordTypeId = @RecordTypeId 

LEFT JOIN sfdc.[Id_Account_fullData_230518-1535] AS F -- lookup Account Id value
ON A.AIMSAccount__c = F.AIMSAccount__c AND F.RecordTypeId = @RecordTypeId
WHERE ((E.AIMSAccount__c IS NOT NULL) AND A.AIMSAccount__c <> A.PAR_AIMS_ACCT__c)
ORDER BY E.ID
