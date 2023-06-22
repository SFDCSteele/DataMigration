-- Opportunity_L_05.sql Base load to Opportunity_L_05
-- fix the record type
--  LAST RUN:  230517 prod

USE Salesforce

DECLARE 
    @OptyCrossSellRecordTypeId AS VARCHAR(18) = NULL,
    @OptyExpandRecordTypeId AS VARCHAR(18) = NULL,
    @OptyNewRecordTypeId AS VARCHAR(18) = NULL,
    @OptyRetainRecordTypeId AS VARCHAR(18) = NULL

SET @OptyCrossSellRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'CrossSell' AND IsActive = 'true')
SET @OptyExpandRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Expand' AND IsActive = 'true')
SET @OptyNewRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'New' AND IsActive = 'true')
SET @OptyRetainRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Retain' AND IsActive = 'true')
--  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


  DROP TABLE sfdc.Opportunity_L_05

/*
SELECT --TOP (1000) 
		--A.[AIMS_ACCT]
      --,A.[OpportunityTypeCode]
      --,A.[OptyId]
	  --,B.PACE_OPPORTUNITYID__C
	  B.ID
      --,A.[StatusCode]
      --,A.[RevnId]
	  --,B.PACE_OPPORTUNITYREVENUEID__C
    ,@OptyCrossSellRecordTypeId  AS 'RecordTypeId'

    INTO sfdc.Opportunity_L_05
  FROM [osc].[opportunity_seed] AS A
  --FROM [oscd].[opportunity_seed] AS A

  --left join sfdc.Id_Opportunity_prod_prime AS B
  left join sfdc.Id_Opportunity_prod AS B
  on A.OptyId = B.PACE_OPPORTUNITYID__C AND A.RevnId = B.PACE_OPPORTUNITYREVENUEID__C
  where A.[OpportunityTypeCode] = 'Cross Sell'
*/

  SELECT --TOP (1000) 
		B.ID
    --CAST(id AS NVARCHAR(50)) AS 'ID'
    --  ,[optyid]
    --  ,[opportunitytypecode]
    --  ,[salesmethodid]
    --  ,[recordtypecode]
      ,CASE
        WHEN [recordtypecode] = 'Cross Sell' THEN @OptyCrossSellRecordTypeId
        WHEN [recordtypecode] = 'Expand' THEN @OptyExpandRecordTypeId
        WHEN [recordtypecode] = 'New Customer' THEN @OptyNewRecordTypeId
        WHEN [recordtypecode] = 'Retain' THEN @OptyRetainRecordTypeId
        ELSE @OptyNewRecordTypeId -- 33K NULL values -- confirmed PK230315
        END
        AS 'RecordTypeId'


    INTO sfdc.Opportunity_L_05

  FROM [osc].[opportunity_recordtype_fix2] AS A

    left join sfdc.Id_Opportunity_prod_prime AS B
  --left join sfdc.Id_Opportunity_prod AS B
  on A.[optyid] = B.PACE_OPPORTUNITYID__C 

