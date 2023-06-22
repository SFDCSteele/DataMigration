--  Account-Account_L_04.sql updates Account RT Account target object view load query to table Account_Account_L_04
--  Update to populate Account.PrimaryContactID__c from AccountContactRelation data.
--  LAST RUN:  230523

USE Salesforce

SELECT  --TOP 10000
    AccountId AS Id
    ,ContactId AS PrimaryContactID__c -- will lookup Contact from PACEPrimaryContactPartyId__c  in Account-Account_L_04.sql

--  INTO sfdc.Account_Account_L_04
--	DROP TABLE sfdc.Account_Account_L_04
FROM sfdc.[Id_AccountContactRelation_fullData_230519-1403]
WHERE IsDirect__c = 'true' AND RelationshipDirection__c = 'CONTACT_TO_ACCOUNT' --alternative to 'ACCOUNT_TO_CONTACT'
