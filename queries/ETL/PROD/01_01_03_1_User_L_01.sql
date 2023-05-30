--	User_L_01_prod.sql table User_T tranformation query to table User_L
--  1. Set local variables
--  2. Set latest value for sfdc.Id_UserRole_env_datetime
--  3. BE SURE TO FILTER OUT ArcBest System Accounts -- see last line here and System_Users_Load.xlsx

DECLARE
    @Environment AS VARCHAR(20) = NULL,
    @UserProfileId AS VARCHAR(20) = NULL,
    @RecordCount AS INT = NULL

USE Salesforce;
-- SET THESE VALUES FOR THE LOAD ENVIRONMENT
SET @Environment = 'PROD' -- load org name, e.g., 'prod'
SET @UserProfileId =  
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_Profile_prod]
    WHERE [NAME] = 'ArcBest Standard')


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_1'
	,'User L (Load)'
	,'User Initial Load'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

	DROP TABLE sfdc.User_L_01
SELECT
    CASE
        WHEN @Environment = 'PROD' THEN A.Username
        ELSE A.Username +  '.' + @Environment 
        END
        AS Username -- ADD ORG NAME AS SUFFIX !!!!
    ,FirstName
    ,LastName
    ,Title
    ,Alias
    ,CASE
        WHEN @Environment = 'PROD' THEN A.Email
        ELSE A.Email +  '.' + @Environment 
        END
        AS Email -- ADD ORG NAME AS SUFFIX !!!!
	--,Email + '.' + @Environment AS Email
    ,CASE
        WHEN @Environment = 'PROD' THEN A.SenderEmail
        ELSE A.SenderEmail +  '.' + @Environment 
        END
        AS SenderEmail -- ADD ORG NAME AS SUFFIX !!!!
    --,SenderEmail + '.' + @Environment AS SenderEmail
    ,StartDate__c
	,EndDate__c
    ,'false' AS IsActive -- comment out to load actual; managing license limit
    ,CorpEmplID__c
--    ,MgrCorpEmplID__c AS "ManagerId" -- type Hierarchy lookup via MgrCorpEmplID__c in L_04
    ,MgrCorpEmplID__c
    ,Area__c -- picklist
    ,Region__c
    ,District__c
    ,Territory__c
    ,C.Id AS UserRoleId -- lookup value in User_L_01
    ,Role__c
    ,SRMRole__c -- added per DS 230414
    ,ResourceOrgRoleName__c
    ,ResourceOrganizationName__c
    ,TimeZoneSidKey
    ,CASE
        WHEN @Environment = 'PROD' THEN A.FederationIdentifier
        ELSE A.FederationIdentifier +  '.' + @Environment 
        END
        AS FederationIdentifier -- ADD ORG NAME AS SUFFIX !!!!
    --,FederationIdentifier + '.' + @Environment AS FederationIdentifier
    ,PACE_RESOURCE_ResourcePartyId__c
    ,PACE_RESOURCE_Username__c
    ,CASE
        WHEN @Environment = 'PROD' THEN A.CommunityNickname
        ELSE A.CommunityNickname +  '.' + @Environment 
        END
        AS CommunityNickname -- ADD ORG NAME AS SUFFIX !!!!
    --,CommunityNickname + '.' + @Environment AS CommunityNickname -- cannot have duplicates
--  required fields not coming from osc.RESOURCE_SEED
    ,'UTF-8' AS "EmailEncodingKey"
    ,'en_US' AS "LanguageLocaleKey"
    ,'en_US' AS "LocaleSidKey"
    ,@UserProfileId AS "ProfileId"
--    ,Id -- User_L_02

	INTO sfdc.User_L_01
FROM sfdc.User_T AS A
LEFT JOIN sfdc.[Id_UserRole_prod] AS C -- updated 230420-1622 UserProfileId lookup
ON A.Role__c = C.DeveloperName

--  Filter out ARCB System Users, which are configured by Func & DevOps teams
WHERE SUBSTRING(Username,1,12) <> 'ArcBest-Corp' -- OR SUBSTRING(Username,1,13) = 'salessupport@'


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_1';

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
	'01_01_03_1'
	,'User L (Load)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_1';


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_1'
	,'User (Export)'
	,'Export'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_1';

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_1'
	,'User (Insert)'
	,'Data Loader Insert'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);



--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_1';


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'01_01_03_1'
	,'User (Import)'
	,'MS SQL Import Keys'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.User_L_01)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '01_01_03_1';

*/