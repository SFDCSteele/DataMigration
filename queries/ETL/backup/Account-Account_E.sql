--	Account-Account_E.sql Account RT Account target object view extraction query to table Account-Account_E
--  LAST RUN:  230524 fulldata delta
USE Salesforce;
SELECT --TOP 0.1 PERCENT
    AIMS_ACCT AS "AIMSAccount__c"
    ,AIMS_ACCT AS "AccountNumber"
    ,OrganizationName AS "Name"
    ,OwnerCorpEmplId AS "OwnerId" -- will lookup User in Account-Account_L_01 from OwnerCorpEmplId__c
    ,OwnerCorpEmplId AS "OwnerCorpEmplId__c" -- lookup to User
    ,PrimaryContactPartyId AS "PrimaryContactId__c" -- will lookup Contact from PACEPrimaryContactPartyId__c in Account-Account_L_03+
    ,PrimaryContactPartyId AS "PACEPrimaryContactPartyId__c" -- lookup Contact
    ,PAR_AIMS_ACCT AS "ParentId" -- will lookup Account  RT Account from PAR_AIMS_ACCT__c in Account-Account_L_02 -- leave empty for Parent account
    ,PAR_AIMS_ACCT AS "PAR_AIMS_ACCT__c" -- lookup Account RT Account
    ,OrganizationDEO_ABFFreightCorporate_c AS 'PrimaryAccountOwner__c' -- added 230327
    ,OrganizationDEO_ABFFreightLocal_c AS 'AccountOwners__c' -- added 230327
    ,YearEstablished AS "YearStarted__c"
    ,DUNSCreditRating AS "CreditRating__c"
    ,WomanOwnedIndicator AS "WomanOwned__c"
    ,MinorityOwnedIndicator AS "MinorityOwned__c"
    ,EmployeesTotal AS "EmployeesTotal__c"
    ,CreatedBy AS "CreatedById"
    ,LEFT(CreationDate, 19) AS "CreatedDate"
    ,LEFT(LastUpdateDate, 19) AS "LastModifiedDate"
    ,LastUpdatedBy AS "LastModifiedById"
    ,REPLACE(RawPhoneNumber, CHAR(39), '') AS "Phone" -- correct Syncreon Inc. data quality problem
    ,LEFT([URL],255) AS "Website" -- truncate URL values to fit standard field
    ,OrganizationDEO_TotalAirSpend_c AS "TFAirSpend__c"
    ,OrganizationDEO_Alias_c AS "Alias__c"
    ,OrganizationDEO_EntityActivity_c AS "EntityActivity__c" -- multi-select picklist
    ,OrganizationDEO_EntityType_c AS "EntityType__c" -- multi-select picklist
    ,OrganizationDEO_ArcBestNew_c AS "ArcBestNew__c"
    ,OrganizationDEO_ExpediteNew_c AS "ExpediteNew__c"
    ,OrganizationDEO_FinalMileNew_c AS "FinalMileNew__c"
    ,OrganizationDEO_IntermodalNew_c AS "IntermodalNew__c"
    ,OrganizationDEO_InternationalAirNew_c AS "InternationalAirNew__c"
    ,OrganizationDEO_InternationalOceanNew_c AS "InternationalOceanNew__c"
    ,OrganizationDEO_LTLNew_c AS "LTLNew__c"
    ,OrganizationDEO_ManagedTransportationNew_c AS "ManagedTransportationNew__c"
    ,OrganizationDEO_ProductLaunchNew_c AS "ProductLaunchNew__c"
    ,OrganizationDEO_RetailNew_c AS "RetailNew__c"
    ,OrganizationDEO_TimeCriticalNew_c AS "TimeCriticalNew__c"
    ,OrganizationDEO_TLDedicatedNew_c AS "DedicatedTruckloadNew__c"
    ,OrganizationDEO_TradeShowNew_c AS "TradeShowNew__c"
    ,OrganizationDEO_TruckloadNew_c AS "TruckloadNew__c"
    ,OrganizationDEO_WarehousingNew_c AS "WarehousingNew__c"
    ,OrganizationDEO_ArcBestAccountNew_c AS "ArcBestNewAccount__c"
    ,OrganizationDEO_ThirdPartyLogisticsFlag_c AS "ThirdPartyLogisticsFlag__c"
    ,OrganizationDEO_LTLDynamicEligibility_c AS "LTLDynamicEligibility__c"
    ,OrganizationDEO_LTLDynamicCourtesy_c AS "LTLDynamicCourtesy__c"
    ,OrganizationDEO_ABFCredit_c AS "ABFCredit__c"
    ,OrganizationDEO_AssetLightCredit_c AS "AssetLightCredit__c"
    ,OrganizationDEO_ABFCreditLimit_c AS "ABFCreditLimit__c"
    ,OrganizationDEO_AssetLightCreditLimit_c AS "AssetLightCreditLimit__c"
    ,OrganizationDEO_TMS_c AS "TMS__c"
    ,OrganizationDEO_DecisionMakingStructure_c AS "DecisionMakingStructure__c" -- picklist
    ,OrganizationDEO_LTLBrokerageEligibility_c AS "LTLBrokerageEligibility__c"
    ,OrganizationDEO_OpenAmount_c AS "OpenAmount__c"
    ,OrganizationDEO_InvoicesPastDue_c AS "InvoicesPastDue__c"
    ,OrganizationDEO_PastDueAmount_c AS "PastDueAmount__c"
    ,OrganizationDEO_OpenAmountPast60_c AS "OpenAmountPast60__c"
    ,OrganizationDEO_AnnualSales_c AS "AnnualSales__c"
    ,OrganizationDEO_TFRailSpend_c AS "TFRailSpend__c"
    ,OrganizationDEO_TFLTLSpend_c AS "TFLTLSpend__c"
    ,OrganizationDEO_TFTLSpend_c AS "TFTLSpend__c"
    ,OrganizationDEO_OrgTier_c AS "OrganizationTier__c" -- 230424 picklist
    ,OrganizationDEO_ABCreditAppStatus_c AS "ABCreditAppStatus__c"
    ,OrganizationDEO_ALCreditAppStatus_c AS "ALCreditAppStatus__c"

-- INTO sfdc.Account_Account_E
-- DROP TABLE sfdc.Account_Account_E
--FROM osc.ACCOUNT_SEED; -- base load seed table
--FROM oscd.ACCOUNT_SEED; -- delta load seed table
