-- Account-Location_L_02.sql delta insert Account RT Location target object view load query to table Account_Location_L_02
--  LAST RUN:  230524 fulldata delta

USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @AcctRecordTypeId AS VARCHAR(18) = NULL,
    @LocRecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230524-1448]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @AcctRecordTypeId = '012770000004LOvAAM' -- fullData Account RT Account
SET @LocRecordTypeId = '012770000004LOwAAM' -- fullData Account RT Location

SELECT --TOP 1500  --VERIFY JOIN CONDITIONS ON RECORDTYPEID !!!!!!!!
/*    F.Id AS Id -- Account.Id restore in Account-Location_L_02_U.sql
    ,*/AddressIntegrationId__c
	,CASE
		WHEN C.Alias IS NULL OR A.CreatedById = 'ABTSupport' THEN @ABTSupportId
		ELSE C.Id
		END
		AS 'CreatedById' -- comment out in Account-Location_L_02_U.sql
    ,A.CreatedDate -- comment out in Account-Location_L_02_U.sql
    ,A.LastModifiedDate -- comment out in Account-Location_L_02_U.sql
	,CASE
        WHEN A.LastModifiedById IS NULL OR A.LastModifiedDate IS NULL THEN NULL
		WHEN D.Alias IS NULL OR A.LastModifiedById = 'ABTSupport' THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'LastModifiedById' -- comment out in Account-Location_L_02_U.sql
    ,ShippingStreet
    ,ShippingCity
--    ,ShippingState -- de-selected in favor of ISO 3166-2 value for PL validation
    ,ShippingStateCode -- ISO 3166-2 value
--    ,ShippingCountry -- de-selected in favor of ISO 3166-2 value for PL validation
    ,ShippingCountryCode -- ISO 3166-2 value
    ,ShippingPostalCode
    ,ShippingProvince__c
    ,ShippingLatitude
    ,ShippingLongitude
    ,AddressType__c -- NEED TO FIGURE OUT PICKLIST STATUS ON THIS!!
    ,Status__c
    ,StatusReason__c
    ,StatusReasonType__c
	,CASE
        WHEN A.StatusLastUpd__c IS NULL OR A.StatusUpdateUserid__c IS NULL THEN NULL
		WHEN E.Alias IS NULL OR A.StatusUpdateUserid__c = 'ABTSupport' THEN @ABTSupportId
		ELSE E.Id
		END
		AS 'StatusUpdateUserid__c'
    ,StatusLastUpd__c
    ,AccountIntegrationId__c
    ,A.PrimaryLocation__c
    ,A.AIMSAccount__c
    ,A.AIMSAccountLocation__c
    ,ABF_ServiceCenter__c
    ,PantherAccountNumber__c
    ,A.[Name]
--  fields not coming from source table
    ,B.Id AS Account__c -- set via AIMSAccount__c
--	,Id -- set via AIMSAccount__c in Account-Location_L_02.sql
    ,B.OwnerId -- set via AIMSAccount__c
    ,@LocRecordTypeId AS RecordTypeId

--  INTO sfdc.Account_Location_L_02
--  DROP TABLE sfdc.Account_Location_L_02
FROM sfdc.Account_Location_T AS A

LEFT JOIN sfdc.[Id_Account_fullData_230524-1821] AS B-- for OwnerId, Account__c -- VERIFY SOURCE FRESHNESS !!!
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = @AcctRecordTypeId

LEFT JOIN sfdc.[Id_User_fullData_230524-1448] AS C -- for CreatedById -- VERIFY SOURCE FRESHNESS !!!
ON TRIM(A.CreatedById) = TRIM(C.Alias) AND TRIM(C.CorpEmplId__c) IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230524-1448] AS D -- for LastModifiedById -- VERIFY SOURCE FRESHNESS !!!
ON TRIM(A.LastModifiedById) = TRIM(D.Alias) AND TRIM(D.CorpEmplId__c) IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230524-1448] AS E -- for StatusUpdateUserid__c -- VERIFY SOURCE FRESHNESS !!!
ON TRIM(A.StatusUpdateUserid__c) = TRIM(E.Alias) AND TRIM(E.CorpEmplId__c) IS NOT NULL

LEFT JOIN sfdc.[Id_Account_fullData_230524-1821] AS F -- for Account-Location record Id values
ON A.AIMSAccountLocation__c = F.AIMSAccountLocation__c AND F.RecordTypeId = @LocRecordTypeId
WHERE F.Id IS NULL -- select rows for Insert
ORDER BY A.AIMSAccountLocation__c
