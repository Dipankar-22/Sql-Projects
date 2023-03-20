/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [District]
      ,[State]
      ,[Area_km2]
      ,[Population]
  FROM [Projects].[dbo].[Data2]

  select *
  from [Projects].[dbo].[Data2]

  select count(*) as column_count
  from Projects..Data2

  select *
  from [Projects].[dbo].[Data1]

  ---Average growth by state

  select state,round(avg(growth)*100,0) avg_growth
  from [Projects].[dbo].[Data1]
  group by state

  ----Average sex ratio by state
  select state,round(avg(sex_ratio)*100,0) avg_sex_ratio
  from [Projects].[dbo].[Data1]
  group by state

  ---Population of india

  select sum(population) as India_population
  from [Projects].[dbo].[Data2]

  ----Top state having Highest area 

  select  state,
               sum(Area_km2)max_area
  from [Projects].[dbo].[Data2]
  group by State
  order by max_area desc

  ----
  select *
  from Projects..Data2

  ---State wise average growth

  select state,round(avg(growth)*100,0)avg_growth
  from Projects..Data1
  group by state 
  order by avg_growth

  ---average sex ratio
  select state,avg(Sex_Ratio)avg_sex_ratio
  from Projects..Data1
  group by state 
  order by avg_sex_ratio desc

  --average literacy rate
 select state,avg(literacy) avg_literacy
 from Projects..Data1
 group by state
 order by avg_literacy desc



  select *
  from Projects..Data1

  ---Population of state 
  select state,sum(population) total_population
  from Projects..Data2
  group by state
  order by total_population desc


  ---top 3 and bottom 3 states according to literacy rate
  
  --Top 3 literate states
  drop table  top_states 
  create table top_states
  (  state nvarchar(255),
    top_states float)

  insert into top_states
  select  top 3 state,avg(literacy) avg_literacy
  from Projects..Data1
  group by state 
  order by avg_literacy desc

  select *
  from top_states

  ---Bottom 3 states 
  drop table bottom_states

  create table bottom_states
  (  state nvarchar(255),
    top_states float)

  insert into bottom_states
  select  top  3 state,avg(literacy) avg_literacy
  from Projects..Data1
  group by state 
  order by avg_literacy asc

  select *
  from bottom_states

  ----States starting with a
  select distinct(state)
  from Projects..Data1
  where state like lower('a%')

  ----States starting with a and ending with m
  select distinct(state)
  from Projects..Data1
  where state like lower('a_%m')

  ----Male and female in population
  select *
  from projects..data1

  select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population 
  from Projects..Data1 a
  inner join projects..data2 b   ----Total population
  on a.district=b.district
  
  ----male and female population state wise 
  select d.state,sum(males)male_population,sum(females)female_population
  from
  (select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males
                 ,round(c.population*sex_ratio/(c.sex_ratio+1),0) females 
   from
  (select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population 
  from Projects..Data1 a
  inner join projects..data2 b   
  on a.district=b.district )c)d
  group by State
  order by male_population desc

  select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males,round(c.population*sex_ratio/(c.sex_ratio+1),0)female_population
  from (select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population 
  from Projects..Data1 a
  inner join projects..data2 b   ----Total population
  on a.district=b.district)c


  select *
  from Projects..data1

  ------Literate and illiterate people in a population state wise 

  select a.state,a.district,a.literacy/100 literacy_ratio,b.population
  from Projects..Data1 a
  inner join projects..Data2 b
  on a.district=b.District

  select d.state,sum(literate_population) total_literate_pop,sum(illiterate_population) total_illiterate_pop
  from
  (select c.state,c.district,round(c.literacy_ratio*c.population,0) literate_population
                 ,round((1-c.literacy_ratio)*c.population,0) illiterate_population
  from (select a.state,a.district,a.literacy/100 literacy_ratio,b.population
  from Projects..Data1 a
  inner join projects..Data2 b
  on a.district=b.District) c)d
  group by d.state 

  ------PREVIOUS YEAR CENSUS VS CURRENT YEAR

  select *
  from Projects..Data1

  select d.state,sum(previous_census_pop) previous_census,sum(current_census_pop) current_census
  from
  (select c.state,c.district,round(c.population/(1+growth),0) previous_census_pop,round(c.population,0) current_census_pop
  from
  (select a.state,a.district,b.population,a.growth
  from projects..data1 a
  inner join projects..data2 b
  on a.district=b.district) c)d
  group by state

  -----Comparing previous and current census of India
  select sum(e.previous_census) previous_population_India,sum(e.current_census) current_population_India
  from   (select d.state,sum(previous_census_pop) previous_census,sum(current_census_pop) current_census
  from
  (select c.state,c.district,round(c.population/(1+growth),0) previous_census_pop,round(c.population,0) current_census_pop
  from
  (select a.state,a.district,b.population,a.growth
  from projects..data1 a
  inner join projects..data2 b
  on a.district=b.district) c)d
  group by state)e


  ----Increase in population in a year

  select f.current_population_India-f.previous_population_India Population_increase
  from   (select sum(e.previous_census) previous_population_India,sum(e.current_census) current_population_India
  from   (select d.state,sum(previous_census_pop) previous_census,sum(current_census_pop) current_census
  from
  (select c.state,c.district,round(c.population/(1+growth),0) previous_census_pop,round(c.population,0) current_census_pop
  from
  (select a.state,a.district,b.population,a.growth
  from projects..data1 a
  inner join projects..data2 b
  on a.district=b.district) c)d
  group by state)e)f

  ----Area of India
  select sum(area_km2) total_area
  from projects..data2


  ---joining table by creating new column

  select '1' as keyy,f.*
  from
    (select sum(e.previous_census) previous_population_India,sum(e.current_census) current_population_India
  from   (select d.state,sum(previous_census_pop) previous_census,sum(current_census_pop) current_census
  from
  (select c.state,c.district,round(c.population/(1+growth),0) previous_census_pop,round(c.population,0) current_census_pop
  from
  (select a.state,a.district,b.population,a.growth
  from projects..data1 a
  inner join projects..data2 b
  on a.district=b.district) c)d
  group by state)e)f

  select '1' as keyy,g.*
  from
  (select sum(area_km2) total_area
  from projects..data2)g


 ----Population vs Area
   select q.total_area/ q.previous_population_India previous_pop_vs_area
        ,q.total_area/q.current_population_India current_pop_vs_area
 from
  (select p.*,o.total_area from
  (select '1' as keyy,f.*
  from
    (select sum(e.previous_census) previous_population_India,sum(e.current_census) current_population_India
  from   (select d.state,sum(previous_census_pop) previous_census,sum(current_census_pop) current_census
  from
  (select c.state,c.district,round(c.population/(1+growth),0) previous_census_pop,round(c.population,0) current_census_pop
  from
  (select a.state,a.district,b.population,a.growth
  from projects..data1 a
  inner join projects..data2 b
  on a.district=b.district) c)d
  group by state)e)f)p
  inner join

  (select '1' as keyy,g.*from
  (select sum(area_km2) total_area
  from projects..data2)g)o
  on p.keyy=o.keyy)q

  -- select g.total_area/ f.previous_population_India previous_pop_vs_area
 --       ,g.total_area/f.current_population_India current_pop_vs_area     ----Final formula
 --   from (above table)

 ---Top 3  literate districts of different state
 select top 3 state,district,Literacy literacy_percent
 from Projects..Data1
 order by Literacy desc

  ---Top 3 districts with highest growth
  select top 3 state,district,growth
  from projects..data1
  order by growth desc


 select *
 from Projects..Data1

 ----select top 3 districts from states having high literacy rate
 select a.* from
(select state,district,Literacy,rank() over(partition by  state order by literacy desc) rank
from projects..Data1) a
where a.rank in (1,2,3) order by state

  
 



