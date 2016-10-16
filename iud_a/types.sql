create or replace type T_DEFAULT_TYPE as object(
  name varchar2(50),
  value number(10,2) );
/

drop type t_default_type;
/

drop function get_type;
/
create or replace function get_type return T_DEFAULT_TYPE as

  c_type T_DEFAULT_TYPE;
begin   
  c_type := T_DEFAULT_TYPE('A',50);
  return c_type;
end;