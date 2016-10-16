create or replace function get_ready_not_returned_orders return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from ORDER_VIEW
    where IS_READY = 1 and RETURN_DATE is null;
  return v_cursor;
end;
/


create or replace function get_discount_types return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from DISCOUNT_TYPES;
  return v_cursor;
end;
/


create or replace function get_bonuses return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from BONUSES;
  return v_cursor;
end;
/


create or replace function get_orders return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from ORDER_VIEW;
  return v_cursor;
end;
/


create or replace function get_client_id(u_login varchar) return integer
as  
  id_ integer;
  client_id_ integer;
begin
  if not CHECK_IS_USER_WORKER(u_login) then
  
    select client_id
      into id_
      from users
      where LOGIN = u_login;
    
    select ID
    into client_id_
    from CLIENTS
    where id = id_;
    return client_id_;
  end if;
  
  
  return 0;
  
  exception
    when NO_DATA_FOUND then
      return 0;
  
end;
/


create or replace function get_service_types return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from Service_types;
  return v_cursor;
end;
/

create or replace function is_order_ready(id_ integer) return boolean
as  
 is_ready integer := 0;
begin
  select  orders.is_ready
    into is_ready
    from orders
    where orders.id = id_;
  if is_ready = 0 then
    return false;
  else
    return true;
  end if;
end;
/
select * from order_view;
/

create or replace function client_info(id_ integer) return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from clients
    where ID = id_;
  return v_cursor;
end;
/




create or replace function client_orders(id_ integer) return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from order_view
      where ID  in (select orders.id from orders where orders.client_id = id_)
      order by order_view.ACCEPTANCE_DATE desc, order_view.IS_READY asc;
  return v_cursor;
end;
/

create or replace function ready_not_returned(id_ integer) return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from order_view
      where order_view.id in (select orders.id from orders
                              where orders.client_id = id_ 
                              and is_ready = 1
                              and return_date is null)
      order by order_view.ACCEPTANCE_DATE desc;
  return v_cursor;
end;
/

select * from orders;


create or replace function get_offices return sys_refcursor
as
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select *
    from offices
    order by address asc;
  return v_cursor;    
end;
/
create or replace function get_ordinary_clients return sys_refcursor 
  as
  v_cursor sys_refcursor;
begin
  open v_cursor for 
    select Id, first_name, LAST_NAME
    from clients  
    where BEST_CLIENT = 0;
  return v_cursor;    
end;
/

create or replace function get_best_clients return sys_refcursor 
  as
  v_cursor sys_refcursor;
begin
  open v_cursor for 
    select Id, first_name, LAST_NAME
    from clients  
    where BEST_CLIENT = 1;
  return v_cursor;    
end;
/

select * from clients;
/
select * from users;
/

create or replace function get_clients return sys_refcursor 
  as
  v_cursor sys_refcursor;
begin
  open v_cursor for 
    select id, first_name, last_name
    from clients
    order by id asc;
  return v_cursor;
end;
/

create or replace function get_workers return sys_refcursor 
  as
  v_cursor sys_refcursor;
begin
  open v_cursor for 
    select login
    from users
    where users.client_id is null;
    return v_cursor;
end;
/
create or replace function get_client_orders(id_ integer) return sys_refcursor
as
v_cursor sys_refcursor;
begin
  open v_cursor for
    select orders.id, clients.first_name, clients.last_name , service_types.name,
          bonuses.type, offices.address, amount, total_price,
          discount_types.description, acceptance_date, return_date, is_ready
    from orders
    join clients
    on clients.id = orders.client_id
    join SERVICE_TYPES
    on orders.service_type_id = service_types.id
    join offices
    on offices.id = orders.office_id
    join users
    on users.login = orders.worker_login
    left join discount_types
    on orders.discount_type_id = discount_types.id
    left join bonuses
    on orders.service_bonus_id = bonuses.id
    where orders.client_id = id_;
  return v_cursor;
end;
/

-- select most active worker
create or replace function get_best_worker return sys_refcursor
as
v_cursor sys_refcursor;
begin
  open v_cursor for
    select max(worker_login), count(id)
    from orders
    group by worker_login;
  return v_cursor;
end;
/
--  get admins/workers
create or replace function get_admins return sys_refcursor
as
v_cursor sys_refcursor;
begin
  open v_cursor for
    select login
    from users 
    join roles 
    on roles.id = users.ROLE_ID
    where roles.NAME like 'admin%';
  return v_cursor;
end;
/

create or replace function get_workers return sys_refcursor
as
v_cursor sys_refcursor;
begin
  open v_cursor for
    select login
    from users 
    join roles 
    on roles.id = users.ROLE_ID
    where roles.NAME like 'worker%';
  return v_cursor;
end;
/
create or replace function get_customers return sys_refcursor
as
v_cursor sys_refcursor;
begin
  open v_cursor for
    select login
    from users 
    join roles 
    on roles.id = users.ROLE_ID
    where roles.NAME like 'user%';
  return v_cursor;
end;
/
select * from roles;
/


create or replace function get_clients_by_service_type(service_type_name varchar) return sys_refcursor
as
v_cursor sys_refcursor;
begin
  open v_cursor for
-- select customer with target service type
    select distinct clients.first_name, clients.last_name
    from clients 
    join orders 
    on clients.id = orders.client_id
    join service_types 
    on orders.SERVICE_TYPE_ID in  ( select id
                                  from SERVICE_TYPES
                                  where name like '%' || service_type_name|| '%');

  return v_cursor;
end;
/

create or replace function get_not_ready_orders_count return sys_refcursor
as
  v_cursor sys_refcursor;
begin
  open v_cursor for
-- select count of  not not ready orders
    select count(id)
    from orders
    where is_ready = 0;
-- = 1;
  return v_cursor;
end;
/
create or replace function get_ready_orders_count return sys_refcursor
as
  v_cursor sys_refcursor;
begin
  open v_cursor for
-- select count of  not not ready orders
    select count(id)
    from orders
    where is_ready = 1;
-- = 1;
  return v_cursor;
end;
/

create or replace function get_orders_by_worker_login(worker_login_ varchar) return sys_refcursor
as
  v_cursor sys_refcursor;
begin
  open v_cursor for
--  select orders collected by worker 'name'
    select clients.first_name, clients.last_name, TOTAL_PRICE, amount 
    from orders
    join clients 
    on orders.client_id = clients.id
    where WORKER_LOGIN = worker_login_;
  return v_cursor;
end;
/


select * from bonuses;

-- select order with current bomus_service
select orders.id
from orders
join bonuses
on orders.SERVICE_BONUS_ID = bonuses.id
where bonuses.TYPE like 'Rapidity';

select * from orders;

--select services with base cost less than
select name
from SERVICE_TYPES
where BASE_COST > 50000;


--select office with maximum clients ever
select count(orders.id), offices.id, offices.ADDRESS
from offices
join orders
on offices.ID = orders.OFFICE_ID
group by offices.address, offices.id
order by count(orders.id) desc;

select * from orders;
select * from offices;

-- select most active client

select count(orders.id),  max(clients.first_name), max(clients.last_name)
from clients
join orders
on clients.id = orders.CLIENT_ID
group by orders.client_id
order by count(orders.id) desc;


select * from roles;
/

--Вывести список услуг в указанный промежуток времени, 
-- которые были начаты, но не закончены, то есть дата возврата в указанный промежуток времени ещё не наступила.
select * from orders;
select * 
from orders
where orders.ACCEPTANCE_DATE < sysdate and orders.return_date is null;
--Вывести список клиентов, которые в указанный промежуток времени
-- воспользовались услугами химчистки только один раз.
select max(clients.first_name), max(clients.last_name), count(clients.id)
from orders
join clients
on clients.id = orders.client_id
where orders.acceptance_date > SYSDATE - 10 and orders.return_date < sysdate
group by clients.id
having count(clients.id) = 1;


