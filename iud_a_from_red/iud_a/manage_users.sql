-- check_user_exists(user_login)

-- SOON!!!

select * from roles;

create or replace function get_role_id_by_name(rolename varchar) return integer
as
  id_ integer;
begin
  select id
  into id_
  from roles
  where name = rolename;
  
  return id_;
end;
/


select * from users;
/
-- +
create or replace function check_user_in_db(u_login varchar, u_password varchar) return boolean
as
  temp_id integer;
  hash_ integer;
begin
  select ora_hash(u_password)
  into hash_
  from dual;

  select role_id
  into temp_id
  from users
  where login = u_login and password = hash_;
  return true;
  exception
    when no_data_found then
      return false;
end;
/
 -- +
create or replace function get_user_role(u_login varchar, u_password varchar) 
  return varchar
as
  role_name varchar(50);
  hashed_password integer;
begin
  select ora_hash(u_password)
  into hashed_password
  from dual;

  select roles.name
    into role_name
    from roles
    join users
    on users.ROLE_ID = roles.id
    where users.login = u_login and users.PASSWORD = hashed_password;
  return role_name;
end;
/
create or replace procedure insert_user(u_login varchar, u_password varchar,
                          u_role_id integer, u_client_id integer)
as
  user_record users%rowtype := null;
  temp_int integer := null;
begin
  if u_login = '' or u_login is null then
    dbms_output.put_line('login not specified');
    return;
  end if;
  
  if u_password = '' or u_password is null then
    dbms_output.put_line('pass not specified');
    return;
  end if;
  
  if u_role_id is null then
    dbms_output.put_line('role id not specified');
    return;  
  elsif  not CHECK_ROLE_EXISTS(u_role_id) then
    raise exceptions_package.role_not_found;
  end if;
  
  if not (u_client_id is null) and not CHECK_CLIENT_EXISTS(u_client_id) then
    dbms_output.put_line('client id is not valid');
    raise exceptions_package.client_not_found;
  end if;
    
  if CHECK_USER_EXISTS(u_login) then
    dbms_output.put_line('user already exists!');
    return;
  end if;
  
  insert into users(LOGIN, PASSWORD, ROLE_ID, CLIENT_ID)
    values (u_login, ora_hash(u_password), u_role_id, u_client_id);
  exception
    when exceptions_package.client_not_found
      or exceptions_package.role_not_found
      then
        LOG_ERROR(SQLERRM || 'Error while inserting a user!');
        raise_application_error(SQLCODE, SQLERRM || 'Error while inserting a user!');
end;
/
--need insert user; -- +
create or replace function register_user(u_login varchar,
                                        u_password varchar,
                                        u_client_id integer)
                                      return boolean
as
  user_record users%rowtype := null;
  role_ integer;
  pass_hash integer;
begin

  select ora_hash(u_password)
    into pass_hash
    from dual;
  
  select *
    into user_record
    from users
    where users.LOGIN = u_login;
  
  return false;
  
  exception
    when NO_DATA_FOUND then
      select roles.id
        into role_
        from roles
        where ROLES.NAME like '%user%';
    
      INSERT_USER(u_login, u_password, role_, u_client_id);
      commit;
      return true;
      
end;
/
 -- +





