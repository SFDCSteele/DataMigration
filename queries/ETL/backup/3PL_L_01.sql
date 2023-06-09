--  Account-Account_L_01.sql Account RT Account target object view load query to table Account_Account_L
--  Lookup of B.OwnerId, C.CreatedById, and D.LastModifiedById for respective org.User
--  LAST RUN:   230518

USE Salesforce


SELECT
	[Name] 
    ,B.Id AS OwnerId
--    ,ThirdPartyLogisticsFlag__c

--  INTO sfdc.[3PL_L_01]
--	DROP TABLE sfdc.[3PL_L_01]
FROM sfdc.Account_Account_T AS A
LEFT OUTER JOIN sfdc.[Id_User_fullData_230516-1405] AS B
ON A.OwnerCorpEmplId__c = B.CorpEmplId__c AND B.CorpEmplId__c IS NOT NULL

WHERE ThirdPartyLogisticsFlag__c = 'true'
