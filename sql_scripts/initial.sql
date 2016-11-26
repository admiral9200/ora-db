select * from roles;

insert into roles(name)
  values ('admin');
insert into roles(name)
  values ('user'); 
insert into roles(name)
  values ('worker');
  
  
select * from users;
declare
  role_id integer;
begin
  select id into role_id from roles where name = 'admin';
  INSERT_USER('admin', 'admin',role_id,null);    
end;