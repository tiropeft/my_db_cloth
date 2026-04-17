# my_db_cloth
Я развернул БД на postgresql через dbeaver, для того чтобы показать мои умения писать запросы.<br> 
БД создана для вымышленного магазина тканей.<br> 
Таблицы в БД: product, customer, orders <br> 
Таблица с описанием ткани product:<br>  
  - product_id - primary key (первичный ключ таблицы),
  - product_description - описание товара,
  - color - цвет ткани,
  - type_material - тип материала,
  - price - цена за погонный метр.<br>
Таблица с данными о покупателях customer:<br> 
  - customer_id - primary key (первичный ключ таблицы),
  - first_name - имя клиента,
  - last_name - фамилия клиента,
  - adress - город проживания,
  - loyalty - состоит ли в системе лояльности клиент.<br>
Таблица с данными о покупках orders:<br> 
  - order_id - primary key (первичный ключ таблицы),
  - product_id - foreign key (внешний ключ отсылающий к таблице product),
  - customer_id - foreign key (внешний ключ отсылающий к таблице customer),
  - order_length - определяет сколько метров ткани было куплено,
  - date - дата заказа.<br> <br> 

В скрипте requests записаны цель запроса и сам запрос после цели.
