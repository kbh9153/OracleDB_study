-- << 제약 조건 >> --

-- 테이블 복사 : 테이블 전체를 복사
	-- 테이블을 복사하면 컬럼과 레코드만 복사됨
	-- 테이블에 할당된 제약조건은 복사되지 않음 (제약조건은 Alter Table을 사용해서 할당해야함)

-- 테이블 전체 복사
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;
CREATE TABLE emp_copy AS SELECT * FROM EMPLOYEE;

SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_COPY;

-- 테이블의 특정 컬럼만 복사
CREATE TABLE emp_second AS SELECT eno, ename, salary, dno FROM EMPLOYEE;

SELECT * FROM EMP_SECOND;

-- 조건을 사용하여 테이블 복사
CREATE TABLE emp_third AS SELECT eno, ename, salary FROM EMPLOYEE WHERE salary > 2000;

SELECT * FROM EMP_THIRD;

-- 컬럼명을 변경하여 복사 (실제 컬럼명이 변경되어 생성)
	-- 테이블명, 컬럼명 : 영문 작명을 권장
CREATE TABLE emp_fourth AS SELECT eno 사원번호, ename 사원명, salary 급여 FROM EMPLOYEE;

SELECT 사원명 FROM EMP_FOURTH;

-- 계산식을 이용하여 테이블 복사 : 계산식을 이용한 컬럼은 반드시 Alias(별칭)을 사용해야함
CREATE TABLE emp_fifth AS SELECT eno, ename, salary * 12 연봉 FROM EMPLOYEE;

SELECT * FROM EMP_FIFTH;

-- 테이블 구조만 복사
	-- 레코드는 복사하지 않음
CREATE TABLE emp_sixth
AS SELECT * FROM EMPLOYEE
WHERE 0 = 1;		-- WHERE 조건 : false를 리턴

SELECT * FROM EMP_SIXTH;

-- 테이블 수정 : Alter Table
CREATE TABLE dept20 AS SELECT * FROM DEPARTMENT;

	-- 기존 테이블에서 컬럼을 추가
	-- 주의 : 반드시 추가할 컬럼에 null을 허용해야함 (not null을 설정시 컬럼이 추가되지 않음)
ALTER TABLE DEPT20 ADD (birth DATE);
ALTER TABLE DEPT20 ADD (email varchar2(100));
ALTER TABLE DEPT20 ADD (address varchar2(200));

	-- 컬럼의 자료형을 수정
ALTER TABLE DEPT20 MODIFY dname varchar2(100);
ALTER TABLE DEPT20 MODIFY dno number(4);
ALTER TABLE DEPT20 MODIFY address Nvarchar2(200);
	
	-- 특정 컬럼 삭제 : 데이터 규모에 따라 부하가 많이 걸릴 수 있음
ALTER TABLE DEPT20 DROP COLUMN birth;
ALTER TABLE DEPT20 DROP COLUMN email;
	-- SET UNUSED : 특정 컬럼을 사용 중지 (컬럼을 삭제시에 부하가 많이 발생되기 떄문에 우선 중지 후 업무시간 외에 컬럼을 삭제하는 편)
ALTER TABLE DEPT20 SET unused (address);	-- 사용 중지
ALTER TABLE DEPT20 DROP unused COLUMN;		-- 사용 중지된 컬럼을 삭제

-- 컬럼 이름 변경
ALTER TABLE DEPT20 RENAME COLUMN loc TO locations;
ALTER TABLE DEPT20 RENAME COLUMN dno TO D_Number;

-- 테이블 이름 변경
RENAME dept20 TO dept30;

-- 테이블 삭제
DROP TABLE DEPT30;


/*
 * DDL : Create(생성), Alter(수정), Drop(삭제) 
 * 	- 객체 : 테이블, 뷰, 인덱스, 트리거, 시퀀스, 함수, 저장프로시져
 * 
 * DML : Insert(레코드 추가), Update(레코드 수정), Delete(레코드 삭제)
 * 	- 테이블의 값(레코드 or 로우) 생성, 수정, 삭제
 * 
 * DQL : Select
 * 
 * 테이블의 전체 내용이나 삭제시
 * 	1. delete : 테이블의 레코드를 삭제 => where을 사용하지 않을 경우 모든 레코드를 삭제 << 포맷 >>
 * 	2. truncate : 테이블의 레코드를 삭제 => 속도가 굉장이 빠름 << 빠른 포맷 >>
 * 	3. drop : 테이블 자체를 삭제
 * 
 *  commit은 insert, update, delete 시에만 필요
 */

CREATE TABLE emp10 AS SELECT * FROM EMPLOYEE;
CREATE TABLE emp20 AS SELECT * FROM EMPLOYEE;
CREATE TABLE emp30 AS SELECT * FROM EMPLOYEE;

-- emp10 : delete를 사용해서 삭제
DELETE emp10;
COMMIT;
SELECT * FROM EMP10;
-- emp20 : truncate를 사용해서 삭제
TRUNCATE TABLE EMP20;
SELECT * FROM EMP20;
-- emp30 : drop를 사용해서 삭제
DROP TABLE EMP30;


/*
 * 데이터 사전 : 시스템의 각종 정보를 출력해주는 테이블
 * 	- user_ : 자신의 계정에 속한 객체 정보를 출력
 * 	- all_ : 자신의 계쩡이 소유한 객체나 권한을 부여 받은 객체 정보를 출력
 * 	- dba_ :데이터 베이스 관리자만 접근 가능한 객체 정보를 출력 (관리자 계정에서만 확인 가능)
 * 
 */

show USER;
SELECT * FROM user_tables;	-- 사용자가 생성한 테이블 정보 출력
SELECT table_name FROM user_tables;
SELECT * FROM user_views;	-- 사용자가 생성한 뷰에 대한 정보 출력
SELECT * FROM user_indexes;	-- 사용자가 생성한 인덱스에 대한 정보 출력
SELECT * FROM USER_SEQUENCES;	-- 사용자가 생성한 시퀀스에 대한 정보 출력
SELECT * FROM USER_CONSTRAINTS;		-- 제약 조건 확인
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMPLOYEE';

SELECT * FROM ALL_ALL_TABLES;		-- 모든 테이블을 출력, 권한 부여받은 테이블만 출력
SELECT * FROM all_views;		-- 모든 사용자가 생성한 뷰에 대한 정보 출력

SELECT * FROM dba_tables;	-- 관리자 계정에서만 실행 가능


-- 제약 조건 : 컬럼의 무결성(결함없는 데이터. 오류없는 데이터)을 확보하기 위해 사용
/*
 * 1. Primary key
 * 2. Unique
 * 3. NOT NULL
 * 4. CHECK
 * 5. FOREIGN KEY
 * 6. DEFAULT
 */

-- 1. Primary Key : 중복된 값을 넣을 수 없음. 하나의 테이블에 한번만 사용 가능. null 값 할당 불가능

	-- a. 테이블 생성시 컬럼에 부여
		-- 제약 조건 이름 : 지정하지 않을 경우, 오라클에서 랜덤하게 제약 조건 이름 부여 => 제약 조건을 수정할 때 제약 조건 이름을 사용해서 수정하는데 있어 불편
		-- 작명 ex. PK_customer01_id => 제약조건약어_테이블명_컬럼명 (PK : Primary Key)
		-- 작명 ex. NN_customer01_pwd =>	제약조건약어_테이블명_컬럼명 (NN : NOT NULL) 
CREATE TABLE customer01 (
	id varchar2(20) CONSTRAINT PK_customer01_id NOT NULL PRIMARY KEY,	-- CONSTRAINT 제약조건이름
	pwd varchar2(20) CONSTRAINT NN_customer01_pwd NOT NULL,
	name varchar2(20) CONSTRAINT NN_customer01_name NOT NULL,
	phone varchar2(30) NULL,
	address varchar2(100) NULL);
	
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'CUSTOMER01';

CREATE TABLE customer02 (
	id varchar2(20) NOT NULL,
	pwd varchar2(20) NOT NULL,
	name varchar2(20) NOT NULL,
	phone varchar2(30) NULL,
	address varchar2(100) NULL);
	
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'CUSTOMER02';

	-- b. 테이블의 컬럼 생성 후 제약 조건 할당
CREATE TABLE customer03 (
	id varchar2(20) NOT NULL,
	pwd varchar2(20) CONSTRAINT NN_customer03_pwd NOT NULL,
	name varchar2(20) CONSTRAINT NN_customer03_name NOT NULL,
	phone varchar2(30) NULL,
	address varchar2(100) NULL,
	CONSTRAINT PK_customer03_id PRIMARY KEY(id)
	);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'CUSTOMER01';

-- 2. Foreign Key (참조키) : 다른 테이블(부모)의 Primary Key, Unique 컬럼을 참조해서 값을 할당

	-- 부모 테이블
CREATE TABLE ParentTbl (
	name varchar2(20),
	age NUMBER(3) CONSTRAINT CK_ParentTbl_age CHECK (AGE BETWEEN 0 AND 200),
	gender varchar2(3) CONSTRAINT CK_ParentTbl_gender CHECK (gender IN ('M', 'W')),
	infono NUMBER CONSTRAINT PK_ParentTbl_infono PRIMARY KEY
	);
	
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'PARENTTBL';

INSERT INTO PARENTTBL 
	VALUES ('홍길동', 30, 'M', 1);

INSERT INTO PARENTTBL 
	VALUES ('킹똘똘', 31, 'M', 2);

INSERT INTO PARENTTBL 
	VALUES ('킹똘똘', 300, 'MAN', 1);		-- 오류 발생. age 컬럼의 CHECK 제약 조건, gender 컬럼의 CHECK 제약 조건, infono 컬럼의 PRIMARY KEY 제약 조건 위배
	
SELECT * FROM PARENTTBL;

	-- 자식 테이블
CREATE TABLE ChildTbl (
	id varchar2(40) CONSTRAINT PK_ChildTbl_id PRIMARY KEY,
	pw varchar2(40),
	infono NUMBER,
	CONSTRAINT FK_ChildTbl_infono FOREIGN KEY(infono) REFERENCES ParentTbl(infono)
	);

INSERT INTO CHILDTBL 
	VALUES ('aaa', 1234, 3);	-- 오류 발생. parent table인 ParentTbl의 infono 컬럼 값 중 3이라는 값을 찾지 못해 참조할 수 없음 -> Foreign key 제약 조건 위배 

INSERT INTO CHILDTBL 
	VALUES ('aaa', 1234, 1);

INSERT INTO CHILDTBL 
	VALUES ('bbb', 1234, 2);

SELECT * FROM CHILDTBL;
COMMIT;

-- 부모 테이블
CREATE TABLE PARENTTBL2 (
	dno NUMBER(2) NOT NULL PRIMARY KEY,
	dname varchar2(50) NULL,
	loc varchar2(50) NULL
	);

INSERT INTO PARENTTBL2 
	VALUES (10, 'SALES', 'SEOUL');

SELECT * FROM PARENTTBL2;

-- 자식 테이블
CREATE TABLE CHILDTBL2 (
	NO NUMBER NOT NULL,
	ename varchar2(50) NULL,
	dno NUMBER(2) NOT NULL, 
	FOREIGN KEY(dno) REFERENCES parenttbl2(dno)
	);

INSERT INTO CHILDTBL2 
	VALUES (1, 'Kim', 10);

SELECT * FROM CHILDTBL2;

-- default 제약 조건 : 값을 할당하지 않으면 default 값이 할당
CREATE TABLE emp_sample01 (
	eno NUMBER(4) NOT NULL PRIMARY KEY,
	ename varchar2(50) NULL,
	salary NUMBER(7, 2) DEFAULT 1000
	);

-- default 컬럼에 값을 할당한 경우
INSERT INTO EMP_SAMPLE01 
	VALUES (1111, '홍길동', 1500);
	
-- default 컬럼에 값을 할당하지 않은 경우. default에 할당된 값이 적용 => default가 설정된 컬럼을 제외하고 나머지 컬럼을 명시
INSERT INTO EMP_SAMPLE01 (eno, ename)
	VALUES (2, '킹길동');
-- default 컬럼에 값을 할당하지 않은 경우. default에 할당된 값이 적용 => valeus에 default 작성
INSERT INTO EMP_SAMPLE01
	VALUES (3, '킹유신', DEFAULT);

SELECT * FROM EMP_SAMPLE01;

CREATE TABLE emp_sample02 (
	eno NUMBER(4) NOT NULL PRIMARY KEY,
	ename varchar2(50) DEFAULT '광.D' NULL,
	salary NUMBER(7, 2) DEFAULT 3000
	);

INSERT INTO EMP_SAMPLE02 
	VALUES (20, DEFAULT, DEFAULT);

SELECT * FROM EMP_SAMPLE02;


-- Primary Key, Foreign Key, Unique, Check, Default, NOT NULL
CREATE TABLE member10 (
	NO NUMBER CONSTRAINT PK_member10_no NOT NULL PRIMARY KEY,
	name varchar2(50) CONSTRAINT NN_member10_name NOT NULL,
	birthday DATE DEFAULT sysdate NULL,
	age NUMBER(3) CHECK (age BETWEEN 0 AND 150) NULL,
	gender char(1) CHECK (gender IN ('M', 'W')) NULL,
	dno NUMBER(2) UNIQUE 
	);

INSERT INTO member10
	VALUES (1, '킹길동', DEFAULT, 30, 'M', 10);

INSERT INTO member10
	VALUES (2, '지수', DEFAULT, 27, 'W', 20);

SELECT * FROM member10;

CREATE TABLE orders10 (
	NO NUMBER NOT NULL PRIMARY KEY,
	prod_no varchar2(100) NOT NULL,
	prod_name varchar2(100) NOT NULL,
	price NUMBER CHECK (price > 10),
	phone varchar2(100) DEFAULT '010-0000-0000',
	dno NUMBER(2) NOT NULL,
	FOREIGN KEY(dno) REFERENCES member10(dno)
	);

INSERT INTO ORDERS10
	VALUES (1, 'A1234', 'M1 MacBook', 2500000, DEFAULT, 10);

SELECT * FROM ORDERS10;