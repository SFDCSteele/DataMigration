use Salesforce

select AddressIntegrationId, Address1, Address2 
from osc.account_location_seed
where AddressIntegrationId = 'B0-0C65-N406'

select top 5000 *
from sfdc.Account_Account_L_02
WHERE AIMSAccount__c = '698505'


select *
from sfdc.[Id_User_fullData_230217-1503]
order by Alias


-- MSSQL IM/EX WIZ ESCAPING ERRORS:
select AddressIntegrationId, Address1, Address2 
from osc.account_location_seed
where AddressIntegrationId = 'B0-0C65-N406'

select TOP 100 AddressIntegrationId__c, AddressType__c
from sfdc.Account_Location_L_01
WHERE sfdc.Account_Location_L_01.AddressIntegrationId__c = 'B0-0C62-SC00'



UPDATE sfdc.Account_Location_L_01
SET AddressType__c = REPLACE(AddressType__c,',',';')
WHERE sfdc.Account_Location_L_01.AddressIntegrationId__c = 'B0-0C62-SC00'

select top 100
	OrganizationDEO_ABFFreightCorporate_c -->> Account.PrimaryAccountOwner__c (PAO)
	,OrganizationDEO_ABFFreightLocal_c -->> AccountOwners__c (PAO & SAOs)
FROM osc.account_seed


-- unique?
select count(AIMSAccountLocation__c)
from sfdc.Account_Location_L_01

select distinct AIMSAccountLocation__c
from sfdc.Account_Location_L_01

-- example row for MSSQL Imp/Exp Wiz escaping issue
select AddressIntegrationId, Address1, Address2 
from osc.account_location_seed
where AddressIntegrationId = 'B0-0C65-N406'

select top 100 *
from osc.account_location_seed
where Country = 'CANADA' AND [State] = 'NB'


select DISTINCT Country, CountryCode, [State], StateCode
from osc.account_location_seed
ORDER BY CountryCode, [StateCode]


select DISTINCT Country, [State]
from osc.CONTACT_SEED
ORDER BY Country, [State]

select AddressIntegrationId, Address1, Address2 
from osc.account_location_seed

select AddressIntegrationId, Count(AddressIntegrationId) AS Count
from osc.account_location_seed
group by AddressIntegrationId
order by Count(AddressIntegrationId) DESC

select AddressIntegrationId__c, Count(AddressIntegrationId__c)
from sfdc.Account_Location_T
group by AddressIntegrationId__c
order by Count(AddressIntegrationId__c) DESC

select AIMSAccountLocation__c, Count(AIMSAccountLocation__c)
from sfdc.Account_Location_T
group by AIMSAccountLocation__c
order by Count(AIMSAccountLocation__c) DESC

-- verifying address fallouts
Select Count(*)
from sfdc.[Id_Account_fullData_230403-0937]
where AIMSAccountLocation__c is not null and AIMSAccountLocation__c <> ''

select * --A.AIMSAccountLocation__c, A.ShippingCountry, A.ShippingCountryCode, A.ShippingState, A.ShippingStateCode, B.AIMSAccountLocation__c
from sfdc.Account_Location_T AS A
left outer join sfdc.[Id_Account_fullData_230403-0937] AS B
ON A.AIMSAccountLocation__c = B.AIMSAccountLocation__c
WHERE B.AIMSAccountLocation__c IS NULL OR B.AIMSAccountLocation__c = ''
ORDER BY A.ShippingCountryCode, A.ShippingStateCode

select DISTINCT A.ShippingCountry, A.ShippingCountryCode, A.ShippingState, A.ShippingStateCode
from sfdc.Account_Location_T AS A
left outer join sfdc.[Id_Account_fullData_230403-0937] AS B
ON A.AIMSAccountLocation__c = B.AIMSAccountLocation__c
WHERE B.AIMSAccountLocation__c IS NULL OR B.AIMSAccountLocation__c = ''
ORDER BY A.ShippingCountryCode, A.ShippingStateCode

use Salesforce

select max(len(ShippingProvince__c))
from sfdc.Account_Location_T


select AIMSAccountLocation__c, ShippingStreet
into sfdc.Account_Location_ShippingStreetUpdate
from sfdc.Account_Location_E
order by AIMSAccountLocation__c


select top 1000 *
from sfdc.Account_Location_ShippingStreetUpdate

-- 230425 account_location_seed primary unique checks
select top 1 PERCENT A.AIMS_ACCT, B.AIMS_ACCT, B.AIMS_LOC, B.PRIMARY_FLAG
from osc.account_seed AS A
left join osc.account_location_seed AS B
ON A.AIMS_ACCT = B.AIMS_ACCT AND B.PRIMARY_FLAG = 1
ORDER BY A.AIMS_ACCT

select A.AIMS_ACCT, count(B.PRIMARY_FLAG) AS Count
from osc.account_seed AS A
left join osc.account_location_seed AS B
ON A.AIMS_ACCT = B.AIMS_ACCT AND B.PRIMARY_FLAG = 1
group by A.AIMS_ACCT
ORDER BY count(B.PRIMARY_FLAG) desc

-- END account_location_seed primary unique checks

-- 230426 L_01 fallout identification
select A.AIMSAccountLocation__c
FROM sfdc.Account_Location_L_01 AS A
LEFT OUTER JOIN sfdc.[Id_Account_fullData_230426-1544] AS B
ON A.AIMSAccountLocation__c = B.AIMSAccountLocation__c
WHERE /*B.RecordTypeId = '012770000004LOwAAM' --AND */B.AIMSAccountLocation__c IS NULL

select count(*)
FROM sfdc.[Id_Account_fullData_230426-1544]
WHERE RecordTypeId = '012770000004LOwAAM' --AND B.AIMSAccountLocation__c IS NULL

--	230517 source data quality checks
select AIMS_LOC, COUNT(AIMS_LOC) AS "COUNT"
from osc.account_location_seed
group by AIMS_LOC
order by COUNT(AIMS_LOC) DESC

--		source to load row count comparison
select COUNT(*) -- 741308
from osc.account_location_seed

select count(*) -- 741308
FROM sfdc.Account_Location_T AS A

LEFT JOIN sfdc.[Id_Account_fullData_230516-1655] AS B-- for OwnerId, Account__c -- VERIFY SOURCE FRESHNESS !!!
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = '012770000004LOvAAM'

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS C -- for CreatedById -- VERIFY SOURCE FRESHNESS !!!
ON TRIM(A.CreatedById) = TRIM(C.Alias) AND TRIM(C.CorpEmplId__c) IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS D -- for LastModifiedById -- VERIFY SOURCE FRESHNESS !!!
ON TRIM(A.LastModifiedById) = TRIM(D.Alias) AND TRIM(D.CorpEmplId__c) IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS E -- for StatusUpdateUserid__c -- VERIFY SOURCE FRESHNESS !!!
ON TRIM(A.StatusUpdateUserid__c) = TRIM(E.Alias) AND TRIM(E.CorpEmplId__c) IS NOT NULL

--	Mock-03 Account:Location fall-outs analysis
select A.AIMS_LOC, A.Country, A.CountryCode, A.[State], A.StateCode
from osc.account_location_seed as A
left join sfdc.[Id_Account_fullData_230518-1535] AS B
on A.AIMS_LOC = B.AIMSAccountLocation__c AND B.RecordTypeId = '012770000004LOwAAM'
where B.AIMSAccountLocation__c is null
order by A.CountryCode, A.StateCode
