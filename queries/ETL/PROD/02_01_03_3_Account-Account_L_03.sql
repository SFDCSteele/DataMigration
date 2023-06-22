--  Account-Account_L_03.sql Account RT Account update ParentId
--  Lookup Account.Id value for Update / Upsert 
--  Lookup and add ParentId value where PAR_AIMS_ACCT__c <> null in Account-Account_L_03
--  ALSO MUST run L_04 to add PrimaryContactId__c
--  LAST RUN:  230522 prod

USE Salesforce

DECLARE 
    @ABTSupportId AS VARCHAR(18) = NULL,
    @RecordTypeId AS VARCHAR(20) = NULL,
    @RecordCount AS INT = NULL

--	Obtain User.Id value for User.Alias = 'ABTSuppt'
SET @ABTSupportId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_User_prod]
    WHERE Alias = 'ABTSuppt')

--  SET PER ENVIRONMENT
SET @RecordTypeId = 
	(SELECT Id 
--  SET CORRECT TABLE NAME BELOW !!
    FROM sfdc.[Id_RecordType_prod]
    WHERE DeveloperName = 'Account' AND IsActive = 'true')

	DROP TABLE sfdc.Account_Account_L_03
SELECT   --TOP 10000
    CASE
        WHEN (E.AIMSAccount__c IS NOT NULL) AND A.AIMSAccount__c <> A.PAR_AIMS_ACCT__c THEN E.Id
        ELSE NULL
        END
		AS 'ParentId'
     ,F.Id

  INTO sfdc.Account_Account_L_03
FROM sfdc.Account_Account_T AS A
/*LEFT JOIN sfdc.[Id_User_prod] AS B -- for OwnerId
ON A.OwnerCorpEmplId__c = B.CorpEmplId__c

LEFT JOIN sfdc.[Id_User_prod] AS C -- for CreatedById
ON TRIM(A.CreatedById) = TRIM(C.Alias)

LEFT JOIN sfdc.[Id_User_prod] AS D -- for LastModifiedById
ON TRIM(A.LastModifiedById) = TRIM(D.Alias)
*/
LEFT JOIN sfdc.[Id_Account_prod] AS E -- lookup Parent Account Id value 
ON TRIM(A.PAR_AIMS_ACCT__c) = TRIM(E.AIMSAccount__c) AND E.RecordTypeId = @RecordTypeId 

LEFT JOIN sfdc.[Id_Account_prod] AS F -- lookup Account Id value
ON A.AIMSAccount__c = F.AIMSAccount__c AND F.RecordTypeId = @RecordTypeId
WHERE ((E.AIMSAccount__c IS NOT NULL) AND A.AIMSAccount__c <> A.PAR_AIMS_ACCT__c)
ORDER BY E.ID

