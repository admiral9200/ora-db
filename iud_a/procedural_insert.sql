create or replace procedure insert_order(client_id integer, service_type_id integer,
  service_bonus_id integer, office_id integer, worker_login varchar, discount_type_id integer,
  amount integer, acceptance_date TIMESTAMP) 
  as
    login_count number;  
    id_ integer;
    total_price_ number(10,2);
    datum date := SYSTIMESTAMP;
  begin
    if client_id is null then
      dbms_output.put_line('client not unvalid');
      return ;
    elsif not CHECK_CLIENT_EXISTS(client_id) then
      raise exceptions_package.client_not_found;
    end if;
    if service_type_id is null then
      dbms_output.put_line('service type unvalid');
      return ;
    elsif not CHECK_SERVICE_TYPE_EXISTS(service_type_id) then
      raise exceptions_package.service_type_not_found;
    end if;
    if office_id is null then 
      dbms_output.put_line('office unvalid');
      return ;
    elsif not CHECK_OFFICE_EXISTS(office_id) then
      raise exceptions_package.office_not_found;
    end if;
    if worker_login is null then
      dbms_output.put_line('worker login unvalid');
      return ;
    elsif not CHECK_USER_EXISTS(worker_login) then
      raise exceptions_package.user_not_found;
    elsif not CHECK_IS_USER_WORKER(worker_login) then
      raise exceptions_package.user_is_not_a_worker;
    end if;
    if (amount < 0) then
      dbms_output.put_line('unvalid amount!');
      raise exceptions_package.invalid_amount;
    end if;
    
    if acceptance_date is null then
     datum := SYSTIMESTAMP;
    else
      datum := acceptance_date;
    end if;
  
--    if datum > SYSTIMESTAMP then
--      dbms_output.put_line('invalid acceptance time');
--      raise exceptions_package.invalid_acceptance_date;
--    end if;
  
  insert into orders (CLIENT_ID,SERVICE_TYPE_ID,SERVICE_BONUS_ID, OFFICE_ID, WORKER_LOGIN, DISCOUNT_TYPE_ID,
  AMOUNT, ACCEPTANCE_DATE)
    values (CLIENT_ID,SERVICE_TYPE_ID,SERVICE_BONUS_ID, OFFICE_ID, WORKER_LOGIN, DISCOUNT_TYPE_ID,
      AMOUNT, datum);    
  
  select id
  into id_
  from orders
  where acceptance_date = (select max(acceptance_date) from orders);
      
  select orders.total_price
    into total_price_
    from orders 
    where id = id_;
    log_order(id_, client_id, office_id, amount, service_type_id ,total_price_);

  INSERT_INVOICE(id_);
  commit;
  exception
    when exceptions_package.client_not_found then 
          DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
    when exceptions_package.service_type_not_found then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.office_not_found then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.user_not_found then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.user_is_not_a_worker then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.invalid_amount then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.invalid_acceptance_date then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');  
end;
/
create or replace procedure update_order( order_id_ integer, client_id integer, service_type_id integer,
  service_bonus_id integer, office_id integer, worker_login varchar, discount_type_id integer,
  amount integer, acceptance_date TIMESTAMP)
  as
    login_count number;  
    id_ integer;
    total_price_ number(10,2);
    datum date := SYSTIMESTAMP;
  begin
    if client_id is null then
      dbms_output.put_line('client not unvalid');
      return ;
    elsif not CHECK_CLIENT_EXISTS(client_id) then
      raise exceptions_package.client_not_found;
    end if;
    if service_type_id is null then
      dbms_output.put_line('service type unvalid');
      return ;
    elsif not CHECK_SERVICE_TYPE_EXISTS(service_type_id) then
      raise exceptions_package.service_type_not_found;
    end if;
    if office_id is null then 
      dbms_output.put_line('office unvalid');
      return ;
    elsif not CHECK_OFFICE_EXISTS(office_id) then
      raise exceptions_package.office_not_found;
    end if;
    if worker_login is null then
      dbms_output.put_line('worker login unvalid');
      return ;
    elsif not CHECK_USER_EXISTS(worker_login) then
      raise exceptions_package.user_not_found;
    elsif not CHECK_IS_USER_WORKER(worker_login) then
      raise exceptions_package.user_is_not_a_worker;
    end if;
    if (amount < 0) then
      dbms_output.put_line('unvalid amount!');
      raise exceptions_package.invalid_amount;
    end if;
    
    if acceptance_date is null then
     datum := SYSTIMESTAMP;
    else
      datum := acceptance_date;
    end if;
  
--    if datum > SYSTIMESTAMP then
--      dbms_output.put_line('invalid acceptance time');
--      raise exceptions_package.invalid_acceptance_date;
--    end if;
  
  update orders 
  set 
  CLIENT_ID = CLIENT_ID,
  SERVICE_TYPE_ID = SERVICE_TYPE_ID,
  SERVICE_BONUS_ID = SERVICE_BONUS_ID,
  OFFICE_ID = OFFICE_ID,
  WORKER_LOGIN = WORKER_LOGIN,
  DISCOUNT_TYPE_ID = DISCOUNT_TYPE_ID,
  AMOUNT = AMOUNT,
  ACCEPTANCE_DATE = datum
  where id = order_id_;    
  
--  select id
--  into id_
--  from orders
--  where acceptance_date = (select max(acceptance_date) from orders);
--      
--  select orders.total_price
--    into total_price_
--    from orders 
--    where id = id_;
--    log_order(id_, client_id, office_id, amount, service_type_id ,total_price_);

--  INSERT_INVOICE(id_);
  commit;
  exception
    when exceptions_package.client_not_found then 
          DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
    when exceptions_package.service_type_not_found then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.office_not_found then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.user_not_found then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.user_is_not_a_worker then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.invalid_amount then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');
      when exceptions_package.invalid_acceptance_date then
       DBMS_OUTPUT.PUT_line('error!!!!!');
        LOG_ERROR(SQLERRM || 'Exception occured while inserting an order!');
        raise_application_error(SQLCode, SQLERRM || 'Exception occured while inserting an order!');  
end;
/



create or replace procedure insert_office(new_address varchar, new_info varchar)
as
  address_ varchar(150);
  info_ varchar(500);  
begin
  if new_address = '' or new_address is null then
    dbms_output.put_line('invalid address!');
    return;
  end if;
  
  if new_info = '' or new_info is null then
    dbms_output.put_line('invalid address!');
    return;
  end if;
  
  select info, address 
  into info_, address_
  from offices
  where offices.info = new_info and offices.address = new_address;
  
  dbms_output.put_line('office already exists!');
  exception
    when no_data_found THEN
    insert into OFFICES(Address, info)
      values (new_address,new_info);
end;
/
create or replace procedure insert_bonus(bonus_name varchar, bonus_value varchar)
as
  bonus_record bonuses%rowtype;
begin
  if bonus_name = '' or bonus_name is null then
    dbms_output.put_line('bonus name not specified');
    return;
  end if;
  
  if bonus_value is null then
    dbms_output.put_line('bonus value invalid!');
    return;
  elsif bonus_value <= 0 then
    raise exceptions_package.invalid_bonus_value;
  end if;
  
  select * 
  into bonus_record
  from BONUSES
  where bonuses.type = bonus_name and bonuses.value = bonus_value;
  
  dbms_output.put_line('bonus already exists!');
  exception
    when exceptions_package.invalid_bonus_value then
      LOG_ERROR(SQLERRM || 'Error while inserting bonus!');
      raise_application_error(SQLCODE, SQLERRM || 'Error while inserting bonus!');
    when no_data_found THEN
    insert into Bonuses(TYPE, VALUE)
      values (bonus_name, bonus_value);
end;
/

create or replace procedure insert_service_type( service_name varchar, service_base_cost number)
as
  service_record service_types%rowtype;
begin
  if service_name = '' or service_name is null then
    dbms_output.put_line('service name not specified');
    return;
  end if;
  
  if service_base_cost is null  then
    dbms_output.put_line('service cost invalid');
    return;
  elsif service_base_cost < 0 then
    raise exceptions_package.invalid_service_price;
  end if;
  
  select * 
  into service_record
  from SERVICE_TYPES
  where name = service_name and base_cost = service_base_cost;
  
  dbms_output.put_line('service already exists!');
  exception
    when exceptions_package.invalid_service_price then
      LOG_ERROR(SQLERRM || 'Error while inserting a service type!');
      raise_application_error(SQLCODE, SQLERRM || 'Error while inserting a service type!');
    when no_data_found THEN
    insert into SERVICE_TYPES(name, base_cost)
      values (service_name,service_base_cost);
end;
/

create or replace procedure insert_discount_type(discount_desc varchar, disc_value number)
as
  discount_record discount_types%rowtype;
begin
  if discount_desc = '' or discount_desc is null then
    dbms_output.put_line('discount description not specified');
    return;
  end if;
  
  if disc_value is null then
    dbms_output.put_line('discount value invalid');
    return;
  elsif disc_value < 0 or disc_value > 100  then
    raise exceptions_package.invalid_discount_value;
  end if;
  
  select * 
  into discount_record
  from DISCOUNT_TYPES
  where DESCRIPTION = discount_desc and value = disc_value;
  dbms_output.put_line('discount already exists!');
  
  exception
    when exceptions_package.invalid_discount_value then
      LOG_ERROR(SQLERRM || 'Error while inserting a discount!');
      raise_application_error(SQLCODE, SQLERRM || 'Error while inserting a discount!');
    when no_data_found THEN
      insert into DISCOUNT_TYPES(DESCRIPTION, value)
       values (discount_desc,disc_value);
end;
/

create or replace procedure insert_role(role_name varchar)
as
  role_record roles%rowtype := null;
begin
  if role_name = '' or role_name is null then
    dbms_output.put_line('role name not specified');
    return;
  end if;
  
  select * 
  into role_record
  from roles
  where roles.name = role_name;
  dbms_output.put_line('role already exists!');
  
  exception
    when no_data_found THEN
      insert into Roles(name)
        values (role_name);
end;
/


create or replace procedure insert_client(client_f_name varchar, client_l_name varchar,
                                                      is_best_client number)
as
  client_record clients%rowtype := null;
begin
  if client_f_name = '' or client_f_name is null then
    dbms_output.put_line('client first name not specified');
    return;
  end if;
  
  if client_l_name = '' or client_l_name is null then
    dbms_output.put_line('client last name not specified');
    return;
  end if;
  
  if is_best_client is null and  not (is_best_client = 1 or is_best_client = 0) then
    dbms_output.put_line('best client flag not specified correctly');
    raise exceptions_package.invalid_best_client_flag;
    return;
  end if;
  
  insert into CLIENTS(FIRST_NAME, LAST_NAME, BEST_CLIENT)
    values (client_f_name, client_l_name, is_best_client);
  
  exception
    when exceptions_package.invalid_best_client_flag then
       LOG_ERROR(SQLERRM || 'Error while inserting a client!');
      raise_application_error(SQLCODE, SQLERRM || 'Error while inserting a client!');
end;
/
create or replace procedure insert_invoice(input_order_id integer)
as
  invoice_record invoices%rowtype := null;
  invoice_id integer := null;
begin
  if input_order_id is null then
    dbms_output.put_line('order id invalid!');
    return;
  elsif not CHECK_ORDER_EXISTS(input_order_id) then
    raise exceptions_package.order_not_found;
  
  end if;
  
  select * 
  into invoice_record
  from invoices
  where input_order_id = ORDER_ID;
  dbms_output.put_line('invoice already exists!');
  
  exception
    when exceptions_package.order_not_found  then
        LOG_ERROR(SQLERRM || 'Error while inserting an invoice!');
        raise_application_error(SQLCODE, SQLERRM || 'Error while inserting an invoice!');
    when no_data_found THEN
      insert into invoices(ORDER_ID, TIME)
        values (input_order_id, SYSTIMESTAMP);
    
end;
/

select * from discount_types;
/


