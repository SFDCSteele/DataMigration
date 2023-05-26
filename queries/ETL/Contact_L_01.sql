--  Contact_L_01.sql Contact target object view load query to Contact_L
USE Salesforce

  DROP TABLE sfdc.Contact_L_01_A
  DROP TABLE sfdc.Contact_L_01

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_fullData_230516-1405]
    WHERE Alias = 'ABTSuppt')

SELECT   --TOP 0.1 PERCENT 
	--count(*)
	 A.ContactIntegrationId__c 
	, E.Id AS 'AccountId' 
	
  INTO sfdc.Contact_L_01_A
FROM sfdc.Contact_T AS A
LEFT JOIN sfdc.Account_Contact_Relation_T AS B-- for Account__c
ON TRIM(A.ContactIntegrationId__c) = TRIM(B.ContactIntegrationId__c) 

LEFT JOIN sfdc.[Id_Account_fullData_230516-1655] AS E-- for Account__c
ON TRIM(B.AIMSAccount__c) = TRIM(E.[AIMSAccount__c]) AND E.RecordTypeId = '012770000004LOvAAM'

where B.Primary__c = 'true'
--order by E.Id
group by A.ContactIntegrationId__c, E.Id

SELECT  -- TOP 0.1 PERCENT 
	A.ContactIntegrationId__c 
	, A.ContactAddrIntegrationId__c
	--, A.AccountId
	, E.AccountId 
	--, E.RecordTypeId
	, A.FirstName AS 'FirstName' 
	, A.LastName AS 'LastName' 
	, A.OwnerCorpEmplId__c 
	,CASE
		WHEN B.Alias IS NULL THEN @ABTSupportId
		ELSE B.Id
		END
		AS 'OwnerId'
	, A.Salutation 
	, A.Comment__c 
	, A.DoNotCall 
	, A.[DoNotContact__c] 
	, A.HasOptedOutOfEmail 
	, A.[DoNotMail__c] 
	, A.Title 
	,CASE
		WHEN C.Alias IS NULL THEN @ABTSupportId
		ELSE C.Id
		END
		AS 'CreatedById'
	, A.CreatedDate 
	,CASE
		WHEN D.Alias IS NULL THEN @ABTSupportId
		ELSE D.Id
		END
		AS 'LastModifiedById'
	, A.LastModifiedDate 
	, A.PhoneExtension__c 
	, A.Phone 
	, A.MobilePhone 
	, A.FaxExtension__c 
	, A.Fax 
	, A.Email 
	, A.Responsibility
	, A.MailingStreet 
	, A.MailingCity 
	, A.MailingState 
	, A.MailingStateCode 
	, A.MailingCountry 
	, A.MailingCountryCode 
	, A.MailingPostalCode 
	, A.MailingProvince__c 
	, A.MailingLatitude 
	, A.MailingLongitude 
	, A.AddressType__c 
	, A.Affinity__c 
	, A.PantherBuyingRole__c 
	, A.OmegaStatus__c 
	, A.PantherInfluenceLevel__c 
	, A.PreferredName__c 
	, A.OwnerCorpEmplId 
	, A.Source__c 
	, A.OmegaIsAccepted__c 
	, A.NumberOfFormSubmissions__c 
	, A.NumberOfPageviews__c 
	, A.MarketingEmailsReplied__c 
	, A.MarketingAutomationContactId__c 
	, A.MarketingEmailsClicked__c 
	, A.MarketingEmailsOpened__c 
	, A.AlternateEmail__c 
	, A.OmegaExpirationDate__c 
	, A.NumberOfSessions__c 
	, A.OmegaInviteDate__c 
	, A.OmegaAcceptedDate__c 
	
  INTO sfdc.Contact_L_01
FROM sfdc.Contact_T AS A

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS B -- for OwnerId
ON A.OwnerCorpEmplId__c = B.CorpEmplId__c AND B.CorpEmplId__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS C -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(C.Alias) and C.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Id_User_fullData_230516-1405] AS D -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(D.Alias) and D.CorpEmplID__c IS NOT NULL

LEFT JOIN sfdc.[Contact_L_01_A] AS E-- for Account__c
ON TRIM(A.ContactIntegrationId__c) = TRIM(E.[ContactIntegrationId__c]) --AND E.RecordTypeId = '012770000004LOvAAM'

order by E.AccountId
