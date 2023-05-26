/****** Script for SelectTopNRows command from SSMS  ******/
Use Salesforce
	  DROP TABLE sfdc.Account_Team_Member_arcBTech_L_03

SELECT --TOP (1000) 
		[ID]
	  ,CASE
		WHEN ([ACCOUNT_PRIMARYACCOUNTOWNER__C] = [TERRITORYNUMBER__C] OR [ACCOUNT_ACCOUNTOWNERS__C] = [TERRITORYNUMBER__C]) THEN 'true'
		ELSE 'false'
		END
		AS 'New_PrimaryAccountOwner__c'
	  ,CASE
		WHEN ([ACCOUNT_PRIMARYACCOUNTOWNER__C] = [TERRITORYNUMBER__C] OR [ACCOUNT_ACCOUNTOWNERS__C] = [TERRITORYNUMBER__C]) THEN 'Primary Owner'
		ELSE 'Secondary Owner'
		END
		AS 'New_Team_Member_Role'

	  INTO sfdc.Account_Team_Member_arcBTech_L_03

  FROM [sfdc].[Id_Account_Team_Member_arcbtech_230504-0955]
	 where [ACCOUNT_ACCOUNTOWNERS__C] is not null AND [TEAMMEMBERROLE] <> 'Primary Owner' --AND [TEAMMEMBERROLE] <> 'Secondary Owner'


