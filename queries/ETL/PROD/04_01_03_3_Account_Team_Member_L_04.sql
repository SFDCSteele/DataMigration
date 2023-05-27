--  Account_Team_Member_Location_L_04.sql Account Team Member target object view load query to tableAccount_Team_Member_Location_L

--This is to add the account ownder for the account location teams in ARCBTECH

USE Salesforce

DROP TABLE sfdc.Account_Team_Member_Location_L_04

SELECT --TOP 0.3 PERCENT
	[OWNERID] AS 'UserId'
    ,'true' AS 'PrimaryAccountOwner__c'
    ,Id AS 'Account__c' -- set via AIMSAccount__c
    ,'Primary Owner' AS 'TeamMemberRole'
    ,'Edit' AS 'ACCOUNTACCESSLEVEL'
    ,'Edit' AS 'CASEACCESSLEVEL'
    ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'


  INTO sfdc.Account_Team_Member_Location_L_04
  
FROM sfdc.[Id_Account_Team_Member_arcBtech_230502-1329]

where  Id is not null

