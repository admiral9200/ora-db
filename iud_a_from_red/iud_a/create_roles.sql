--grant create role to nexemjail;
--select * from users users;


--drop user worker_connection;
drop role worker;
drop role user_;
drop role guest;

create role worker;
create role user_;
create role guest;

--drop user worker_connection;
create user worker_connection identified by password;
grant worker to worker_connection;


--drop roleworker;
/
grant create session to worker;
grant execute on nexemjail.INSERT_ORDER to worker;
grant execute on nexemjail.UPDATE_ORDER_READY_STATUS to worker;
grant execute on nexemjail.UPDATE_ORDER_RETURN_DATE to worker;
grant execute on nexemjail.IS_ORDER_READY to worker;
grant execute on nexemjail.client_orders to worker;
grant execute on nexemjail.client_info to worker;
grant execute on nexemjail.get_service_types to worker;
grant execute on nexemjail.get_offices to worker;
grant execute on nexemjail.get_orders to worker;
grant execute on nexemjail.get_client_id to worker;
grant execute on nexemjail.ready_not_returned to worker;
grant execute on nexemjail.get_order_info to worker;

grant execute on nexemjail.update_order_return_date to worker;

grant execute on nexemjail.GET_SERVICE_TYPES to worker;
grant execute on nexemjail.GET_BONUSES to worker;
grant execute on nexemjail.GET_CLIENTS to worker;
grant execute on nexemjail.GET_DISCOUNT_TYPES to worker;
--grant execute on nexemjail.UPDATE_USER_LOGIN to worker;
grant execute on nexemjail.UPDATE_USER_PASSWORD to worker;
grant execute on nexemjail.get_ready_not_returned_orders to worker;
grant execute on nexemjail.insert_client to worker;
grant execute on nexemjail.insert_client_v2 to worker;



grant worker to worker_connection;
--grant django_session to worker_connection;


--drop role user;

grant create session to user_;
grant execute on nexemjail.IS_ORDER_READY to user_;
grant execute on nexemjail.get_client_id to user_;
grant execute on nexemjail.client_info to user_;
grant execute on nexemjail.client_orders to user_;
grant execute on nexemjail.get_order_info to user_;
grant execute on nexemjail.get_service_types to user_;
grant execute on nexemjail.get_offices to user_;
grant execute on nexemjail.ready_not_returned to user_;
grant execute on nexemjail.update_client_info to user_;
grant execute on nexemjail.UPDATE_USER_PASSWORD to user_;


----drop user user_connection;
create user user_connection identified by password;
grant user_ to user_connection;
--grant django_session to user_connection;





--drop role guest;

grant create session to guest;
grant execute on nexemjail.GET_OFFICES to guest;
grant execute on nexemjail.check_user_exists to guest;
grant execute on nexemjail.check_user_in_db to guest;
grant execute on nexemjail.GET_SERVICE_TYPES to guest;

grant execute on nexemjail.GET_USER_ROLE to guest;
-- THIS IS NOT WORKING!!!!!
--grant execute on nexemjail.create_user to guest;


grant execute on nexemjail.register_user to guest;
create user guest_connection identified by password;

grant guest to guest_connection;
--grant django_session to guest_connection;






--grant insert on nexemjail.orders to worker;
--grant update on nexemjail.orders to worker;
--
--grant select on nexemjail.orders to worker;
--
--grant update on nexemjail.invoices to worker;
--grant insert on nexemjail.invoices to worker;


--------

--drop role user;


--create role django_session;
--grant create session to django_session;
--grant delete on nexemjail.django_session to django_session;





