--  Account-Account_L_01.sql Account RT Account target object view load query to table Account_Account_L
--  Lookup of B.OwnerId, C.CreatedById, and D.LastModifiedById for respective org.User
--  lAST RUN:   230516 prod

USE Salesforce
--delete  from sfdc.Migration_Status

select * FROM sfdc.Migration_Status 
Order by stepsID