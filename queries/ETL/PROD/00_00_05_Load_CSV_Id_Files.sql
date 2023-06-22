/*
Id_User_prod
Id_Contact_prod
Id_AccountContactRelation_prod
Id_Account_prod
Id_Opportunity_prod
*/
Use Salesforce
TRUNCATE TABLE sfdc.Id_User_prod;
GO
 
-- import the file
BULK INSERT sfdc.Id_User_prod
FROM 'C:\Users\U87BSTE\OneDrive - ArcBest\Data Migration\export_files\Id_User_prod.csv'
WITH
(
        FORMAT='CSV',
        FIRSTROW=2
)
GO
select count(*) from sfdc.Id_User_prod