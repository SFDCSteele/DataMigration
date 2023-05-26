--	User_T.sql table User_E tranformation query to table User_T
--  LAST RUN:  230524 fulldata delta
USE Salesforce
--  SET CORRECT DATE VALUE FOR IsActive DETERMINATION
DECLARE
    @ActiveDateString AS VARCHAR(20) =NULL
SET
    @ActiveDateString = '2023-05-18' -- delta CURRENT REFRESH DATA EXTRACT DATE

SELECT
    Username
    ,FirstName
    ,LastName
    ,Title
    ,Alias
	,Email
    ,SenderEmail
	,StartDate__c
    ,CASE -- correct for Salesforce max date value
        WHEN 
			CAST(EndDate__c AS date) > CAST('4000-12-31' AS date) THEN '4000-12-31'
        ELSE EndDate__c
        END
        AS "EndDate__c"
    ,CASE
        WHEN 
			--  BE SURE TO SET CORRECT DATE VALUE FOR @ActiveDateString
            CAST(StartDate__c AS date) <= CAST(@ActiveDateString AS date) 
			AND 
			CAST(EndDate__c AS date) >= CAST(@ActiveDateString AS date) THEN 'true'
        ELSE 'false'
        END
        AS "IsActive"
    ,CorpEmplID__c
    ,ManagerId -- lookup User.Id in User_L_04.sql
    ,MgrCorpEmplID__c
    ,CASE -- 230516 updated to account for current values per DS
        WHEN TRIM(Area__c) = 'ABFINSIDE' THEN 'ABFInside'
        WHEN TRIM(Area__c) = 'BUSINESSDEV' THEN 'BUSINESSDEV'
        WHEN TRIM(Area__c) = 'DEVELOPMENT' THEN 'Development'
        WHEN TRIM(Area__c) = 'ENTERPRISE' THEN 'Enterprise'
        WHEN TRIM(Area__c) = 'EXPEDITE' THEN 'Expedite'
        WHEN TRIM(Area__c) = 'FIELD' THEN 'Field'
        WHEN TRIM(Area__c) = 'MOLOAM' THEN 'MOLOAM'
        WHEN TRIM(Area__c) = 'TLSTRATEGY' THEN 'TLStrategy'
        WHEN TRIM(Area__c) = 'ACCTDEVELOPMNT' THEN NULL
        WHEN TRIM(Area__c) = 'MOLOCO' THEN NULL
        ELSE NULL
        END
        AS "Area__c" -- picklist
    ,Region__c
    ,District__c
    ,Territory__c
    ,UserRoleId -- lookup value in User_L_01.sql
    ,Role__c
    ,SRMRole__c -- added per DS 230414
    ,ResourceOrgRoleName__c
    ,ResourceOrganizationName__c
    ,CASE
		WHEN TimeZoneSidKey IS NULL THEN 'America/Chicago'
		ELSE TimeZoneSidKey
		END
		AS "TimeZoneSidKey" -- same format as SF
    ,FederationIdentifier
    ,PACE_RESOURCE_ResourcePartyId__c
    ,PACE_RESOURCE_Username__c
    ,CommunityNickname

--  INTO sfdc.User_T
--  DROP TABLE sfdc.User_T
FROM sfdc.User_E
