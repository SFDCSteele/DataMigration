use Salesforce

select a.PartyID, a.AddressId, b.PartyID, b.AddressId
from osc.ACCOUNT_ADDRESS as a
inner join osc.account_address as b
on a.PartyId = b.AddressId

select a.PartyID, b.PartyID, b.AddressId
from osc.ACCOUNT as a
inner join osc.account_address as b
on a.PartyId = b.PartyId

select b.PartyID, count(b.partyid)
from osc.ACCOUNT_ADDRESS as b
group by b.PartyId

select distinct PartyId
from osc.account_address


select a.PartyID, b.SourceObjectId, b.CreatedBy, b.PartyID, b.NoteId
from osc.ACCOUNT as a
inner join osc.ACCOUNT_NOTE as b
on a.PartyId = b.SourceObjectId

select top 100 PartyId
from osc.account_address
union
select top 100 PartyId
from osc.contact_address

select DISTINCT a.PartyId, a.LocationId, b.PartyId, b.LocationId
from osc.account_address as a
INNER JOIN osc.contact_address as b
ON a.LocationId = b.LocationId
-- note overlaps

-- list table.column metadata attributes in ArcBest data dictionary worksheet order
select TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_PRECISION_RADIX, NUMERIC_SCALE, DATETIME_PRECISION
from Salesforce.INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = N'account_address_seed' AND TABLE_SCHEMA = N'osc'
order by ORDINAL_POSITION

	-- list schemas in database
select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
order by s.name

select Province, State
from osc.CONTACT_ADDRESS
where Province <> State


SELECT TimezoneCode, count(TimezoneCode)
from osc.RESOURCE
group by TimezoneCode

