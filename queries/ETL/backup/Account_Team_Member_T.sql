-- Accont_Team_Member_T.sql Account RT Account target object view transformation query to table Account_Account_T
USE Salesforce

-- Account RT Account Primary owner

  DROP TABLE sfdc.Account_Team_Member_Primary_T
SELECT  -- TOP 0.1 PERCENT 
    UserId
    ,territory
    ,SecondaryTerritoryNumber__c
	,'true' AS PrimaryAccountOwner__c
    ,AIMSAccount__c

  INTO sfdc.Account_Team_Member_Primary_T
FROM sfdc.Account_Team_Member_Primary_E

-- Account RT Account Secondary owner

  DROP TABLE sfdc.Account_Team_Member_Secondary_T
SELECT  -- TOP 0.1 PERCENT 
    UserId
    ,territory
	,PrimaryTerritoryNumber__c
    ,SecondaryTerritoryNumber__c
	,'false' AS PrimaryAccountOwner__c
    ,AIMSAccount__c

  INTO sfdc.Account_Team_Member_Secondary_T
FROM sfdc.Account_Team_Member_Secondary_E

-- Account RT Location Primary owner

  DROP TABLE sfdc.Account_Team_Member_Location_Primary_T
SELECT  -- TOP 0.1 PERCENT 
    UserId
    ,territory
    ,SecondaryTerritoryNumber__c
	,'true' AS PrimaryAccountOwner__c
    ,AIMS_LOC


  INTO sfdc.Account_Team_Member_Location_Primary_T
FROM sfdc.Account_Team_Member_Location_Primary_E

-- Account RT Location Secondary owner

  DROP TABLE sfdc.Account_Team_Member_Location_Secondary_T
SELECT  -- TOP 0.1 PERCENT 
    UserId
    ,territory
    ,SecondaryTerritoryNumber__c
	,'false' AS PrimaryAccountOwner__c
    ,AIMS_LOC


  INTO sfdc.Account_Team_Member_Location_Secondary_T
FROM sfdc.Account_Team_Member_Location_Secondary_E

