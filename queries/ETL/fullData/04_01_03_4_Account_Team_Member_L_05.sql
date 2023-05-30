--  Account_Team_Member_L_05.sql Account Team Member target object view load query to tableAccount_Team_Member_L

--This is to add the account ownder for the account location teams in ARCBTECH

USE Salesforce

--	DROP TABLE sfdc.Account_Team_Member_L_05
SELECT --TOP (10) 
      [ID]
      ,'Edit' AS 'ACCOUNTACCESSLEVEL'
      ,'Edit' AS 'CASEACCESSLEVEL'
      ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'
      --,[ACCOUNTID]
	  ,PRIMARYACCOUNTOWNER_C
  	  ,CASE
		WHEN PRIMARYACCOUNTOWNER_C = 'true' then 'Primary Owner'
		ELSE 'Secondary Owner'
		END
        AS 'TeamMemberRole'

--  INTO sfdc.Account_Team_Member_L_05

FROM [sfdc].[Id_Account_Team_Member_arcBtech_230425-1317]
  --where [PRIMARYACCOUNTOWNER_C]  != 1
  --where [ID] is null

  Order by ACCOUNTID


