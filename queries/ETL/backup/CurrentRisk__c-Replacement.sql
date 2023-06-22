,REPLACE( -- INSERT 	3	more REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
		REPLACE(CurrentRisk__c, ',', ';')
		,'BUSINESS IS DOWN', 'Business is down')
		,'CHANGE IN PERSONNEL', 'Change in personnel')
		,'CLAIMS', 'Claims')
		,'COMPANY CLOSED', 'Company closed')
		,'COMPANY WAS PURCHASED', 'Company was purchased')
		,'CUSTOMER IS NOT AT RISK', 'Customer is not at risk')
		,'CUSTOMER NOT RESPONDING/UNWILL', 'Customer not responding/Unwilling to meet')
		,'I DON''T KNOW THE REASON', 'I don''t know the reason')
		,'LOCATION CLOSED', 'Location closed')
		,'OTHER PLEASE LEAVE COMMENT', 'Other - Please leave comment')
		,'PRICE', 'Price')
		,'PRICE CMC SPECIFIC', 'Price - CMC specific')
		,'SEASONAL', 'Seasonal')
		,'SERVICE', 'Service')
	AS "CurrentRisk__c"  -- multi-select picklist	
