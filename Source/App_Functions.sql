create or replace function f_app_get_current_user_id
return number 
is 
begin 
	return apex_util.get_current_user_id ;
end ;


create or replace function f_app_get_task_status
(
    i_task_source_pk in number,
    i_task_source_table in varchar2
)
return varchar2 
is 
o_status varchar2(255) ;
begin 
    select status into o_status from app_tasks 
        where 
        task_source_table = i_task_source_table and 
        task_source_table_pk_id = i_task_source_pk ;

    return o_status ;
end ;
/



create or replace function f_app_is_task_accepted 
( 
    i_task_source_pk in number,
    i_task_source_table in varchar2 
)
return number 
is 
l_status varchar2(255) ;
begin 
    l_status := f_test_get_task_status (i_task_source_pk,i_task_source_table);
    if l_status = 'ACCEPTED' then 
        return 1;
    else 
        return 0;
    end if;
end;
/