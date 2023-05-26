
use Salesforce


--	analysis query for confirming field and field values maps
select top 200
AIMS_ACCT
,CreationDate
,ChurnQuestion2_c
,DueDate
,AIMSLocations_c
,ChurnQuestion4_c
,Subject
,OwnercorpEmplId
,ActivityId
,StatusCode
,InternalType_c
,CreatedBy
,LastUpdateDate
,LastUpdatedBy

from osc.activity_seed
where ActivityFunctionCode = 'TASK' and InternalType_c = 'CUSTOMER_CHURN'
-- END


select Name, len(Name) -- max(len(Name))
from sfdc.HealthCheck_T_UAT
group by Name
order by len(Name) DESC

