-- Account-Location_T.sql Account RT Location target object view transformation query to table Account_Location_T
--  LAST RUN:  230524 fulldata delta
USE Salesforce
SELECT --TOP 1 PERCENT
    AddressIntegrationId__c
    ,CreatedById -- lookup from User Id via Account-Location_L_*.sql
    ,CreatedDate
    ,LastModifiedDate
    ,LastModifiedById -- lookup from User Id via Account-Location_L_*.sql
    ,ShippingStreet
    ,ShippingCity
    ,ShippingState
    ,ShippingStateCode
    ,ShippingCountry
    ,ShippingCountryCode
    ,ShippingPostalCode
    ,ShippingProvince__c
    ,CASE
        WHEN ShippingLatitude > 90 OR ShippingLatitude < -90 OR ShippingLongitude > 180 OR ShippingLongitude < -180
        THEN NULL
        ELSE ShippingLatitude
        END
    AS ShippingLatitude
    ,CASE
        WHEN ShippingLatitude > 90 OR ShippingLatitude < -90 OR ShippingLongitude > 180 OR ShippingLongitude < -180
        THEN NULL
        ELSE ShippingLongitude
        END
    AS ShippingLongitude
    ,REPLACE(AddressType__c,',',';') AS AddressType__c -- Multi-Select Picklist with API Name values aligned to MDM values
    ,Status__c
    ,StatusReason__c
    ,StatusReasonType__c
    ,StatusUpdateUserid__c -- lookup from User Id via Account-Location_L_*.sql
    ,StatusLastUpd__c
    ,AccountIntegrationId__c
	,CASE -- per DS 230216-1537:  0 = true; 1 = false -- per DS 230329-0854 1 = true; 0 = false
		WHEN PrimaryLocation__c = 1 THEN 'true'
		WHEN PrimaryLocation__c = 0 THEN 'false'
		ELSE 'false'
		END
		AS "PrimaryLocation__c" -- checkbox
    ,AIMSAccount__c
    ,AIMSAccountLocation__c
    ,ABF_ServiceCenter__c
    ,PantherAccountNumber__c
    ,CASE
        WHEN [Name] IS NULL THEN CONCAT('NO NAME FOR ACCOUNT LOCATION ', AIMSAccountLocation__c) 
        ELSE [Name]
        END
    AS "Name"
  
--  INTO sfdc.Account_Location_T
--  DROP TABLE sfdc.Account_Location_T
FROM sfdc.Account_Location_E
--WHERE [Name] IS NULL OR ShippingLatitude > 90 OR ShippingLatitude < -90 OR ShippingLongitude > 180 OR ShippingLongitude < -180
ORDER BY AddressIntegrationId__c
