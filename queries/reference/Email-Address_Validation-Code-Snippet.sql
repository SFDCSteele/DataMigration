--  RC230331 I discovered that this does NOT currently cover this case:  anytext@anytext@.com
--  RC230407 modified to cover case above
WHERE 
    InvoicingEmail__c LIKE '%_@__%.__%' 
    AND PATINDEX('%[^a-z,0-9,@,.,_]%', REPLACE(InvoicingEmail__c, '-', 'a')) = 0
    AND LEN(InvoicingEmail__c) - LEN(REPLACE(InvoicingEmail__c,'@','')) = 1
