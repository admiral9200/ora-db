select * from offices;
select * from bonuses;
select * from roles;
select * from SERVICE_TYPES;
select * from clients;
select * from DISCOUNT_TYPES;
/
begin
  INSERT_OFFICE('Minsk, st.Natsionalizma 170', 'Office of Unibel in Minsk');
  Insert_Office('Brest, st.Sovetskaya 187', 'Office of Unibel in Brest');
  Insert_Office('Vitebsk, st.Malinovaya 170', 'Office of Unibel in Vitebsk');
  Insert_Office('Gomel, st.Lexmark 187', 'Office of Unibel in Gomel');
  INSERT_BONUS('Rapidity', 13.5);
  INSERT_BONUS('Extra Rapidity', 25);
  
  INSERT_SERVICE_TYPE('Coat cleaning', 130000);
  INSERT_SERVICE_TYPE('Suite cleaning', 148000);
  INSERT_SERVICE_TYPE('Dress cleaning', 98000);
  INSERT_SERVICE_TYPE('Pants cleaning', 78500);
  INSERT_SERVICE_TYPE('Scarf cleaning', 51000);
  INSERT_SERVICE_TYPE('Stocking cleaning', 53000);
  
  INSERT_DISCOUNT_TYPE('Best client', 3);
  INSERT_DISCOUNT_TYPE('Anivessary', 7);
  INSERT_DISCOUNT_TYPE('Worker', 12);  
  INSERT_DISCOUNT_TYPE('GOD', 100);  
  INSERT_ROLE('admin');
  INSERT_ROLE('worker');
  INSERT_ROLE('customer');
  INSERT_ROLE('animewasamistake');
--  Insert_client('Alex', 'Sh', 1);
--  Insert_client('Tama', 'Robo', 0);
--  Insert_client('Kagura', 'Umibozu', 1);
--  Insert_client('Katsura', 'Kotaro', 1);
--  Insert_client('Hasegava', 'Taizo', 0);
--  Insert_client('Tsukuyo','The moon', 1);
  Insert_user('nexemjail', 'password', 2, null); -- worker
  INSERT_USER('kagura', 'password', 3, 3);
  INSERT_USER('tsukuyo', 'password', 3, 21);-- as customer
    --delete from users;
  INSERT_INVOICE(41);
  INSERT_INVOICE(42);
  INSERT_INVOICE(1);
  INSERT_INVOICE(500);
end;
/
select * from clients;
select * from INVOICES;
/

declare
  client_id integer;
  service_type_id integer;
  office_id integer;
  worker_login varchar(500);
begin
  Select Id
  into client_id
  from clients
  where clients.FIRST_NAME like 'Tsuku%';

  select id
  into service_type_id
  from SERVICE_TYPES
  where name = 'Coat cleaning';

  select id
  into office_id
  from OFFICES
  where OFFICES.ADDRESS like 'Viteb%';

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
    3,
    Systimestamp
    );
    commit;
end;
/
select * from orders;
select * from clients;
select * from invoices;
/

begin
    null;
     INSERT_Invoice(42);
    -- Insert_client('Gorilla','Hamburger', 0);
end;
/




    


  
  
