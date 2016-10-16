--grant create role to c##nexemjail;
--select * from users users;

select * from C##NEXEMJAIL.clients;
select * from C##NEXEMJAIL.users;
select * from C##NEXEMJAIL.orders;
select * from C##NEXEMJAIL.roles;
commit;

drop user c##worker_connection;
create user c##worker_connection identified by password;
grant c##worker to c##worker_connection;

create role c##worker;
drop role c##worker;
/
grant create session to c##worker;
grant execute on C##NEXEMJAIL.INSERT_ORDER to c##worker;
grant execute on C##NEXEMJAIL.UPDATE_ORDER_READY_STATUS to c##worker;
grant execute on C##NEXEMJAIL.UPDATE_ORDER_RETURN_DATE to c##worker;
grant execute on C##NEXEMJAIL.IS_ORDER_READY to c##worker;
grant execute on C##NEXEMJAIL.client_orders to c##worker;
grant execute on c##nexemjail.client_info to c##worker;
grant execute on c##nexemjail.get_service_types to c##worker;
grant execute on c##nexemjail.get_offices to c##worker;
grant execute on c##nexemjail.get_orders to c##worker;
grant execute on c##nexemjail.get_client_id to c##worker;
grant execute on c##nexemjail.ready_not_returned to c##worker;
grant execute on c##nexemjail.get_order_info to c##worker;

grant execute on c##nexemjail.update_order_return_date to c##worker;

grant execute on C##NEXEMJAIL.GET_SERVICE_TYPES to c##worker;
grant execute on C##NEXEMJAIL.GET_BONUSES to c##worker;
grant execute on C##NEXEMJAIL.GET_CLIENTS to c##worker;
grant execute on C##NEXEMJAIL.GET_DISCOUNT_TYPES to c##worker;
--grant execute on C##NEXEMJAIL.UPDATE_USER_LOGIN to c##worker;
grant execute on C##NEXEMJAIL.UPDATE_USER_PASSWORD to c##worker;
grant execute on C##NEXEMJAIL.get_ready_not_returned_orders to c##worker;
grant execute on C##NEXEMJAIL.insert_client to c##worker;



grant c##worker to c##worker_connection;
--grant c##django_session to c##worker_connection;

create role c##user;
drop role c##user;

grant create session to c##user;
grant execute on C##NEXEMJAIL.IS_ORDER_READY to c##user;
grant execute on c##nexemjail.get_client_id to c##user;
grant execute on c##nexemjail.client_info to c##user;
grant execute on c##nexemjail.client_orders to c##user;
grant execute on c##nexemjail.get_order_info to c##user;
grant execute on c##nexemjail.get_service_types to c##user;
grant execute on c##nexemjail.get_offices to c##user;
grant execute on c##nexemjail.ready_not_returned to c##user;
grant execute on c##nexemjail.update_client_info to c##user;
grant execute on C##NEXEMJAIL.UPDATE_USER_PASSWORD to c##user;


--drop user c##user_connection;
create user c##user_connection identified by password;
grant c##user to c##user_connection;
grant c##django_session to c##user_connection;




create role c##guest;
drop role c##guest;

grant create session to c##guest;
grant execute on C##NEXEMJAIL.GET_OFFICES to c##guest;
grant execute on c##nexemjail.check_user_exists to c##guest;
grant execute on c##nexemjail.check_user_in_db to c##guest;
grant execute on C##NEXEMJAIL.GET_SERVICE_TYPES to c##guest;

grant execute on c##nexemjail.GET_USER_ROLE to c##guest;
grant execute on c##nexemjail.create_user to c##guest;
grant execute on c##nexemjail.register_user to c##guest;
create user c##guest_connection identified by password;

grant c##guest to c##guest_connection;
--grant c##django_session to c##guest_connection;






--grant insert on c##nexemjail.orders to c##worker;
--grant update on c##nexemjail.orders to c##worker;
--
--grant select on c##nexemjail.orders to c##worker;
--
--grant update on c##nexemjail.invoices to c##worker;
--grant insert on c##nexemjail.invoices to c##worker;


--------


create role c##user;
drop role c##user;


--create role c##django_session;
--grant create session to c##django_session;
--grant delete on c##nexemjail.django_session to c##django_session;





