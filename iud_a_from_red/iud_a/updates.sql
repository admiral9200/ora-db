create or replace function get_service_by_id(id_ integer) return sys_refcursor
as
  cur sys_refcursor;
begin
  open cur for
    select *
    from SERVICE_TYPES
    where ID = id_;
  return cur;
end;
/

create or replace procedure update_service_by_id(id_ integer, name_ varchar, base_cost_ number)
as
begin
  update service_types
  set 
    NAME = name_, 
    BASE_COST = base_cost_
    where id = id_;
end;
/



create or replace function get_bonus_by_id(id_ integer) return sys_refcursor
as
  cur sys_refcursor;
begin
  open cur for
    select *
    from BONUSES
    where ID = id_;
  return cur;
end;
/

create or replace procedure update_bonus_by_id(id_ integer, type_ varchar, value_ number)
as
begin
  update BONUSES
  set 
    TYPE = type_,
    VALUE = VALUE_
    where id = id_;
end;
/


create or replace function get_discount_by_id(id_ integer) return sys_refcursor
as
  cur sys_refcursor;
begin
  open cur for
    select *
    from DISCOUNT_TYPES
    where ID = id_;
  return cur;
end;
/

create or replace procedure update_discount_by_id(id_ integer, desc_ varchar, value_ number)
as
begin
  update DISCOUNT_TYPES
  set 
    DESCRIPTION = desc_,
    VALUE = value_
    where id = id_;
end;
/

create or replace function get_office_by_id(id_ integer) return sys_refcursor
as
  cur sys_refcursor;
begin
  open cur for
    select *
    from OFFICES
    where ID = id_;
  return cur;
end;
/

create or replace procedure update_office_by_id(id_ integer, loc varchar, descr_ varchar)
as
begin
  update OFFICES
  set 
    ADDRESS = loc,
    INFO = descr_
    where id = id_;
end;
/

