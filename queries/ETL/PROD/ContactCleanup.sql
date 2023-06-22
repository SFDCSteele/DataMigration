WITH 

dups AS 
   (SELECT CONTACTINTEGRATIONID__C
          ,count(*) AS dup_count
      FROM osc.contact_dup_check
     WHERE contactintegrationid__c > ''
     GROUP BY CONTACTINTEGRATIONID__C
    HAVING count(*) > 1)

,contact_with_primary_account as
   (SELECT c.ID
          ,a.ID as ACCOUNTID
          ,c.CONTACTINTEGRATIONID__C
      FROM osc.contact_dup_check c
      JOIN dups d
        on c.CONTACTINTEGRATIONID__C = d.CONTACTINTEGRATIONID__C
      JOIN dbo.Account a
        ON a.Id = C.ACCOUNTID
      JOIN (SELECT * FROM osc.contact_relationship_seed
                 UNION
                 SELECT * FROM oscd.CONTACT_RELATIONSHIP_seed) s
        ON s.AIMS_ACCT = a.AIMSAccount__c
       AND s.relationship = 'ACCOUNT_TO_CONTACT'
       AND s.contactintegrationid = c.CONTACTINTEGRATIONID__C
       and s.primaryflag = 1)

,contacts_to_delete as
   (SELECT c.*
      FROM osc.contact_dup_check c
      JOIN dups d
        on c.CONTACTINTEGRATIONID__C = d.CONTACTINTEGRATIONID__C
      JOIN dbo.Account a
        ON a.Id = C.ACCOUNTID
      JOIN (SELECT * FROM osc.contact_relationship_seed
                 UNION
                 SELECT * FROM oscd.CONTACT_RELATIONSHIP_seed) s
        ON s.AIMS_ACCT = a.AIMSAccount__c
       AND s.relationship = 'ACCOUNT_TO_CONTACT'
       AND s.contactintegrationid = c.CONTACTINTEGRATIONID__C
       and s.primaryflag = 0)


,relationships_to_add_back as
   (SELECT p.ID
          ,d.ACCOUNTID
          ,cast(0 as bit) as PrimaryFlag
      FROM contacts_to_delete d
      join contact_with_primary_account p
        on p.CONTACTINTEGRATIONID__C = d.CONTACTINTEGRATIONID__C
       and p.ACCOUNTID <> d.ACCOUNTID /* exclude if account matches, i.e. already related*/
       )



/* TO GET THE DELETES
SELECT * FROM contacts_to_delete 
*/

/* TO GET THE RELATIONSHIP ADD BACKS
SELECT * FROM relationships_to_add_back
*/