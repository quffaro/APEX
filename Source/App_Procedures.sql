-- PROCEDURES 

--- WRITE NEW TASK TO TASK TABLE
create or replace procedure p_app_write_new_task_to_task_table 
(
    i_table in varchar2
    ,i_app_code in varchar2
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
    app_code
    ,task_source_table
    ,task_source_table_pk_id
    ,task_name
    ,status_id
    ,assigned_on
    ,assigned_to
    ,assigned_by
)
values
(
    i_app_code
    ,i_table
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




create or replace function f_get_current_user_id
return number 
is 
begin 
	return apex_util.get_current_user_id ;
end ;