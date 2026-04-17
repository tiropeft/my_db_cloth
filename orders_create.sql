
--Создаю таблицу orders, в которой будут храниться данные:
-- order_id - id покупки первичный ключ таблицы,
-- product_id - внешний ключ отсылающий к таблице product,
-- customer_id - внешний ключ отсылающий к таблице customer,
-- order_length - определяет сколько метров ткани было куплено 

create table orders(
	order_id serial not null primary key,
	product_id int constraint fk_product_id references product(product_id),
	customer_id int constraint fk_customer_id references customer(customer_id),
	order_length smallint not null  
);

--Добавляю еще поле date - дата, когда покупка была совершена 

alter table orders add column date date default(now()) not null;

--Заполняю таблицу случайными данными 

insert into orders(product_id, customer_id, order_length, date)
	select
		floor(random() * 8)::int as product_id,
		floor(random() * 1175 +3218)::int as customer_id,
		floor(random() * 50)::int as order_length,
		now() + (random() * (interval '90 days'))
  	from generate_series(1, 2500);
	
--Смотрю правильно ли получилась таблица

select
	*
from orders

delete from orders		