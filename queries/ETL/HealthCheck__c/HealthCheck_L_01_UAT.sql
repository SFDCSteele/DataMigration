-- HealthCheck_L_01_UAT.sql HealthCheck target object view transformation query to table Account_Account_T
USE Salesforce
--  DROP TABLE sfdc.HealthCheck_L_01
DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @RecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_arcBtech_230422-1253]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @RecordTypeId =  '012770000004LOvAAM' -- fullData RT Account '012770000004LOvAAM' -- arcbtech RT Account '012770000004LOvAAM'

SELECT  -- TOP 0.1 PERCENT 
	A.[Name] 
	,PACEActivityId__c 
	,B.Id AS Account__c 
	,A.AIMSAccount__c 
	,C.Id AS OwnerId 
	,A.OwnerCorpEmplId__c 
--	,D.Id AS CreatedById
	,CASE
		WHEN D.Alias IS NULL THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'CreatedById'
	,A.CreatedDate 
	--, E.Id AS LastModifiedById 
	,CASE
		WHEN E.Alias IS NULL THEN @ABTSupportId
		ELSE E.Id
		END
		AS 'LastModifiedById'
	,A.LastModifiedDate 
	,CurrentRisk__c
	,DueDate__c 
	,Locations__c 
	,Mitigation__c 
	,Status__c
    ,Type__c

--    ,B.RecordTypeId -- TEST
--    ,B.AIMSAccount__c -- TEST

--  INTO sfdc.HealthCheck_L_01
FROM sfdc.HealthCheck_T_UAT AS A
LEFT OUTER JOIN sfdc.[Id_Account_arcBtech_230422-1251] AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = @RecordTypeId

LEFT OUTER JOIN sfdc.[Id_User_arcBtech_230422-1253] AS C -- for OwnerId
ON A.OwnerCorpEmplId__c = C.CorpEmplId__c

LEFT JOIN sfdc.[Id_User_arcBtech_230422-1253] AS D -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(D.Alias)

LEFT JOIN sfdc.[Id_User_arcBtech_230422-1253] AS E -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(E.Alias)
