CREATE TABLE TEST_TASKS(
    TASK_ID NUMBER(10) GENERATED ALWAYS AS IDENTITY
    ,TASK_SOURCE_TABLE VARCHAR2(255) NOT NULL 
    ,TASK_SOURCE_TABLE_PK_ID NUMBER(10) NOT NULL
    ,TASK_NAME VARCHAR2(255) NOT NULL
    ,STATUS VARCHAR2(255) NOT NULL
    ,ASSIGNED_ON VARCHAR2(255) NOT NULL
    ,ASSIGNED_TO VARCHAR2(255) NOT NULL
    ,ASSIGNED_BY VARCHAR2(255) NOT NULL
    ,TIME_STARTED VARCHAR2(255) 
    ,TIME_COMPLETED VARCHAR2(255) 
) ;

CREATE TABLE TEST_REQUESTS(
    REQUEST_ID NUMBER(10) GENERATED ALWAYS AS IDENTITY
    ,REQUEST_NAME VARCHAR2(255) NOT NULL
    ,REQUESTED_BY VARCHAR2(255) NOT NULL
    ,REQUEST_STATUS VARCHAR2(255) NOT NULL 
    ,REQUEST VARCHAR2(511) NOT NULL
) ;

---- TEST_GROUPS

CREATE SEQUENCE s_groups ;

CREATE TABLE TEST_GROUPS(
	GROUP_ID NUMBER(10) 
	,GROUP_NAME VARCHAR2(255)
	,CONSTRAINT group_pk PRIMARY KEY (GROUP_ID)
) ;

CREATE OR REPLACE TRIGGER trg_groups 
	BEFORE INSERT on TEST_GROUPS
	FOR EACH ROW 
	WHEN (new.group_id IS NULL)
	BEGIN 
		SELECT s_groups.NEXTVAL
		INTO   :new.group_id
		FROM   dual;
	END;
/

--- TEST_USERS 
CREATE SEQUENCE s_people ;

CREATE TABLE TEST_PEOPLE(
    PEOPLE_ID NUMBER(10)
    ,IS_GROUP NUMBER(1) DEFAULT 0
    ,NAME VARCHAR2(255)
    ,CONSTRAINT people_pk PRIMARY KEY (PEOPLE_ID)
);

CREATE TABLE TEST_JN_PEOPLE(
    PEOPLE_ID NUMBER(10)
    ,MEMBER_OF_ID NUMBER(10)
);

CREATE OR REPLACE TRIGGER trg_people 
    BEFORE INSERT on TEST_PEOPLE 
    FOR EACH ROW 
    WHEN (new.people_id IS NULL)
    BEGIN 
        SELECT s_people.NEXTVAL
        INTO   :new.people_id
        FROM   dual;
    END;
/


INSERT ALL
    INTO TEST_PEOPLE (IS_GROUP,NAME) VALUES (1,'Requesters')
    INTO TEST_PEOPLE (IS_GROUP,NAME) VALUES (1,'Reviewers')

    INTO TEST_PEOPLE (IS_GROUP,NAME) VALUES (0,'Matt Cuffaro')
    INTO TEST_PEOPLE (IS_GROUP,NAME) VALUES (0,'Carlos Santander')

    INTO TEST_JN_PEOPLE (PEOPLE_ID,MEMBER_OF_ID) VALUES (3,1)
    INTO TEST_JN_PEOPLE (PEOPLE_ID,MEMBER_OF_ID) VALUES (4,2)
SELECT 1 FROM DUAL;

---- TEST_USERS
CREATE SEQUENCE s_users ;

CREATE TABLE TEST_USERS(
	USER_ID NUMBER(10) 
	,USER_NAME VARCHAR2(255)
	,CONSTRAINT users_pk PRIMARY KEY (USER_ID)
) ;

CREATE OR REPLACE TRIGGER trg_users 
	BEFORE INSERT on TEST_USERS 
	FOR EACH ROW 
	WHEN (new.user_id IS NULL)
	BEGIN 
		SELECT s_users.NEXTVAL
		INTO   :new.user_id
		FROM   dual;
	END;
/

CREATE TABLE TEST_JN_USER_GROUP_MEMBERSHIP(
	USER_ID NUMBER(10)
	,GROUP_ID NUMBER(10)
) ;

-- TRIGGER






INSERT ALL
   INTO TEST_GROUPS (GROUP_NAME) VALUES ('Requesters')
   INTO TEST_GROUPS (GROUP_NAME) VALUES ('Reviewers')
SELECT 1 FROM DUAL;

INSERT ALL
	INTO TEST_USERS (USER_NAME) VALUES ('Matt Cuffaro')
	INTO TEST_USERS (USER_NAME) VALUES ('Carlos Santander')
SELECT 1 FROM DUAL;

INSERT ALL
INTO TEST_JN_USER_GROUP_MEMBERSHUP 
(USER_ID,GROUP_ID)
VALUES
(1,1)
,(1,2)
SELECT 1 FROM DUAL;


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


create or replace procedure 
p_test_accept_task 
(
    x_task_id in number 
)
is begin 
update 
test_tasks 
set 
status='ACCEPTED'
,time_started=LOCALTIMESTAMP 
where task_id = x_task_id ;
end ; 
/

--- 
--- 
create or replace procedure
p_test_accept_request_task 
(
    x_request_id in number
)
declare l_task_id number;
begin 
    select 
        task_id into l_task_id
        from 
        test_tasks where 
        task_source_table_pk_id = x_request_id 
        AND 
        task_source_table = 'TEST REQUESTS' ;

    p_test_accept_task(x_task_id => l_task_id) ;
end ;


-- working 
create or replace procedure p_test_accept_request_task
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
    p_test_accept_task(o_task_id);
end;

create or replace procedure p_check_task_is_accepted 
(
    i_task_source_pk in number
    i_task_source_table in number 
)
as 

begin 
    select status from test_tasks 
        where 
        task_source_table

