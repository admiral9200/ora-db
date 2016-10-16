create or replace function get_order_info(id_ integer) return sys_refcursor
as
  v_cursor sys_refcursor;
begin
  open v_cursor for
    select * from order_view
    where order_view.id = id_;
  return v_cursor;
end;
/
select * from orders;
/

drop view order_view;
/
create view order_view as
  select orders.id, clients.first_name , clients.last_name , service_types.name as service_name,
          bonuses.type as bonus_type, offices.address as office_address ,
          amount, total_price, discount_types.description as discount_type,
          acceptance_date, 
          return_date, is_ready
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
  on orders.service_bonus_id = bonuses.id;
  
select * from orders;
select * from order_view;
  
drop view users_view;
  
create view users_view as
  select login, first_name, last_name, roles.name
  from users
  left join clients
  on users.CLIENT_ID = clients.id
  join roles
  on users.role_id = roles.id;

select * from users_view;
select * from users;
  
drop view invoice_view;
create view invoice_view as
  select invoices.id, first_name, last_name, service_types.name,
          orders.total_price, orders.worker_login, invoices.TIME,  offices.address
  from orders
  join invoices
  on orders.id = invoices.order_id
  join clients
  on orders.client_id = clients.id
  join service_types
  on orders.service_type_id = service_types.id
  join offices
  on orders.office_id = offices.id;

select * from invoices;
select * from invoice_view;
