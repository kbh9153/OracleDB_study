-- << 권한 관리 >> --

/*
 * 권한관리
 * 
 * 사용권한 : DBMS를 여러 명이 사용
 *  - 각 사용자별로 계정을 생성 : DBMS에 접속할 수 있는 사용자를 생성
 *   1. 인증(Authentication : Credential(Identity + Password)) 확인
 * 	 2. 허가(Authorization : 인증된 사용자에게 Oracle의 시스템 권한, 객체(테이블, 뷰, 트리거, 함수) 권한 부여)
 * 		a. System Privileges : 오라클의 전반적인 권한
 * 		b. Object Privilegec : 객체 (테이블, 뷰, 트리거, 함수, 저장 프로시저, 시퀀스, 인덱스) 접근 권한
 */

/*
 * DDL : 객체 생성 (Create, Alter, Drop)
 * DML : 레코드 조작 (Insert, Update, Delete)
 * DQL : 레코드 검색 (Select)
 * DTL : 트랜잭션 (Begin transaction, Rollback, Commit)
 * DCL : 권한관리 (Grant, Revoke, Deny)
 */

-- Oracle에서 계정 생성 (일반 계정에서는 계정을 생성 권한이 없음)

	-- 최고 관리자 계정(sys) : 계정 생성 권한 있음
	-- ID : usertest01 / PW : 1234
CREATE USER usertest01 IDENTIFIED BY 1234;

-- 단순히 계정과 암호만을 생성해서 오라클에 접속할 수 있는 권한이 없음 => 접속 권한을 부여받아야함

-- 계정 연결 (SQL Plus)
CONNECT usertest01/1234;


-- System Privileges
	-- Create Session : 오라클에 접속할 수 있는 권한
	-- Create Table : 오라클에서 테이블을 생성할 수 있는 권한
	-- Create Sequence : 시퀀스 생성할 수 있는 권한
	-- Create view : 뷰를 생성할 수 있는 권한

-- 생성한 계정에 오라클 접속 권한(Create Session) 부여
	-- 구문 : grant 부여할권한 to 계정
GRANT CREATE SESSION TO usertest01;

-- 오라클에 접속하여도 테이블을 생성할 수 있는 권한이 없음 => 테이블 생성할 수 있는 권한을 부여받아야함
GRANT CREATE TABLE TO usertest01;

/*
 * 테이블 스페이스 (Table Space) : 객체(테이블, 뷰, 시퀀스, 인덱스, 트리거, 저장프로시저, 함수 등)를 저장할 수 있는 공간
 *  - 관리자 계정에서 각 사용자별 테이블 스페이스 가능
 * SYSTEM : DBA (관리자 계정에서만 접근 가능)
 */
SELECT * FROM dba_users;	-- dba_ : 최고 관리자(sys)에서 사용 가능
SELECT USERNAME, DEFAULT_TABLESPACE AS DataFile, TEMPORARY_TABLESPACE AS LogFile FROM dba_users WHERE username IN ('HR', 'USERTEST01');

-- 계정에게 테이블 스페이스 (SYSTEM => USERS) 변경
ALTER USER usertest01
DEFAULT tablespace users
TEMPORARY tablespace temp;

-- 계정에게 Users 테이블 스페이스를 사용할 수 있는 공간 할당
ALTER USER usertest01
quota 2m ON users;	-- 2m : 2MB. usertest01에게 용량 2mb를 사용할 수 있도록 공간 할당

-- 테이블의 소유주를 출력. 계정별로 소유한 테이블을 출력
SELECT * FROM ALL_TABLES
WHERE owner IN ('HR', 'USERTEST01', 'USERTEST02');


-- Object Privileges : 테이블, 뷰, 트리거, 함수, 저장 프로시저, 시퀀스, 인덱스에 부여되는 권한할당

/*
        ===========================================================
        권한       Table       view        sequence        procedeur
        -----------------------------------------------------------
        Alter       O                        O
        Delete      O          O
        Execute                                              O
        Index       O
        Insert      O          O
        References  O
        Select      O          O             O
        Update      O          O
        ===========================================================
 */
 
-- 특정 테이블에 select 권한 부여하기
    -- 계정 생성 (최고관리자(sys) 계정으로 접속)
    -- Autication (인증) : credential (ID + PW)
create user user_test10 identified by 1234;
    -- Authorization (허가) : 권한 부여
grant create session, create table, create view to user_test10;

    -- 계정을 생성하면 기본적으로 system 테이블 스페이스를 사용함 => system 테이블 스페이스 : 관리자만 사용 가능한 테이블 스페이스
    -- 테이블 스페이스 바꾸기 (USERS 테이블 스페이스로 바꾸기)
alter user user_test10
default tablespace "USERS"
temporary tablespace "TEMP";
    -- 테이블 스페이스 용량 할당 (무제한)   
alter user "USER_TEST10" quota unlimited on "USERS";

-- 테이블 소유주 확인 : 특정 계정에서 객체를 생성하면 그 계정이 그 객체를 소유하게 됨
select * from dba_tables where owner in ('HR', 'USER_TEST10');

-- 다른 사용자의 테이블을 접근하려면 관련 권한이 필요 (객체 접근 권한)
    -- USER_TEST10에서 HR 계정에서 소유중인 EMPLOYEE 테이블에 접근하기
    -- 다른 사용자의 객체를 출력시 객체명 앞에 객체 소유주명을 명시해줘야 함 (자신의 객체이면 생략 가능)
    -- 구문 : grant 객체의권한 on 객체명 to 사용자명
grant select on hr.employee to USER_TEST10;
select * from hr.employee;
select * from user_test10.test10Tbl;

-- 다른 사용자 테이블에서 insert, update, delete 권한 부여 (최고 관리자 계정 접속 후 권한 설정)
grant insert, update, delete on hr.employee to USER_TEST10;
-- 다른 사용자 테이블에서 insert, update, delete 권한 해지 (최고 관리자 계정 접속 후 권한 설정)
revoke insert, update, delete on hr.employee from USER_TEST10;

desc hr.employee;

-- with grant option : 특정 계정에게 권한을 부여하면서 해당 권한을 다른 사용자에게도 부여할 수 있는 권한을 부여
    -- user_test10 계정이 다른 사용자에게 hr.employee 테이블에 접근할 수 있는 권한을 부여할 수 있도록 설정 (USER_TEST10 -> USER_TEST11)
grant select on hr.employee to USER_TEST10 with grant option;
grant select on hr.employee to USER_TEST11 with grant option;

grant select on hr.dept_copy55 to USER_TEST10;
revoke select on hr.dept_copy55 from USER_TEST10;

select * from hr.dept_copy55;


-- Public : 모든 사용자에게 권한을 부여하는 것
grant select, insert, update, delete on hr.dept_copy56 to public; 

select * from hr.dept_copy56;

/*
    Role : 자주 사용하는 여러개의 권한을 묶어두는 것
        1. dba : 시스템의 모든 권한이 적용된 Role => sys
        2. connect : 
        3. resource : 
 */
 
 -- 사용자 정의 Role 생성 : 자주 사용하는 권한들을 묶어서 Role을 생성
    -- 1. 롤 생성
create role roletest1;
    -- 2. 롤에 자주 사용하는 권한 적용
grant create session, create table, create view, create sequence, create trigger to roletest1;
    -- 3. 생성된 롤을 계정에게 적용
grant roletest1 to user_test10;

-- 현재 사용자에게 부여된 롤 확인
select * from user_role_privs;

-- 롤에 부여된 권한 정보 확인
select * from role_sys_privs;
select * from role_sys_privs where role like 'ROLETEST1';

-- 객체 권한을 role에 부여하기
create role roletest2;

grant select on hr.employee to roletest2;   -- 계정에게 객체 권한을 적용한 것이 아니라 롤에 적용

grant roletest2 to user_test10;  -- 롤을 계정에게 적용

-- 실습
create table dept_copy57
as
select * from department;

create role roletest3;

grant select, insert, delete on hr.dept_copy57 to roletest3

grant roletest3 to user_test10;

select * from user_role_privs;

select * from hr.dept_copy57;

 
