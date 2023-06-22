-- AccountPlan__c_L_01
--  LAST RUN:   230502

USE SALESFORCE

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @AcctRecordTypeId AS VARCHAR(18) = NULL


--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230501-1801]
    WHERE Alias = 'ABTSuppt')

--  MANUAL VALUE ENTRIES PER ENVIRONMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--  org-specific RecordTypeId values:    
SET @AcctRecordTypeId = '012770000004LOvAAM' -- fullData Account RT Account  012770000004LOvAAM

SELECT
--    Id -- lookup in AccountPlan__c_L_02.sql
    PACE_BusinessPlanId__c
    ,[Name]
    ,BusinessPlanTypeCode__c
    ,StatusCode__c
    ,B.Id AS "Account__c"     -- lookup in AccountPlan__c_L_01.sql -- Config ???
    ,A.AIMSAccount__c
    ,CASE
        WHEN C.Alias IS NULL OR A.OwnerCorpEmplId__c = 'ABTSupport' THEN @ABTSupportId
        ELSE C.Id
        END
        AS 'OwnerId'    -- lookup in AccountPlan__c_L_01.sql
    ,A.OwnerCorpEmplId__c
	,CASE
		WHEN D.Alias IS NULL OR A.CreatedById = 'ABTSupport' THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'CreatedById' -- lookup in AccountPlan__c_L_01.sql
    ,CreatedDate
 	,CASE
        WHEN A.LastModifiedById IS NULL OR A.LastModifiedDate IS NULL THEN NULL
		WHEN E.Alias IS NULL OR A.LastModifiedById = 'ABTSupport' THEN @ABTSupportId
		ELSE E.Id
		END
		AS 'LastModifiedById' -- lookup in AccountPlan__c_L_01.sql
    ,LastModifiedDate
    ,Description__c
    ,PlanYear__c
    ,Challenges__c
    ,ChallengesFCL__c
    ,Goals__c
    ,GoalsFCL__c
    ,Needs__c
    ,NeedsFCL__c
    ,Value__c  
    ,ValuesFCL__c

--  INTO sfdc.AccountPlan__c_L_01
--  DROP TABLE sfdc.AccountPlan__c_L_01
FROM sfdc.AccountPlan__c_T AS A
LEFT OUTER JOIN sfdc.[Id_Account_fullData_230502-1300] AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = @AcctRecordTypeId
LEFT OUTER JOIN sfdc.[Id_User_fullData_230501-1801] AS C
ON A.OwnerCorpEmplId__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL
LEFT OUTER JOIN sfdc.[Id_User_fullData_230501-1801] AS D
ON A.CreatedById = D.Alias AND D.CorpEmplID__c IS NOT NULL
LEFT OUTER JOIN sfdc.[Id_User_fullData_230501-1801] AS E
ON A.LastModifiedById = E.Alias AND E.CorpEmplID__c IS NOT NULL
ORDER BY PACE_BusinessPlanId__c
