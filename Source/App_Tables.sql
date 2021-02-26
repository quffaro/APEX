-- logging
create sequence app_seq_log ;

create table app_log (
	log_id number(10) not null 
	,logged_on varchar2(255) not null 
	,logged_by varchar2(255) not null 
	,log_type_id number(5) not null 
	,log_message varchar2(4000) 
	,constraint app_log_pk primary key (log_id)
) ;

create or replace trigger app_trg_log 
	before insert on app_log
	for each row 
	when (new.log_id is null)
	begin 
		select app_seq_log.nextval 
		into   :new.log_id 
		from   dual;
	end ;
/


-- tasks
create sequence app_seq_tasks ;

create table app_tasks 
(
	task_id number(10) not null 
	,app_code varchar2(4) not null
	,task_source_table varchar2(255) not null
	,task_source_table_pk_id number(10) not null
	,task_name varchar2(255) not null 
	,status_id number(10) default 1
	,assigned_on varchar2(255) not null 
	,assigned_to varchar2(255) not null
	,assigned_by varchar2(255) not null
	,time_started varchar2(255)
	,time_completed varchar2(255)
	,constraint app_task_pk primary key (task_id)
) ;

create or replace trigger app_trg_tasks
	before insert on app_tasks
	for each row 
	when (new.task_id is null)
	begin 
		select app_seq_tasks.nextval 
		into   :new.people_id 
		from   dual;
	end ;
/

--- people 
create sequence app_seq_people ;

create table app_people (
	people_id number(10) not null
	,is_group number(1) default 0 
	,name varchar2(255) not null
	,constraint app_people_pk primary key (people_id)
) ;

create or replace trigger app_trg_people 
	before insert on app_people 
	for each row 
	when (new.people_id is null)
	begin 
		select app_seq_people.nextval 
		into   :new.people_id 
		from   dual;
	end ;
/

--- users 




