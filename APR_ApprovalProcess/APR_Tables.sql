--- people 
--- the people table controls membership. 
--- users 

create sequence apr_seq_users ;
create table apr_users (
    user_id number(10) not null 
    ,apex_id number(20)
    ,first_name varchar2(255) not null 
    ,last_name varchar2(255) not null 
    ,displayname varchar2(255) not null
    ,email varchar2(255)
    ,constraint apr_user_pk primary key (user_id)
) ; 
create or replace trigger app_trg_users
    before insert on apr_users
    for each row 
    when (new.user_id is null)
    begin 
        select apr_seq_users.nextval 
        into   :new.user_id 
        from   dual;
    end ;
/

---
create sequence apr_seq_groups ;
create table apr_groups (
    group_id number(10) not null 
    ,group_name varchar(255) not null
    ,constraint apr_group_pk primary key (group_id)
);
create or replace trigger app_trg_groups
    before insert on apr_groups
    for each row 
    when (new.group_id is null)
    begin 
        select apr_seq_groups.nextval 
        into   :new.group_id 
        from   dual;
    end ;
/

create table apr_jn_user_groups (
    user_id number(10) not null 
    ,user_member_of_group_id number(10) not null
) ;

create table apr_jn_group_groups (
    group_id number(10) not null 
    ,group_member_of_group number(10) not null
) ;



create sequence apr_seq_requests ;
create table apr_requests(
    request_id number(10) not null
    ,request_name varchar2(255) not null
    ,requested_by varchar2(255) not null
    ,request_status varchar2(255) not null 
    ,request varchar2(511) not null
    ,constraint apr_request_pk primary key (request_id)
) ;
create or replace trigger app_trg_requests
    before insert on apr_requests
    for each row 
    when (new.request_id is null)
    begin 
        select apr_seq_requests.nextval 
        into   :new.request_id
        from   dual;
    end ;
/



-- PROCESS TO WRITE TO TASK TABLE
-- Assigns task to reviewer
INSERT INTO 
TEST_TASKS 
(TASK_SOURCE_TABLE
,TASK_SOURCE_TABLE_PK_ID
,TASK_NAME
,STATUS
,ASSIGNED_ON
,ASSIGNED_TO
)
VALUES
('TEST_REQUESTS'
,:P10_REQUEST_ID
,'REQUEST'
,'NOT STARTED'
,'NOW'
,'REVIEWER');

--
CREATE OR REPLACE PROCEDURE 
P_WRITE_NEW_TASK_TO_TASK_TABLE 
(
    X_TABLE IN VARCHAR2
    ,X_PK_ID IN NUMBER 
    ,X_TASK_NAME IN VARCHAR2
    ,X_ASSIGNED_TO IN VARCHAR2
    ,X_ASSIGNED_BY IN VARCHAR2
)
IS
BEGIN 
INSERT INTO 
TEST_TASKS 
(
    TASK_SOURCE_TABLE
    ,TASK_SOURCE_TABLE_PK_ID
    ,TASK_NAME
    ,STATUS
    ,ASSIGNED_ON
    ,ASSIGNED_TO
    ,ASSIGNED_BY
)
VALUES
(
    X_TABLE
    ,X_PK_ID
    ,X_TASK_NAME
    ,'NOT STARTED'
    ,LOCALTIMESTAMP
    ,X_ASSIGNED_TO
    ,X_ASSIGNED_BY
);
END ;
/



create or replace function f_test_check_task_accepted 
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


