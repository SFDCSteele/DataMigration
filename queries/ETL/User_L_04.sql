--	User_L_04.sql table User_T tranformation query to table User_L_04 to apply ManagerId to User
--  1. Set latest value for sfdc.Id_UserRole_env_datetime
--  2. BE SURE TO FILTER OUT ArcBest System Accounts -- see last line here and System_Users_Load.xlsx
--  see System_Users_Load.xlsx
--  LAST RUN:  230518

USE Salesforce;
SELECT
    B.Id -- User.Id to update
    ,C.Id AS ManagerId -- User.ManagerId
--  ,A.CorpEmplID__c -- test only
--  ,A.MgrCorpEmplID__c -- test only

--	INTO sfdc.User_L_04
--	DROP TABLE sfdc.User_L_04
FROM sfdc.User_T AS A
--  INSERT CORRECT JOIN TABLE NAMES FOR ENVIRONMENT AND DATE
LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS B -- lookup matching User Id
ON A.CorpEmplID__c = B.CorpEmplID__c AND B.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS C -- lookup Manager's User.Id value
ON A.MgrCorpEmplID__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL

--  Filter out ARCB System Users
WHERE 
	SUBSTRING(A.Username,1,12) <> 'ArcBest-Corp'  AND A.IsActive = 'true'
    AND B.MgrCorpEmplID__c <> ''