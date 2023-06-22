/****** Script for SelectTopNRows command from SSMS  ******/
Use Salesforce
DROP TABLE [sfdc].[Id_Opportunity_prod_sum_1]
SELECT --TOP (1000) 
		A.[NAME]
      ,A.[ID]
      ,A.[RECORDTYPEID]
      ,A.[PACE_OPPORTUNITYID__C]
      ,A.[PACE_OPPORTUNITYREVENUEID__C]
      ,A.[ACCOUNTID]
      ,A.[AIMSACCOUNT__C]
	  ,CONCAT(A.PACE_OpportunityId__c,'/',A.[AIMSACCOUNT__C]) AS OptyKey
      ,A.[CONTACTID]
	  ,B.ContactId as 'PrimaryContactId'
	  ,B.ContactIntegrationId__c AS 'PrimaryContactIntegrationId'
	  ,B.IsPrimary
      ,A.[OWNERCORPEMPLID__C]
      ,A.[STAGENAME]
      ,A.[STATUSCODE__C]

	  INTO [sfdc].[Id_Opportunity_prod_sum_1]
  FROM [sfdc].[Id_Opportunity_prod] AS A

  LEFT JOIN sfdc.OpportunityContactRole_L_01 AS B
  ON A.PACE_OpportunityID__c = B.PACE_OpportunityID__c And b.IsPrimary = 'true'

  order by A.[PACE_OPPORTUNITYID__C],A.[PACE_OPPORTUNITYREVENUEID__C]


DROP TABLE [sfdc].[Id_Opportunity_prod_sum_2]
SELECT --TOP (1000) 
		[NAME]
      ,[ID]
      ,[RECORDTYPEID]
      ,[PACE_OPPORTUNITYID__C]
      ,[PACE_OPPORTUNITYREVENUEID__C]
      ,[ACCOUNTID]
      ,[AIMSACCOUNT__C]
	  ,OptyKey
	  ,ROW_NUMBER()over(partition by OptyKey order by OptyKey) as [PrimaryIndicator]
      ,[CONTACTID]
	  ,PrimaryContactId
	  ,PrimaryContactIntegrationId
	  ,IsPrimary
      ,[OWNERCORPEMPLID__C]
      ,[STAGENAME]
      ,[STATUSCODE__C]

	  INTO [sfdc].[Id_Opportunity_prod_sum_2]
  FROM [sfdc].[Id_Opportunity_prod_sum_1]
  order by [PACE_OPPORTUNITYID__C],[PACE_OPPORTUNITYREVENUEID__C]

DROP TABLE [sfdc].[Id_Opportunity_prod_prime]
SELECT --TOP (1000) 
		[NAME]
      ,[ID]
      ,[RECORDTYPEID]
      ,[PACE_OPPORTUNITYID__C]
      ,[PACE_OPPORTUNITYREVENUEID__C]
      ,[ACCOUNTID]
      ,[AIMSACCOUNT__C]
	  ,OptyKey
	  ,[PrimaryIndicator]
      ,[CONTACTID]
	  ,PrimaryContactId
	  ,PrimaryContactIntegrationId
	  ,IsPrimary
      ,[OWNERCORPEMPLID__C]
      ,[STAGENAME]
      ,[STATUSCODE__C]

	  INTO [sfdc].[Id_Opportunity_prod_prime]
  FROM [sfdc].[Id_Opportunity_prod_sum_2]
  where [PrimaryIndicator] = 1
  order by [PACE_OPPORTUNITYID__C],[PACE_OPPORTUNITYREVENUEID__C]
 