--Нам известен продукт - "1".
--Задача: получить список всех покупателей, купивших этот продукт. 
--По каждому покупателю нужно вывести 1 поле:
--имя и фамилию 
-------------------------------------------------------
select
	first_name || ' ' || last_name as name_customer
from product p
	join orders o
		using(product_id)
	join customer c
		using(customer_id)
where product_id = 1; 
-------------------------------------------------------



--Выбрать продукты которые принесли большую прибыльность.
--Вывести product_id, и его сумму покупок (метры * на цену) и отсортировать в обратном порядке
-------------------------------------------------------
select
	p.product_id, 
	sum(o.order_length * p.price) as amount
from product p
	join orders o 
		on o.product_id = p.product_id
group by p.product_id
order by amount desc;
-------------------------------------------------------



--Найти покупателей у которых количество покупок от 3 и выше
--и длина в покупках погонного метра более 10 метров 
--вывести поля customer_id, имя и фамилию покупателя, сколько покупок он совершил
--отсортировать в порядке убывания по количеству заказов
-------------------------------------------------------
select
	customer_id,
	c.first_name || ' ' || last_name as name,
	count(*) as count_pays
from orders o 
	join customer c
		using(customer_id)
where order_length > 10
group by customer_id, name
having count(*) >= 3
order by count_pays desc;
-------------------------------------------------------



--проверил действительно ли покупатель с id 3783 (самый первый из прошлого запроса)
--имеет столько покупок длиной более 10 метров
select
	first_name || ' ' || last_name as name,
	order_length
from orders o 
	join customer c 
		using(customer_id)
where customer_id = 3783;
-------------------------------------------------------



-- Вывести описание товаров с длиной описания менее 200 символов,
-- для остальных вывести "Не помещается полностью"
-------------------------------------------------------
select
	case
		when length(product_description) < 200
		then product_description
		else 'Не помещается полностью'
	end
from product;
-------------------------------------------------------



--вывести покупки с длиной заказа более 30 метров, 
--или покупки в которых участвовал лояльный клиент
-------------------------------------------------------
select
	order_id
from
	orders o  
where o.order_length > 30
group by o.order_id

union

select
	order_id
from customer c
	join orders o
		on c.customer_id = o.customer_id
where loyalty = true;
-------------------------------------------------------



--вывести покупки с длиной заказа более 30 метров, 
--исключить покупки от покупателей без системы лояльности
-------------------------------------------------------
select
	order_id
from
	orders o  
where o.order_length > 30
group by o.order_id

except 

select
	order_id
from customer c
	join orders o
		on c.customer_id = o.customer_id
where loyalty = False;
	

--Посчитать сколько таких покупок (условия прошлого запроса)
-------------------------------------------------------
select
	count(order_id)
from
	(select
		order_id
	from
		orders o  
	where o.order_length > 30
	group by o.order_id
	
	except 
	
	select
		order_id
	from customer c
		join orders o
			on c.customer_id = o.customer_id
	where loyalty = False)
-------------------------------------------------------



--Вывести номер продукта и количество продаж в зависимости от длины
-- все, >20, >30, > 40.
	
select
	product_id,
	count(*) as all_orders,
	count(*) filter(where o.order_length > 20) as "orders > 20",
	count(*) filter(where o.order_length > 30) as "orders > 30",
	count(*) filter(where o.order_length > 40) as "orders > 40"
from orders o
	join product p 
		using(product_id)
group by product_id 
order by product_id;
-------------------------------------------------------



--По каждому товару вывести поля:
--- id, цвет.
--- кол-во покупок, данного товара.
--- сумму продаж по данному товару.
-- Расчеты будут в cte.

with count_order as(
	select
		product_id,
		count(order_id) cnt_ord
	from
		product p
		join 
			orders o
			using(product_id)
	group by product_id
			
),
sum_amount as (
	select
		product_id,
		sum(p.price * o.order_length) sum_amount
	from product p
		join orders o
			using(product_id)
	group by product_id 
)

select
	product_id,
	p.color,
	cnt_ord,
	sum_amount
from product p
	join count_order co
		using(product_id)
		join sum_amount
			using(product_id)
-------------------------------------------------------	



--Вывести список всех покупок:
--длину метров заказа.
--максимальную и минимальную длину заказа на данный вид товара.
--и общее количество заказов и сумму оплаты, которую получили за данный тип товара 

select 
	product_id,
	order_length,
	max(order_length) over(partition by product_id),
	min(order_length) over(partition by product_id),
	count(*) over(partition by product_id),
	sum(o.order_length*p.price) over(partition by product_id)
from product p
	join orders o
		using(product_id);



