--<< constraints and view quiz >>--

-- 데이터 무결성과 제약 조건

-- 1. employee 테이블의 구조를 복사하여 emp_sample 란 이름의 테이블을 만드시오. 사원 테이블의 사원번호 컬럼에 테이블 레벨로 primary key 제약조건을 지정하되 제약조건 이름은 my_emp_pk로 지정하시오. 
CREATE TABLE emp_sample
AS
SELECT * FROM EMPLOYEE;

ALTER TABLE EMP_SAMPLE
ADD CONSTRAINT my_emp_pk PRIMARY KEY(eno);
-- 2. department 테이블의 구조를 복사하여 dept_sample 란 이름의 테이블을 만드시오. 부서 테이블의 부서번호 컬럼에 레벨로 primary key 제약 조건을 지정하되 제약 조건이름은 my_dept_pk로 지정하시오. 
CREATE TABLE dept_sample
AS
SELECT * FROM DEPARTMENT;

ALTER TABLE DEPT_SAMPLE
ADD CONSTRAINT my_dept_pk PRIMARY KEY(dno);

-- 3. 사원 테이블의 부서번호 컬럼에 존재하지 않는 부서의 사원이 배정되지 않도록 외래키 제약조건을 지정하되 제약 조건이름은 my_emp_dept_fk 로 지정하시오. [주의 : 위 복사한 테이블을 사용하시오]
ALTER TABLE emp_sample
ADD CONSTRAINT my_emp_dept_fk FOREIGN KEY(dno) REFERENCES dept_sample(dno);

-- 4. 사원테이블의 커밋션 컬럼에 0보다 큰 값만을 입력할 수 있도록 제약 조건을 지정하시오. [주의 : 위 복사한 테이블을 사용하시오]
UPDATE EMP_SAMPLE
SET commission = 0
WHERE COMMISSION IS NULL;

ALTER TABLE EMP_SAMPLE
ADD CONSTRAINT CK_emp_sample_commission CHECK (commission >= 0);

-- 5. 사원테이블의 웝급 컬럼에 기본 값으로 1000 을 입력할 수 있도록 제약 조건을 지정하시오. [주의 : 위 복사한 테이블을 사용하시오]
ALTER TABLE EMP_SAMPLE 
MODIFY salary DEFAULT 1000;

-- 6. 사원테이블의 이름 컬럼에 중복되지 않도록  제약 조건을 지정하시오. [주의 : 위 복사한 테이블을 사용하시오]
ALTER TABLE EMP_SAMPLE
ADD CONSTRAINT UK_emp_sample_ename UNIQUE(ename);

-- 7. 사원테이블의 커밋션 컬럼에 null 을 입력할 수 없도록 제약 조건을 지정하시오. [주의 : 위 복사한 테이블을 사용하시오]
ALTER TABLE EMP_SAMPLE
MODIFY commission CONSTRAINT NN_emp_sample_ename NOT NULL;

-- 8. 위의 생성된 모든 제약 조건을 제거 하시오. 
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME IN ('EMP_SAMPLE', 'DEPT_SAMPLE');

ALTER TABLE EMP_SAMPLE
DROP CONSTRAINT MY_EMP_DEPT_FK;

ALTER TABLE EMP_SAMPLE
DROP CONSTRAINT MY_EMP_PK;

/*
ALTER TABLE EMP_SAMPLE
DROP CONSTRAINT MY_EMP_PK CASCADE;
*/

ALTER TABLE EMP_SAMPLE
DROP CONSTRAINT UK_EMP_SAMPLE_ENAME;

ALTER TABLE EMP_SAMPLE
DROP CONSTRAINT NN_EMP_SAMPLE_ENAME;

ALTER TABLE EMP_SAMPLE
DROP CONSTRAINT CK_EMP_SAMPLE_COMMISSION;

ALTER TABLE DEPT_SAMPLE
DROP CONSTRAINT MY_DEPT_PK;

------------------------------------------------

-- 뷰 문제 

-- 1. 20번 부서에 소속된 사원의 사원번호과 이름과 부서번호를 출력하는 select 문을 하나의 view 로 정의 하시오. 뷰의 이름 : v_em_dno 
CREATE VIEW v_em_dno
AS
SELECT eno, ename, dno
FROM employee
WHERE dno = 20;

-- 2. 이미 생성된 뷰( v_em_dno ) 에 대해서 급여 역시 출력 할 수 있도록 수정하시오. 
CREATE OR REPLACE VIEW V_EM_DNO
AS
SELECT eno, ename, dno, salary
FROM employee
WHERE dno = 20;

-- 3. 생성된 뷰를 제거 하시오.
DROP VIEW v_em_dno;

-- 4. 각 부서의 급여의  최소값, 최대값, 평균, 총합을 구하는 뷰를 생성 하시오.  뷰이름 : v_sal_emp
CREATE VIEW v_sal_emp
AS
SELECT dno, MIN(salary) AS 최소급여, MAX(salary) AS 최대급여, ROUND(AVG(salary), 2) AS 평균급여, SUM(salary) AS 급여총합
FROM employee
GROUP BY dno;

-- 5. 이미 생성된 뷰( v_em_dno ) 에 대해서 읽기 전용 뷰로 수정하시오. 
CREATE OR REPLACE VIEW V_EM_DNO
AS
SELECT eno, ename, dno, salary
FROM employee WITH READ ONLY;
WHERE dno = 20;

COMMIT;