--	User_L_01_fulldata.sql table User_T tranformation query to table User_L
--  1. Set local variables
--  2. Set latest value for sfdc.Id_UserRole_env_datetime
--  3. BE SURE TO FILTER OUT ArcBest System Accounts -- see last line here and System_Users_Load.xlsx

DECLARE
    @Environment AS VARCHAR(20) = NULL,
    @UserProfileId AS VARCHAR(20) = NULL

-- SET THESE VALUES FOR THE LOAD ENVIRONMENT
SET @Environment = 'fulldata02' -- load org name, e.g., 'fullData'
SET @UserProfileId = '00e77000000Lt2RAAS' -- ArcBest Standard User Profile Id for environment

USE Salesforce;
SELECT
    Username + '.' + @Environment AS Username -- ADD ORG NAME AS SUFFIX
    ,FirstName
    ,LastName
    ,Title
    ,Alias
	,Email + '.' + @Environment AS Email
    ,SenderEmail + '.' + @Environment AS SenderEmail
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
    ,FederationIdentifier + '.' + @Environment AS FederationIdentifier
    ,PACE_RESOURCE_ResourcePartyId__c
    ,PACE_RESOURCE_Username__c
    ,CommunityNickname + '.' + @Environment AS CommunityNickname -- cannot have duplicates
--  required fields not coming from osc.RESOURCE_SEED
    ,'UTF-8' AS "EmailEncodingKey"
    ,'en_US' AS "LanguageLocaleKey"
    ,'en_US' AS "LocaleSidKey"
    ,@UserProfileId AS "ProfileId"
--    ,Id -- User_L_02

--	INTO sfdc.User_L_01
--	DROP TABLE sfdc.User_L_01
FROM sfdc.User_T AS A
LEFT JOIN sfdc.[Id_UserRole_fullData_230420-1622] AS C -- updated 230420-1622 UserProfileId lookup
ON A.Role__c = C.DeveloperName

--  Filter out ARCB System Users, which are configured by Func & DevOps teams
WHERE SUBSTRING(Username,1,12) <> 'ArcBest-Corp' -- OR SUBSTRING(Username,1,13) = 'salessupport@'
