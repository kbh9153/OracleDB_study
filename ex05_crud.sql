-- << CRUD (Create, Read, Update, Delete) >> --

-- Object(객체) : DataBase의 존재 (SID : XE => Express Edition(무료버전))
/*
 * Standard Edition(유료), Enterprise Edition(유료)
 * 
 * 	-- DDL (Create, Alter, Drop)
 * 	1. 테이블
 * 	2. 뷰
 * 	3. 저장 프로시져
 * 	4. 트리거
 * 	5. 인덱스
 * 	6. 함수
 * 
 * 	 => 1 ~ 6의 파일들이 있으면 XE 데이터베이스가 관리
 */

-- 테이블 생성 (Create) - DDL 객체 생성
/*
 * Create Table 테이블명(
 * 		컬럼명1 자료형(입력값 byte 제한) null허용여부 제약조건,
 * 		컬럼명2 자료형(입력값 byte 제한) null허용여부 제약조건,
 * 		컬럼명3 자료형(입력값 byte 제한) null허용여부 제약조건
 * 		);
 */

CREATE TABLE dept(
	dno NUMBER(2) NOT NULL,
	dname VARCHAR2(14) NOT NULL,
	loc VARCHAR2(13) NULL
	);
	
SELECT * FROM DEPT;

-- DML : 테이블의 값(Record or Row)을 삽입(insert), 수정(update), 삭제(delete)
/*
 * 트랜잭션을 발생 시킴 : log에 기록을 먼저 하고 Database에 적용
 * 	- begin transaction : 트랜잭션 시작 (Insert, Update, delete 구문이 시작되면 자동으로 시작)
 * 	- rollback : 트랜잭션 롤백 (RAM에 적용된 트랜잭션을 삭제)
 * 	- commit : 트랜잭션을 적용 (실제 DataBase에 영원히 적용)
 * 
 * insert into 테이블명(컬럼명1, 컬럼명2, 컬럼명3)
 * 		values((컬럼명1)값1, (컬럼명2)값2, (컬럼명3)값3);
 */

-- begin transaction 발생 후 INSERT 실행
INSERT INTO DEPT (dno, dname, loc)
	VALUES (10, 'MANAGER', 'SEOUL');

	-- insert, update, delete 구문은 자동으로 트랜잭션이 시작(begin transaction;) - RAMP에만 적용되어 있는 상태
ROLLBACK;
COMMIT;

/*
 * insert 시 컬럼명을 생략
 * insert into dept
 * 		values(값1, 값2, 값3)
 */
	
INSERT INTO DEPT
	values(20, 'ACCOUNTING', 'BUSAN');

-- Null 허용 컬럼에 값을 넣지 않기
INSERT INTO DEPT(dno, dname)
	values(30, 'RESEARCH');
	
-- 데이터 유형에 맞지 않는 값을 넣으면 오류 발생
INSERT INTO DEPT (dno, dname, loc)
	values(300, 'SALES', 'DAEGU')	-- 오류발생. dno 컬럼은 number(2)이기 때문에 300은 삽입 불가능

INSERT INTO DEPT (dno, dname, loc)
	values(40, 'SALESSSSSSSSSSSSSSSSSSSSSSSSSSSSSS', 'INCHEON') -- 오류발생. dname 컬럼은 varchar2(14)이기 때문에 불가능
	
-- 자료형 (문자 자료형)
/*
 * char(10) : 고정크기 10byte. 3byte만 넣을 경우 7byte의 빈공간이 생성
 * 	=> 장점 : 성능이 빠름 / 단점 : 자원낭비(하드용량)
 * 	=> ex. 'abc       ' : 공백 7칸
 * 	=> 주민번호, 전화번호와 같이 입력값의 고정된 자리수를 알 수 있을 때 사용
 * 
 * varchar2(10) : 가변크기 10byte. 3byte만 넣을 경우 3byte만 공간 할당
 * 	=> 장점 : 자원낭비(하드용량) 없음 / 단점 : 성능이 느림
 * 	=> ex. 'abc' : 공백 0칸
 * 	=> 자리 수를 알 수 없는 가변 크기인 경우 사용(주소, 메일주소 등)
 * 
 * Nchar(10) : 고정크기. 유니코드 10자 (한글, 중국어, 일본어 등)
 * Nvarchar2(10) 가변크기. 유니코드 10자 (한글, 중국어, 일본어 등)
 */

-- 자료형 (숫자 자료형)
/*
 * NUMBER(2) : 정수 2자리만 입력 가능
 * NUMBER(7, 3) : 전체 7자리 중 소수점 3자리까지 입력 가능 
 * NUMBER(8, 5) : 전체 8자리 중 소수점 5자리까지 입력 가능
 * 	=> 전체 자리수에 .은 포함되지 않음
 */
CREATE TABLE test1_tbl(
	a NUMBER(3, 2) NOT NULL,
	b NUMBER(5, 2) NOT NULL,
	c char(6) NULL,
	d varchar2(10) NULL,
	e Nchar(6) NULL,
	f Nvarchar2(10) NULL);
	
INSERT INTO TEST1_TBL (a, b, c, d, e, f)
	values(3.22, 111.22, 'aaaaaa', 'bbbbbbbbbb', '한글여섯글자', '한글열글자가능함');
	
SELECT * FROM TEST1_TBL;

INSERT INTO TEST1_TBL (a, b, c, d, e, f)
	values(3.22, 111.22, '한글세글자', 'bbbbbbbbbb', '한글여섯글자', '한글열글자가능함');	-- 오류 발생. b 컬럼은 char(6)인데, char 형식에서는 한글이 한글자당 3byte씩 차지하기 때문
	
COMMIT;

--------------------------------------------

CREATE TABLE member1(
	NO number(10) NOT NULL,
	id varchar2(50) NOT NULL,
	passwd varchar2(50) NOT NULL,
	name Nvarchar2(6) NOT NULL,
	phone varchar2(50) NULL,
	address varchar2(100) NULL,
	mdate DATE NOT NULL,
	email varchar2(50) NULL);

INSERT INTO member1(NO, id, passwd, name, phone, address, mdate, email)
	values(1, 'aaaa', 'password', '홍길동', '010-1111-1111', '인천 서구 석남동', sysdate, 'aaa@aaa.com');

INSERT INTO member1
	values(2, 'bbb', 'password', '이순신', '010-2222-2222', '인천 서구 석디동', sysdate, 'bbb@bbb.com');

-- NULL 허용 컬럼에 NULL로 값을 할당
INSERT INTO member1(NO, id, passwd, name, phone, address, mdate, email)
	values(3, 'cc', 'password', '킹세종', 'NULL', 'NULL', sysdate, 'NULL');

-- NULL 허용 컬럼에 값을 넣지 않을 경우 NULL 값이 할당
INSERT INTO member1(NO, id, passwd, name, mdate)
	values(4, 'ddd', 'password', '광D', sysdate);

COMMIT;


-- 데이터 수정 (update : 데이터 수정 후 commit)
/*
 * 반드시 where 조건을 사용해야함. 그렇지 않으면 모든 레코드(row)가 수정됨
 * 
 * update 테이블명
 * set 컬럼명 = 수정할값
 * where 컬럼명 = 값;
 */

-- where 사용
UPDATE MEMBER1
SET name = '킹순신'
WHERE NO = 2;

-- where 미사용 
-- UPDATE MEMBER1
-- SET name = '짭길동' 	-- where 사용안할 시 모든 레코드가 변경

UPDATE MEMBER1
SET ID = 'abc'
WHERE NO = 3;

UPDATE MEMBER1
SET email = 'abcd@abcd.com'
WHERE NO = 1;

UPDATE MEMBER1
SET MDATE = '2022/01/01'
WHERE NO = 4;


-- 하나의 레코드에서 여러컬럼 동시에 수정하기
UPDATE MEMBER1
SET name = '킹길동', email = 'kkk@kkk.com', phone = '010-1234-5678'
WHERE NO = 1;

UPDATE MEMBER1 
SET mdate = TO_DATE('2022-01-01', 'YYYY-MM-DD')
WHERE NO = 3;

COMMIT;
SELECT * FROM MEMBER1;


-- 데이터(레코드(로우)) 삭제 (delete)
/*
 * 반드시 where 조건을 사용해야함 => 사용하지 않은 경우 모든 레코드가 삭제됨
 * 트랜잭션을 종료(종료방법 : rollback, commit)
 * 
 * delete 테이블명
 * where 컬럼명 = 값
 * 
 * update, delete 시 where 절에 사용되는 컬럼은 고유한 컬럼이어야 함. 그렇지 않으면 여러 컬럼이 업데이트되거나 삭제될 수 있음
 * 	=> Primary key, Unique 컬럼을 사용해야함
 */

-- where 사용
DELETE member1
WHERE NO = 3;

-- where 미사용
-- DELETE member1 => 모든 레코드가 삭제됨

UPDATE MEMBER1
SET name = '킹비버'
WHERE NO = 4;

SELECT * FROM MEMBER1;

--------------------------------------------

-- 제약 조건 : 컬럼의 무결성(결함없는 데이터. 오류없는 데이터)을 확보하기 위해 사용
/*
 * Primary key
 *  - 하나의 테이블에 한번만 사용 가능. 중복된 데이터를 넣지 못하도록 설정
 *	- null 값을 할당할 수 없음
 */

CREATE TABLE member2(
	NO number(10) NOT NULL PRIMARY KEY,
	id varchar2(50) NOT NULL,
	passwd varchar2(50) NOT NULL,
	name Nvarchar2(6) NOT NULL,
	phone varchar2(50) NULL,
	address varchar2(100) NULL,
	mdate DATE NOT NULL,
	email varchar2(50) NULL);

-- Praimary key가 설정된 컬럼(NO 컬럼)은 중복된 값을 넣을 수 없음
INSERT INTO member2(NO, id, passwd, name, phone, address, mdate, email)
	values(1, 'aaaa', 'password', '홍길동', '010-1111-1111', '인천 서구 석남동', sysdate, 'aaa@aaa.com');

-- Praimary key가 설정된 컬럼(NO 컬럼)은 중복된 값을 넣을 수 없음
INSERT INTO member2
	values(2, 'bbb', 'password', '이순신', '010-2222-2222', '인천 서구 석디동', sysdate, 'bbb@bbb.com');

-- Praimary key가 설정된 컬럼(NO 컬럼)은 중복된 값을 넣을 수 없음
INSERT INTO member2(NO, id, passwd, name, phone, address, mdate, email)
	values(3, 'cc', 'password', '킹세종', 'NULL', 'NULL', sysdate, 'NULL');

-- Praimary key가 설정된 컬럼(NO 컬럼)은 중복된 값을 넣을 수 없음
INSERT INTO member2(NO, id, passwd, name, mdate)
	values(4, 'ddd', 'password', '광D', sysdate);

INSERT INTO member2(NO, id, passwd, name, phone, address, mdate, email)
	values(5, 'aaaa', 'password', '홍길동', '010-1111-1111', '인천 서구 석남동', sysdate, 'aaa@aaa.com');

UPDATE MEMBER2 
SET name = '킹유신'
WHERE NO = 5;	-- 테이블에서 중복되지 않는 고유한 컬럼을 조건으로 사용해야 함

SELECT * FROM member2;

/*
 * Unique Key
 *  - 하나의 테이블에 여러 컬럼에 지정 가능. 중복된 데이터를 넣지 못하도록 설정
 *	- null 값을 할당할 수 있음
 */

CREATE TABLE member3(
	NO number(10) NOT NULL PRIMARY KEY,		-- 중복된 값을 넣을 수 없음
	id varchar2(50) NOT NULL UNIQUE,	-- 중복된 값을 넣을 수 없음
	passwd varchar2(50) NOT NULL,
	name Nvarchar2(6) NOT NULL,
	phone varchar2(50) NULL,
	address varchar2(100) NULL,
	mdate DATE NOT NULL,
	email varchar2(50) NULL);
	
-- Praimary key가 설정된 컬럼(NO 컬럼)은 중복된 값을 넣을 수 없음
INSERT INTO member3(NO, id, passwd, name, phone, address, mdate, email)
	values(1, 'aaaa', 'password', '홍길동', '010-1111-1111', '인천 서구 석남동', sysdate, 'aaa@aaa.com');

-- Unique key가 설정된 컬럼(id 컬럼)은 중복된 값을 넣을 수 없음
INSERT INTO member3
	values(2, 'bbb', 'password', '이순신', '010-2222-2222', '인천 서구 석디동', sysdate, 'bbb@bbb.com');

-- Unique key가 설정된 컬럼(id 컬럼)은 중복된 값을 넣을 수 없음
INSERT INTO member2(NO, id, passwd, name, phone, address, mdate, email)
	values(3, 'bbb', 'password', '킹세종', 'NULL', 'NULL', sysdate, 'NULL');
	
SELECT * FROM MEMBER3;
COMMIT;