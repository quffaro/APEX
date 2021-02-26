insert into apr_users (first_name,last_name,displayname,email) 
	with users as (
		select 'Matt', 'Cuffaro', 'Matt Cuffaro', 'mcuffaro@deftconsultinginc.com' from dual union all 
		select 'Carlos', 'Santander', 'Carlos Santander', 'csantander@deftconsultinginc.com' from dual 
	)
	select * from users ;

insert into apr_groups (group_name) 
	with groups as (
		select 'Requesters' from dual union all 
		select 'Reviewers' from dual 
	) 
	select * from groups ;

insert into apr_jn_user_groups (user_id,user_member_of_group_id)
	with jns as (
		select 1, 1 user_member_of_group_id from dual union all 
		select 2, 2 user_member_of_group_id from dual 
	)
	select * from jns ;