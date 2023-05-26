--  Account_Team_Member_L_05.sql Account Team Member target object view load query to tableAccount_Team_Member_L

--This is to add the account ownder for the account location teams in ARCBTECH

USE Salesforce

	DROP TABLE sfdc.Account_Team_Member_L_06
SELECT --TOP (10) 
      B.[USERID]
      ,'Edit' AS 'ACCOUNTACCESSLEVEL'
      ,'Edit' AS 'CASEACCESSLEVEL'
      ,'Edit' AS 'OPPORTUNITYACCESSLEVEL'
  	  ,A.[ID] as 'AccountId'
  	  ,CASE
        WHEN B.[PRIMARYACCOUNTOWNER_C] = 1 then 'Primary Owner'
        ELSE 'Secondary Owner'
        END
        AS 'TeamMemberRole'
      ,CASE
        WHEN B.[PRIMARYACCOUNTOWNER_C] = 1 THEN 'true'
        ELSE 'false'
        END
        AS 'PrimaryAccountOwner__c'

  INTO sfdc.Account_Team_Member_L_06


  FROM [sfdc].[Id_Account_Location_arcBtech_230426-1626] AS A 
   
  LEFT Join [sfdc].[Id_Account_Team_Member_arcBtech_230425-1317] AS B
  ON B.[ACCOUNTID] = A.[ACCOUNT__C]

  --Where A.[ID] IN ( '0017700000G8OV6AAN', '0017700000G7g0AAAR','0017700000G7g0BAAR','0017700000G7g0DAAR','0017700000G7g0EAAR' )
  where B.USERID is NOT NULL AND RECORDTYPENAME__C = 'Location'--NOT NULL

  Order by ACCOUNTID


