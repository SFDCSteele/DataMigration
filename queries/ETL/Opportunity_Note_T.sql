-- Opportunity_Note_T.sql Opportunity_Note target object view transformation query to table Opportunity_Note_T
USE Salesforce
  DROP TABLE sfdc.Opportunity_Note_T

SELECT 
	PACE_OpportunityId__c 
	, ParentId 
	, CreatedById 
	, CreatedDate 
	, LastModifiedById 
	, LastModifiedDate 
	, Body 
	,CONCAT(PACE_OpportunityId__c,TRIM(Body)) AS OptyKey
	
  INTO sfdc.Opportunity_Note_T
FROM sfdc.Opportunity_Note_E
Order By PACE_OpportunityId__c
