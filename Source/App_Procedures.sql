-- PROCEDURES 

--- WRITE NEW TASK TO TASK TABLE
create or replace procedure p_write_new_task_to_task_table 
(
    i_table in varchar2
    ,i_pk_id in number 
    ,i_task_name in varchar2
    ,i_assigned_to in varchar2
    ,i_assigned_by in varchar2
)
is
begin 
insert into 
app_tasks 
(
    task_source_table
    ,task_source_table_pk_id
    ,task_name
    ,status_id
    ,assigned_on
    ,assigned_to
    ,assigned_by
)
values
(
    i_table
    ,i_pk_id
    ,i_task_name
    ,1 -- not started
    ,LOCALTIMESTAMP
    ,i_assigned_to
    ,i_assigned_by
);
end ;
/

--- ACCEPT TASK
create or replace procedure p_app_accept_task 
(
	i_task_id in number
) 
is 
begin 
	update 
	app_tasks
	set 
		status_id=2 -- started 
		,time_started=LOCALTIMESTAMP
	where 
		task_id = i_task_id ;
end ; 
/

--- ACCEPT TASK GIVEN REQUEST ID
create or replace procedure p_app_accept_request_task
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

    --dbms_output.put_line(o_task_id);
    p_app_accept_task(o_task_id);
end;