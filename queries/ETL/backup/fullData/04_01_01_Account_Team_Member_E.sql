--	Account_Team_Member_E.sql Account RT Account target object view extraction query to table Account_Team_Member_E
USE Salesforce;


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
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

-- Account RT Account Primary owner
DROP TABLE sfdc.Account_Team_Member_Primary_E
SELECT --TOP 1000 --0.1 PERCENT
    OwnerCorpEmplId AS "UserId"
    ,OrganizationDEO_ABFFreightCorporate_c AS "territory"
    ,OrganizationDEO_ABFFreightLocal_c AS "SecondaryTerritoryNumber__c"
	--,value territory
    ,AIMS_ACCT AS "AIMSAccount__c"


 INTO sfdc.Account_Team_Member_Primary_E
--FROM osc.ACCOUNT_SEED 
FROM oscd.ACCOUNT_SEED 
	--CROSS APPLY STRING_SPLIT(OrganizationDEO_ABFFreightLocal_c,';');

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Primary_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_01_1';

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_01_2'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Secondary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

-- Account RT Account Secondary owner
 DROP TABLE sfdc.Account_Team_Member_Secondary_E
SELECT --TOP 1000 --0.1 PERCENT
    OwnerCorpEmplId AS "UserId"
    ,OrganizationDEO_ABFFreightCorporate_c AS "PrimaryTerritoryNumber__c"
    ,OrganizationDEO_ABFFreightLocal_c AS "SecondaryTerritoryNumber__c"
	,value territory
    ,AIMS_ACCT AS "AIMSAccount__c"


 INTO sfdc.Account_Team_Member_Secondary_E
--FROM osc.ACCOUNT_SEED 
FROM oscd.ACCOUNT_SEED 
	CROSS APPLY STRING_SPLIT(OrganizationDEO_ABFFreightLocal_c,';')
WHERE OrganizationDEO_ABFFreightLocal_c != ''
--AND OrganizationDEO_ABFFreightLocal_c like '%DX1-07%'

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Secondary_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_01_2';


-- Account RT Location Primary owner
 DROP TABLE sfdc.Account_Team_Member_Location_Primary_E

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_01_3'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Location Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

SELECT --TOP 1000 --0.1 PERCENT
	B.OwnerCorpEmplId AS "UserId"
	,B.OrganizationDEO_ABFFreightCorporate_c AS "territory"
	,B.OrganizationDEO_ABFFreightLocal_c AS "SecondaryTerritoryNumber__c"
	--,value territory
	, A.AIMS_ACCT AS "AIMSAccount__c1"
	,B.AIMS_ACCT AS "AIMSAccount__c2"
	,a.AIMS_LOC
	--,B.


 INTO sfdc.Account_Team_Member_Location_Primary_E
--FROM osc.account_location_seed AS A
FROM oscd.account_location_seed AS A

--Left JOIN osc.account_seed AS B 
Left JOIN oscd.account_seed AS B 
on A.AIMS_ACCT = B.AIMS_ACCT

--LEFT JOIN sfdc.ACCOUNT_ACCOUNT_T AS B
--ON A.AIMS_ACCT = B.AIMSAccount__c
--CROSS APPLY STRING_SPLIT(B.OrganizationDEO_ABFFreightLocal_c,';')

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Location_Primary_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_01_3';


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_01_4'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Location Secondary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

-- Account RT Location Secondary owner
 DROP TABLE sfdc.Account_Team_Member_Location_Secondary_E

SELECT --TOP 1000 --0.1 PERCENT
	B.OwnerCorpEmplId AS "UserId"
	,B.OrganizationDEO_ABFFreightCorporate_c AS "PrimaryTerritoryNumber__c"
	,B.OrganizationDEO_ABFFreightLocal_c AS "SecondaryTerritoryNumber__c"
	,value territory
	, A.AIMS_ACCT AS "AIMSAccount__c1"
	,B.AIMS_ACCT AS "AIMSAccount__c2"
	,a.AIMS_LOC
	--,B.


 INTO sfdc.Account_Team_Member_Location_Secondary_E
--FROM osc.account_location_seed AS A
FROM oscd.account_location_seed AS A

--Left JOIN osc.account_seed AS B 
Left JOIN oscd.account_seed AS B 
on A.AIMS_ACCT = B.AIMS_ACCT

--LEFT JOIN sfdc.ACCOUNT_ACCOUNT_T AS B
--ON A.AIMS_ACCT = B.AIMSAccount__c
CROSS APPLY STRING_SPLIT(B.OrganizationDEO_ABFFreightLocal_c,';')
WHERE B.OrganizationDEO_ABFFreightLocal_c != ''


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Team_Member_Location_Secondary_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '04_01_01_4';
