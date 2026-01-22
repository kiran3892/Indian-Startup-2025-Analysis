select * from startup;

select sum(amount_mn) as "Total Funding Amount (Mn)" from startup;

select company, amount_mn as "Funded Amount(Mn)" from startup
order by amount_mn desc
limit 10;