create or replace function get_roles return sys_refcursor
as  
 v_cursor sys_refcursor;
begin
  open v_cursor for 
    select name
    from roles;
  return v_cursor;
end;