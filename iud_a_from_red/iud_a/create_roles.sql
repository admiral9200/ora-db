--grant create role to c##nexemjail;
--select * from users users;


--drop user c##worker_connection;
drop role c##worker;
drop role c##user_;
drop role c##guest;

create role c##worker;
create role c##user_;
create role c##guest;

--drop user c##worker_connection;
create user c##worker_connection identified by password;
grant c##worker to c##worker_connection;


--drop rolec##worker;
/
grant create session to c##worker;
grant execute on c##nexemjail.INSERT_ORDER to c##worker;
grant execute on c##nexemjail.UPDATE_ORDER_READY_STATUS to c##worker;
grant execute on c##nexemjail.UPDATE_ORDER_RETURN_DATE to c##worker;
grant execute on c##nexemjail.IS_ORDER_READY to c##worker;
grant execute on c##nexemjail.client_orders to c##worker;
grant execute on c##nexemjail.client_info to c##worker;
grant execute on c##nexemjail.get_service_types to c##worker;
grant execute on c##nexemjail.get_offices to c##worker;
grant execute on c##nexemjail.get_orders to c##worker;
grant execute on c##nexemjail.get_client_id to c##worker;
grant execute on c##nexemjail.ready_not_returned to c##worker;
grant execute on c##nexemjail.get_order_info to c##worker;
grant execute on c##nexemjail.get_roles to c##worker;

grant execute on c##nexemjail.update_order_return_date to c##worker;

grant execute on c##nexemjail.GET_SERVICE_TYPES to c##worker;
grant execute on c##nexemjail.GET_BONUSES to c##worker;
grant execute on c##nexemjail.GET_CLIENTS to c##worker;
grant execute on c##nexemjail.GET_DISCOUNT_TYPES to c##worker;
--grant execute on c##nexemjail.UPDATE_USER_LOGIN to c##worker;
grant execute on c##nexemjail.UPDATE_USER_PASSWORD to c##worker;
grant execute on c##nexemjail.get_ready_not_returned_orders to c##worker;
grant execute on c##nexemjail.insert_client to c##worker;



grant c##worker to c##worker_connection;
--grant django_session to c##worker_connection;


--drop role c##user;

grant create session to c##user_;
grant execute on c##nexemjail.IS_ORDER_READY to c##user_;
grant execute on c##nexemjail.get_client_id to c##user_;
grant execute on c##nexemjail.client_info to c##user_;
grant execute on c##nexemjail.client_orders to c##user_;
grant execute on c##nexemjail.get_order_info to c##user_;
grant execute on c##nexemjail.get_service_types to c##user_;
grant execute on c##nexemjail.get_offices to c##user_;
grant execute on c##nexemjail.ready_not_returned to c##user_;
grant execute on c##nexemjail.update_client_info to c##user_;
grant execute on c##nexemjail.UPDATE_USER_PASSWORD to c##user_;


----drop user c##user_connection;
create user c##user_connection identified by password;
grant c##user_ to c##user_connection;
--grant django_session to c##user_connection;





--drop role c##guest;

grant create session to c##guest;
grant execute on c##nexemjail.GET_OFFICES to c##guest;
grant execute on c##nexemjail.check_user_exists to c##guest;
grant execute on c##nexemjail.check_user_in_db to c##guest;
grant execute on c##nexemjail.GET_SERVICE_TYPES to c##guest;

grant execute on c##nexemjail.GET_USER_ROLE to c##guest;
-- THIS IS NOT WORKING!!!!!
grant execute on c##nexemjail.create_user to c##guest;


grant execute on c##nexemjail.register_user to c##guest;
create user c##guest_connection identified by password;

grant c##guest to c##guest_connection;
--grant django_session to c##guest_connection;






--grant insert on c##nexemjail.orders to c##worker;
--grant update on c##nexemjail.orders to c##worker;
--
--grant select on c##nexemjail.orders to c##worker;
--
--grant update on c##nexemjail.invoices to c##worker;
--grant insert on c##nexemjail.invoices to c##worker;


--------

--drop role c##user;


--create role django_session;
--grant create session to django_session;
--grant delete on c##nexemjail.django_session to django_session;





