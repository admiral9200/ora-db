create or replace function insert_client_v2(client_f_name varchar, client_l_name varchar,
                                                      is_best_client number) return integer
as
  client_record clients%rowtype := null;
  c_id integer := 0;
begin
  if client_f_name = '' or client_f_name is null then
    dbms_output.put_line('client first name not specified');
    return c_id;
  end if;

  if client_l_name = '' or client_l_name is null then
    dbms_output.put_line('client last name not specified');
    return c_id;
  end if;

  if is_best_client is null and  not (is_best_client = 1 or is_best_client = 0) then
    dbms_output.put_line('best client flag not specified correctly');
    raise exceptions_package.invalid_best_client_flag;
    return c_id;
  end if;

  insert into CLIENTS(FIRST_NAME, LAST_NAME, BEST_CLIENT)
    values (client_f_name, client_l_name, is_best_client)
    returning id into c_id;

  return c_id;

  exception
    when exceptions_package.invalid_best_client_flag then
       LOG_ERROR(SQLERRM || 'Error while inserting a client!');
      raise_application_error(SQLCODE, SQLERRM || 'Error while inserting a client!');
end;
/