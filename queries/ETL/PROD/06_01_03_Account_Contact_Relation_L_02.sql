--  Account_Contact_Relation_L_02.sql Account Contact Relationship target object view load query to table Account_Contact_Relation_L
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
	'06_01_03_2'
	,'Account Contact Relation L (Load)'
	,'Load for Update'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);
*/
DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @AccountAccountRecordTypeId AS VARCHAR(20) = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @AccountAccountRecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

	DROP TABLE sfdc.Account_Contact_Relation_L_01

SELECT --TOP,  0.3 PERCENT
	E.ID
	, C.Id AS 'AccountId'
    , A.AIMSAccount__c     
    --, E.AIMSAccount__c     
    , A.ContactIntegrationId__c 
    --, E.ContactIntegrationId__c 
	, D.Id AS 'ContactId'
    , A.RelationshipDirection__c 
    , A.IsDirect 
    , A.Primary__c 
    , A.Roles 
    , A.Role__c 

  INTO sfdc.Account_Contact_Relation_L_01
FROM sfdc.Account_Contact_Relation_T AS A

LEFT JOIN sfdc.[Id_Account_prod] AS C-- for Account__c
ON TRIM(A.AIMSAccount__c) = TRIM(C.AIMSAccount__c)  AND C.RecordTypeId = @AccountAccountRecordTypeId

LEFT JOIN sfdc.[Id_Contact_prod] AS D-- for Contact__c
ON TRIM(A.ContactIntegrationId__c) = TRIM(D.ContactIntegrationId__c)

LEFT JOIN sfdc.[Id_AccountContactRelation_prod] AS E
ON D.Id = E.CONTACTID AND C.Id = E.ACCOUNTID


Where C.Id Is NOT NULL AND D.Id Is NOT NULL 
		--AND C.Id LIKE '07k77000008tvFl%' OR D.Id LIKE '07k77000008tvFl%' OR E.Id LIKE '07k77000008tyqg' --'07k77000008tvWw'
		AND E.ID is not null AND A.Primary__c = 'true'  --comment this is for updating the primary (record Id is NOT null)
		--AND E.ID is  null --AND A.Primary__c = 'false'  --comment this is for inserting the secondary (record Id is null)
        --AND IsDirect__c = 'true' AND RelationshipDirection__c = 'CONTACT_TO_ACCOUNT' --alternative to 'ACCOUNT_TO_CONTACT'
        AND A.RelationshipDirection__c = 'CONTACT_TO_ACCOUNT' --alternative to 'ACCOUNT_TO_CONTACT'
--order by C.Id, D.Id
order by D.Id, C.Id

/*
DECLARE 
    @RecordCount AS INT = NULL

--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Account_Contact_Relation_L_02)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '06_01_03_2';
*/