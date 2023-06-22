--  OpportunityContactRole_L_02.sql -- Load #01 query for OpportunityContactRole object
--  LAST RUN:  230523 prod

USE SALESFORCE


  DROP TABLE sfdc.OpportunityContactRole_L_01

SELECT --TOP (1000) 
      A.[ID] AS 'OpportunityId'
      ,A.[PACE_OPPORTUNITYID__C] AS 'PACE_OpportunityID__c'
      ,A.[PACE_OPPORTUNITYREVENUEID__C] AS 'PACE_OpportunityRevenueId__c'
	  ,A.[PRIMARY_CONTACT__C] AS 'ContactId'
	  ,CAST(C.CONTACTINTEGRATIONID__C AS VARCHAR(30)) AS 'ContactIntegrationId__c'
	  ,'true' AS 'IsPrimary'

  INTO sfdc.OpportunityContactRole_L_01

  FROM [sfdc].[Id_Opportunity_prod] AS A

  LEFT JOIN [sfdc].[Id_OpportunityContactRoles_prod] AS B
  ON A.[PACE_OPPORTUNITYID__C] = B.PACE_OPPORTUNITYID__C 
  AND A.[PACE_OPPORTUNITYREVENUEID__C] = B.PACE_OPPORTUNITYREVENUEID__C
  AND A.[PRIMARY_CONTACT__C] = B.CONTACTID

  LEFT JOIN sfdc.Id_Contact_prod AS C
  ON A.CONTACTID = C.ID

  WHERE B.[ID] IS NULL AND A.[PRIMARY_CONTACT__C] is not null

order by [PACE_OpportunityID__c],[PACE_OpportunityRevenueId__c],[ContactIntegrationId__c]

