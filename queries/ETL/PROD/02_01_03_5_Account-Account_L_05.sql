--  Account-Account_L_05.sql updates target object Account_Account_L_05
--  Update to populate Account.ShippingAddress component fields 
--      from Account_Location_T.ShippingAddress component fields
--      where PrimaryLocation__c = 'true'
--  LAST RUN:  230525 prod delta

USE Salesforce

DECLARE 
    @RecordTypeId AS VARCHAR(20) = NULL,
    @RecordCount AS INT = NULL

--  SET PER ENVIRONMENT
SET @RecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'02_01_03_5'
	,'Account RT Account L (Load)'
	,'Load Account RT Account - Shipping Address'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

	DROP TABLE sfdc.Account_Account_L_05
SELECT  --TOP 10000
    A.Id
    ,ShippingStreet
    ,ShippingCity
    ,ShippingStateCode
    ,ShippingCountryCode
    ,ShippingPostalCode
    ,ShippingProvince__c
    ,ShippingLatitude
    ,ShippingLongitude

  INTO sfdc.Account_Account_L_05
FROM sfdc.[Id_Account_prod] AS A
INNER JOIN sfdc.Account_Location_T AS B -- verify this works on base load too!!!!!
ON A.AIMSAccount__c = B.AIMSAccount__c AND B.PrimaryLocation__c = 'true'
WHERE A.RecordTypeId = @RecordTypeId




--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Account_L_05)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '02_01_03_5';

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
	'02_01_03'
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
	'02_01_03'
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
	'02_01_03'
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
	'02_01_03'
	,'Account_Team_Member E (Extract)'
	,'Extract Account Primary'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

*/