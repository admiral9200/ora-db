drop function check_client_exists;
/
select * from roles;

create or replace function check_is_best_client(id_ integer) return boolean
as
  is_best_client number;
begin
  select best_client
    into is_best_client
    from clients
    where clients.id = id_;
    
  if is_best_client = 0 then
    return false;
  else
    return true;
  end if;
end;
/
create or replace function check_client_exists(client_id integer) return boolean
as
  temp_id integer;
begin
  select id
  into temp_id
  from clients
  where ID = client_id;
  return true;
  exception
    when no_data_found then
      return false;
end;
/
create or replace function check_bonus_exists(id_ integer) return boolean
as
  temp_id integer;
begin
  select id
  into temp_id
  from bonuses
  where ID = id_;
  return true;
  exception
    when no_data_found then
      return false;
end;
/
create or replace function check_order_exists(order_id integer) return boolean
as
  temp_id integer;
begin
  select id
  into temp_id
  from orders
  where ID = order_id;
  return true;
  exception
    when no_data_found then
      return false;
end;
/

create or replace function check_discount_exists(id_ integer) return boolean
as
  temp_id integer;
begin
  select id
  into temp_id
  from DISCOUNT_TYPES
  where ID = id_;
  return true;
  exception
    when no_data_found then
      return false;
end;
/

create or replace function check_office_exists(id_ integer) return boolean
as
  temp_id integer;
begin
  select id
  into temp_id
  from OFFICES
  where ID = id_;
  return true;
  exception
    when no_data_found then
      return false;
end;
/


create or replace function check_role_exists(id_ integer) return boolean
as
  temp_id integer;
begin
  select id
  into temp_id
  from ROLES
  where ID = id_;
  return true;
  exception
    when no_data_found then
      return false;
end;
/

create or replace function check_service_type_exists(id_ integer) return boolean
as
  temp_id integer;
begin
  select id
  into temp_id
  from SERVICE_TYPES
  where ID = id_;
  return true;
  exception
    when no_data_found then
      return false;
end;
/

create or replace function check_invoice_exists(id_ integer) return boolean
as
  temp_id integer;
begin
  select id
  into temp_id
  from INVOICES
  where ID = id_;
  return true;
  exception
    when no_data_found then
      return false;
end;
/
create or replace function check_user_exists(u_login varchar) return boolean
as
  temp_id integer;
begin
  select role_id
    into temp_id
    from users
    where login = u_login;
  return true;
  exception
    when no_data_found then
      return false;
end;
/
select * from orders;


create or replace function check_is_user_worker(u_login varchar) return boolean
as
  temp_id integer;
  ROLE_ INTEGER;
begin

  SELECT ROLE_ID
  INTO TEMP_ID
  FROM USERS
  WHERE USERS.LOGIN = U_LOGIN;
  
  SELECT roles.ID
  INTO role_
  FROM ROLES
  WHERE roles.NAME LIKE 'worker%';
  
  IF (ROLE_ = TEMP_ID) then 
    return true;
  end if;
    return false;
    
  exception
    when NO_DATA_FOUND then
      return false;
end;
/
create or replace function get_orders_count(client_id_ integer) return number
as
  PRAGMA AUTONOMOUS_TRANSACTION;
  num_orders number := 0;
begin
  select count(orders.id)
    into num_orders
    from orders
    where orders.client_id  = client_id_;
  dbms_output.put_line('got orders ' || num_orders);
  return num_orders;
end;
/


