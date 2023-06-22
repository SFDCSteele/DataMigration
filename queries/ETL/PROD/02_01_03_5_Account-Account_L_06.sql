--  Account-Account_L_06.sql updates target object Account_Account_L_06
--  Update to populate Account.TFLTLSpend__c, TFTLSpend__c component fields 

USE Salesforce

	DROP TABLE sfdc.Account_Account_L_06
SELECT  --TOP 10000
		B.Id
	  --,A.[AIMS_ACCT]
	  --,B.AIMSACCOUNT__C
      ,A.[OrganizationDEO_TFLTLSpend_c] AS 'TFLTLSpend__c'
      ,A.[OrganizationDEO_TFTLSpend_c]  AS 'TFTLSpend__c'
      ,A.OrganizationDEO_TotalAirSpend_c AS "TFAirSpend__c"

      INTO sfdc.Account_Account_L_06

  FROM [osc].[account_seed] AS A
  --FROM [oscd].[account_seed] AS A

  left join sfdc.Id_Account_prod AS B
  ON A.AIMS_ACCT = B.AIMSACCOUNT__C

  Where B.Id is NOT NULL



