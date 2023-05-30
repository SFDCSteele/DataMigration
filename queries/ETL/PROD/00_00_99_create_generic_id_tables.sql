--  Account-Account_L_01.sql Account RT Account target object view load query to table Account_Account_L
--  Lookup of B.OwnerId, C.CreatedById, and D.LastModifiedById for respective org.User
--  lAST RUN:   230516 prod

USE Salesforce


DROP Table sfdc.[Id_User_prod]

select * 
    INTO sfdc.[Id_User_prod]
from sfdc.[Id_User_prod]

DROP Table sfdc.[Id_Account_prod]

select * 
    INTO sfdc.[Id_Account_prod]
from sfdc.[Id_Account_prod]

DROP Table sfdc.[Id_Contact_prod]

select * 
    INTO sfdc.[Id_Contact_prod]
from sfdc.[Id_Contact_prod]
DROP Table sfdc.[Id_AccountContactRelation_prod]


select * 
    INTO sfdc.[Id_AccountContactRelation_prod]
from sfdc.[Id_AccountContactRelation_prod_230518-1139]


CREATE TABLE sfdc.Migration_Status (
    stepsID varchar(50) ,
    description varchar(255),
    action varchar(255),
    startDateTime datetime,
    endDateTime dateTime,
    recordCount int,
    status varchar(255) 
);

create index Migration_Status_Index
    on sfdc.[Migration_Status](stepsID);

