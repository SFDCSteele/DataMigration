use Salesforce

select top .1 percent OrganizationDEO_Alias_c
from osc.account_seed
--where OrganizationName = 'CHARCOAL COMPANION'


select COUNT(*) 
from osc.account_seed


select OrganizationDEO_ABFFreightCorporate_c -- max(len(OrganizationDEO_ABFFreightCorporate_c))
from osc.account_seed

select max(len(OrganizationDEO_TotalAirSpend_c))
from osc.account_seed

select count(PAR_AIMS_ACCT)
from osc.account_seed
--where PAR_AIMS_ACCT = ''

select TOP 0.1 PERCENT * from sfdc.Account_Account_E


--Picklist value maps
select EntityActivity__c, Count(EntityActivity__c) 
from sfdc.Account_Account_E
group by EntityActivity__c

select EntityType__c, Count(EntityType__c) 
from sfdc.Account_Account_E
group by EntityType__c

select ThirdPartyLogisticsFlag__c, Count(ThirdPartyLogisticsFlag__c) 
from sfdc.Account_Account_E
group by ThirdPartyLogisticsFlag__c



select LTLDynamicEligibility__c, Count(LTLDynamicEligibility__c) 
from sfdc.Account_Account_E
group by LTLDynamicEligibility__c

select count(*)
from osc.account_seed

select TOP 0.1 PERCENT * from sfdc.Account_Account_T

select *
from sfdc.Id_User_Staging

--	DROP TABLE sfdc.Id_User_Staging
select * from sfdc.User_L

select * from sfdc.Id_User_Staging

-- Rows in ACCOUNT_SEED with OwnerCorpEmplId values not found in RESOURCE_SEED
select A.AIMS_ACCT, A.OwnerCorpEmplId, B.CorpEmplId__c
from osc.account_seed as A
Left Outer Join osc.resource_seed as B
on A.OwnerCorpEmplId = B.CorpEmplId__c
where B.CorpEmplId__c is null

-- Rows in ACCOUNT_SEED with OwnerCorpEmplId values not found in RESOURCE_SEED
select count(A.AIMS_ACCT)
from osc.account_seed as A
Left Outer Join osc.resource_seed as B
on A.OwnerCorpEmplId = B.CorpEmplId__c
where B.CorpEmplId__c is null


SELECT count(*)
FROM sfdc.Account_Account_L_01


select LastUpdatedBy, CreatedBy

-- Rows in ACCOUNT_SEED with OwnerCorpEmplId values not found in RESOURCE_SEED
select A.AIMS_ACCT, A.CreatedBy, B.CorpEmplId__c
from osc.account_seed as A
Left Outer Join osc.resource_seed as B
on A.CreatedBy = B.CorpEmplId__c


-- Rows in ACCOUNT_SEED with CreatedBy values not found in RESOURCE_SEED
select A.CreatedBy, count(A.CreatedBy) AS Count
from osc.account_seed as A
Left Outer Join osc.resource_seed as B
on A.CreatedBy = B.Username
group by A.CreatedBy
order by Count desc

-- Rows in ACCOUNT_SEED with LastUpdatedBy values not found in RESOURCE_SEED
select A.LastUpdatedBy, count(A.LastUpdatedBy) AS Count
from osc.account_seed as A
Left Outer Join osc.resource_seed as B
on A.LastUpdatedBy = B.Username
group by A.LastUpdatedBy
order by Count desc


select *
from sfdc.[Id_User_Staging_230207-1624]
where alias = 'everge'


select data_type, character_set_catalog, character_set_schema, character_set_name, collation_catalog, collation_schema, collation_name, count(*) count 
from sqlsalesforcedev.Salesforce.INFORMATION_SCHEMA

select AIMS_ACCT
from osc.account_seed
where AIMS_ACCT = '000605'

use Salesforce

select len(URL), count(len(URL))
from osc.account_seed
group by len(URL)
order by len(URL) desc
-- Where OrganizationName = 'VACUUM PROCESS ENGINEERING'

select RawPhoneNumber, CHAR(34), CHAR(39), replace(rawphonenumber, char(39), '')
from osc.account_seed
where OrganizationName = 'SYNCREON INC'
-- where RawPhoneNumber

select TOP 500 *
from sfdc.[Id_Account_fullData_230220-1442]


select AIMSAccount__c
from sfdc.[Id_Account_fullData_230220-1442]
where AIMSAccount__c = '000605'

select AIMS_ACCT, COUNT(AIMS_ACCT)
from osc.account_seed
GROUP BY AIMS_ACCT
ORDER BY COUNT(AIMS_ACCT) DESC

--	Locate duplicate Account:Account record imports
select AIMSAccount__c, COUNT(AIMSAccount__c)
from sfdc.[Id_Account_fullData_230221-1656]
GROUP BY AIMSAccount__c
--HAVING COUNT(AIMSAccount__c) > 1
ORDER BY COUNT(AIMSAccount__c) DESC

select COUNT(*) 
from sfdc.Account_Account_T

select * --AIMSAccount__c  --, COUNT(AIMSAccount__c)
from sfdc.[Id_Account_fullData_230220-1442]
WHERE AIMSAccount__c = '564935'

select * 
from osc.Account_seed
where '403735' = AIMS_ACCT


select *
from sfdc.sfdc.[Id_User_fullData_230217-1503]
where AIMSAccount__c = '114027'


SELECT *
FROM osc.account_seed
where TRIM(AIMS_ACCT) = '564935'
-- AIMS_ACCT_564935


-- Alias__c lengths? 
select Alias__c, LEN(Alias__c)
from sfdc.Account_Account_E
GROUP BY Alias__c
HAVING LEN(Alias__c) > 1
ORDER BY LEN(Alias__c) DESC

-- 230223 updated RawPhoneNumber column formats = 11 numeric, no punctuation
SELECT max(len(RawPhoneNumber))
FROM osc.account_seedF

select top 1000 OrganizationDEO_ABFFreightCorporate_c, OrganizationDEO_ABFFreightLocal_c --* 
from osc.account_seed



SELECT COUNT(*)
FROM sfdc.Account_Account_L_03
WHERE ParentId IS NULL

select top 1000 OrganizationDEO_EntityActivity_c
from osc.account_seed


OrganizationDEO_EntityActivity_c
OrganizationDEO_EntityType_c
Stable

select count(*)
FROM sfdc.[Id_AccountContactRelation_fullData_230404-1443]
where IsDirect__c = 'true' AND RelationshipDirection__c = 'CONTACT_TO_ACCOUNT'

select count(*)
from osc.account_seed

select  * --count(*)
from osc.contact_relationship_seed
where PrimaryFlag = 1 and Relationship = 'CONTACT_TO_ACCOUNT'

select top 100 *
from osc.account_location_seed

select top 100 *
from sfdc.Account_Account_L_02
where name = 'OXFORD INDS INC'

-- Account-Account_L_02.sql Account.Id lookup join condition failure analysis: 
select top 100 *
from sfdc.[Id_Account_fullData_230404-1657]
where AIMSAccount__c = '001557' --AND RecordTypeId = '012770000004LOwAAM'
order by RecordTypeId

select top 1000 *
from sfdc.[Id_Account_fullData_230404-1657]
--where AIMSAccount__c = '001557' --AND RecordTypeId = '012770000004LOwAAM'
order by AIMSAccount__c--, RecordTypeId

select A.Id, A.RecordTypeId, B.Id, B.RecordTypeId, B.AIMSAccount__c, B.AIMSAccountLocation__c, B.OwnerCorpEmplId__c
from sfdc.[Id_Account_fullData_230404-1657] AS A
FULL OUTER JOIN sfdc.[Id_Account_fullData_230406-1708] AS B
ON A.Id = B.Id --AND A.RecordTypeId = B.RecordTypeId
WHERE A.Id IS NULL OR B.Id IS NULL
-- END

-- Data Quality issues f/up
select *
from sfdc.[Id_Account_fullData_230404-1657]
where OwnerId is null


SELECT TOP 100 AIMSAccount__c, A
FROM sfdc.Account_Account_L_02

-- 230425 check on moving from OwnerCorpEmplId to OrganizationDEO_ABFFreightCorporate_c AS "OwnerId" FAILED !!!
-- no change as a result of this test
select top 500 OwnerCorpEmplId, OrganizationDEO_ABFFreightCorporate_c
from osc.account_seed AS A
--END

--	230425 TEST OF L_01 join code
-- select count(*)
 SELECT A.OwnerCorpEmplId__c, B.CorpEmplId__c, A.CreatedById, C.Alias, A.LastModifiedById, D.Alias
FROM sfdc.Account_Account_T AS A
LEFT JOIN sfdc.[Id_User_fullData_230424-1346] AS B -- for OwnerId
ON A.OwnerCorpEmplId__c = B.CorpEmplId__c AND B.CorpEmplId__c IS NOT NULL AND B.title <> 'MOCK-01'

LEFT JOIN sfdc.[Id_User_fullData_230424-1346] AS C -- for CreatedById
ON A.CreatedById = C.Alias AND C.Alias IS NOT NULL AND C.title <> 'MOCK-01'
LEFT JOIN sfdc.[Id_User_fullData_230424-1346] AS D -- for LastModifiedById
ON A.LastModifiedById = D.Alias AND D.Alias IS NOT NULL AND D.title <> 'MOCK-01'


select *
from sfdc.[Id_User_fullData_230424-1346]
where title <> 'MOCK-01'

-- test for ABTSupport Id retrieveal PASS
(SELECT Id 
    FROM sfdc.[Id_User_fullData_230424-1346]
    WHERE Alias = 'ABTSuppt')

-- 230425 validate L_03 row count = 15,255
select A.Id, A.AIMSAccount__c, A.PAR_AIMS_ACCT__c, B.Id, B.AIMSAccount__c
from sfdc.[Id_Account_fullData_230425-1555] AS A
LEFT JOIN sfdc.[Id_Account_fullData_230425-1555] AS B
ON A.PAR_AIMS_ACCT__c = B.AIMSAccount__c
WHERE A.PAR_AIMS_ACCT__c IS NOT NULL AND B.AIMSAccount__c IS NOT NULL
--	PASS

--	230426 row inclusion test for Account-Account_L_05 rowcount 278165
SELECT --top 1000
	A.AIMSAccount__c,B.AIMSAccount__c,PrimaryLocation__c
FROM sfdc.[Id_Account_fullData_230425-1555] AS A
LEFT OUTER JOIN sfdc.Account_Location_L_01 AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND PrimaryLocation__c = 'true'

--	identify gap between 278259 and 278165
SELECT --top 1000
	A.AIMSAccount__c,B.AIMSAccount__c
FROM sfdc.[Id_Account_fullData_230425-1555] AS A
LEFT OUTER JOIN sfdc.Account_Location_L_01 AS B
ON A.AIMSAccount__c = B.AIMSAccount__c 
WHERE B.AIMSAccount__c IS NULL


-- 230427 preparation for arcbtech remediation
-- OrganizationTier__c update

-- check source # 278162 rows with 1907 null
select count(*) --top 500 OrganizationDEO_OrgTier_c
from osc.account_seed
where OrganizationDEO_OrgTier_c is null

-- CSV load query:
select 
	A.Id, B.OrganizationTier__c --, A.AIMSAccount__c, B.[Name]
--	INTO sfdc.Account_Account_arcBtech_OrganizationTier__c
--	DROP TABLE sfdc.Account_Account_arcBtech_OrganizationTier__c
from sfdc.[Id_Account_arcBtech_230427-1249] AS A
LEFT OUTER JOIN sfdc.Account_Account_L_01 AS B
ON A.AIMSAccount__c = B.AIMSAccount__c --AND A.RecordTypeId = B.RecordTypeId
WHERE A.RecordTypeId = '012770000004LOvAAM' AND B.AIMSAccount__c IS NOT NULL
--	END of OrganizationTier__c remediation

--	arcBtech.Account.ShippingAddress Update
-- CSV load query:
select top 1000
	A.Id
    ,ShippingStreet
    ,ShippingCity
    ,ShippingStateCode
    ,ShippingCountryCode
    ,ShippingPostalCode
    ,ShippingProvince__c
    ,ShippingLatitude
    ,ShippingLongitude
	
--	INTO sfdc.Account_Account_arcBtech_ShippingAddress
--	DROP TABLE sfdc.Account_Account_arcBtech_ShippingAddress
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

-- construct JOINs
select -- 276708
--count(*)
top 10000 A.Id, A.AIMSAccount__c, A.RecordTypeId, B.Id, B.AIMSAccount__c, B.RecordTypeId, C.Id, B.AIMSAccount__c, C.RecordTypeID, C.PrimaryLocation__c, D.Id, D.ShippingStreet
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


-- A 278381 account
SELECT COUNT(*)
FROM sfdc.[Id_Account_arcBtech_230427-1249]
where recordtypeId = '012770000004LOvAAM' AND AIMSAccount__c IS NOT NULL

-- B 278162 account
SELECT COUNT(*)
FROM sfdc.[Id_Account_fullData_230427-1056]
where recordtypeId = '012770000004LOvAAM'

-- C 276722 location
SELECT COUNT(*)
FROM sfdc.[Id_Account_fullData_230427-1056]
where RecordTypeId = '012770000004LOwAAM' AND PrimaryLocation__c = 'true'

-- D 278165 account
SELECT COUNT(*)
FROM sfdc.[Account_Account_L_05]
--	END arcBtech.Account.ShippingAddress Update

--	230509 MOCK-02 review RT Account

--	Account:Account OwnerId issue
select TOP 1000 *
from osc.account_seed
where AIMS_ACCT = '604849'

--	SOQL
select Id, Name, OwnerId, AIMSAccount__c, RecordTypeId
from Account
where OwnerId = '00577000000yzZTAAY' and RecordTypeID = '012770000004LOvAAM'

select Id, CorpEmplId__c
from User
where corpemplid__c = '00504805'

--	SQL to identify Accounts with Owners not found in User from 4/13 snapshot DS informed, OK to replace w/'ABTSupport' User
select A.AIMS_ACCT, A.OwnerCorpEmplId, B.CorpEmplID__c
FROM osc.account_seed AS A
LEFT OUTER JOIN osc.resource_seed AS B
ON A.OwnerCorpEmplId = B.CorpEmplID__c
WHERE B.CorpEmplID__c IS NULL AND (NOT A.OwnerCorpEmplId LIKE 'Corp%')

--	contact_relationship_seed review
select top 50 *
from osc.contact_relationship_seed

--	missing data columns... 
select top 50 *
from sfdc.[Id_AccountContactRelation_fullData_230331-1147]

--	END 230509 MOCK-02 review RT Account

--	230510 MOCK-02 review RT Account, Location, Opportunity, and related
--		Account-Level review WALGREEN CO record data
DECLARE
    @Account AS VARCHAR(18) = NULL
SET
	@Account = '002174'
select * from osc.account_seed where AIMS_ACCT = @Account
select * from sfdc.Account_Account_E where AIMSAccount__c = @Account
select * from sfdc.Account_Account_L_02 where AIMSAccount__c = @Account

--		AccountTeam WALGREEN CO #002174 user search by District-Territory
use Salesforce
DECLARE
    @DistTerr AS VARCHAR(18) = NULL
SET
	@DistTerr = 'DX1-01' -- AX2-02 N; DX1-01 Y; EX1-36 Y; MA2-03 N; CD2-02 values for WALGREEN CO
select top 50 * from osc.resource_seed
where concat(District__c,'-',Territory__c) = @DistTerr

--		Account Locations WALGREEN CO #002174 
DECLARE
    @Account AS VARCHAR(18) = NULL
SET
	@Account = '002174'
SELECT A.AIMS_ACCT, B.AIMS_ACCT, B.AIMS_ACCT AS "AIMSAccount__c"
	, AIMS_LOC AS "AIMSAccountLocation__c", PRIMARY_FLAG AS "PrimaryLocation__c"
	, Address1, CITY, StateCode, CountryCode
FROM osc.account_seed AS A
INNER JOIN osc.account_location_seed AS B
ON A.AIMS_ACCT = B.AIMS_ACCT
WHERE A.AIMS_ACCT = @Account  
--	AND PRIMARY_FLAG = 1
ORDER BY PRIMARY_FLAG DESC, B.AIMS_LOC

--		Account Contact Relations WALGREEN CO #002174 
DECLARE
    @Account AS VARCHAR(18) = NULL
SET
	@Account = '00972W'
SELECT A.AIMS_ACCT, B.AIMS_ACCT, B.Relationship, B.PrimaryFlag, B.ContactIntegrationId
FROM osc.account_seed AS A
INNER JOIN osc.contact_relationship_seed AS B
ON A.AIMS_ACCT = B.AIMS_ACCT
WHERE A.AIMS_ACCT = @Account  
	AND Relationship = 'CONTACT_TO_ACCOUNT'
ORDER BY A.AIMS_ACCT, PrimaryFlag DESC, B.ContactIntegrationId

--		Opportunity WALGREEN CO #002174 
DECLARE
    @Account AS VARCHAR(18) = NULL
SET
	@Account = '00972W'
SELECT A.AIMS_ACCT, B.AIMS_ACCT, B.Name, B.OptyId, B.RevnId, B.SalesStage, B.StatusCode
FROM osc.account_seed AS A
INNER JOIN osc.opportunity_seed AS B
ON A.AIMS_ACCT = B.AIMS_ACCT
WHERE A.AIMS_ACCT = @Account  
--	AND Relationship = 'CONTACT_TO_ACCOUNT'
ORDER BY A.AIMS_ACCT, B.OptyId, B.RevnId

--		view in detail
select * from osc.opportunity_seed where OptyId = '300001006193877' AND RevnId = '300001166147633'

--		Activity WALGREEN CO #002174 
DECLARE
    @Account AS VARCHAR(18) = NULL
SET
	@Account = '002174'
SELECT A.AIMS_ACCT, B.AIMS_ACCT, B.ActivityId, B.[Subject], B.lastupdatedate, B.ActivityDescription
	, B.ActivityFunctionCode, B.ActivityStartDate, B.ActivityStatus, B.ActivityTypeCode
FROM osc.account_seed AS A
INNER JOIN osc.activity_seed AS B
ON A.AIMS_ACCT = B.AIMS_ACCT
WHERE A.AIMS_ACCT = @Account  
	AND OpportunityId = '300001389126478'
	AND ActivityTypeCode <> 'Internal Communication'
ORDER BY B.ActivityStartDate, B.ActivityId

--		view in detail
select * from osc.activity_seed where AIMS_ACCT = '002174' AND OpportunityId = '300001166147625' --AND RevnId = '300001166147633'

--	HealthCheck__c 
DECLARE
    @Account AS VARCHAR(18) = NULL
SET
	@Account = '002174'
select * FROM osc.ACTIVITY_SEED Where AIMS_ACCT = @Account AND ActivityFunctionCode = 'TASK' AND StatusCode <> 'CANCELED' AND InternalType_c = 'CUSTOMER_CHURN'
select * FROM sfdc.HealthCheck_L_01 Where AIMSAccount__c = @Account


--		OpportunityTeamMember WALGREEN CO #002174 
--		view in detail
select * from osc.opportunity_team_seed where OptyId = '300001166147625' --AND RevnId = '300001166147633'

--		OpportunityContactRole WALGREEN CO #002174 
--		view in detail
select * from osc.opportunity_contact_seed where OptyId = '300001166147625' --AND RevnId = '300001166147633'

--	AccountPlan__c WALGREEN CO #002174
DECLARE
    @Account AS VARCHAR(18) = NULL
SET
	@Account = '002174'
select * from osc.business_plan_seed where AIMS_ACCT = @Account
select * from sfdc.AccountPlan__c_E where AIMSAccount__c = @Account
select * from sfdc.AccountPlan__c_L_01 where AIMSAccount__c = @Account


/* EXCEPTIONS:
WALGREEN CO #002174
#	Account Team
- 3 display on Account Team, only 2 D-T values in AccountOwners__c match User D-T values -- JOIN / WHERE issue?
- Corp01 is on Account Team, not a match to any D-T value -- JOIN / WHERE issue?
#	Account Locations
- none noted
#	Account Contact Relationships
- 52 rows expected from source, 51 observed
#	Opportunities
- StageStartDate__c is being erroneously set by a flow; consider Inserting LastModifiedDate 
-	closeDate - checking with PK as to whether this is UI or programmatic
#	Activities
-	Observed consistent with source for 3 Opportunities
#	Health Checks
-	none noted
#	OppTeamMember
-	none noted
#	OppContactRole
-	none noted
#	AccountPlan__c
-	none noted; nulls in source for 2/4 MS PL fields, but others working as expected.

1 SOURCE VEND #00972W

*/ 

--	230522 verify Account_Account_L_03
select *
from sfdc.Account_Account_L_03
--	END

--	230522 Account-Account_L_05.sql
select count(*)
FROM sfdc.[Id_Account_fullData_230518-1535] AS A
LEFT OUTER JOIN sfdc.Account_Location_L_01 AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.PrimaryLocation__c = 'true'
WHERE A.RecordTypeId = '012770000004LOvAAM' and 


