--	User_L_03.sql table User_T tranformation query to table User_L_03
--  1. Set latest value for sfdc.Id_UserRole_env_datetime
--  2. BE SURE TO FILTER OUT ArcBest System Accounts -- see last line here and System_Users_Load.xlsx
--  see System_Users_Load.xlsx
--  LAST RUN:  230501

USE Salesforce;
SELECT
    A.IsActive
    ,B.Id -- via JOIN w/User Id values on updates

--	INTO sfdc.User_L_03
--	DROP TABLE sfdc.User_L_03
FROM sfdc.User_T AS A
--  INSERT CORRECT JOIN TABLE NAMES FOR ENVIRONMENT AND DATE
LEFT JOIN sfdc.[Id_User_fullData_230501-1725] AS B -- lookup matching User Id
ON A.CorpEmplID__c = B.CorpEmplID__c AND B.CorpEmplID__c IS NOT NULL

--  Filter out ARCB System Users
WHERE SUBSTRING(A.Username,1,12) <> 'ArcBest-Corp'  AND A.IsActive = 'true'

