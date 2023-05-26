--	Delta_rowcounts_230524.sql
--	Check osc vs oscd rowcounts for required source SEED tables

use Salesforce
select count(*)
--from osc.account_seed -- 278093
--from oscd.account_seed  -- 3941
--from osc.account_location_seed -- 741308
from oscd.account_location_seed  -- 5583
--from osc.activity_seed -- 1905572
--from oscd.activity_seed  -- 5513
--from osc.activity_team_seed -- 2009919
--from oscd.activity_team_seed -- 6032
--from osc.activity_contact_seed -- 1165549
--from oscd.activity_contact_seed -- 1692
--from osc.contact_seed -- 484957
--from oscd.contact_seed  -- 4721
--from osc.contact_relationship_seed -- 991038
--from oscd.contact_relationship_seed  -- 6544
--from osc.opportunity_seed -- 159109
--from oscd.opportunity_seed  -- 1552
--from osc.OPPORTUNITY_CONTACT_SEED -- 135637
--from oscd.OPPORTUNITY_CONTACT_SEED  -- 353
--from osc.OPPORTUNITY_TEAM_SEED -- 203153
--from oscd.OPPORTUNITY_TEAM_SEED -- 2495
--from osc.resource_seed -- 1868
--from oscd.resource_seed  -- 1868
