
# 1.How has the revenue of Instagram changed over the years? Provide an overview of the revenue per year.

select years, sum(revenue)
from meta_revenue
where parent_company =  'Instagram'
group by years
order by years

  

# 2.What is the revenue in  2022  and  2021 that has been generated  by the video ad types of both platforms combined? Did the revenue grow?

SELECT years, SUM(revenue) AS total_revenue
FROM meta_revenue
WHERE years BETWEEN  2021  AND  2022
AND ad_types LIKE  '%Video%'
GROUP BY years

  

# 3. Create a column called “ad_products” that creates one value that groups the Display ad types together and one value that groups the Video ad types together. What is the total revenue generated  by each ad product?

  

select  case  when ad_types like  '%Display%'  then  'Dispaly ad'
    else  'Video ad'  end  as ad_products ,
    sum(revenue) as total_revenue
from meta_revenue
group by ad_products

  

# 4.How do the number of clients and the number of conversions compare between the Display and Video for the years 2021  and  2022?

select  case  when ad_types like  '%Display%'  then  'Dispaly ad'
    else  'Video ad'  end  as ad_products ,
    count(distinct client_id) as num_clients,
    sum(conversions) as total_conversions, years
from meta_revenue
group by ad_products, years
having years in ('2021' , '2022')

  

# 5.What is the number of impressions in  2022 per age group across Facebook and Instagram?
 
select  sum(impressions), age_bucket_user, parent_company
from meta_revenue
where years =  '2022'
group by age_bucket_user, parent_company
order by age_bucket_user

  

# 6.Have the number of conversions been trending upwards or downwards for Facebook for the age bucket 18-24  and  25-34  over the last few years?

select  sum(conversions), years
from meta_revenue
where parent_company='Facebook'  and age_bucket_user in ('18-24', '25-34')
group by years
order by years

  

# 7. A standard metric to analyze in the ads business is called conversion-per-click which is defined as your total conversion value divided by the number of clicks. Can you build the conversion-per-click metric and analyze how the metric is trending for Instagram for the age bucket 18-24  over the last few years?

select  sum(conversions)/sum(clicks) as conversion_per_click, year
from meta_revenue
where parent_company =  'Instagram'  and age_bucket_user =  '18-24'
group by years
order by years

  
  

# 8.Video ads have been booming in the last few years. TikTok is apparently popular amongst the youngsters. Can you identify the ad_id of Video ads that have generated  over  2 million in revenue in  2022? Note: the revenue numbers are already in millions, so 2 million will be 2

select ad_id, sum(revenue) as total_revenue
from meta_revenue
where ad_types like  '%Video%'  and years =  '2022'
group by ad_id
having  sum(revenue) >  2

  

# 9.Summarize the number of clicks that have been generated for each year  when the user and the advertiser have the same geographical code.

select years, sum(clicks)
from meta_revenue
where geo_user = geo_advertiser
group by years
order by years

  

# 10. Create a new column that splits the data  between domestic and international. Domestic means that the user and advertiser have the same geography code. International means that the user and advertiser have different geography codes. How much revenue is generate through domestic activity versus international activity in  2022 for each platform (Instagram and Facebook)?

select  case  when geo_user = geo_advertiser then  'Domestic'  else  'International'  end  as geo_group,
    sum(revenue),
    parent_company
from meta_revenue
where years =  '2022'
group by parent_company, geo_group

  

# 11.Analyse if there is a clear distinction in the sales of the LCS (Large Customer Sales) and SMB (Small and Medium Businesses) sales teams. Anything that doesn’t match LCS or SMB can be called Other. How much revenue did the LCS and SMB sales teams generate in  2022 split between domestic and international activity?

select  case  when geo_user = geo_advertiser then  'Domestic'  else  'International'  end  as geo_group,
    sum(revenue),
    case  when sales_team like  '%LCS%'  then  'LCS'  when sales_team like  '%SMB%'  then  'SMB'  else  'others'  end  as sales_segment
from meta_revenue
where years =  '2022'
group by geo_group, sales_segment
order by sales_segment

  

# 12.Create a column that summarizes the dates based on the calendar quarters in the year (e.g., Q1 is  2022-01-01  to  2022-03-31). What is the revenue and  number of conversions generated per quarter for the SMB sales team in  2022?
  
select  case  when dates between  '2022-01-01'  and  '2022-03-31'  then  'Q1'
    when dates between  '2022-04-01'  and  '2022-06-30'  then  'Q2'
    when dates between  '2022-07-01'  and  '2022-09-30'  then  'Q3'
    when dates between  '2022-10-01'  and  '2022-12-31'  then  'Q4'
    else  'others'
    end  as QUERTER,
    sum(revenue) as total_revenue,
    sum(conversions) as total_conversions
from meta_revenue
where years =  '2022'  and sales_team like  '%SMB%'
group by QUERTER
order by QUERTER

  

# 13.What is the average amount of revenue per ad that is  generated per quarter for the SMB sales team in  2022?

select  case  when dates between  '2022-01-01'  and  '2022-03-31'  then  'Q1'
    when dates between  '2022-04-01'  and  '2022-06-30'  then  'Q2'
    when dates between  '2022-07-01'  and  '2022-09-30'  then  'Q3'
    when dates between  '2022-10-01'  and  '2022-12-31'  then  'Q4'
    else  'others'
    end  as QUERTER,
    sum(revenue)/count(distinct ad_id) as avg_revenue
from meta_revenue
where years =  '2022'  and sales_team like  '%SMB%'
group by QUERTER
order by QUERTER

  

# 14. 14. Calculate the following metrics for the top  10 clients that have the highest amount of revenue in  2022: Total revenue, total conversions, total clicks, conversions per click, and average revenue per conversion

select client_id,
    sum(revenue) total_revenue,
    sum(conversions) total_conversions,
    sum(clicks) total_clicks,
    sum(conversions)/sum(clicks) conversion_per_click,
    sum(revenue)/sum(conversions) avg_amount_per_conversion
from meta_revenue
where years =  2022
group by client_id
order by total_revenue desc
limit  10
