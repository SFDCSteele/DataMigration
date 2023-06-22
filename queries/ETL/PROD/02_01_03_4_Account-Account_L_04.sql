--  Account-Account_L_04.sql updates Account RT Account target object view load query to table Account_Account_L_04
--  Update to populate Account.PrimaryContactID__c from AccountContactRelation data.
--  LAST RUN:  230523

USE Salesforce


DECLARE 
    @RecordCount AS INT = NULL


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'02_01_03_4'
	,'Account RT Account L (Load)'
	,'Load Account RT Account - Primary Contact Id'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

	DROP TABLE sfdc.Account_Account_L_04
SELECT  --TOP 10000
    AccountId AS Id
    ,ContactId AS PrimaryContactID__c -- will lookup Contact from PACEPrimaryContactPartyId__c  in Account-Account_L_04.sql

  INTO sfdc.Account_Account_L_04
FROM sfdc.[Id_AccountContactRelation_prod]
WHERE IsDirect__c = 'true' AND RelationshipDirection__c = 'CONTACT_TO_ACCOUNT' --alternative to 'ACCOUNT_TO_CONTACT'


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Account_L_04)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '02_01_03_4';

/*


DECLARE 
    @RecordCount AS INT = NULL


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

DECLARE 
    @RecordCount AS INT = NULL


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

DECLARE 
    @RecordCount AS INT = NULL


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

DECLARE 
    @RecordCount AS INT = NULL


Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'04_01_01_1'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

*/