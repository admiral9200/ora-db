declare
  client_id integer;
  service_type_id integer;
  office_id integer;
  worker_login varchar(500);
begin
  Select Id
  into client_id
  from clients
  where clients.FIRST_NAME like 'Hasegava%';

  select id
  into service_type_id
  from SERVICE_TYPES
  where name = 'Coat cleaning';

  select id
  into office_id
  from OFFICES
  where OFFICES.ADDRESS like 'Minsk%';

  select login
  into worker_login
  from USERS
  where USERS.LOGIN like 'nexemjail%';

  INSERT_ORDER(
    client_id,
    service_type_id,
    null,
    office_id,
    worker_login,
    null,
    15,
    Systimestamp
    );
end;
/
select * from service_types;
select * from orders;
select * from clients;
/