--  Account-Account_L_01.sql Account RT Account target object view load query to table Account_Account_L
--  Lookup of B.OwnerId, C.CreatedById, and D.LastModifiedById for respective org.User
--  lAST RUN:   230516 fulldata

USE Salesforce


DROP Table sfdc.[Id_User_fullData]

select * 
    INTO sfdc.[Id_User_fullData]
from sfdc.[Id_User_fullData_230524-1448]

DROP Table sfdc.[Id_Account_fullData]

select * 
    INTO sfdc.[Id_Account_fullData]
from sfdc.[Id_Account_fullData_230524-2012]

DROP Table sfdc.[Id_Contact_fullData]

select * 
    INTO sfdc.[Id_Contact_fullData]
from sfdc.[Id_Contact_fullData_230518-0928]
DROP Table sfdc.[Id_AccountContactRelation_fullData]


select * 
    INTO sfdc.[Id_AccountContactRelation_fullData]
from sfdc.[Id_AccountContactRelation_fullData_230518-1139]


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

