----questions for Swiggy project

1. Find customers who have never ordered
2. Average Price/dish
3. Find the top restaurant in terms of the number of orders for a given month
4. restaurants with monthly sales greater than x for 
5. Show all orders with order details for a particular customer in a particular date range
6. Find restaurants with max repeated customers 
7. Month over month revenue growth of swiggy
8. Customer - favorite food
9.Find the most loyal customers for all restaurant
10.Month over month revenue growth of a restaurant


Question 1. Find customers who have never ordered

select b.user_id,b.name,b.email,b.password
FROM [Swiggy Project].[dbo].[Orders$] a
right join [Swiggy Project].[dbo].[Users$] b
on a.user_id=b.user_id
where a.user_id is null

Question 2. Average Price/dish

select b.f_id,b.f_name,b.type,round(avg(a.price),2)avg_price
FROM [Swiggy Project].[dbo].[Menu$] a
join [Swiggy Project].[dbo].[Food$] b
on a.f_id=b.f_id
group by b.f_id,b.f_name,b.type
order by f_id 

Question 3. Find the top restaurant in terms of the number of orders for a given month.

select d.r_id,d.r_name,d.cuisine,c.max_order,c.month_name
from(
select top 10 count(b.r_id)max_order,max(r_id) over(partition by month_name order by r_id )top_restaurant_id,b.month_name
from(
select *,datename(month,date)month_name
FROM [Swiggy Project].[dbo].[Orders$])b
group by r_id,b.month_name
order by max_order desc)c
join [Swiggy Project].[dbo].[Restaurants$] d
on c.top_restaurant_id=d.r_id

--select *,datename(month,date)month_name
--FROM [Swiggy Project].[dbo].[Orders$]

Question 4. restaurants with monthly sales greater than x for 

select c.r_id,sum(c.amount)sum_amount,c.month_name
from(
select *,datename(month,date) month_name
from [Swiggy Project].[dbo].[Orders$])c
join [Swiggy Project].[dbo].[restaurants$] d
on c.r_id=d.r_id
group by c.month_name,c.r_id
having sum(c.amount)>800
order by sum_amount desc 

Question 5. Show all orders with order details for a particular customer in a particular date range

--Answer
 select	b.order_id,e.r_name,g.f_name
 from [Swiggy Project].[dbo].[Orders$] b
 JOIN [Swiggy Project].[dbo].[Restaurants$] e on e.r_id=b.r_id
 join [Swiggy Project].[dbo].[Order_Detail$] f on b.order_id=f.order_id
 join [Swiggy Project].[dbo].[Food$] g on g.f_id=f.f_id
 where user_id =(select user_id 
                   from [Swiggy Project].[dbo].[users$]
                   where name like 'Vartika') and (date>'2022-06-10' and date<'2022-07-10')

 --select user_id from [Swiggy Project].[dbo].[users$]
 --where name like 'Vartika' 
 --and (date>'2022-06-10' and date<'2022-07-10')

 Question 6. Find restaurants with max repeated customers 
 
 select f.r_id,count(f.r_id) as loyal_customers
 from(select a.user_id,a.r_id,count(a.r_id)count_order_placed
      from [Swiggy Project].[dbo].[Orders$] a
      group by a.user_id,a.r_id
      having count(a.r_id)>1)f
 group by f.r_id
 order by loyal_customers desc
 
 Question 7. Month over month revenue growth of swiggy 

 select month_name,sum_sales,
        round(((sum_sales-lag_before)/lag_before)*100,2) as percent_growth
 from(
     select *,lag(f.sum_sales) over(order by f.sum_sales)lag_before
	 from(
	 select distinct(a.month_name),sum(a.amount)sum_sales
	 from(
	 select *,datename(month,date)month_name
	 from [Swiggy Project].[dbo].[Orders$])a
	 group by a.month_name)f)g
order by percent_growth desc


 Question 8. Customer - favorite food 

 select e.name,e.f_name as favourite_food,e.type,count_orders
 from(select d.name,c.f_name ,c.type, b.user_id,a.f_id,count(a.f_id)count_orders,
      rank() over (partition by name order by count(a.f_id)desc) as rnk
	 FROM [Swiggy Project].[dbo].[Order_Detail$]a 
	 join [Swiggy Project].[dbo].[Orders$]b on a.order_id=b.order_id
	 join [Swiggy Project].[dbo].[Food$] c on a.f_id=c.f_id
	 join [Swiggy Project].[dbo].[Users$] d on b.user_id=d.user_id
	 group by d.name,c.f_name,c.type,a.f_id,b.user_id)e
where e.rnk<2


 Question 9. Find the most loyal customers for all restaurant

 select k.r_name,q.r_id,z.name as 'loyal_customer',q.user_id,q.count_orders as'count_order_place'
 from(
 select distinct(w.r_id),w.user_id,w.count_orders
 from(
 select user_id,r_id,count(user_id)count_orders
 from [Swiggy Project].[dbo].[Orders$]
 group by user_id,r_id)w
 group by w.r_id,w.user_id,w.count_orders
 having w.count_orders>1)q
 left join [Swiggy Project].[dbo].[Users$] z
 on q.user_id=z.user_id
 left join [Swiggy Project].[dbo].[Restaurants$] k
 on k.r_id=q.r_id
 group by z.name,q.user_id,q.r_id,q.count_orders,k.r_name


Question 10 .Month over month revenue growth of a restaurant

select f.r_id,f.month_name,f.revenue,round(((f.revenue-f.lag_before)/f.lag_before)*100,2) percent_growth
from(
select*,lag(e.revenue)over(partition by e.r_id order by e.month_name desc)lag_before
from(
select d.r_id,d.month_name,sum(d.revenue)revenue
from(
select r_id,datename(month,date)month_name,sum(amount)revenue
from [Swiggy Project].[dbo].[Orders$]
group by r_id,date)d
group by d.r_id, d.month_name)e)f









 

 

 
 
 













