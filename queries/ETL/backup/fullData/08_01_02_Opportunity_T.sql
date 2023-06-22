-- Opportunity_T.sql
--  LAST RUN:  230517 fulldata

USE Salesforce

Insert INTO sfdc.Migration_Status (
    stepsID
    ,description
    ,action
    ,startDateTime
    --,endDateTime
    ,recordCount
    ,status 
) values (
	'08_01_02'
	,'Opportunity E (Transform)'
	,'Transform'
	,GETDATE()
	--,''
	,0
	,'STARTED'
);

  DROP TABLE sfdc.Opportunity_T

SELECT --TOP 1 PERCENT
    LEFT([Name], 120) AS "Name"
--    ,Id -- lookup from Opportunity in Opportunity_L_02
--    ,ContactId-- lookup from OpportunityTeamMember in Opportunity_L_02
    ,PACE_OpportunityID__c
    ,PACE_OpportunityRevenueId__c
    ,CASE	
        WHEN Type = 'Cross Sell' THEN 'Cross Sell'
        WHEN Type = 'Expand' THEN 'Expand'
        WHEN Type = 'EXPANSION' THEN 'Expand'
        WHEN Type = 'New' THEN 'New Customer'
        WHEN Type = 'RENEW' THEN 'Retain'
        WHEN Type = 'Retain' THEN 'Retain'
        ELSE 'New Customer'
        END
        AS "Type" -- Picklist
    ,AccountId -- lookup in Opportunity_L_01
    ,AIMSAccount__c
    ,OwnerId -- lookup in Opportunity_L_01
    ,OwnerCorpEmplId__c
    ,CASE
        WHEN CreatedById = 'ABTSupport' THEN 'ABTSuppt'
        ELSE CreatedById
        END
        AS "CreatedById" -- lookup in Opportunity_L_01
    ,CreatedDate
    ,CASE
        WHEN LastModifiedById = 'ABTSupport' THEN 'ABTSuppt'
        ELSE LastModifiedById
        END
        AS "LastModifiedById" -- lookup in Opportunity_L_01
    ,LastModifiedDate
    ,CloseDate 
--    ,f(CloseDate) AS "Fiscal" -- associated fiscal qtr or period -- depends on Fiscal Year decision DM
,CASE	
	WHEN StageName = '01-Discovery' THEN 'Discovery'
	WHEN StageName = '01-Initial Renewal Evaluation' THEN 'Initial Evaluation'
	WHEN StageName = '01-Qualification' THEN 'Qualify'
	WHEN StageName = '02-Needs Analysis' THEN 'Needs Analysis'
	WHEN StageName = '02-Negotiation' THEN 'Negotiation'
	WHEN StageName = '02-Qualification' THEN 'Qualify'
	WHEN StageName = '03-Needs Analysis' THEN 'Needs Analysis'
	WHEN StageName = '03-Negotiation' THEN 'Negotiation'
	WHEN StageName = '03-Onboarding' THEN 'Onboarding'
	WHEN StageName = '04-Closed Won' THEN 'Closed Won'
	WHEN StageName = '04-Negotiation' THEN 'Negotiation'
	WHEN StageName = '04-Onboarding' THEN 'Onboarding'
	WHEN StageName = '05-Closed Won' THEN 'Closed Won'
	WHEN StageName = '05-Onboarding' THEN 'Onboarding'
	WHEN StageName = '06-Closed Won' THEN 'Closed Won'
	WHEN StageName = 'Create Solution' AND StatusCode__c = 'OPEN' THEN 'Needs Analysis'
	WHEN StageName = 'Create Solution' AND StatusCode__c = 'WON' THEN 'Closed Won'
	WHEN StageName = 'Create Solution' AND StatusCode__c = 'LOST' THEN 'Needs Analysis'
	WHEN StageName = 'Create Solution' AND StatusCode__c = 'NO_SALE' THEN 'Needs Analysis'
	WHEN StageName = 'Establish Price/Contract' AND StatusCode__c = 'OPEN' THEN 'Negotiation'
	WHEN StageName = 'Establish Price/Contract' AND StatusCode__c = 'WON' THEN 'Closed Won'
	WHEN StageName = 'Establish Price/Contract' AND StatusCode__c = 'LOST' THEN 'Negotiation'
	WHEN StageName = 'Establish Price/Contract' AND StatusCode__c = 'NO_SALE' THEN 'Negotiation'
	WHEN StageName = 'Identify Opportunity' AND StatusCode__c = 'OPEN' THEN 'Discovery'
	WHEN StageName = 'Identify Opportunity' AND StatusCode__c = 'WON' THEN 'Closed Won'
	WHEN StageName = 'Identify Opportunity' AND StatusCode__c = 'LOST' THEN 'Discovery'
	WHEN StageName = 'Identify Opportunity' AND StatusCode__c = 'NO_SALE' THEN 'Discovery'
	WHEN StageName = 'Onboard/Trial' AND StatusCode__c = 'OPEN' THEN 'Onboarding'
	WHEN StageName = 'Onboard/Trial' AND StatusCode__c = 'WON' THEN 'Closed Won'
	WHEN StageName = 'Onboard/Trial' AND StatusCode__c = 'LOST' THEN 'Onboarding'
	WHEN StageName = 'Onboard/Trial' AND StatusCode__c = 'NO_SALE' THEN 'Onboarding'
	WHEN StageName = 'Trial' AND StatusCode__c = 'OPEN' THEN 'Onboarding'
	WHEN StageName = 'Trial' AND StatusCode__c = 'WON' THEN 'Closed Won'
	WHEN StageName = 'Trial' AND StatusCode__c = 'LOST' THEN 'Onboarding'
	WHEN StageName = 'Trial' AND StatusCode__c = 'NO_SALE' THEN 'Onboarding'
	ELSE 'Discovery'
	END
	AS "StageName"
 -- Picklist
    ,CASE	
        WHEN StatusCode__c = 'LOST' THEN 'Lost'
        WHEN StatusCode__c = 'NO_SALE' THEN 'Lost'
        WHEN StatusCode__c = 'OPEN' THEN 'Open'
        WHEN StatusCode__c = 'WON' THEN 'Won'
        ELSE StatusCode__c
        END
        AS "StatusCode__c" -- Picklist
    ,CASE	
        WHEN ReasonWonLostCode__c = '10_OF_PROJECTED_REVENUE_SECURE' THEN '20% of Projected Revenue Secured'
        WHEN ReasonWonLostCode__c = '3PL_BUSINESS_NOT_SECURED' THEN 'Lost - 3PL Business Not Secured'
        WHEN ReasonWonLostCode__c = 'ACHIEVED_ENDORSED_CARRIER_STAT' THEN 'Achieved Endorsed Carrier Status'
        WHEN ReasonWonLostCode__c = 'AWARDED_PRIMARY_CARRIER_STATUS' THEN 'Awarded Primary Carrier Status'
        WHEN ReasonWonLostCode__c = 'Contract Impasse' THEN 'Lost - Contract Impasse'
        WHEN ReasonWonLostCode__c = 'CONTRACT_EXECUTED' THEN 'Won - Contract Executed'
        WHEN ReasonWonLostCode__c = 'CUSTOMER_NOT_READY' THEN 'Lost - No Decision / Customer Not Ready / No Budget'
        WHEN ReasonWonLostCode__c = 'DUPLICATE' THEN 'Duplicate'
        WHEN ReasonWonLostCode__c = 'GOOD_LEAD' THEN 'Good lead'
        WHEN ReasonWonLostCode__c = 'LOST_BILLING_INVOICING_ISSUES' THEN 'Lost - Billing / Invoicing Issues'
        WHEN ReasonWonLostCode__c = 'LOST_CAPACITY' THEN 'Lost - Capacity'
        WHEN ReasonWonLostCode__c = 'LOST_CARGO_CLAIMS' THEN 'Lost - Cargo Claims'
        WHEN ReasonWonLostCode__c = 'LOST_CONTRACT_MISSED_TIMELINE' THEN 'Lost - Contract - Missed Timeline / Deadline'
        WHEN ReasonWonLostCode__c = 'LOST_CREDIT_BAD_DEBT' THEN 'Lost - Credit / Bad Debt Issues'
        WHEN ReasonWonLostCode__c = 'LOST_EXPERIENCE' THEN 'Lost - Poor Service/Experience'
        WHEN ReasonWonLostCode__c = 'LOST_FIT' THEN 'Lost - Not a fit for ArcBest'
        WHEN ReasonWonLostCode__c = 'LOST_ONTIME_TRANSIT' THEN 'Lost - On-Time % / Transit Reliability'
        WHEN ReasonWonLostCode__c = 'LOST_PRICE' THEN 'Lost - Price'
        WHEN ReasonWonLostCode__c = 'LOST_RESPONSIVENESS' THEN 'Lost - Lack of responsiveness by buyer'
        WHEN ReasonWonLostCode__c = 'LOST_ROI' THEN 'Lost - Can''t prove ROI'
        WHEN ReasonWonLostCode__c = 'LOST_SOLUTION' THEN 'Lost - Solution does not fit need'
        WHEN ReasonWonLostCode__c = 'LOST_TERMS' THEN 'Lost - Issues with terms and conditions'
        WHEN ReasonWonLostCode__c = 'LOST_TO_COMPETITION' THEN 'Lost to Competition'
        WHEN ReasonWonLostCode__c = 'LOST_TO_INTERNAL_DEVELOPMENT' THEN 'Lost to internal development'
        WHEN ReasonWonLostCode__c = 'LOST_TO_NO_DECISION' THEN 'Lost to no decision'
        WHEN ReasonWonLostCode__c = 'LOST_TRANSIT_COMPETITIVENESS' THEN 'Lost - Transit Competitiveness'
        WHEN ReasonWonLostCode__c = 'NO_BANDWIDTH' THEN 'No bandwidth'
        WHEN ReasonWonLostCode__c = 'NO_BUDGET' THEN 'No budget'
        WHEN ReasonWonLostCode__c = 'OTHER' THEN 'Other'
        WHEN ReasonWonLostCode__c = 'PRICE' THEN 'Won - Price'
        WHEN ReasonWonLostCode__c = 'PRODUCT' THEN 'Won - Solution'
        WHEN ReasonWonLostCode__c = 'RELATIONSHIP' THEN 'Won - Relationship'
        WHEN ReasonWonLostCode__c = 'TRACK_RECORD' THEN 'Won - Track Record'
        WHEN ReasonWonLostCode__c = 'WON_CARGO_CLAIMS_PERFORMANCE' THEN 'Won - Cargo Claims Performance'
        WHEN ReasonWonLostCode__c = 'WON_CONSISTENCY_RELIABILITY' THEN 'Won - Consistency / Reliability'
        WHEN ReasonWonLostCode__c = 'WON_CREATIVITY_IN_SOLUTION' THEN 'Won - Creativity in Solution'
        WHEN ReasonWonLostCode__c = 'WON_PRICE' THEN 'Won - Price'
        WHEN ReasonWonLostCode__c = 'WON_SOLUTION' THEN 'Won - Solution'
        WHEN ReasonWonLostCode__c = 'WON_TRANSIT_COMPETITIVENESS' THEN 'Won - Transit Competitiveness'
        ELSE ReasonWonLostCode__c
        END
        AS "ReasonWonLostCode__c" -- Picklist -- see PK discussion via email on PL values
    ,WinLossDescription__c
    ,CASE
        WHEN PrimaryCompetitor__c = 'MERCER TRANSPORTATION CO INC' THEN 'Mercer Transportation Inc'
        ELSE PrimaryCompetitor__c
        END
        AS "PrimaryCompetitor__c" -- Picklist -- Source & Target values identical except one value
    ,Amount
    ,Probability
    ,CASE	
        WHEN BusinessType__c = 'Contract' THEN 'Contract'
        WHEN BusinessType__c = 'Corporate' THEN 'Corporate'
        WHEN BusinessType__c = 'Dynamic' THEN 'Dynamic'
        WHEN BusinessType__c = 'Spot Market' THEN 'Spot Market'
        WHEN BusinessType__c = 'Tariff' THEN 'Tariff'
        WHEN BusinessType__c = 'Tariff-deferred' THEN 'Tariff'
        ELSE BusinessType__c
        END
        AS "BusinessType__c" -- Picklist
,CASE	
	WHEN LeadSource = '1ST_TIME_LIST' THEN '1st Time List'
	WHEN LeadSource = '3RD PARTY SOURCING' THEN '3rd Party Sourcing'
	WHEN LeadSource = '3rd_Party_Sourcing' THEN '3rd Party Sourcing'
	WHEN LeadSource = 'Account Rollout' THEN 'Account Rollout'
	WHEN LeadSource = 'ACCOUNT_ROLLOUT' THEN 'Account Rollout'
	WHEN LeadSource = 'Affiliate' THEN 'Affiliate'
	WHEN LeadSource = 'Brand Sponsorship' THEN 'Brand Sponsorship'
	WHEN LeadSource = 'DemandBase' THEN 'DemandBase'
	WHEN LeadSource = 'DEMAND_BASE' THEN 'DemandBase'
	WHEN LeadSource = 'DIRECT_MAIL' THEN 'Direct mail'
	WHEN LeadSource = 'EMAIL' THEN 'E-Mail'
	WHEN LeadSource = 'Existing Customer - New Busine' THEN 'Existing Customer - New Business'
	WHEN LeadSource = 'EXISTING_CUSTOMER_NEW_BUSINESS' THEN 'Existing Customer - New Business'
	WHEN LeadSource = 'FAX' THEN 'Fax'
	WHEN LeadSource = 'GPL - Carrier' THEN 'GPL - Carrier'
	WHEN LeadSource = 'GPL_CARRIER' THEN 'GPL - Carrier'
	WHEN LeadSource = 'GPL - Customer' THEN 'GPL - Customer'
	WHEN LeadSource = 'GPL_CUSTOMER' THEN 'GPL - Customer'
	WHEN LeadSource = 'Letter Head Routing Order' THEN 'Letter Head Routing Order'
	WHEN LeadSource = 'LinkedIn' THEN 'LinkedIn'
	WHEN LeadSource = 'Sales Navigator' THEN 'LinkedIn - Sales Navigator'
	WHEN LeadSource = 'MAGAZINE_PERIODICAL_NEWSLETTER' THEN 'Magazine/Periodical/Newsletter'
	WHEN LeadSource = 'Magazine Periodical Newsletter' THEN 'Magazine/Periodical/Newsletter'
	WHEN LeadSource = 'MAGAZINES/MARKETING' THEN 'Magazines/Marketing'
	WHEN LeadSource = 'MAGAZINES_MARKETING' THEN 'Magazines/Marketing'
	WHEN LeadSource = 'Marketing and Public Relations' THEN 'Marketing and Public Relations'
	WHEN LeadSource = 'MARKETING_PUBLIC_RELATIONS' THEN 'Marketing and Public Relations'
	WHEN LeadSource = 'Medallia' THEN 'Medallia'
	WHEN LeadSource = 'ZSP_MODEL_PREDICTION' THEN 'Model Based Prediction'
	WHEN LeadSource = 'My Carrier Referral' THEN 'My Carrier Referral'
	WHEN LeadSource = 'New Locations Report' THEN 'New Locations Report'
	WHEN LeadSource = 'NEW_LOCATIONS_REPORT' THEN 'New Locations Report'
	WHEN LeadSource = 'OPERATIONS' THEN 'Operations'
	WHEN LeadSource = 'Operations Lead - Air Freight' THEN 'Operations Lead - Air Freight'
	WHEN LeadSource = 'OPERATIONS_LEAD_AIR_FREIGHT' THEN 'Operations Lead - Air Freight'
	WHEN LeadSource = 'Operations Lead - Elite Servic' THEN 'Operations Lead - Elite Services'
	WHEN LeadSource = 'OPERATIONS_LEAD_ELITE_SERVICES' THEN 'Operations Lead - Elite Services'
	WHEN LeadSource = 'Operations Lead - Gen Ops' THEN 'Operations Lead - Gen Ops'
	WHEN LeadSource = 'OPERATIONS_LEAD_GEN_OPS' THEN 'Operations Lead - Gen Ops'
	WHEN LeadSource = 'Operations Lead - Gold Team' THEN 'Operations Lead - Gold Team'
	WHEN LeadSource = 'OPERATIONS_LEAD_GOLD_TEAM' THEN 'Operations Lead - Gold Team'
	WHEN LeadSource = 'Operations Lead - Internationa' THEN 'Operations Lead - International'
	WHEN LeadSource = 'OPERATIONS_LEAD_INTERNATIONAL' THEN 'Operations Lead - International'
	WHEN LeadSource = 'Other' THEN 'Other'
	WHEN LeadSource = 'OVERSEAS_AGENT' THEN 'Overseas Agent'
	WHEN LeadSource = 'PHONE' THEN 'Phone'
	WHEN LeadSource = 'PIERS' THEN 'PIERS'
	WHEN LeadSource = 'Product Launch' THEN 'Product Launch'
	WHEN LeadSource = 'PRODUCT LAUNCH' THEN 'Product Launch'
	WHEN LeadSource = 'Research' THEN 'Prospecting/Research'
	WHEN LeadSource = 'PROSPECTING_RESEARCH' THEN 'Prospecting/Research'
	WHEN LeadSource = 'QUOTE' THEN 'Quote'
	WHEN LeadSource = 'Referral - Customer' THEN 'Referral - Customer'
	WHEN LeadSource = 'REFERRAL_CUSTOMER' THEN 'Referral - Customer'
	WHEN LeadSource = 'Referral - Driver' THEN 'Referral - Driver'
	WHEN LeadSource = 'REFERRAL_DRIVER' THEN 'Referral - Driver'
	WHEN LeadSource = 'Referral - Panther Employee' THEN 'Referral - Expedite'
	WHEN LeadSource = 'REFERRAL_EXPEDITE' THEN 'Referral - Expedite'
	WHEN LeadSource = 'Referral - External' THEN 'Referral - External'
	WHEN LeadSource = 'REFERRAL_EXTERNAL' THEN 'Referral - External'
	WHEN LeadSource = 'Referral - Fleet Owner' THEN 'Referral - Fleet Owner'
	WHEN LeadSource = 'REFERRAL_FLEET_OWNER' THEN 'Referral - Fleet Owner'
	WHEN LeadSource = 'Referral - Internal' THEN 'Referral - Internal'
	WHEN LeadSource = 'Referral - LTL' THEN 'Referral - LTL'
	WHEN LeadSource = 'REFERRAL_LTL' THEN 'Referral - LTL'
	WHEN LeadSource = 'Referral - TL' THEN 'Referral - TL'
	WHEN LeadSource = 'REFERRAL_TL' THEN 'Referral - TL'
	WHEN LeadSource = 'RESEARCH' THEN 'Research'
	WHEN LeadSource = 'ZSP_RULES_PREDICTION' THEN 'Rules based prediction'
	WHEN LeadSource = 'Sales Support' THEN 'Sales Support'
	WHEN LeadSource = 'SALES_VISIT' THEN 'Sales visit'
	WHEN LeadSource = 'Supply Chain Brain' THEN 'Supply Chain Brain'
	WHEN LeadSource = 'Trade Show' THEN 'Trade Show'
	WHEN LeadSource = 'TRADE_SHOW' THEN 'Trade Show'
	WHEN LeadSource = 'Turndown' THEN 'Turndown'
	WHEN LeadSource = 'Virtual Event' THEN 'Virtual Event'
	WHEN LeadSource = 'WEB' THEN 'Web'
	WHEN LeadSource = 'Web Chat' THEN 'Web Chat'
	WHEN LeadSource = 'WEB_CHAT' THEN 'Web Chat'
	WHEN LeadSource = 'WIRELESS' THEN 'Wireless message'
	WHEN LeadSource = 'Zoominfo' THEN 'ZoomInfo'
	ELSE LeadSource
	END
	AS "LeadSource" -- Picklist
    ,CASE	
        WHEN RelatedToA3PL__c = '1' THEN 'true'
        WHEN RelatedToA3PL__c = '0' THEN 'false'
        ELSE 'false'
        END
        AS "RelatedToA3PL__c"  -- Checkbox
    ,X3PL__c
    ,CASE	
        WHEN RelatedToRetail__c = '1' THEN 'true'
        WHEN RelatedToRetail__c = '0' THEN 'false'
        ELSE 'false'
        END
        AS "RelatedToRetail__c"  -- Checkbox
    ,CASE	
        WHEN Retailer__c = 'Amazon' THEN 'Amazon'
        WHEN Retailer__c = 'Best Buy' THEN 'Best Buy'
        WHEN Retailer__c = 'CVS' THEN 'CVS'
        WHEN Retailer__c = 'Target' THEN 'Target'
        WHEN Retailer__c = 'Wal-Mart' THEN 'Wal-Mart / Sams'
        WHEN Retailer__c = 'Walgreen''s' THEN 'Walgreens'
        ELSE Retailer__c
        END
        AS "Retailer__c"  -- Picklist
    ,REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(CustomerServiceReqs__c, ',', ';'), 
                    'CUSTOMERSOLUTIONSHOTLINE', 'General Customer Service (Centralized - Customer Solutions or Gold Team Hotline)'),
                    'CUSTOMERSOLUTIONSMANAGEDACCT', 'Account Development (Customer Solutions or Vertical Managed Account)'),
                    'SELFSERVE', 'Arcb.com or Omega TMS (Digital Self Serve)'),
                    'SERVICECENTER', 'Local Customer Service (Service Center)')
        AS "CustomerServiceReqs__c" -- MultiSelect
    ,InternalType__c -- not a Picklist per PK 230301
    ,CASE	
        WHEN RetailPlus__c = '1' THEN 'true'
        WHEN RetailPlus__c = '0' THEN 'false'
        ELSE 'false'
        END
        AS "RetailPlus__c"  -- Checkbox
    ,REPLACE(REPLACE(RetailPlusRetailers__c,'''', ''), ',', ';') 
        AS "RetailPlusRetailers__c" -- MultiSelect -- Source & Target values idential, only REPLACE ',' with ';'
    ,CASE	
        WHEN DecisionMakerIdentifiedFlag__c = 'Y' THEN 'true'
        WHEN DecisionMakerIdentifiedFlag__c = 'N' THEN 'false'
        ELSE 'false'
        END
        AS "DecisionMakerIdentifiedFlag__c" -- Checkbox
    ,CASE	
        WHEN LevelofRisk__c = 'HIGH' THEN 'High'
        WHEN LevelofRisk__c = 'LOW' THEN 'Low'
        WHEN LevelofRisk__c = 'NONE' THEN 'None'
        ELSE LevelofRisk__c
        END
        AS "LevelofRisk__c" -- Picklist
    ,CASE	
        WHEN Solution__c = 'Air Freight - Domestic' THEN 'International Air'
        WHEN Solution__c = 'Air Freight - International Export' THEN 'International Air'
        WHEN Solution__c = 'Air Freight - International Import' THEN 'International Air'
        WHEN Solution__c = 'Elite Services - Flat Bed' THEN 'Expedite'
        WHEN Solution__c = 'Elite Services - Lift Gate' THEN 'Expedite'
        WHEN Solution__c = 'Elite Services - Secret Cleared Driver' THEN 'Expedite'
        WHEN Solution__c = 'Elite Services - Special Care' THEN 'Expedite'
        WHEN Solution__c = 'Elite Services - Temperature Control' THEN 'Expedite'
        WHEN Solution__c = 'Expedite' THEN 'Expedite'
        WHEN Solution__c = 'Final Mile' THEN 'Final Mile'
        WHEN Solution__c = 'Flatbed' THEN 'Expedite'
        WHEN Solution__c = 'General Ground - Cargo Vans' THEN 'Expedite'
        WHEN Solution__c = 'General Ground - Straight Trucks' THEN 'Expedite'
        WHEN Solution__c = 'General Ground - Tractor' THEN 'Expedite'
        WHEN Solution__c = 'Intermodal' THEN 'Intermodal'
        WHEN Solution__c = 'International Ocean - FCL Export' THEN 'International Ocean'
        WHEN Solution__c = 'International Ocean - FCL Import' THEN 'International Ocean'
        WHEN Solution__c = 'International Ocean - LCL Export' THEN 'International Ocean'
        WHEN Solution__c = 'International Ocean - LCL Import' THEN 'International Ocean'
        WHEN Solution__c = 'International Shipping - Air' THEN 'International Air'
        WHEN Solution__c = 'International Shipping - Ocean' THEN 'International Ocean'
        WHEN Solution__c = 'LTL' THEN 'LTL'
        WHEN Solution__c = 'LTL Brokerage' THEN 'LTL Brokerage' -- 230522 changed from 'Brokerage' per PK / DS
        WHEN Solution__c = 'Managed Transportation' THEN 'Managed Transportation'
        WHEN Solution__c = 'Moving Services' THEN 'Moving Services'
        WHEN Solution__c = 'Premium Logistics - High Value' THEN 'Expedite'
        WHEN Solution__c = 'Premium Logistics - Other' THEN 'Expedite'
        WHEN Solution__c = 'Premium Logistics - Temperature Controlled/Validated' THEN 'Expedite'
        WHEN Solution__c = 'Product Launch' THEN 'Product Launch'
        WHEN Solution__c = 'Reefer' THEN 'Expedite'
        WHEN Solution__c = 'Retail Logistics' THEN 'Retail Logistics'
        WHEN Solution__c = 'Supply Chain Optimization' THEN 'Supply Chain Optimization'
        WHEN Solution__c = 'Time Critical' THEN 'Time Critical'
        WHEN Solution__c = 'Trade Show Shipping' THEN 'Trade Show'
        WHEN Solution__c = 'Truckload' THEN 'Truckload'
        WHEN Solution__c = 'Truckload - Dedicated' THEN 'Dedicated Truckload'
        WHEN Solution__c = 'Truckload Brokerage' THEN 'Brokerage'
        WHEN Solution__c = 'Volume/ABF' THEN 'LTL'
        WHEN Solution__c = 'Warehousing' THEN 'Warehousing'
        WHEN Solution__c = 'Warehousing & Distribution' THEN 'Warehousing'
        ELSE Solution__c
        END
        AS "Solution__c" -- Picklist
    ,CASE
        WHEN InvoicingEmail__c LIKE '%_@__%.__%' AND 
            PATINDEX('%[^a-z,0-9,@,.,_]%', REPLACE(InvoicingEmail__c, '-', 'a')) = 0 AND
            LEN(InvoicingEmail__c) - LEN(REPLACE(InvoicingEmail__c,'@','')) = 1 THEN InvoicingEmail__c
        WHEN InvoicingEmail__c IS NULL THEN NULL
        ELSE 'BadEmail@BadEmail.com'
        END
        AS "InvoicingEmail__c" -- REGEX test
    ,CASE	
        WHEN InvoicingPreferences__c = 'E_INVOICING' THEN 'e-Invoicing'
        WHEN InvoicingPreferences__c = 'MAILING' THEN 'Mailing'
        WHEN InvoicingPreferences__c = 'OTHER' THEN 'Other'
        ELSE InvoicingPreferences__c
        END
        AS "InvoicingPreferences__c" -- Picklist
    ,CASE	
        WHEN TechnicalRequirements__c = 'API' THEN 'API'
        WHEN TechnicalRequirements__c = 'EDI' THEN 'EDI'
        WHEN TechnicalRequirements__c = 'NONE' THEN 'None'
        WHEN TechnicalRequirements__c = 'Both' THEN 'Both'
        ELSE TechnicalRequirements__c
        END
        AS "TechnicalRequirements__c" -- Picklist
    ,LEFT(NextStep,255) AS "NextStep"
    ,CASE	
        WHEN LegalRequirements__c = 'MUTUAL_NDA' THEN 'Mutual NDA'
        WHEN LegalRequirements__c = 'NDA' THEN 'NDA'
        WHEN LegalRequirements__c = 'NONE' THEN 'None'
        WHEN LegalRequirements__c = 'OTHER' THEN 'Other'
        WHEN LegalRequirements__c = 'TRANSPORTATION_AGREEMENT' THEN 'Transportation Agreement'
        ELSE LegalRequirements__c
        END
        AS "LegalRequirements__c" -- Picklist
    ,CASE	
        WHEN RetainType__c = 'DEF' THEN 'DEF'
        WHEN RetainType__c = 'GRI' THEN 'GRI'
        WHEN RetainType__c = 'PIP' THEN 'PIP'
        WHEN RetainType__c = 'YRP' THEN 'YRP'
        ELSE RetainType__c
        END
        AS "RetainType__c" -- Picklist
    ,CASE	
        WHEN Geographies__c = 'Alaska' THEN 'Alaska'
        WHEN Geographies__c = 'Canada' THEN 'Canada'
        WHEN Geographies__c = 'Domestic' THEN 'Domestic'
        WHEN Geographies__c = 'Domestic_Canadian' THEN 'Domestic Canadian'
        WHEN Geographies__c = 'Dominican Republic' THEN 'Dominican Republic'
        WHEN Geographies__c = 'Export' THEN 'Export'
        WHEN Geographies__c = 'Guam' THEN 'Guam'
        WHEN Geographies__c = 'Hawaii' THEN 'Hawaii'
        WHEN Geographies__c = 'Import' THEN 'Import'
        WHEN Geographies__c = 'Intra-Canada' THEN 'Intra-Canada'
        WHEN Geographies__c = 'Intra-Mexico' THEN 'Intra-Mexico'
        WHEN Geographies__c = 'Mexico' THEN 'Mexico'
        WHEN Geographies__c = 'Puerto Rico' THEN 'Puerto Rico'
        WHEN Geographies__c = 'U.S. Virgin Islands' THEN 'U.S. Virgin Islands'
        ELSE Geographies__c
        END
        AS "Geographies__c" -- Picklist
    ,CASE	
        WHEN Equipment__c = 'Air Cargo' THEN 'Air Cargo'
        WHEN Equipment__c = 'Air Charter' THEN 'Air Charter'
        WHEN Equipment__c = 'Cargo Van' THEN 'Cargo Van'
        WHEN Equipment__c = 'Dry Van' THEN 'Dry Van'
        WHEN Equipment__c = 'FCL' THEN 'FCL'
        WHEN Equipment__c = 'Flatbed' THEN 'Flatbed'
        WHEN Equipment__c = 'LCL' THEN 'LCL'
        WHEN Equipment__c = 'Lift Gate' THEN 'Lift Gate'
        WHEN Equipment__c = 'Power Only - Tractor' THEN 'Power Only - Tractor'
        WHEN Equipment__c = 'Pup' THEN 'Pup'
        WHEN Equipment__c = 'Reefer' THEN 'Reefer'
        WHEN Equipment__c = 'Straight Truck' THEN 'Straight Truck'
        ELSE Equipment__c
        END
        AS "Equipment__c" -- Picklist
    ,CASE	
        WHEN ArcBestNew__c = 'Y' THEN 'true'
        WHEN ArcBestNew__c = 'N' THEN 'false'
        ELSE 'false'
        END
        AS "ArcBestNew__c" -- Checbox
    ,CASE	
        WHEN NewSolution__c = 'Y' THEN 'true'
        WHEN NewSolution__c = 'N' THEN 'false'
        ELSE 'false'
        END
        AS "NewSolution__c" -- Checkbox
    ,AccountShipmentDate__c
    ,ProposalId__c

  INTO sfdc.Opportunity_T
FROM sfdc.Opportunity_E
ORDER BY AIMSAccount__c, PACE_OpportunityID__c, PACE_OpportunityRevenueId__c


DECLARE 
    @RecordCount AS INT = NULL


--  SET PER Record Count
SET @RecordCount = 
	(SELECT count(*)
    FROM sfdc.Opportunity_T)

UPDATE sfdc.Migration_Status 
	SET 
    --stepsID
    --,description
    --,action
    --,startDateTime
    endDateTime = GETDATE()
    ,recordCount=@RecordCount
    ,status='COMPLETED' 
WHERE stepsID = '08_01_02';
