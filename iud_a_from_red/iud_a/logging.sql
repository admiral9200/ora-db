-- doing loggin here
CREATE OR REPLACE DIRECTORY LOG_DIR AS 'C:\Users\shevc\Documents\ora-db\';
GRANT READ ON DIRECTORY LOG_DIR TO PUBLIC; 
/

create or replace procedure log_best_client(str varchar)
as
  out_file utl_file.file_type;
  cur_date varchar(500);
begin 
    select cast(systimestamp as varchar(500))
    into cur_date 
    from dual;
    out_file := Utl_File.FOpen('LOG_DIR', 'best_clients.txt' , 'a');
    Utl_File.Put_Line(out_file , str || ' ' || cur_date);
    Utl_File.FClose(out_file);
end;
/

create or replace procedure log_error(err_msg varchar)
as
  out_file utl_file.file_type;
  cur_date varchar(500);
begin
    select cast(systimestamp as varchar(500))
    into cur_date 
    from dual;
    
    out_file := Utl_File.FOpen('LOG_DIR', 'errors.txt' , 'a');
    Utl_File.Put_Line(out_file ,cur_date || '    ' || err_msg);
    Utl_File.FClose(out_file);
end;
/

drop table order_log;
/
create table order_log(
  id integer not null,  
  client_id integer not null,
  office_id integer not null,
  amount integer not null,
  service_type_id integer not null,
  total_price number(10,2) not null
);
/

create or replace procedure log_order(id integer, client_id integer, office_id integer,
                                        amount integer, service_type integer, total_price number)
as
begin
  insert into order_log(id, client_id, office_id, amount, service_type_id, total_price)
  values (id, client_id, office_id, amount, service_type, total_price);
end;
/
select * from order_log;


