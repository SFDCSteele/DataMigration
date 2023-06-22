--  Opportunity_Note_L_02.sql Opportunity_Note target object view load query to table Opportunity_Note_L
USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230328-1657]
    WHERE Alias = 'Corp01')

	DROP TABLE sfdc.Opportunity_Note_L_02

SELECT --TOP 0.3 PERCENT
	A.PACE_OpportunityId__c 
	, F.Id AS 'ParentId' --- opportunity 
	, CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'CreatedById' 
	, A.CreatedDate 
	, CASE
		WHEN C.Id IS NULL OR C.Id = 'ABTSupport' THEN @ABTSupportId
		ELSE C.Id
		END
		AS 'LastModifiedById' 
	, A.LastModifiedDate 
	, A.Body 
	, CASE
		WHEN B.Id IS NULL OR B.Id = 'ABTSupport' THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'OwnerId' 
	, F.AIMSAccount__c AS 'Title'

  INTO sfdc.Opportunity_Note_L_02
FROM sfdc.Opportunity_Note_T AS A

LEFT JOIN sfdc.[Id_User_fullData_230328-1657] AS B -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(B.Alias)

LEFT JOIN sfdc.[Id_User_fullData_230328-1657] AS C -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(C.Alias)

LEFT JOIN sfdc.[Id_Opportunity_fullData_230331-0930] AS F
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c 

Where F.Id IS NOT NULL
order by F.Id
