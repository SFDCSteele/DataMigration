-- AccountPlan__c_T.sql
USE SALESFORCE

SELECT
    Id -- lookup in AccountPlan__c_L_02.sql
    ,PACE_BusinessPlanId__c
    ,[Name]
    ,CASE	
        WHEN BusinessPlanTypeCode__c = 'ORA_GLOBAL' THEN 'Global'
        WHEN BusinessPlanTypeCode__c = 'ORA_REGIONAL' THEN 'Regional'
        ELSE BusinessPlanTypeCode__c
        END
        AS "BusinessPlanTypeCode__c"-- picklist
    ,CASE	
        WHEN StatusCode__c = 'FINAL' THEN 'Final'
        WHEN StatusCode__c = 'ORA_DRAFT' THEN 'Draft'
        WHEN StatusCode__c = 'ORA_IN_REVISION' THEN 'In Revision'
        ELSE StatusCode__c
        END
        AS "StatusCode__c" -- picklist
    ,Account__c     -- lookup in AccountPlan__c_L_01.sql -- Config ???
    ,AIMSAccount__c
    ,OwnerId -- lookup in AccountPlan__c_L_01.sql
    ,OwnerCorpEmplId__c
    ,CreatedById -- lookup in AccountPlan__c_L_01.sql
    ,CreatedDate
    ,LastModifiedById -- lookup in AccountPlan__c_L_01.sql
    ,LastModifiedDate
    ,Description__c
    ,PlanYear__c
    ,Challenges__c
    ,REPLACE( -- INSERT 	5	more REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(ChallengesFCL__c, ',', ';')
                            ,'CAPACITY', 'Capacity')
                            ,'COST_MANAGEMENT', 'Cost Management')
                            ,'INEFFICIENCIES', 'Inefficiencies')
                            ,'OTHER', 'Other')
                            ,'TECHNOLOGY_RESTRAINTS', 'Technology Restraints')
                            ,'TRANSPORTATION_KNOWLEDGE', 'Transportation Knowledge')
        AS "ChallengesFCL__c"  -- multi-select picklist	
    ,Goals__c
    ,REPLACE( -- INSERT 	5	more REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(GoalsFCL__c, ',', ';')
                            ,'ADVANCING_TECHNOLOGY', 'Advancing Technology')
                            ,'BUSINESS_GROWTH', 'Business Growth')
                            ,'CAPACITY_SOLUTIONS', 'Capacity Solutions')
                            ,'COST_MANAGEMENT', 'Cost Management')
                            ,'EFFICIENCIES', 'Efficiencies')
                            ,'OTHER', 'Other')
        AS "GoalsFCL__c"  -- multi-select picklist
    ,Needs__c
    ,REPLACE(	 -- INSERT 	5
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(NeedsFCL__c, ',', ';')
                            ,'COST_MANAGEMENT', 'Cost Management')
                            ,'CREATIVE_SOLUTIONS', 'Creative Solutions')
                            ,'INNOVATIVE_TECHNOLOGY', 'Innovative Technology')
                            ,'OTHER', 'Other')
                            ,'RELIABILITY', 'Reliability')
                            ,'TRUSTED_PARTNERSHIP', 'Trusted Partnership')
        AS "NeedsFCL__c" -- picklist
    ,Value__c  
    ,REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(		
                            REPLACE(ValuesFCL__c, ',', ';')
                            ,'COST_MANAGEMENT', 'Cost Management')
                            ,'LOGISTICS_SOLUTIONS', 'Logistics Solutions')
                            ,'OTHER', 'Other')
                            ,'RELATIONSHIPS', 'Relationships')
                            ,'RELIABILITY', 'Reliability')
                            ,'TECHNOLOGY', 'Technology')
    AS "ValuesFCL__c" -- picklist

--  INTO sfdc.AccountPlan__c_T
--  DROP TABLE sfdc.AccountPlan__c_T

FROM sfdc.AccountPlan__c_E
ORDER BY PACE_BusinessPlanId__c
