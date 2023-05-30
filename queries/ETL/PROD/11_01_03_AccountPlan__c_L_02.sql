-- AccountPlan__c_L_02
--  LAST RUN:   230518 prod

USE SALESFORCE

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'11_01_03_2'
	,'Account Plan L (Load)'
	,'Load for Update'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @AcctRecordTypeId AS VARCHAR(18) = NULL


--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  MANUAL VALUE ENTRIES PER ENVIRONMENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--  org-specific RecordTypeId values:    

--  SET PER ENVIRONMENT
SET @AccountAccountRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

SELECT
--    Id -- lookup in AccountPlan__c_L_02.sql
    PACE_BusinessPlanId__c
    ,[Name]
    ,BusinessPlanTypeCode__c
    ,StatusCode__c
    ,B.Id AS "Account__c"     -- lookup in AccountPlan__c_L_02.sql -- Config ???
    ,A.AIMSAccount__c
    ,CASE
        WHEN C.Alias IS NULL OR A.OwnerCorpEmplId__c = 'ABTSupport' THEN @ABTSupportId
        ELSE C.Id
        END
        AS 'OwnerId'    -- lookup in AccountPlan__c_L_02.sql
    ,A.OwnerCorpEmplId__c
	,CASE
		WHEN D.Alias IS NULL OR A.CreatedById = 'ABTSupport' THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'CreatedById' -- lookup in AccountPlan__c_L_02.sql
    ,CreatedDate
 	,CASE
        WHEN A.LastModifiedById IS NULL OR A.LastModifiedDate IS NULL THEN NULL
		WHEN E.Alias IS NULL OR A.LastModifiedById = 'ABTSupport' THEN @ABTSupportId
		ELSE E.Id
		END
		AS 'LastModifiedById' -- lookup in AccountPlan__c_L_02.sql
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

--  INTO sfdc.AccountPlan__c_L_02
--  DROP TABLE sfdc.AccountPlan__c_L_02
FROM sfdc.AccountPlan__c_T AS A
LEFT OUTER JOIN sfdc.[Id_Account_prod] AS B
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.RecordTypeId = @AcctRecordTypeId
LEFT OUTER JOIN sfdc.[Id_User_prod] AS C
ON A.OwnerCorpEmplId__c = C.CorpEmplID__c AND C.CorpEmplID__c IS NOT NULL
LEFT OUTER JOIN sfdc.[Id_User_prod] AS D
ON A.CreatedById = D.Alias AND D.CorpEmplID__c IS NOT NULL
LEFT OUTER JOIN sfdc.[Id_User_prod] AS E
ON A.LastModifiedById = E.Alias AND E.CorpEmplID__c IS NOT NULL
ORDER BY PACE_BusinessPlanId__c


LEFT JOIN sfdc.[Id_AccountPlan__c_prod] AS F-- for Contact record Id values
ON TRIM(A.PACE_BusinessPlanId__c) = TRIM(F.[BusinessPlanId]) 

Where F.Id is null

DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.AccountPlan__c_L_02)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '11_01_03_2';