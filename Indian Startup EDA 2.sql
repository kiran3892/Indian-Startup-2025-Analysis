select * from startup;

-- Calculating Total Funds (Mn) received

select 
	sum(amount_mn) as "Total Funding Amount (Mn)"
from startup;


-- Top 10 Companies with most funds recevied

select 
		company as "Company Name",
		amount_mn as "Funds Received (Mn)",
		lead_investor as "Funded By"
from startup
order by 2 desc
Limit 10;


-- Investors with Clients Volume

select
		lead_investor as "Invesstor Name",
		count(*) as "Number of Clients"
from startup
where lead_investor not in ('Not Available')
group by 1
order by 2 desc;


-- State wise Startups number

select 
		headquarters as "State Name",
		count(*) as "Number of Startups"
from startup
group by 1
order by 2 desc
limit 15;


-- Categorizing the funding amount and analysing which category has major startups

-- Adding New column for categorization
Alter table startup
add column funding_category text; 

-- Pouplating the coumn with data
update startup
set funding_category = case 
							when amount_mn < 10 then 'Low Capital Investment'
							when amount_mn between 10 and 30 then 'Medium Capital Investment'
							when amount_mn between 31 and 70 then 'High Capital Investment'
						Else 'Premium Investment'
						end;
select
		funding_category as "Funding Category",
		count(*) as "Number of Startups"
from startup
group by 1
order by 2 desc;


-- Identifying sectors with high startups

select 
		sector_name as "Sector",
		count(*) as "Number of Startups"
from startup
group by 1
order by 2 desc
limit 10;


-- Most preferred funding type by investors

select
	distinct funding_type as "Funing Type",
	count(*) as "Number of Startups Funded"
from startup
group by 1
order by 2 desc
limit 15;



-- Finding out top funding choice by each sector
select 
	"Sector",
	array_agg(funding_type) as "Funding Types",
	"Number of Startups",
	"Rank"
from (select 
			sector_name as "Sector",
			funding_type,
			count(*) as "Number of Startups",
			dense_rank() over (partition by sector_name order by count(*) desc) as "Rank"
		from startup
		group by 1,2
		order by 3 desc)
where "Rank" = 1
group by 1,3,4
order by 3 desc;


-- Finding out geogrpahical interest towards funding type

select 
	"State",
	array_agg("Funding Type") as "Funding Types",
	"Rank"
from 
(select 
		headquarters as "State",
		funding_type as "Funding Type",
		count(*) as "Number of Times used",
		rank() over (partition by headquarters order by count(*)desc) as "Rank"
from startup
group by 1,2)
where "Rank" = 1
group by 1,3;




	


