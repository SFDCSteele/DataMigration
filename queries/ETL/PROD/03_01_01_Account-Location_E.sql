--	Account-Location_E.sql Account RT Location target object view extraction query to table Account-Location_E
--      LAST RUN:  230524 prod delta
USE Salesforce;

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
	'03_01_01'
	,'Account RT Location E (Extract)'
	,'Extract Account RT Location'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
  DROP TABLE sfdc.Account_Location_E

SELECT --TOP 0.1 PERCENT
    AddressIntegrationId AS "AddressIntegrationId__c"
    ,CreatedBy AS "CreatedById"
    ,LEFT(CreationDate, 19) AS "CreatedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    ,LEFT(LastUpdateDate, 19) AS "LastModifiedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    ,LastUpdatedBy AS "LastModifiedById"
    ,CASE -- check for nulls prior to concatenation
        WHEN Address1 IS NULL AND Address2 IS NULL THEN NULL
        WHEN Address1 IS NOT NULL AND Address2 IS NULL THEN Address1
        WHEN Address1 IS NULL AND Address2 IS NOT NULL THEN Address2
        ELSE CONCAT(TRIM(Address1), ' ', Address2) -- 230425 per H. Sibal
        END
        AS "ShippingStreet" -- concatenate address lines w/space between
    ,City AS "ShippingCity"
    ,[State] AS "ShippingState"
    ,[StateCode] AS "ShippingStateCode"
    ,Country AS "ShippingCountry"
    ,CountryCode AS "ShippingCountryCode"
    ,PostalCode AS "ShippingPostalCode"
    ,Province AS "ShippingProvince__c"
    ,Latitude AS "ShippingLatitude"
    ,Longitude AS "ShippingLongitude"
    ,AddressType AS "AddressType__c" -- m-select picklist values:  BILL_TO,SELL_TO,SHIP_TO
    ,PartySiteEO_ActiveFlag_c AS "Status__c"
    ,PartySiteEO_StatusReason_c AS "StatusReason__c"
    ,PartySiteEO_StatusReasonType_c AS "StatusReasonType__c"
    ,PartySiteEO_StatusUpdateUserid_c AS "StatusUpdateUserid__c"
    ,LEFT(PartySiteEO_StatusLastUpd_c,19) AS "StatusLastUpd__c" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    ,AccountIntegrationId AS "AccountIntegrationId__c"
    ,PRIMARY_FLAG AS "PrimaryLocation__c"
    ,AIMS_ACCT AS "AIMSAccount__c"
    ,AIMS_LOC AS "AIMSAccountLocation__c"
    ,serv_station AS "ABF_ServiceCenter__c"
    ,OrganizationDEO_PantherAccountNumber_c AS "PantherAccountNumber__c"
 -- Changed per PK & DS 230419
    ,LEFT(CONCAT(TRIM(Address1), ' ', TRIM(City), ' ', TRIM(StateCode), ' ', TRIM(CountryCode)), 255)
        AS [Name] -- PK 230419  has revised this again; need neew formula

  INTO sfdc.Account_Location_E
-- FROM osc.ACCOUNT_LOCATION_SEED AS A -- base load tables
--FROM oscd.ACCOUNT_LOCATION_SEED AS A -- delta load tables
FROM oscall.ACCOUNT_LOCATION_SEED AS A -- base load tables
LEFT JOIN sfdc.ACCOUNT_ACCOUNT_T AS B
ON A.AIMS_ACCT = B.AIMSAccount__c

/*

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Location_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '03_01_01';
*/

