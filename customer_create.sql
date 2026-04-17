
--Создаю таблицу customer, в которой будут храниться данные:
-- customer_id - id покупателя первичный ключ таблицы,
-- first_name - имя покупателя,
-- last_name - фамилия покупателя,
-- adress - адрес покупателя

create table customer(
	customer_id serial primary key,
	first_name varchar(20),
	last_name varchar(20),
	adress varchar(50),
	check(length(first_name) >=2)
)

--Добавляю еще поле loyalty определяющая состоит ли покупатель в системе лояльности

alter table customer add column Loyalty bool; 


--Добавляю еще поле login и наложу ограничение, что он должен быть уникальным

alter table customer add column login varchar unique; 


--Заполняю таблицу случайными данными

insert into customer(first_name, last_name, adress, Loyalty)
select first_name,
     last_name,
     adress,
     Loyalty
  from (select unnest(array['Adam','Borov', 'Sergey','Maxim','Vitaliy', 'Roger', 'Pavel', 'Michael']) as first_name) as f
 cross join
       (select unnest(array['Matthews','Hancock', 'Popov', 'White', 'Ivanov', 'Arbuzov','Polevskiy']) as last_name) as l
  cross join
       (select unnest(array['Moscow','Moscow', 'Saint Petersburg', 'Novokuzneck', 'Kazan', 'Novosibirsk','Ekaterinburg']) as adress) as a
 cross join
 		(select unnest(array[True, False,  False]) as Loyalty) as lo
 order by random()
 
 
 
 --Заполню поле login
 
insert into customer(login)
select 
	md5(random()::varchar) as login
from generate_series(1, 1176)
 
 -----------------------------------------------------
 

 
--Смотрю правильно ли получилась таблица	

select *
from customer c

select
	first_name,
    last_name,
    adress,
    Loyalty,
	coalesce(login, 
		select
			md5(random()::varchar) as login
		from generate_series(1, 1176)	
	) as login

