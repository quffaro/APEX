create or replace procedure p_apr_accept_request_task
(
    i_request_id in number
)
as 
o_task_id number ;
begin 
    select task_id into o_task_id from test_tasks
        where 
        task_source_table_pk_id = i_request_id and 
        task_source_table = 'TEST REQUESTS';

    p_app_accept_task(o_task_id);
end; 