-- Contact_T.sql Contact target object view transformation query to table Contact_T
USE Salesforce

  DROP TABLE sfdc.Contact_T
SELECT  -- TOP 0.1 PERCENT 
	ContactIntegrationId__c 
	, ContactAddrIntegrationId__c 
	--, REPLACE(REPLACE(FirstName,',',';'),'"','''' ) AS FirstName 
	, FirstName AS FirstName 
	, LastName 
	, OwnerCorpEmplId__c 
	, Salutation 
	--, REPLACE(REPLACE(Comment__c,',',';'),'"','''' ) AS Comment__c 
	, Comment__c AS Comment__c 
	, DoNotCall 
	, [DoNotContact__c] 
	, HasOptedOutOfEmail 
	, [DoNotMail__c] 
	, Title 
	, CreatedById 
	, CreatedDate 
	, LastModifiedDate 
	, LastModifiedById 
	, PhoneExtension__c 
	, Phone 
	, MobilePhone 
	, FaxExtension__c 
	, Fax 
    ,CASE
        WHEN Email LIKE '%_@__%.__%' AND 
            PATINDEX('%[^a-z,0-9,@,.,_]%', REPLACE(Email, '-', 'a')) = 0 AND
            LEN(Email) - LEN(REPLACE(Email,'@','')) = 1 THEN Email
        WHEN Email IS NULL THEN NULL
        ELSE 'BadEmail@BadEmail.com'
        END
        AS "Email" -- REGEX test
	--, Email 
	, SUBSTRING(Responsibility,0,80) AS 'Responsibility'
	, MailingStreet 
	, MailingCity 
	, MailingState
	, MailingStateCode 
	, MailingCountry 
	, MailingCountryCode
	, MailingPostalCode 
	, MailingProvince__c 
	, MailingLatitude 
	, MailingLongitude 
    ,REPLACE(AddressType__c,',',';') AS AddressType__c
	, Affinity__c 
	, PantherBuyingRole__c 
	, OmegaStatus__c 
	, PantherInfluenceLevel__c 
	--, REPLACE(REPLACE(PreferredName__c,',',';'),'"','''' ) AS PreferredName__c 
	, PreferredName__c AS PreferredName__c 
	, OwnerCorpEmplId 
	, Source__c 
	, OmegaIsAccepted__c 
	, NumberOfFormSubmissions__c 
	, NumberOfPageviews__c 
	, MarketingEmailsReplied__c 
	, MarketingAutomationContactId__c 
	, MarketingEmailsClicked__c 
	, MarketingEmailsOpened__c 
	, AlternateEmail__c 
	, OmegaExpirationDate__c 
	, NumberOfSessions__c 
	, OmegaInviteDate__c 
	, OmegaAcceptedDate__c 
	
  INTO sfdc.Contact_T
FROM sfdc.Contact_E
