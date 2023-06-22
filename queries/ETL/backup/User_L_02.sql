--	User_L_02_fulldata.sql table User_T tranformation query to table User_L_02 for Update / Upsert use
--  1. Set local variables
--  2. Set latest value for sfdc.Id_UserRole_env_datetime
--  3. BE SURE TO FILTER OUT ArcBest System Accounts -- see last line here and System_Users_Load.xlsx
--  see System_Users_Load.xlsx
--  LAST RUN:  230524 fulldata delta

DECLARE
    @Environment AS VARCHAR(20) = NULL,
    @UserProfileId AS VARCHAR(20) = NULL

-- SET THESE VALUES FOR THE LOAD ENVIRONMENT
SET @Environment = /*'PROD'*/ /*'fulldata02'*/ -- load org name, e.g., 'fullData'
SET @UserProfileId = /*'00e77000000Lt2RAAS'*/ -- ArcBest Standard User Profile Id for environment

USE Salesforce;
SELECT
    CASE
        WHEN @Environment = 'PROD' THEN A.Username
        ELSE A.Username +  '.' + @Environment 
        END
        AS Username -- ADD ORG NAME AS SUFFIX !!!!
    ,A.FirstName
    ,A.LastName
    ,A.Title
    ,A.Alias
    ,CASE
        WHEN @Environment = 'PROD' THEN Email
        ELSE Email +  '.' + @Environment 
        END
        AS Email
    ,CASE
        WHEN @Environment = 'PROD' THEN SenderEmail
        ELSE SenderEmail +  '.' + @Environment 
        END
        AS SenderEmail
    ,StartDate__c
	,EndDate__c
--  temp workaround for active users > license limit
    ,A.IsActive --'' AS IsActive /*'false' AS */ --A.IsActive -- comment out to load actual; managing license limit
    ,A.CorpEmplID__c
    ,D.Id AS "ManagerId" -- type Hierarchy lookup via MgrCorpEmplID__c value
    ,A.MgrCorpEmplID__c
    ,Area__c -- picklist
    ,Region__c
    ,A.District__c
    ,A.Territory__c
    ,C.Id AS 'UserRoleId'
    ,A.Role__c
    ,SRMRole__c -- added per DS 230414
    ,ResourceOrgRoleName__c
    ,ResourceOrganizationName__c
    ,TimeZoneSidKey
    ,CASE
        WHEN @Environment = 'PROD' THEN FederationIdentifier
        ELSE FederationIdentifier + '.' + @Environment
        END
        AS FederationIdentifier
    ,PACE_RESOURCE_ResourcePartyId__c
    ,PACE_RESOURCE_Username__c
    ,CommunityNickname + '.' + @Environment AS CommunityNickname -- cannot have duplicates
--  required fields not coming from osc.RESOURCE_SEED
    ,'UTF-8' AS "EmailEncodingKey"
    ,'en_US' AS "LanguageLocaleKey"
    ,'en_US' AS "LocaleSidKey"
    ,@UserProfileId AS "ProfileId"
    ,B.Id -- via JOIN w/User Id values on updates

--	INTO sfdc.User_L_02
--	DROP TABLE sfdc.User_L_02
FROM sfdc.User_T AS A
--  INSERT CORRECT JOIN TABLE NAMES FOR ENVIRONMENT AND DATE
LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS B -- lookup matching User Id
ON A.CorpEmplID__c = B.CorpEmplID__c AND TRIM(B.CorpEmplId__c) IS NOT NULL
LEFT JOIN sfdc.[Id_UserRole_fullData_230516-1119] AS C -- lookup UserRoleId
ON A.Role__c = C.DeveloperName
LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS D -- lookup ManagerId
ON A.MgrCorpEmplID__c = D.CorpEmplID__c AND TRIM(D.CorpEmplId__c) IS NOT NULL

--  Filter out ARCB System Users, which are manually configured
WHERE SUBSTRING(A.Username,1,12) <> 'ArcBest-Corp' 
ORDER BY B.Id

