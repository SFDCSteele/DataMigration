--  Opportunity_Note_L_01.sql Opportunity_Note target object view load query to table Opportunity_Note_L
USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230516-1405]
    WHERE Alias = 'ABTSuppt')

--this select and table will create a unique record for each opty/note
	DROP TABLE sfdc.[Opportunity_Note_L_01_A]

SELECT --TOP 0.3 PERCENT
	A.PACE_OpportunityId__c 
	--,F.PrimaryIndicator
	, F.Id AS 'ParentId' --- opportunity OptyKey
	--  ,ROW_NUMBER()over(partition by A.PACE_OpportunityID__c order by A.PACE_OpportunityID__c) as [PrimaryIndicator2]
	  ,ROW_NUMBER()over(partition by A.OptyKey order by A.OptyKey) as [PrimaryIndicator3]
	, CASE
		WHEN B.Alias IS NULL THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'CreatedById' 
	, A.CreatedDate 
	, CASE
		WHEN C.Alias IS NULL THEN @ABTSupportId
		ELSE C.Id
		END
		AS 'LastModifiedById' 
	, A.LastModifiedDate 
	, A.Body 
	, CASE
		WHEN B.Alias IS NULL THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'OwnerId' 
	, F.AIMSAccount__c AS 'Title'

  INTO sfdc.[Opportunity_Note_L_01_A]
FROM sfdc.Opportunity_Note_T AS A

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS B -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(B.Alias)  and B.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS C -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(C.Alias)  and B.CorpEmplID__c IS NOT NULL

LEFT JOIN [sfdc].[Id_Opportunity_fullData_230518-1111] AS F
ON A.PACE_OpportunityID__c = F.PACE_OpportunityID__c --AND F.PrimaryIndicator = 1

Where F.Id IS NOT NULL 
--  AND  A.[PACE_OpportunityID__c] = '300001167400412'
order by F.Id;

	DROP TABLE sfdc.Opportunity_Note_L_01
SELECT 
	  PACE_OpportunityId__c 
	--, PrimaryIndicator
	, ParentId
	--, [PrimaryIndicator3]
	, CreatedById 
	, CreatedDate 
	, LastModifiedById 
	, LastModifiedDate 
	, Body 
	, OwnerId
	, Title

  INTO sfdc.Opportunity_Note_L_01

from sfdc.Opportunity_Note_L_01_A

Where   [PrimaryIndicator3] = 1 --AND [PACE_OpportunityID__c] = '300001167400412'
--AND [PACE_OpportunityID__c] = '300000026865344'
order by PACE_OpportunityID__c

