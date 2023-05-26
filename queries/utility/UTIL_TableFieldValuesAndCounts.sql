-- Field Values
USE Salesforce
DECLARE		@Schema as varchar(50) = NULL
DECLARE 	@Table as varchar(50) = NULL
DECLARE 	@Field as varchar(50) = null
DECLARE 	@SQL as varchar(4800) = null

	SET @Schema = 'sfdc'
	SET @Table = 'HealthCheck_E_UAT'
	SET @Field = 'Type__c'

SET @SQL = 'select ' + @Field + ', count(' + @Field + ') as Count from Salesforce.' + @Schema + '.' + @Table + ' group by ' + @Field + ' order by '+ @Field
EXEC (@SQL)