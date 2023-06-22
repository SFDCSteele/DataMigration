--	User_E.sql User target object view extraction query to table User_E
--  LAST RUN:  230524 prod delta
USE Salesforce;

DECLARE 
    @RecordCount AS INT = NULL

/*
Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_01'
	,'User E (Extract)'
	,'User Base Load'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
	DROP TABLE sfdc.User_E
SELECT 
	TimezoneCode AS "TimeZoneSidKey" -- No translation needed, same format as SF; replace nulls in User_T
	,Username AS "PACE_RESOURCE_Username__c" -- DS230120 - also use this for Alias value
	,ResourceOrgRoleName AS "ResourceOrgRoleName__c"
    ,ResourceOrganizationName AS "ResourceOrganizationName__c"
	,FirstName AS "FirstName"
	,LastName AS "LastName"
	,Username AS "Alias"
	,TRIM(ResourceEmail) AS "Email"
	,TRIM(ResourceEmail) AS "SenderEmail"
	,TRIM(ResourceEmail) AS "Username"
    ,LEFT(ResourceStartDate, 10) AS "StartDate__c" -- reformat for SF 2015-12-27 00:00:00.0000000 to 02/08/2021T18:13:54.000Z
    ,LEFT(ResourceEndDate, 10) AS "EndDate__c" -- reformat for SF 2015-12-27 00:00:00.0000000 to 02/08/2021T18:13:54.000Z
	,ResourcePartyId AS "PACE_RESOURCE_ResourcePartyId__c"
    ,'' AS IsActive -- to be updated in User_T
    ,CorpEmplID__c AS "CorpEmplID__c"
    ,MgrCorpEmplID__c AS "ManagerId" -- lookup User.Id in User_L_04.sql
    ,MgrCorpEmplID__c AS "MgrCorpEmplID__c"
    ,TRIM(JobTitle) AS "Title"
    ,TRIM(Area__c) AS "Area__c" -- picklist
    ,Region__c AS "Region__c"
    ,District__c AS "District__c"
    ,Territory__c AS "Territory__c"
    ,Role__c AS UserRoleId -- lookup in User_L_01
    ,Role__c AS "Role__c"
    ,SRMRole__c AS SRMRole__c -- added per DS 230414
    ,TRIM(ResourceEmail) AS "FederationIdentifier"
    ,FirstName + ' ' + LastName AS CommunityNickname -- DS230120 - use First and Last names

	INTO sfdc.User_E
FROM osc.RESOURCE_SEED -- BASE LOAD UPSERT
--FROM oscd.RESOURCE_SEED -- DELTA LOAD UPSERT
--where Username like '%desan%'
--where Username = 'mdesanto@arcb.com'
where CorpEmplID__c = '00767509'



/*
--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_01';
*/