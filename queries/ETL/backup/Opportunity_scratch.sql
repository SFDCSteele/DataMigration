use salesforce

select top .1 percent *
from osc.opportunity_seed

select closeDate, lastUpdateDate, SalesStage, StatusCode
from osc.opportunity_seed
where closedate is null

select LeadSource_c, Source_c, SalesStage, StatusCode
from osc.opportunity_seed
--where LeadSource_c is not null or Source_c is not null
--where Source_c is not null
where LeadSource_c is not null AND Source_c is not null

select count(*)
from osc.opportunity_seed
where LeadSource_c is null AND Source_c is null

select TOP 1 PERCENT *
from osc.opportunity_team_seed

select count(*)
from sfdc.OpportunityTeamMember_L_01

select TOP 1 PERCENT CorpEmplID__c
from osc.opportunity_team_seed

select TOP 1 PERCENT *
from osc.opportunity_contact_seed

select closeDate, lastUpdateDate, SalesStage, StatusCode
from osc.opportunity_seed
where StatusCode = 'WON'


select distinct SalesStage, StatusCode
from osc.opportunity_seed
order by SalesStage, StatusCode

select top 1 percent *
from sfdc.opportunity_L_01


select COUNT(A.AIMSAccount__c)
FROM (

SELECT COUNT(*) --DISTINCT AIMSAccount__c
from sfdc.[Id_Account_fullData_230310-1503]
WHERE RecordTypeId = '0128F000000koHjQAI'




SELECT TOP 10000
	A.PACE_OpportunityID__c
	, A.AIMSAccount__c, B.AIMSAccount__c
	, A.OwnerCorpEmplId__c, C.CorpEmplID__c
	, A.CreatedById, D.Alias
	--, A.LastModifiedById, E.Alias
FROM sfdc.Opportunity_T AS A

LEFT JOIN sfdc.[Id_Account_fullData_230310-1503] AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = '0128F000000koHjQAI'

LEFT JOIN sfdc.[Id_User_fullData_230307-1407] AS C -- for OwnerId
ON A.OwnerCorpEmplId__c = C.CorpEmplID__c

LEFT JOIN sfdc.[Id_User_fullData_230307-1407] AS D -- for CreatedById
ON A.CreatedById = D.Alias AND D.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230307-1407] AS E -- for LastModifiedById
ON A.LastModifiedById = E.Alias AND E.CorpEmplID__c IS NOT NULL
--ORDER BY A.PACE_OpportunityID__c


SELECT CreatedBy, LastUpdatedBy
FROM osc.opportunity_seed;


SELECT A.PACE_OpportunityID__c
	, A.LastModifiedById--, E.Alias
FROM sfdc.Opportunity_T AS A

LEFT JOIN sfdc.[Id_User_fullData_230307-1407] AS E -- for LastModifiedById
ON A.LastModifiedById = E.Alias AND E.CorpEmplID__c IS NOT NULL

select FirstName, LastName, CorpEmplID__c, Alias
from sfdc.[Id_User_fullData_230307-1407]
where CorpEmplID__c is not null
order by LastName, FirstName

select *
from sfdc.Opportunity_L_01


select count(*)
from sfdc.Opportunity_L_01

select count(*)
from osc.opportunity_seed
where OpportunityTypeCode is null


SELECT max(len(NextSteps_c))
from osc.opportunity_seed

select RETAILPLUSRETAILERS__C
from sfdc.Opportunity_E
where PACE_OPPORTUNITYID__C = '300000783827091'

select RETAILPLUSRETAILERS__C
from sfdc.Opportunity_L_01
where PACE_OPPORTUNITYID__C = '300000783827091'

select InvoicingEmail__c
from sfdc.Opportunity_E
WHERE InvoicingEmail__c LIKE '%_@__%.__%' AND PATINDEX('%[^a-z,0-9,@,.,_]%', REPLACE(InvoicingEmail__c, '-', 'a')) = 0


select distinct *
from sfdc.Opportunity_L_01


select distinct Name, PACE_OpportunityID__c, StageName, WinLossDescription__c, Amount, Probability, Solution__c
from sfdc.Opportunity_L_01

select TOP 10 OptyId, Count(OptyId)
from osc.opportunity_seed
group by OptyId
order by Count(OptyId) DESC

select A.OptyId, A.Name, A.Solution_c, A.Revenue, A.WinProb, B.OptyId, B.CorpEmplID__c
from osc.opportunity_seed AS A
LEFT JOIN osc.opportunity_team_seed AS B
ON A.OptyId = B.OptyId
WHERE A.OptyId = '300000028342014'
ORDER BY A.OptyId, B.CorpEmplID__c



SELECT [Name], CreationDate, LastUpdateDate, closeDate, AccountShipmentDate_c
FROM OSC.opportunity_seed
WHERE OptyId = '300000444842401'

select distinct OptyId, ContactIntegrationId
from osc.opportunity_contact_seed

select TOP 1000 A.PACE_OpportunityID__c, A.Id, B.OptyId 
from sfdc.[Id_Opportunity_fullData_230321-0830] AS A
LEFT OUTER JOIN osc.opportunity_team_seed AS B
ON A.PACE_OpportunityID__c = B.OptyId
ORDER BY A.PACE_OpportunityID__c, A.Id

select COUNT(*)
from sfdc.[Id_Opportunity_fullData_230321-0830] AS A
LEFT OUTER JOIN osc.opportunity_team_seed AS B
ON A.PACE_OpportunityID__c = B.OptyId
WHERE B.OptyId IS NULL

select COUNT(*)
from sfdc.[Id_Opportunity_fullData_230321-0830] AS A
LEFT OUTER JOIN osc.opportunity_CONTACT_seed AS B
ON A.PACE_OpportunityID__c = B.OptyId
WHERE B.OptyId IS NULL


select COUNT(*)
from osc.opportunity_seed AS A
LEFT OUTER JOIN osc.opportunity_team_seed AS B
ON A.OptyId = B.OptyId
WHERE B.OptyId IS NULL

select COUNT(*)
from osc.opportunity_seed AS A
LEFT OUTER JOIN osc.opportunity_CONTACT_seed AS B
ON A.OptyId = B.OptyId
WHERE B.OptyId IS NULL


select A.PACE_OpportunityID__c, A.Id, B.OptyId, B.CorpEmplID__c, B.PrimaryFlag
from sfdc.[Id_Opportunity_fullData_230321-0830] AS A
LEFT OUTER JOIN osc.opportunity_team_seed AS B
ON A.PACE_OpportunityID__c = B.OptyId
WHERE A.PACE_OpportunityID__c = '300000921803645'
ORDER BY A.PACE_OpportunityID__c, A.Id, B.OptyId, B.CorpEmplID__c, B.PrimaryFlag

select TOP 10 OptyId, Count(OptyId)
from osc.opportunity_seed
group by OptyId
order by Count(OptyId) DESC


select A.PACE_OpportunityID__c, A.Id, B.OptyId, B.CorpEmplID__c, B.PrimaryFlag, C.CorpEmplID__c, C.Id
from sfdc.[Id_Opportunity_fullData_230321-0830] AS A
LEFT OUTER JOIN osc.opportunity_team_seed AS B
ON A.PACE_OpportunityID__c = B.OptyId
LEFT OUTER JOIN sfdc.[Id_User_fullData_230307-1407] AS C
ON B.CorpEmplID__c = C.CorpEmplID__c
WHERE A.PACE_OpportunityID__c = '300000921803645'
ORDER BY A.PACE_OpportunityID__c, A.Id, B.OptyId, B.CorpEmplID__c, B.PrimaryFlag


select count(OwnerCorpEmplId)
from osc.opportunity_seed
WHERE OwnerCorpEmplId IS NULL

select count(*) from sfdc.[Id_Opportunity_fullData_230321-0830]


select top 5 *
from sfdc.OpportunityTeamMember_T

select top 5 *
from sfdc.[Id_User_fullData_230307-1407]

select top 5 *
from sfdc.[Id_Opportunity_fullData_230321-0830]


select A.PACE_OptyId__c, B.CorpEmplId__c, C.PACE_OpportunityID__c
FROM sfdc.OpportunityTeamMember_T AS A
LEFT JOIN sfdc.[Id_User_fullData_230307-1407] AS B
ON A.CorpEmplId__c = B.CorpEmplId__c
LEFT JOIN sfdc.[Id_Opportunity_fullData_230321-0830] AS C
ON A.PACE_OptyId__c = C.PACE_OpportunityID__c
WHERE A.PACE_OptyId__c IS NOT NULL AND B.CorpEmplId__c IS NOT NULL AND C.PACE_OpportunityID__c IS NOT NULL
ORDER BY A.PACE_OptyId__c, B.CorpEmplId__c, C.PACE_OpportunityID__c


select distinct a.OptyId, b.OptyId
from osc.opportunity_team_seed as A
left join osc.opportunity_seed as B
on a.OptyId = b.OptyId
where b.OptyId is null

select *
from osc.opportunity_team_seed
where OptyId = '300000031550669'

select count(*)
from sfdc.OpportunityTeamMember_L_01


select max(len(Title))
from sfdc.[Id_User_fullData_230307-1407]

select count(*)
from sfdc.opportunity_L_01
where Type IS NULL --or BusinessType__c = ''



OpportunityTypeCode


select top 100 *
from sfdc.opportunity_L_01


SELECT DISTINCT ContactId, PACE_OpportunityID__c 
FROM sfdc.[Id_OpportunityContactRole_fullData_230403-1446]
WHERE IsPrimary = 'true' AND PACE_OpportunityID__c IS NOT NULL AND ContactId IS NOT NULL

SELECT distinct ContactId
FROM sfdc.[Id_OpportunityContactRole_fullData_230403-1446]
WHERE IsPrimary = 'true'


select COUNT(*)
from sfdc.[Id_Opportunity_fullData_230331-0930] AS A
LEFT OUTER JOIN osc.opportunity_CONTACT_seed AS B
ON A.PACE_OpportunityID__c = B.OptyId
WHERE B.OptyId IS NULL

select count(*)
from osc.opportunity_CONTACT_seed

--	IMPORTANT!!
select OptyId, ContactIntegrationId, PrimaryFlag
from osc.opportunity_CONTACT_seed
WHERE PrimaryFlag = 1

select DISTINCT PACE_OpportunityID__c, ContactId, IsPrimary
from sfdc.OpportunityContactRole_L_01
WHERE IsPrimary = 'true'

--select TOP 5 * --OptyId, ContactIntegrationId, PrimaryFlag
select OptyId, ContactIntegrationId, PrimaryFlag
from osc.opportunity_CONTACT_seed
WHERE PrimaryFlag = 1

SELECT TOP 500 *
FROM SFDC.[Id_OpportunityContactRole_fullData_230404-1032]
ORDER by PACE_OpportunityId__c


select count(*)
from osc.opportunity_seed


-- StageName Field History Event Update load
select Count(*)
from sfdc.[Id_Opportunity_fullData_230331-0930]
WHERE StatusCode__c = 'Lost' AND StageName = 'Closed Won'

select DISTINCT StageName, StatusCode__c
from sfdc.[Id_Opportunity_fullData_230331-0930]
WHERE StatusCode__c = 'Lost'
ORDER BY StageName

select top 1000 Id, StageName
from sfdc.[Id_Opportunity_fullData_230331-0930]
WHERE StatusCode__c = 'Lost'

select Id, StageName, [Name]
from sfdc.[Id_Opportunity_fullData_230331-0930]
WHERE Id = '00677000005QnFPAA0'
-- END StageName Field History Event Update load

--	230502 L_03 rowcount investigation of OPPORTUNITY_SEED
use Salesforce
/*
select count(*)
from sfdc.[Id_Opportunity_fullData_230428-1733]
*/

select distinct --top 500 
A.PACE_OpportunityID__c, F.PACE_OpportunityID__c, 
A.PACE_OpportunityRevenueId__c, F.PACE_OpportunityRevenueId__c
FROM sfdc.Opportunity_T AS A

LEFT JOIN sfdc.[Id_Account_fullData_230427-1056] AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = '012770000004LOvAAM'

LEFT JOIN sfdc.[Id_User_fullData_230501-1801] AS C -- for OwnerId, 
ON A.OwnerCorpEmplId__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230501-1801] AS D -- for CreatedById
ON A.CreatedById = D.Alias AND D.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230501-1801] AS E -- for LastModifiedById
ON A.LastModifiedById = E.Alias AND E.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_Opportunity_fullData_230428-1733] AS F -- for Opportunity.Id in Opportunity_L_03
ON CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) = CONCAT(F.PACE_OpportunityID__c, F.PACE_OpportunityRevenueId__c)
WHERE -- Filter to exclude duplicate Opportunity_Seed PK values in 230414 refresh dataset - DELETE FOR SUBSEQUENT !!!
    CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) <> '300001278345897300001278345901'
    AND CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) <> '300000759186132300000772749477'
    AND CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) <> '300000759186132300000759186161'
    AND CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c) <> '300001278345897300001339558208'

SELECT CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c), count(CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c))
FROM sfdc.[Id_Opportunity_fullData_230428-1733] as a
group by CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c)
order by count(CONCAT(A.PACE_OpportunityID__c, A.PACE_OpportunityRevenueId__c)) desc

-- check for duplicate primary keys on OPPORTUNITY_SEED
SELECT CONCAT(A.OptyId, '-', A.RevnId) AS [PK Value], count(CONCAT(A.OptyId, '-', A.RevnId)) AS [PK Value Count]
FROM osc.opportunity_seed as a
group by CONCAT(A.OptyId, '-', A.RevnId)
order by count(CONCAT(A.OptyId, '-', A.RevnId)) desc

select *
from osc.opportunity_seed as a
where CONCAT(A.OptyId, '-', A.RevnId) = '300001278345897-300001278345901'


/*
300001278345897-300001278345901
300000759186132-300000772749477
300000759186132-300000759186161
300001278345897-300001339558208
*/
--	END L_03 rowcount investigation of OPPORTUNITY_SEED


--	230517 data quality checks

--		rowcount = 159109
select count(*)
select top 10 *
from osc.opportunity_seed

--	Check PK uniqueness = Unique
select distinct OptyId, RevnId
from osc.opportunity_seed

--	230518 Insert fallout check
--	check for missing record...
select *
from osc.opportunity_seed
WHERE OptyId = '300000444842401'
--	CreationDate '2017-03-12 02:33:11.0000000'

--	StageName change DQ review
select top 100 SalesStage, StatusCode
from osc.opportunity_seed
where SalesStage LIKE  '%Closed Won' and StatusCode = 'LOST'

--	230523 data quality / row count evaluations PASS
--		rowcount
select count(*) -- 135637
from osc.OPPORTUNITY_CONTACT_SEED

--		distinct row count
select distinct OptyId,	ContactIntegrationId,	PrimaryFlag  -- 135637 PASS
from osc.OPPORTUNITY_CONTACT_SEED

--		nulls row count
select count(*) -- 0 PASS
from osc.OPPORTUNITY_CONTACT_SEED
where OptyId is null OR ContactIntegrationId is null or PrimaryFlag is null

--	END 230523 data quality / row count evaluations

--	230523 JOIN rowcount troubleshooting
select top 100 *
from osc.OPPORTUNITY_CONTACT_SEED

--	230523 Opportunity.StageName history event row selection criteria / counts checks PASS
SELECT count(*)
FROM sfdc.[Id_Opportunity_fullData_230518-1111]
WHERE StatusCode__c = 'Lost' AND Id IS NOT NULL
    AND (StageName = 'Needs Analysis'
        OR StageName = 'Negotiation' 
        OR StageName = 'Discovery' 
        OR StageName = 'Onboarding'
        OR StageName = 'Qualify'
        OR StageName = 'Initial Evaluation'
        OR StageName = 'Closed Won') 

--	gross = 159108
--	StatusCode__c = 'Lost' = 102685
--	entire WHERE clause = 102685

--	END 230523 Opportunity.StageName history event row selection criteria / counts checks PASS

--	230523 oscd schema vs osc row counts

select count(*)
--from osc.account_seed -- 278093
--from oscd.account_seed  -- 278066
--from osc.account_location_seed -- 741308
--from oscd.account_location_seed  -- 741687
--from osc.contact_seed -- 484957
--from oscd.contact_seed  -- 485487
--from osc.opportunity_seed -- 159109
--from oscd.opportunity_seed  -- 12443
--from osc.activity_seed -- 1905572
--from oscd.activity_seed  -- 33373
--from osc.resource_seed -- 1868
--from oscd.resource_seed  -- 1868
