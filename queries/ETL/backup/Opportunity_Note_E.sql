--	Opportunity_Note_E.sql Account RT Account target object view extraction query to table Opportunity_Note_E
USE Salesforce;
 --DROP TABLE sfdc.Opportunity_Note_E

SELECT --TOP 1000 
    OptyId AS 'PACE_OpportunityId__c' 
    , OptyId AS 'ParentId' 
    , CreatedBy AS 'CreatedById' 
    , LEFT(CreationDate, 19) AS 'CreatedDate' -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , LEFT(LastUpdateDate, 19) AS 'LastModifiedDate' -- reformat for SF 2015-12-27 00:00:00.0000000 to 2015-12-27 00:00:00
    , LastUpdatedBy AS 'LastModifiedById' 
    , NoteTxt AS 'Body'

 --INTO sfdc.Opportunity_Note_E
FROM osc.OPPORTUNITY_NOTE_SEED 
Order by OptyId
