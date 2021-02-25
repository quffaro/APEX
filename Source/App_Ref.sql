--- STATUSES
create sequence app_seq_ref_status ;

create table app_ref_status (
	status_id number(10) not null
	,status varchar2(255) not null
	,constraint status_pk primary key (status_id)
) ;

create or replace trigger app_trg_ref_status
	before insert on app_ref_status
	for each row 
	when (new.status_id is null)
	begin 
		select app_seq_ref_status.nextval 
		into   :new.status_id 
		from   dual;
	end ;
/

insert into app_ref_status (status) VALUES 
	("Not Started")
	,("Started")
	,("Completed") ;