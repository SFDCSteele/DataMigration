use salesforce

select top 500
	Address1
	,Address2
	,City
	,StateCode
	,CountryCode
    ,LEFT(CONCAT(TRIM(Address1), ' ', TRIM(Address2), ' ', TRIM(City), ' ', TRIM(StateCode), ', ', TRIM(CountryCode)), 255)
        AS [Name] -- PK & DS 230419  


FROM osc.account_location_seed