create or replace package exceptions_package as
    client_not_found exception;
    service_type_not_found exception;
    office_not_found exception;
    user_is_not_a_worker exception;
    invalid_acceptance_date exception;
    invalid_amount exception; 
    user_not_found exception;
    invalid_bonus_value exception;
    invalid_service_price exception;
    invalid_discount_value exception;
    invalid_best_client_flag exception;
    role_not_found exception;
    order_not_found exception;
      
    pragma EXCEPTION_INIT(order_not_found, -20013);
    pragma EXCEPTION_INIT(role_not_found, -20014);
    pragma EXCEPTION_INIT(invalid_best_client_flag, -20012);
    pragma EXCEPTION_INIT(invalid_discount_value, -20011);
    pragma EXCEPTION_INIT(invalid_service_price, -20010);
    pragma EXCEPTION_INIT(invalid_bonus_value, -20009);
    pragma EXCEPTION_INIT(user_not_found, -20008);
    pragma EXCEPTION_INIT(client_not_found, -20000);
    pragma EXCEPTION_INIT(service_type_not_found, -20001);
    pragma EXCEPTION_INIT(office_not_found, -20002);
    pragma EXCEPTION_INIT(user_is_not_a_worker, -20004);
    pragma EXCEPTION_INIT(invalid_acceptance_date, -20005);
    pragma EXCEPTION_INIT(invalid_amount, -20006);
end exceptions_package;