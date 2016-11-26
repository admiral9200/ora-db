select * from orders;
/
create or replace procedure update_client_info(new_first_name varchar ,new_last_name  varchar ,
    id_to_update integer) as
begin
  update clients
    set clients.FIRST_NAME = new_first_name, clients.LAST_NAME = new_last_name
    where clients.ID = id_to_update;  
end;
/
create or replace procedure update_client_status(client_id integer, status integer)
as
begin
  if not ( status = 1 or status = 0 ) then 
    -- raise an exception here!
    SYS.DBMS_OUTPUT.put_line('invalid status of customer!');
  else
    UPDATE clients
      set clients.best_client = status
      where clients.id = client_id;
  end if;
end;
/
create or replace procedure update_office_info(office_id integer, new_address varchar,
  new_info varchar)
as
begin
  update OFFICES
    set ADDRESS = new_address, info = new_info
    where id = office_id;
  DBMS_OUTPUT.put_line(office_id || ' updated');
end;
/
create or replace procedure update_role(role_id integer, new_name varchar)
as
begin
  update roles
    set NAME = new_name
    where ID = role_id;
end;
/
create or replace procedure update_bonus_value(bonus_id integer, new_value number)
as
begin
  update bonuses
    set value = new_value
    where id = bonus_id;
end;
/
create or replace procedure update_bonus_type(bonus_id integer, new_type varchar2)
as
begin
  update bonuses
    set type = new_type
    where id = bonus_id;
end;
/
create or replace procedure update_discount_description(discount_id integer, new_desc varchar2)
as
begin
  update discount_types
    set DESCRIPTION = new_desc
    where ID = discount_id;
end;
/
create or replace procedure update_discount_value(discount_id integer, new_value number)
as
begin
  update discount_types
    set value = new_value
    where ID = discount_id;
end;
/
create or replace procedure update_service_type_name(service_id integer, new_name varchar2)
as
begin
  update SERVICE_TYPES
    set name = new_name
    where ID = service_id;
end;
/
create or replace procedure update_service_type_base_cost(service_id integer, new_base_cost number)
as
begin
  update SERVICE_TYPES
    set BASE_COST = new_base_cost
    where ID = service_id;
end;
/
create or replace procedure update_user_password(login_ varchar, new_pass varchar)
as
begin
  update Users
  set PASSWORD = ora_hash(new_pass)
  where login = login_;
end;
/
create or replace procedure update_user_client_id(login_ varchar, new_client_id integer)
as
begin
  update Users
  set client_id = new_client_id
  where login = login_;
end;
/
--- dependency!! replace with some shitty stuff
create or replace procedure update_user_login(old_login varchar, new_login varchar)
as
begin
  update Users
  set login =  new_login
  where login = old_login;
end;
/
create or replace procedure update_order_ready_status(order_id integer, status integer)
as
begin
  update ORDERS
    set orders.IS_READY = status
    where orders.id = order_id;
  COMMIT;
end;
/
-- aka return order
create or replace procedure update_order_return_date(order_id integer)
AS
begin
  update ORDERS
  set RETURN_DATE = SYSTIMESTAMP
  where id = order_id;
end;
/ 
create or replace procedure update_order_discount_type(order_id integer, new_discount_type integer)
AS
begin
  update ORDERS
  set DISCOUNT_TYPE_ID = new_discount_type
  where id = order_id;
end;
/ 
create or replace procedure update_order_total_price(order_id integer, new_price integer)
AS
begin
  update ORDERS
  set TOTAL_PRICE = new_price
  where id = order_id;
end;
/ 
create or replace procedure update_order_amount(order_id integer, new_amount integer)
AS
begin
  update ORDERS
  set AMOUNT = new_amount
  where id = order_id;
end;
/ 
create or replace procedure update_order_bonus_id(order_id integer, new_bonus_id integer)
AS
begin
  update ORDERS
  set SERVICE_BONUS_ID = new_bonus_id
  where id = order_id;
end;
/ 
--drop procedure update_orders_bonus_id;
--/
create or replace procedure update_order_office(order_id integer, new_office integer)
AS
begin
  update ORDERS
  set OFFICE_ID = new_office
  where id = order_id;
end;
/ 
create or replace procedure update_user_login(old_login varchar , new_login varchar)
as
  user_record users%rowtype;
begin
  select * 
  into user_record
  from users
  where login = old_login;
  
  user_record.Login := new_login;
  
  insert into users
  values user_record;
  
  update orders
  set WORKER_LOGIN = new_login
  where worker_login = old_login;
  
  delete from users
  where login = old_login;
  
end;
/




select * from clients;
/


declare 
  id_to_replace integer;
begin
  select id
  into id_to_replace
  from clients 
  where first_name like 'Alex%';

--  DBMS_OUTPUT.PUT_LINE(id_to_replace);
--  UPDATE_CLIENT_INFO(
--  'Alexey',
--  'Shlemenkov',
--  id_to_replace
--  );
--  SET_CLIENT_STATUS(id_to_replace, 2);
--  UPDATE_OFFICE_INFO(1,'Minsk, st.Natsionalizma 170', 'Office of Unibel in Minsk');
--  UPDATE_ROLE(1,'admin');
--  UPDATE_BONUS_Value(1,13.5);
--  UPDATE_DISCOUNT_DESCRIPTION(1,'Best client');
--  UPDATE_DISCOUNT_VALUE(1,3);
-- UPDATE_SERVICE_TYPE_BASE_COST(1,130000);
--  UPDATE_SERVICE_TYPE_NAME(1,'Coat cleaning');
--  UPDATE_USER_PASSWORD('nexemjail', 'password');
--  UPDATE_USER_CLIENT_ID('kagura', 3);
-- UPDATE_USER_LOGIN('nexemjail', 'nexemjail1');  
-- UPDATE_ORDER_READY_STATUS(1,1);
-- UPDATE_ORDER_RETURN_DATE(1);
--  UPDATE_ORDER_DISCOUNT_TYPE(1,2);
--  UPDATE_ORDER_TOTAL_PRICE(1,500);
-- UPDATE_ORDER_AMOUNT(1,200);
-- UPDATE_ORDERS_BONUS_ID(1,null);
--UPDATE_ORDER_OFFICE(1,1);
--  delete from users
--  where LOGIN = 'nexemjail1';

-- UPDATE_USER_LOGIN('nexemjail', 'nexemjail1');
-- UPDATE_USER_LOGIN('nexemjail1', 'nexemjail');
end;
/


select * from users;
select * from orders;
select * from service_types;
select * from discount_types;
select * from bonuses;
select * from OFFICES;
select * from roles;
