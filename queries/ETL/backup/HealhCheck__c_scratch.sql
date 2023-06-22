use Salesforce

select max(len(Subject))
--select  distinct ActivityId
from osc.activity_seed
Where ActivityFunctionCode = 'TASK' AND StatusCode <> 'CANCELED' AND InternalType_c = 'CUSTOMER_CHURN'


select max(len(Subject))
from osc.activity_seed
