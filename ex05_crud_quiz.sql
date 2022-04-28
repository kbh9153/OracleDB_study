-- << crud quiz >> --

-- 8-1. 다음 표에 명시된 대로 DEPT 테이블을 생성 하시오.
CREATE TABLE dept (
	dno NUMBER(2) NOT NULL,
	dname varchar2(14) NULL,
	loc varchar2(13) NULL);
	
-- 8-2. 다음 표에 명시된 대로 EMP 테이블을 생성 하시오. 
CREATE TABLE emp (
	eno NUMBER(4) NOT NULL,
	ename varchar2(10) NULL,
	dno NUMBER(2) NULL);

-- 8-3. 긴이름을 넣을 수 있도록 EMP 테이블의 ENAME 컬럼의 크기를 늘리시오.
ALTER TABLE EMP MODIFY ename varchar2(25);

-- 8-4. EMPLOYEE 테이블을 복사해서 EMPLOYEE2 란 이름의 테이블을 생성하되 사원번호, 이름, 급여, 부서번호 컬럼만 복사하고 새로 생성된 테이블의 컬럼명은 각각 EMP_ID, NAME, SAL, DEPT_ID 로 지정 하시오.
CREATE TABLE EMPLOYEE2 AS SELECT eno EMP_ID, ename NAME, salary SAL, dno DEPT_ID FROM EMPLOYEE;

-- 8-5. EMP 테이블을 삭제 하시오.
DROP TABLE EMP;

-- 8-6. EMPLOYEE2 란 테이블 이름을 EMP로 변경 하시오.
RENAME employee2 TO emp;

-- 8-7. DEPT 테이블에서 DNAME 컬럼을 제거 하시오.
ALTER TABLE dept DROP COLUMN dname;

-- 8-8. DEPT 테이블에서 LOC 컬럼을 UNUSED로 표시 하시오.
ALTER TABLE dept SET unused (loc);

-- 8-9. UNUSED 커럼을 모두 제거 하시오.
ALTER TABLE dept DROP unused COLUMN;

-- 9-1. EMP 테이블의 구조만 복사하여 EMP_INSERT 란 이름의 빈 테이블을 만드시오.
CREATE TABLE emp_insert AS SELECT * FROM EMP WHERE 0 = 1;
ALTER TABLE EMP_INSERT ADD (hiredate DATE);

-- 9-2. 본인을 EMP_INSERT 테이블에 추가하되 SYSDATE를 이용해서 입사일을 오늘로 입력하시오.
INSERT INTO EMP_INSERT (emp_id, name, sal, dept_id, hiredate)
	VALUES (10, 'Hyeon', 30000, 10, SYSDATE);

-- 9-3. EMP_INSERT 테이블에 옆 사람을 추가하되 TO_DATE 함수를 이용해서 입사일을 어제로 입력하시오. 
INSERT INTO EMP_INSERT (emp_id, name, sal, dept_id, hiredate)
	VALUES (11, 'Ho', 30000, 20, SYSDATE - 1);

-- 9-4. employee 테이블의 구조와 내용을 복사하여 EMP_COPY란 이름의 테이블을 만드시오.
CREATE TABLE emp_copy AS SELECT * FROM EMPLOYEE;

-- 9-5. 사원번호가 7788인 사원의 부서번호를 10번으로 수정하시오. [ EMP_COPY 테이블 사용]
UPDATE EMP_COPY SET dno = 10 WHERE eno = 7788;

-- 9-6. 사원번호가 7788 의 담당 업무 및 급여를 사원번호 7499의 담당업무 및 급여와 일치 하도록 갱신하시오. [ EMP_COPY 테이블 사용]
UPDATE EMP_COPY
SET job = (SELECT job FROM EMP_COPY WHERE eno = 7499),
salary = (SELECT salary FROM EMP_COPY WHERE eno = 7499)
WHERE eno = 7788;

-- 9-7. 사원번호 7369와 업무가 동일한 사원의 부서번호를 사원 7369의 현재 부서번호로 갱신 하시오. [ EMP_COPY 테이블 사용]
UPDATE EMP_COPY 
SET dno = (SELECT dno FROM EMPLOYEE WHERE eno = 7369)
WHERE job = (SELECT job FROM EMPLOYEE WHERE eno = 7369);

-- 9-8. department 테이블의 구조와 내용을 복사하여 DEPT_COPY 란 이름의 테이블을 만드시오.
CREATE TABLE dept_copy AS SELECT * FROM DEPARTMENT;

-- 9-9. DEPT_COPY란 테이블에서 부서명이 RESEARCH인 부서를 제거 하시오.
DELETE dept_copy WHERE dname = 'RESEARCH';

-- 9-10. DEPT_COPY 테이블에서 부서번호가 10 이거나 40인 부서를 제거 하시오.
DELETE dept_copy WHERE dno IN(10, 40);

SELECT * FROM DEPT_COPY;
COMMIT;