-- HealthCheck_L_01.sql HealthCheck target object view transformation query to table Account_Account_T
--	LAST RUN:	230518
USE Salesforce
DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @RecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @RecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

  DROP TABLE sfdc.HealthCheck_L_01
SELECT
--  Id -- lookup in L_02
	PACEActivityId__c 
	,B.Id AS Account__c 
	,A.AIMSAccount__c 
	,CASE
		WHEN D.Alias IS NULL THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'CreatedById'
	,A.CreatedDate 
	,CurrentRisk__c
	,DueDate__c 
	,CASE
		WHEN E.Alias IS NULL THEN @ABTSupportId
		ELSE E.Id
		END
		AS 'LastModifiedById'
	,A.LastModifiedDate 
	,Locations__c 
	,Mitigation__c 
	,A.[Name] 
    ,CASE
        WHEN C.Alias IS NULL OR A.OwnerCorpEmplId__c = 'ABTSupport' THEN @ABTSupportId
        ELSE C.Id
        END
        AS 'OwnerId'    -- lookup in HealthCheck__c_L_01.sql
	,A.OwnerCorpEmplId__c 
	,Status__c
    ,Type__c

  INTO sfdc.HealthCheck_L_01
FROM sfdc.HealthCheck_T AS A
LEFT OUTER JOIN sfdc.[Id_Account_prod] AS B  -- for Account.Id
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = @RecordTypeId

LEFT OUTER JOIN sfdc.[Id_User_prod] AS C -- for OwnerId
ON A.OwnerCorpEmplId__c = C.CorpEmplId__c AND C.CorpEmplId__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS D -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(D.Alias)  AND D.CorpEmplId__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_prod] AS E -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(E.Alias) AND E.CorpEmplId__c IS NOT NULL
