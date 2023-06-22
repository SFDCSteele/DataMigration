--  Account-Account_L_05.sql updates target object Account_Account_L_05
--  Update to populate Account.ShippingAddress component fields 
--      from Account_Location_T.ShippingAddress component fields
--      where PrimaryLocation__c = 'true'
--  LAST RUN:  230525 fulldata delta

DECLARE 
    @RecordTypeId AS VARCHAR(20) = NULL
--  SET PER ENVIRONMENT
SET @RecordTypeId = '012770000004LOvAAM' -- fullData RT Account

USE Salesforce

SELECT  --TOP 10000
    A.Id
    ,ShippingStreet
    ,ShippingCity
    ,ShippingStateCode
    ,ShippingCountryCode
    ,ShippingPostalCode
    ,ShippingProvince__c
    ,ShippingLatitude
    ,ShippingLongitude

--  INTO sfdc.Account_Account_L_05
--	DROP TABLE sfdc.Account_Account_L_05
FROM sfdc.[Id_Account_fullData_230524-2012] AS A
INNER JOIN sfdc.Account_Location_T AS B -- verify this works on base load too!!!!!
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.PrimaryLocation__c = 'true'
WHERE A.RecordTypeId = @RecordTypeId
