--	Contact_E.sql Contact target object view extraction query to table Contact_E
USE Salesforce;

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'05_01_03'
	,'Contact E (extract)'
	,'Extract'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);


DROP TABLE sfdc.Contact_E
SELECT --top 1000--TOP 0.1 PERCENT
	ContactIntegrationId AS 'ContactIntegrationId__c' 
	, ContactAddrIntegrationId AS 'ContactAddrIntegrationId__c' 
	, FirstName AS 'FirstName' 
	, LastName AS 'LastName' 
	, OwnerCorpEmplId AS 'OwnerCorpEmplId__c' 
	, SalutoryIntroduction AS 'Salutation' 
	, Comments AS 'Comment__c' 
	, DoNotCallFlag AS 'DoNotCall' 
	, DoNotContactFlag AS 'DoNotContact__c' 
	, DoNotEmailFlag AS 'HasOptedOutOfEmail' 
	, DoNotMailFlag AS 'DoNotMail__c' 
	, JobTitle AS 'Title' 
	, CreatedBy AS 'CreatedById' 
    ,LEFT(CreationDate, 19) AS "CreatedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    ,LEFT(LastUpdateDate, 19) AS "LastModifiedDate" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
	, LastUpdatedBy AS 'LastModifiedById' , WorkPhoneExtension AS 'PhoneExtension__c' 
	, RawWorkPhoneNumber AS 'Phone' 
	, RawMobileNumber AS 'MobilePhone' 
	, FaxExtension AS 'FaxExtension__c' 
	, RawFaxNumber AS 'Fax' 
	, EmailAddress AS 'Email' 
	, PersonDEO_PantherResponsibility_c AS 'Responsibility' 
    --,Address1 + CHAR(13) + CHAR(10) + Address2 AS "MailingStreet" -- concatenate address lines w/ CR/LF between
	,CASE -- check for nulls prior to concatenation
		WHEN Address1 IS NULL AND Address2 IS NULL THEN NULL
		WHEN Address1 IS NOT NULL AND Address2 IS NULL THEN Address1
		WHEN Address1 IS NULL AND Address2 IS NOT NULL THEN Address2
		ELSE CONCAT(TRIM(Address1), ' ', Address2) -- 230425 per H. Sibal
		END
		AS "MailingStreet" -- concatenate address lines w/ CR/LF between	
    ,City AS "MailingCity"
    ,[State] AS "MailingState"
	, [StateCode] AS 'MailingStateCode' 
	, Country AS 'MailingCountry' 
    , CountryCode AS "MailingCountryCode"
	, PostalCode AS 'MailingPostalCode' 
	, Province AS 'MailingProvince__c' 
	, latitude AS 'MailingLatitude' 
	, longitude AS 'MailingLongitude' 
	, AddressType AS 'AddressType__c' 
	, PersonDEO_ABFFAffinity_c AS 'Affinity__c' 
	, PersonDEO_PantherBuyingRole_c AS 'PantherBuyingRole__c' 
	, PersonDEO_OmegaStatus_c AS 'OmegaStatus__c' 
	, PersonDEO_PantherInfluenceLevel_c AS 'PantherInfluenceLevel__c' 
	, PersonDEO_PreferredName_c AS 'PreferredName__c' 
	, OwnerCorpEmplId AS 'OwnerCorpEmplId' 
	, PersonDEO_Source_c AS 'Source__c' 
	, PersonDEO_OmegaIsAccepted_c AS 'OmegaIsAccepted__c' 
	, PersonDEO_NumberOfFormSubmissions_c AS 'NumberOfFormSubmissions__c' 
	, PersonDEO_NumberOfPageviews_c AS 'NumberOfPageviews__c' 
	, PersonDEO_MarketingEmailsReplied_c AS 'MarketingEmailsReplied__c' 
	, PersonDEO_MarketingAutomationContactId_c AS 'MarketingAutomationContactId__c' 
	, PersonDEO_MarketingEmailsClicked_c AS 'MarketingEmailsClicked__c' 
	, PersonDEO_MarketingEmailsOpened_c AS 'MarketingEmailsOpened__c' 
	, PersonDEO_AlternateEMail_c AS 'AlternateEmail__c' 
    ,LEFT(PersonDEO_OmegaExpirationDate_c,19) AS "OmegaExpirationDate__c" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
	, PersonDEO_NumberOfSessions_c AS 'NumberOfSessions__c' 
    ,LEFT(PersonDEO_OmegaInviteDate_c,19) AS "OmegaInviteDate__c" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    ,LEFT(PersonDEO_OmegaAcceptedDate_c,19) AS "OmegaAcceptedDate__c" -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00

 INTO sfdc.Contact_E
--FROM osc.CONTACT_SEED -- base load tables
FROM oscd.CONTACT_SEED -- delta load tables
--where Address1 IS NULL

DECLARE 
    @RecordCount AS INT = NULL


--  SET PER ENVIRONMENT
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Contact_E)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '05_01_03';
