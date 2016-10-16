create or replace trigger Set_Order_Price_Status_Trigger
  before insert on orders 
  for each row
  declare 
    service_price number;
    service_bonus_percentage number;
    discount number;
  begin
    select base_cost
    into service_price
    from service_types
    where service_types.id = :new.service_type_id;
  
    if :new.service_bonus_id is null then
      service_bonus_percentage := 0;
    else
      select value
      into service_bonus_percentage
      from bonuses
      where bonuses.id = :new.service_bonus_id;
    end if;
    
    if :new.discount_type_id is null and check_is_best_client(:new.client_id) then
      select id 
        into discount
        from discount_types
        where discount_types.description like 'Best client%';
      
      :new.discount_type_id := discount; 
    end if;
    
    if :new.discount_type_id is null then
      discount := 0;
    else
      select value
      into discount
      from discount_types
      where :new.discount_type_id = discount_types.id;
    end if;
    :new.total_price := :new.amount * (service_price * (1 + service_bonus_percentage / 100)) * (1 - discount/100) ;
    :new.is_ready := 0;
  end;
/


create or replace trigger Set_Best_Client_Trigger
  after insert on orders 
  for each row
  declare 
    num_orders integer;
  begin
    if not CHECK_IS_BEST_CLIENT(:new.client_id) then 
      dbms_output.put_line(:new.client_id);
      num_orders := GET_ORDERS_COUNT(:new.client_id);
      dbms_output.put_line(num_orders);
      if num_orders >= 3 then
        UPDATE_CLIENT_STATUS(:new.client_id, 1);
      end if;
    end if;
  end;
/
select * from orders;
select * from clients;
/

create or replace trigger log_best_client_changing
  after update of best_client on clients
  for each row
  begin  
    if :new.best_client = 1 then
      log_best_client(:new.id || ' ' || :new.first_name || ' ' 
                      || :new.last_name || ' became a best client!'); 
    end if;  
  end;
/





