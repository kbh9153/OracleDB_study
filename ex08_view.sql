-- << 뷰 >> --

/*
 * 뷰 (view) 가상의 테이블을 뷰(view)라고 함
 * 	- 테이블은 데이터 값을 가지고 있음
 * 	- 뷰는 데이터 값을 가지지 않음. 오직 실행 코드만 있음
 * 	- 뷰 사용 목적
 * 	 1) 보안 : 실제 테이블의 특정 컬럼만 가져와서 실제 테이블의 중요 컬럼을 숨길 수 있음
 * 	 2) 복잡한 쿼리를 뷰 생성을 통해 편리하게 사용 가능 (복잡한 JOIN 쿼리)
 * 	- 뷰는 일반적으로 select 구문이 옴
 * 	- 뷰는 Insert, Update, Delete 구문이 올 수 없음
 * 	- 뷰의 값을 Insert하면 실제 테이블에 값이 추가 (단, 실제 테이블의 제약 조건을 만족해야만 Insert 가능)
 * 	- 뷰의 값을 Insert할 경우 실제 테이블의 제약조건에 따라 Insert가 가능할 수도 불가능할 수도 있음
 * 	- 그룹 함수를 적용한 view에는 Insert 할 수 없음
 */

CREATE TABLE dept_copy60
AS SELECT * FROM DEPARTMENT;

CREATE TABLE emp_copy60
AS SELECT * FROM EMPLOYEE;

-- 뷰 생성 (view, table을 구분할 수 없어 view 별칭에 view 약어 v를 가장 앞에 붙임)
CREATE VIEW v_emp_job
AS SELECT eno, ename, dno, job
FROM EMP_COPY60
WHERE job LIKE 'SALESMAN';

-- 뷰 생성 확인
SELECT * FROM USER_VIEWS;

-- 뷰 실행 (select * from 뷰이름)
SELECT * FROM V_EMP_JOB;

-- 복잡한 JOIN 쿼리를 뷰에 만들어두기
CREATE VIEW v_join
AS
SELECT e.dno, ename, job, dname, loc
FROM employee e, department d
WHERE e.DNO = d.DNO
AND job = 'SALESMAN';

SELECT * FROM V_JOIN;

-- 뷰를 사용해서 실제 테이블의 중요한 정보 숨기기 (보안)
SELECT * FROM EMP_COPY60;	-- 실제 테이블

CREATE VIEW simple_emp	-- view를 사용해서 실제 테이블의 중요 컬럼을 숨김 => 사용자들은 view인지 table인지 구분할 수 없음
AS
SELECT ename, job, dno
FROM emp_copy60;

SELECT * FROM SIMPLE_EMP;

SELECT * FROM USER_VIEWS;

-- 뷰를 생성할 때 반드시 별칭 이름을 사용해야 하는 경우 => group by할 때
CREATE VIEW v_groupping
AS 
SELECT dno, COUNT(*) AS groupCount, AVG(salary) AS avg, SUM(salary) AS sum
FROM emp_copy60
GROUP BY DNO;

SELECT * FROM V_GROUPPING;

-- 뷰를 생성할 때 as 하위에 select 문이 와야함. insert, update, delete 문은 올 수 없음
CREATE VIEW v_error
AS
INSERT INTO dno
	VALUES (60, 'HR', 'BUSAN');		-- 오류 발생
	
-- view에 값을 insert할 수 있을까? 컬럼의 제약 조건을 만족하면 view에도 값을 넣을 수 있음
	-- => 실제 테이블에 값이 insert 됨
CREATE VIEW v_detp
AS
SELECT dno, dname
FROM dept_copy60;

SELECT * FROM V_DETP;

INSERT INTO V_DETP	-- view에 값을 INSERT, 제약조건이 일치할 때 insert가 가능
	VALUES (70, 'HR');

SELECT * FROM DEPT_COPY60;

-- V_DETP가 존재하지 않을 경우 : CREATE / 존재할 경우 : REPLACE
	-- => replace : 수정
CREATE OR REPLACE VIEW V_DETP
AS
SELECT dname, loc
FROM dept_copy60;

SELECT * FROM V_DETP;

INSERT INTO V_DETP
	VALUES ('CLERK', 'DAEGU');

UPDATE DEPT_COPY60
SET dno = 80
WHERE dno IS NULL;

ALTER TABLE DEPT_COPY60 
ADD CONSTRAINT PK_dept_copy60_dno PRIMARY KEY(dno);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'DEPT_COPY60';

INSERT INTO V_DETP
	VALUES ('ANALYST', 'SEOKDI');	-- 오류 발생. 실제 테이블의 제약 조건을 만족하지 못했기 때문

SELECT * FROM USER_VIEWS;
SELECT * FROM (V_GROUPPING);	-- 그룹핑된 view에는 INSERT 불가능

CREATE OR REPLACE VIEW V_GROUPPING
AS
SELECT dno, COUNT(*) AS groupCount, ROUND(AVG(salary), 2) AS avg, SUM(salary) AS sum
FROM emp_copy60
GROUP BY DNO;

SELECT * FROM V_GROUPPING;

DROP VIEW V_GROUPPING;

-- insert, update, delete가 가능한 뷰 : 실제 테이블의 제약조건을 만족해야함
CREATE VIEW v_dept10
AS
SELECT dno, dname, loc
FROM dept_copy60;

INSERT INTO V_DEPT10
	VALUES (90, 'ANALYST', 'SEOKDI');

SELECT * FROM V_DEPT10;

UPDATE V_DEPT10
SET dname = 'HR', loc = 'DAEGU'
WHERE dno = 90;

DELETE v_dept10
WHERE dno = 90;

-- 읽기만 가능한 뷰를 생성(with read only 옵션) => insert, update, delete 하지 못하도록 설정
CREATE VIEW v_readonly
AS
SELECT dno, dname, loc
FROM dept_copy60 WITH READ ONLY;

SELECT * FROM V_READONLY;

INSERT INTO V_READONLY
VALUES (90, 'ANALYST', 'SEOUL');	-- 오류 발생. v_readonly 뷰에는 READ ONLY 옵션이 설정되어 있어 INSERT가 불가능

UPDATE V_READONLY
SET dname = 'CLERK', loc = 'BUSAN'
WHERE dno = 90;		-- 오류 발생. v_readonly 뷰에는 READ ONLY 옵션이 설정되어 있어 UPDATE가 불가능

DELETE v_readonly
WHERE dno = 90;		-- 오류 발생. v_readonly 뷰에는 READ ONLY 옵션이 설정되어 있어 DELETE가 불가능

COMMIT;
	
