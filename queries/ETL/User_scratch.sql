use Salesforce

-- 230328 identify role values differences between RESOURCE_SEED and Salesforce.fullData
select distinct A.role__c AS "osc.RESOURCE_SEED.Role__c", b.name AS "UserRole.Name", b.developername AS "UserRole.DeveloperName", b.Id AS "UserRole.Id"
from osc.resource_seed as A
full outer join sfdc.[Id_UserRole_fullData_230328-1502] as B
on a.Role__c = b.developername
order by A.role__c



-- 230328 5 users with duplicate email values not loading to fullData as of 230338-1700 — for further research
select ResourceEmail, count(ResourceEmail) AS Count
from osc.resource_seed
group by ResourceEmail
having count(ResourceEmail) > 1

select a.LastName, a.FirstName, a.IsActive, a.CorpEmplID__c, b.CorpEmplID_c, b.Username, c.Lastname, c.Firstname
from sfdc.User_L_02 as A
left outer join	sfdc.[Id_User_fullData_230328-1657] as B
ON a.CorpEmplID__c = b.CorpEmplID_c
left outer join	sfdc.[Id_User_fullData_230328-1657] as C
ON a.Lastname + a.FirstName = c.Lastname + c.Firstname
where b.CorpEmplID_c is null

--	Confirming ABT Support Id
select *
from sfdc.[Id_User_fullData_230328-1657]
where Id = '00577000000yzZDAAY'

-- loopback test for complete Insert of 1832 RESOURCE_SEED rows to fulldata at 230421
select *
from sfdc.[Id_User_fullData_230421-1226]
where Username LIKE '%fulldata02'

select A.Username, A.Alias, B.Username
from sfdc.[Id_User_fullData_230421-1226] as A
left join osc.resource_seed as B
ON A.Alias = B.Username
where A.Username LIKE '%fulldata02'
--	END TEST -- PASS 

--	Uniqueness test on CorpEmplId__c
select CorpEmplID__c, COUNT(CorpEmplID__c)
from sfdc.[Id_User_fullData_230421-1226]
group by CorpEmplID__c
order by COUNT(CorpEmplID__c) desc
-- END TEST -- PASS 

--	Uniqueness test on Alias
select Alias, COUNT(Alias)
from sfdc.[Id_User_fullData_230421-1226]
group by Alias
order by COUNT(Alias) desc
-- END TEST -- PASS 

-- determine max len of Alias
select max(len(Alias))
from sfdc.[Id_User_fullData_230421-1226]
Where CorpEmplID__c IS NOT NULL
-- END

-- testing for ManagerId lookup from MgrCorpEmplID__c
select Id, CorpEmplId__c, ManagerId, MgrCorpEmplID__c
from sfdc.[Id_User_arcBtech_230424-1346]
where ManagerId is not null --MgrCorpEmplID__c = '00356797'


select max(len(Area__c))
from sfdc.User_L_02

--	230504 User.ManagerId testing
select top 10 *
from sfdc.User_T

SELECT -- COUNT(*)
    B.Id -- User.Id to update
    ,C.Id AS ManagerId -- User.ManagerId
  ,A.CorpEmplID__c -- test only
  ,A.MgrCorpEmplID__c -- test only
FROM sfdc.User_T AS A
--  INSERT CORRECT JOIN TABLE NAMES FOR ENVIRONMENT AND DATE
LEFT JOIN sfdc.[Id_User_fullData_230501-1801] AS B -- lookup matching User Id
ON A.CorpEmplID__c = B.CorpEmplID__c AND B.CorpEmplID__c IS NOT NULL AND B.MgrCorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230501-1801] AS C -- lookup Manager's User.Id value
ON A.MgrCorpEmplID__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL

WHERE 
	SUBSTRING(A.Username,1,12) <> 'ArcBest-Corp'  AND A.IsActive = 'true'
	AND A.MgrCorpEmplID__c IS NOT NULL

--	END 230504 User.ManagerId testing


--	230524 RESOURCE_SEED delta refresh data quality evaluation

--		confirm row count
select count(*) from oscd.resource_seed -- = 1868

--		confirm 100% CorpEmplID__c = PASS
select * from oscd.resource_seed where CorpEmplID__c IS NULL

--		confirm no dupl. email -- PASS
select ResourceEmail, COUNT(ResourceEmail)
from oscd.resource_seed
group by ResourceEmail
order by COUNT(ResourceEmail) DESC

--		confirm no dupl. CorpEmplID__c -- PASS
select CorpEmplID__c, COUNT(CorpEmplID__c) 
from oscd.resource_seed
group by CorpEmplID__c
order by COUNT(CorpEmplID__c) DESC

--		confirm Area__c values align to PL = PASS
select distinct Area__c
from oscd.resource_seed
order by Area__c

--	examine JOIN to existing User.Ids
select A.CorpEmplID__c, B.CorpEmplID__c, B.Id
FROM sfdc.User_T AS A
--  INSERT CORRECT JOIN TABLE NAMES FOR ENVIRONMENT AND DATE
LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS B -- lookup matching User Id
ON A.CorpEmplID__c = B.CorpEmplID__c AND TRIM(B.CorpEmplId__c) IS NOT NULL
WHERE B.Id IS NULL
-- 230524 6 new users