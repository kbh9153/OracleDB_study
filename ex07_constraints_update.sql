-- << 제약 조건 수정 >> --

-- Alter Table : 기존의 테이블에 제약 조건을 수정

-- 테이블 복사
CREATE TABLE emp_copy50 AS SELECT * FROM EMPLOYEE;
CREATE TABLE dept_copy50 AS SELECT * FROM DEPARTMENT;

SELECT * FROM EMP_COPY50;
SELECT * FROM DEPT_COPY50;
-- 원본 테이블 제약조건 확인(주의 : 영문 테이블명 대문자로 작성할 것!)
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('EMPLOYEE', 'DEPARTMENT');

-- 테이블을 복사하면 테이블 구주와 레코드만 복사
	-- => 테이블의 제약 조건은 복사되지 않음
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('EMP_COPY50', 'DEPT_COPY50');

-- 복사한 테이블에 제약 조건 추가
	-- Primary Key 추가 (기존 데이터에 중복되는 데이터가 있으면 추가시 오류 발생)
ALTER TABLE EMP_COPY50
ADD CONSTRAINT PK_emp_copy50_eno PRIMARY KEY(eno);

ALTER TABLE DEPT_COPY50
ADD CONSTRAINT PK_emp_copy50_dno PRIMARY KEY(dno);

	-- Foreign Key 추가
ALTER TABLE EMP_COPY50
ADD CONSTRAINT FK_emp_copy50_dno FOREIGN KEY(dno) REFERENCES dept_copy50(dno);

	-- NOT NULL 제약 조건 수정 => add 대신에 modify 사용(모든 컬럼은 따로 설정하지 않으면 기본적으로 NULL이 설정되어 있음)
		-- => emp_copy50에 NOT NULL을 설정하지 않았지만 Primary Key를 설정하였기에 자등으로 NOT NULL이 설정됨
		-- => dept_copy50에 NOT NULL을 설정하지 않았지만 Primary Key를 설정하였기에 자등으로 NOT NULL이 설정됨
ALTER TABLE EMP_COPY50
MODIFY ename CONSTRAINT NN_emp_copy50_ename NOT NULL;

	-- commission 컬럼 not null 제약 조건 수정
		-- => 기존 데이터에 null 값이 있어 수정시 오류 발생 => update 구문을 사용하여 null값을 다른 값으로 수정이 필요
UPDATE EMP_COPY50
SET COMMISSION = 0
WHERE COMMISSION IS NULL;

ALTER TABLE EMP_COPY50
MODIFY commission CONSTRAINT NN_emp_copy50_commission NOT NULL;

SELECT commission FROM EMP_COPY50;

	-- Unique 제약 조건 추가 (기존 데이터에 중복되는 데이터가 있으면 추가시 오류 발생)
-- 중복값 데이터 있는지 확인
SELECT ename, count(*)
FROM EMP_COPY50
GROUP BY ENAME
HAVING COUNT(*) > 1;

ALTER TABLE EMP_COPY50
ADD CONSTRAINT UQ_emp_copy50_ename unique(ename);

-- 제약 조건 이름 변경
ALTER TABLE EMP_COPY50
RENAME CONSTRAINT UQ_emp_copy50_ename TO UK_emp_copy50_ename;

	-- Check 제약 조건 추가
ALTER TABLE EMP_COPY50
ADD CONSTRAINT CK_emp_copy50_salary CHECK (salary BETWEEN 0 AND 10000);

	-- Default 제약 조건 추가 (default는 제약조건이 아님 => 제약 조건 이름을 할당할 수 없음)
		-- => 엄밀히 default는 제약조건이 아니라 값을 넣지 않을 경우를 대비한 기본값 설정일 뿐
ALTER TABLE EMP_COPY50
MODIFY salary DEFAULT 1000;

INSERT INTO EMP_COPY50 (eno, ename, commission)
	VALUES (9999, '석.D', 100);

ALTER TABLE EMP_COPY50
MODIFY hiredate DEFAULT sysdate;

INSERT INTO EMP_COPY50
	VALUES (8888, '가.D', NULL, NULL, DEFAULT, DEFAULT, 1000, NULL);

SELECT * FROM EMP_COPY50;


-- 제약 조건 제거 : Alter Table 테이블명 drop

-- Primary key 제거 : primary key는 테이블에 하나만 존재
	-- => 제약 조건 이름으로도 제거가 되지만 테이블에 하나만 존재하기 때문에 삭제시 제약 조건 이름이 굳이 불필요 
ALTER TABLE EMP_COPY50
	DROP PRIMARY KEY;

ALTER TABLE DEPT_COPY50
	DROP PRIMARY KEY;	-- 오류발생 : FOREIGN KEY가 참조하기 때문에 삭제 불가
	
ALTER TABLE DEPT_COPY50
	DROP PRIMARY KEY CASCADE;	-- cascade(강제)를 사용하면 FOREIGN KEY를 먼저 자동 삭제되고 PRIMARY KEY가 삭제됨
	
-- NOT NULL 제약 조건 제거하기 : 제약 조건 이름으로 삭제
ALTER TABLE EMP_COPY50
DROP CONSTRAINT NN_emp_copy50_ename; 

-- Unique, Check 제약 조건 제거하기
ALTER TABLE EMP_COPY50
DROP CONSTRAINT UK_emp_copy50_ename;

ALTER TABLE EMP_COPY50
DROP CONSTRAINT CK_emp_copy50_salary;

ALTER TABLE EMP_COPY50
DROP CONSTRAINT NN_emp_copy50_commission;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN ('EMP_COPY50', 'DEPT_COPY50');

-- default는 null 허용 컬럼은 default를 null로 설정(= default 조건을 제거하는 것)
ALTER TABLE EMP_COPY50
MODIFY hiredate DEFAULT NULL;


/*
 * 제약 조건 disable / enable
 * 	- 제약조건을 중지
 *  - 대량의 데이터를 Insert(Bulk Insert)할 때 제약조건이 실행되고 있으면 부하가 많이 걸림(각각의 레코드마다 제약 조건이 check 되기 때문)
 * 	  => 때문에 잠시 중지(disable) 후 데이터를 Insert 다시 실행(enable)
 * 	- Index를 생성시 부하가 많이 걸림 => 때문에 disable -> enable
 */
ALTER TABLE DEPT_COPY50 
ADD CONSTRAINT PK_dept_copy50_dno PRIMARY KEY(dno);

ALTER TABLE EMP_COPY50
ADD CONSTRAINT FK_emp_copy50_eno PRIMARY KEY(eno);

ALTER TABLE EMP_COPY50
ADD CONSTRAINT FK_emp_copy50_dno FOREIGN KEY(dno) REFERENCES dept_copy50(dno);

SELECT * FROM user_constraints
WHERE TABLE_NAME IN ('EMP_COPY50', 'DEPT_COPY50');

ALTER TABLE EMP_COPY50
disable CONSTRAINT FK_emp_copy50_dno;

INSERT INTO EMP_COPY50 (eno, ename, dno)
VALUES (8989, 'aaaa', 50);

INSERT INTO DEPT_COPY50 
VALUES (50, 'HR', 'SEOUL');

ALTER TABLE EMP_COPY50
enable CONSTRAINT FK_emp_copy50_dno;