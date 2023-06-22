-- HealthCheck_T.sql HealthCheck target object view transformation query to table Account_Account_T
--	LAST RUN:  230518

USE Salesforce
/*
Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'16_01_02'
	,'Health Check T (Transform)'
	,'Transform'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
  DROP TABLE sfdc.HealthCheck_T

SELECT  -- TOP 0.1 PERCENT 
--  Id -- lookup in L_02
	PACEActivityId__c
	,Account__c 
	,AIMSAccount__c 
	,CreatedById 
	,CreatedDate 
--	, CurrentRisk__c TEST ONLY
	,REPLACE( -- INSERT 	13	more REPLACE(
		REPLACE(
			REPLACE(
				REPLACE(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(
										REPLACE(
											REPLACE(
												REPLACE(
													REPLACE(
														REPLACE(
															REPLACE(CurrentRisk__c, ',', ';')
															,'BUSINESS IS DOWN', 'Business is down')
															,'CHANGE IN PERSONNEL', 'Change in personnel')
															,'CLAIMS', 'Claims')
															,'COMPANY CLOSED', 'Company closed')
															,'COMPANY WAS PURCHASED', 'Company was purchased')
															,'CUSTOMER IS NOT AT RISK', 'Customer is not at risk')
															,'CUSTOMER NOT RESPONDING/UNWILL', 'Customer not responding/Unwilling to meet')
															,'I DON''T KNOW THE REASON', 'I don''t know the reason')
															,'LOCATION CLOSED', 'Location closed')
															,'OTHER PLEASE LEAVE COMMENT', 'Other - Please leave comment')
															,'PRICE', 'Price')
															,'PRICE CMC SPECIFIC', 'Price - CMC specific')
															,'SEASONAL', 'Seasonal')
															,'SERVICE', 'Service')
		AS "CurrentRisk__c"  -- multi-select picklist	
	,DueDate__c 
	,LastModifiedById 
	,LastModifiedDate 
	,Locations__c 
	,Mitigation__c 
	,[Name] 
	,OwnerId 
	,OwnerCorpEmplId__c 
	,CASE
		WHEN [Status__c] IN ('CANCELED', 'IN_PROGRESS', 'NOT_STARTED', 'ON_HOLD') THEN 'Open'
		WHEN Status__c = 'COMPLETE' THEN 'Completed'
		ELSE NULL
		END
		AS 'Status__c'
	,Type__c

  INTO sfdc.HealthCheck_T
FROM sfdc.HealthCheck_E;
/*
DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.HealthCheck_T)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '16_01_02';
*/