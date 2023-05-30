-- AccountPlan__c_E.sql
--  LAST RUN:  230518 prod
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
	'11_01_01'
	,'Account Plan E (Extract)'
	,'Extract'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
  DROP TABLE sfdc.AccountPlan__c_E

SELECT
    BusinessPlanId AS "Id" -- lookup in AccountPlan__c_L_02.sql
    ,BusinessPlanId AS "PACE_BusinessPlanId__c"
    ,LEFT([Name], 80) AS "Name"
    ,BusinessPlanTypeCode AS "BusinessPlanTypeCode__c"
    ,StatusCode AS "StatusCode__c"
    ,AIMS_ACCT AS "Account__c"     -- lookup in AccountPlan__c_L_01.sql -- Config ???
    ,AIMS_ACCT AS "AIMSAccount__c"
    ,OwnerCorpEmplId AS "OwnerId" -- lookup in AccountPlan__c_L_01.sql
    ,OwnerCorpEmplId AS "OwnerCorpEmplId__c"
    ,CreatedBy AS "CreatedById" -- lookup in AccountPlan__c_L_01.sql
    ,LEFT(CreationDate, 19) AS "CreatedDate"
    ,LastUpdatedBy AS "LastModifiedById" -- lookup in AccountPlan__c_L_01.sql
    ,LEFT(LastUpdateDate, 19) AS "LastModifiedDate"
    ,Description AS "Description__c"
    ,N'20' + SUBSTRING(PeriodStartName, 5, 2) AS "PlanYear__c"
    ,Challenges_c AS "Challenges__c"
    ,ChallengesFCL_c AS "ChallengesFCL__c"
    ,Goals_c AS "Goals__c"
    ,GoalsFCL_c AS "GoalsFCL__c"
    ,Needs_c AS "Needs__c"
    ,NeedsFCL_c AS "NeedsFCL__c"
    ,Value_c AS "Value__c"  
    ,ValuesFCL_c AS "ValuesFCL__c"

  INTO sfdc.AccountPlan__c_E

--FROM osc.BUSINESS_PLAN_SEED
FROM oscd.BUSINESS_PLAN_SEED
ORDER BY BusinessPlanId


DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.AccountPlan__c_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '11_01_01';