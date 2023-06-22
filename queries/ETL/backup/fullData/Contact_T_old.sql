-- Contact_T.sql Contact target object view transformation query to table Contact_T
USE Salesforce
  DROP TABLE sfdc.Contact_E2
SELECT 
	A.[ContactIntegrationId__c]
	, B.AIMS_ACCT AS 'AccountId'
	, B.PrimaryFlag AS 'IsDirect'
  INTO sfdc.Contact_E2

  FROM [sfdc].[Contact_E] AS A

  LEFT JOIN osc.CONTACT_RELATIONSHIP_SEED AS B-- for Account__c
	ON A.[ContactIntegrationId__c] = B.[ContactIntegrationId]

  Where B.PrimaryFlag = 1
  group by A.[ContactIntegrationId__c],B.AIMS_ACCT,B.PrimaryFlag;

--  DROP TABLE sfdc.Contact_T
SELECT  -- TOP 0.1 PERCENT 
	A.ContactIntegrationId__c 
	, B.ContactAddrIntegrationId__c 
	, A.AccountId
	,CASE	
		WHEN A.IsDirect = 1 THEN 'true'
		WHEN A.IsDirect = 0 THEN 'false'
		ELSE 'false'
		END
		AS "IsDirect"
	, REPLACE(REPLACE(B.FirstName,',',';'),'"','''' ) AS FirstName 
	, B.LastName 
	, B.OwnerCorpEmplId__c 
	, B.Salutation 
	, REPLACE(REPLACE(B.Comment__c,',',';'),'"','''' ) AS Comment__c 
	, B.DoNotCall 
	, B.[DoNotContact__c] 
	, B.HasOptedOutOfEmail 
	, B.[DoNotMail__c] 
	, B.Title 
	, B.CreatedById 
	, B.CreatedDate 
	, B.LastModifiedDate 
	, B.LastModifiedById 
	, B.PhoneExtension__c 
	, B.Phone 
	, B.MobilePhone 
	, B.FaxExtension__c 
	, B.Fax 
	, B.Email 
	, SUBSTRING(B.Responsibility,0,80) AS 'Responsibility'
	, B.MailingStreet 
	, B.MailingCity 
	, B.MailingCountry 
	, B.MailingPostalCode 
	, B.MailingStateCode 
	, B.MailingProvince__c 
	, B.MailingLatitude 
	, B.MailingLongitude 
    ,REPLACE(B.AddressType__c,',',';') AS AddressType__c
	, B.Affinity__c 
	, B.PantherBuyingRole__c 
	, B.OmegaStatus__c 
	, B.PantherInfluenceLevel__c 
	, REPLACE(REPLACE(B.PreferredName__c,',',';'),'"','''' ) AS PreferredName__c 
	, B.OwnerCorpEmplId 
	, B.Source__c 
	, B.OmegaIsAccepted__c 
	, B.NumberOfFormSubmissions__c 
	, B.NumberOfPageviews__c 
	, B.MarketingEmailsReplied__c 
	, B.MarketingAutomationContactId__c 
	, B.MarketingEmailsClicked__c 
	, B.MarketingEmailsOpened__c 
	, B.AlternateEmail__c 
	, B.OmegaExpirationDate__c 
	, B.NumberOfSessions__c 
	, B.OmegaInviteDate__c 
	, B.OmegaAcceptedDate__c 
	
--  INTO sfdc.Contact_T
FROM sfdc.Contact_E2 AS A
  LEFT JOIN sfdc.[Contact_E] AS B-- for Account__c
	ON A.[ContactIntegrationId__c] = B.[ContactIntegrationId__c]

	--Order by A.[ContactIntegrationId__c],A.AccountId
	Order by A.AccountId
;
