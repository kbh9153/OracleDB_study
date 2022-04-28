-- << 권한 관리 >> --

/*
 * 권한관리
 * 
 * 사용권한 : DBMS를 여러 명이 사용
 *  - 각 사용자별로 계정을 생성 : DBMS에 접속할 수 있는 사용자를 생성
 *   1. 인증(Authentication : Credential(Identity + Password)) 확인
 * 	 2. 허가(Authorization : 인증된 사용자에게 Oracle의 시스템 권한, 객체(테이블, 뷰, 트리거, 함수) 권한 부여)
 * 		a. System Privileges : 오라클의 전반적인 권한
 * 		b. Object Privileges : 객체 (테이블, 뷰, 트리거, 함수, 저장 프로시저, 시퀀스, 인덱스) 접근 권한
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