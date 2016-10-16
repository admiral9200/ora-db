select * from users;
/

create role c##worker not identified;
/

update users
  set password = ora_hash('password');
/
create or replace function login_to_database(user_ varchar, pass_ varchar)
  return varchar
as

begin
  CHECK_USER_EXISTS(

end;