--  Account_Account_arcBtech_ShippingAddress_L_01.sql 230428 remediation load
--  Takes ShippingAccress data from fullData.Account:Account records and cross-links them to
--  arcBtech.Account:Account records to Update ShippingAddress field
--  NOTE:  the coverage for this update is impacted by the outstanding StateCode and CountryCode source data quality issue
USE SALESFORCE

select top 1000 -- 276708 rows at 230428-1051
	A.Id
    ,ShippingStreet
    ,ShippingCity
    ,ShippingStateCode
    ,ShippingCountryCode
    ,ShippingPostalCode
    ,ShippingProvince__c
    ,ShippingLatitude
    ,ShippingLongitude
	
--	INTO sfdc.Account_Account_arcBtech_ShippingAddress_L_01
--	DROP TABLE sfdc.Account_Account_arcBtech_ShippingAddress_L_01
from sfdc.[Id_Account_arcBtech_230427-1249] AS A -- 278381
left JOIN sfdc.[Id_Account_fullData_230427-1056] AS B -- 278162
ON A.AIMSAccount__c = B.AIMSAccount__c AND A.RecordTypeId = B.RecordTypeId
left JOIN sfdc.[Id_Account_fullData_230427-1056] AS C -- 276722
ON B.AIMSAccount__c = C.AIMSAccount__c
LEFT OUTER JOIN sfdc.Account_Account_L_05 AS D  -- 278165 account
ON B.Id = D.Id
WHERE 
	A.RecordTypeId = '012770000004LOvAAM' AND A.AIMSAccount__c IS NOT NULL
	AND B.RecordTypeId = '012770000004LOvAAM' AND B.AIMSAccount__c IS NOT NULL
	AND C.RecordTypeId = '012770000004LOwAAM' AND C.PrimaryLocation__c = 'true' AND C.AIMSAccount__c IS NOT NULL
	AND D.Id IS NOT NULL
ORDER BY A.AIMSAccount__c
