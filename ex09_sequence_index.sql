-- << 시퀀스, 인덱스, 권한관리 >> --

/*
 * 시퀀스 : 자동 번호 발생
 * 	- 번호가 자동 발생이 되면 뒤로 되돌릴 수 없음 (되돌리기 위해서는 삭제 후 다시 생성해야 함)
 * 	- Primary Key 키 컬럼에 번호를 자동으로 발생시키기 위해 사용
 *  - Primary Key 키 컬럼에는 중복되지 않는 고유값에 대한 신경을 쓰지 않아도 됨
 */

-- 초기값 : 10, 증가값 : 10
CREATE SEQUENCE sample_seq
INCREMENT BY 10		-- 증가값
START WITH 10;		-- 초기값

-- 시퀀스의 정보를 출력하는 데이터 사전
SELECT * FROM USER_SEQUENCES;

SELECT sample_seq.nextval FROM DUAL;	-- 시퀀스의 다음값 출력
SELECT sample_seq.currval FROM DUAL;	-- 시퀀스의 현재값 출력

-- 초기값 : 2, 증가값 : 2
CREATE SEQUENCE sample_seq2
INCREMENT BY 2
START WITH 2
nocache;		-- 캐쉬를 사용하지 않음 (캐쉬 : RAM) => 서버의 부하를 줄여줄 수 있음

/*
 * sequence에 cache를 사용하는 경우 vs 사용하지 않는 경우
 * 	- cache : 서버의 성능을 향상하기 위해 사용 (기본값 : 20개)
 * 	 => 캐쉬를 사용한다는 것으 메모리(RAM)을 사용한다는 것
 * 
 * 캐쉬를 사용하는 경우
 *  - 넘버링이 이루어질 때마다 캐쉬 사이즈까지는 넘버를 저장하고 기존 캐쉬에 저장된 넘버에서 이어서 넘버링 값을 할당 => 서버 성능 향
 * 	- 서버가 다운된 경우 캐쉬된 넘버링이 있는 경우 기존 캐쉬된 넘버링을 다시 할당
 * 캐쉬를 사용하지 않는 경우
 *  - 넘버링이 이루어질 때마다 오라클에서 새로운 값을 할당받
 *  - 서버가 다운된 경우 캐쉬된 넘버링이 모두 초기화되어 오라클에서 새로운 값을 할당 받게됨
 * 
 */

SELECT sample_seq2.nextval FROM DUAL;
SELECT sample_seq2.currval FROM DUAL;

-- 시퀀스를 Primary Key에 적용하기
CREATE TABLE dept_copy80
AS
SELECT * FROM DEPARTMENT
WHERE 0 = 1;

	-- 1. 시퀀스 생성 : 초기값 10 / 증가값 10
CREATE SEQUENCE dept_seq
INCREMENT BY 10
START WITH 10
nocache;

	-- 2. 시퀀스 적용
INSERT INTO DEPT_COPY80 (dno, dname, loc)
	VALUES (dept_seq.nextval, 'HR', 'SEOUL');
	
SELECT * FROM DEPT_COPY80;

-----------------------------------------------------

-- 시퀀스 생성
CREATE SEQUENCE emp_seq_no
INCREMENT BY 1
START WITH 1
nocache;

CREATE TABLE emp_copy80
AS
SELECT * FROM EMPLOYEE
WHERE 0 = 1;

SELECT * FROM EMP_COPY80;

-- 시퀀스를 테이블의 특정 컬럼을 적용
INSERT INTO EMP_COPY80
VALUES (emp_seq_no.nextval, 'SMITH', 'SALESMAN', 2222, sysdate, 3000, 300, 20);

-----------------------------------------------------

-- 기존의 시퀀스 수정

SELECT * FROM user_sequences;

ALTER SEQUENCE emp_seq_no
MAXVALUE 1000;	-- 최대값 1000으로 수정

ALTER SEQUENCE emp_seq_no
CYCLE; 	-- CYCLE(최대값까지 도달 후 다시 최소값으로 다시 넘버링 시작(순환)) 사용 => 기본값 N (사용안함)

ALTER SEQUENCE emp_seq_no
NOCYCLE;	-- NOCYLE : 사이클 사용안함

-- 시퀀스 삭제

DROP SEQUENCE sample_seq;

-----------------------------------------------------

/*
 * INDEX : 테이블의 컬럼에 생성. 특정 컬럼에 검색을 빠르게 사용할 수 있도록 함 (= 색인)
 *  - 테이블 스캔과 다른 기능
 *  - 색인과 유사한 기능 : 중요 키워드 별로 구분하여 빠르게 위치를 검색할 수 있도록 함 (검색 속도가 상대적으로 빠름)
 *  - 테이블 스캔 : INDEX를 사용하지 않고 레코드의 처음부터 마지막까지 검색 (검색 속도가 상대적으로 느림)
 * 	 => INDEX가 생성되지 않은 컬럼은 검색시 테이블 스캔을 함
 *  - INDEX Page : 컬럼의 중요 키워드를 추출해서 위치 정보를 저장한 페이지
 * 	 => DB 메모리 공간의 10% 차지
 *  - Primary Key, Unique 키가 적용된 컬럼은 Index Page가 자동으로 생성되어 검색 
 *  - Where 절에서 자주 검색을 하는 컬럼에 Index를 생성 (테이블의 검색을 자주하는 컬럼에 INDEX 생성)
 *  - Index를 생성할 때 과부하가 많이 걸림 => 떄문에 주로 업무시간을 피해서 생성을 하는 편임
 *  - 퀄리티가 낮은 INDEX는 오히려 검색 속도 저하를 발생시키니 신중하게 작성할 것
 */

-- index 정보가 저장되어 있는 데이터 사전

	-- user_tab_columns, user_ind_columns
SELECT * FROM user_tab_columns;
SELECT * FROM user_ind_columns;

SELECT * FROM USER_TAB_COLUMNS
WHERE TABLE_NAME IN ('EMPLYEE', 'DEPARTMENT');

SELECT index_name, table_name, column_name
FROM USER_IND_COLUMNS
WHERE table_name IN ('EMPLOYEE', 'DEPARTMENT');

SELECT * FROM EMPLOYEE;		-- employee 테이블의 eno 컬럼에 PRIMARY KEY가 있어 자동으로 INDEX 생성되어 있음

-- index 자동 생성 (Primary Key, Unique가 적용된 컬럼에는 Index Page가 자동으로 생성되어 있음)
CREATE TABLE tbl1 (
	a NUMBER(4) NULL CONSTRAINT PK_tb1_a PRIMARY KEY,
	b NUMBER(4) NULL,
	c NUMBER(4) NULL);

SELECT index_name, table_name, column_name
FROM USER_IND_COLUMNS
WHERE table_name IN ('TBL1');

CREATE TABLE tbl2 (
	a NUMBER(4) NULL CONSTRAINT PK_tb2_a PRIMARY KEY,
	b NUMBER(4) NULL CONSTRAINT UK_tb2_b UNIQUE,
	c NUMBER(4) NULL);
	
SELECT index_name, table_name, column_name
FROM USER_IND_COLUMNS
WHERE table_name IN ('TBL2');

CREATE TABLE emp_copy90
AS
SELECT * FROM EMPLOYEE;

SELECT index_name, table_name, column_name
FROM USER_IND_COLUMNS
WHERE table_name IN ('EMP_COPY90');

SELECT * FROM emp_copy90
WHERE ename = 'KING';	-- ename 컬럼에 INDEX가 없어 테이블 스캔 방식으로 KING을 검색	

-- ename 컬럼에 index 생성하기
CREATE INDEX id_emp_name
ON emp_copy90(ename);

SELECT index_name, table_name, column_name
FROM USER_IND_COLUMNS
WHERE table_name IN ('EMP_COPY90');

SELECT * FROM EMP_COPY90
WHERE ename = 'KING';

-- ename 컬럼의 index 제거
DROP INDEX id_emp_name;

/*
 * INDEX는 주기적으로 REBUILD 해줘야함 (1주일, 1달 주기 => 업체별 상이)
 * 	- DML(Insert, Update, Delete)dl 빈번하게 일어날 경우, Index Page는 조각남
 */

-- Index REBUILD를 해야하는 정보 얻기
	-- Index의 Tree 깊이가 4 이상인 경우가 조회가 되면 REBUILD할 필요가 있음
SELECT I.TABLESPACE_NAME, I.TABLE_NAME, I.INDEX_NAME, I.BLEVEL,
	DECODE (SIGN(NVL(I.BLEVEL, 99) -3), 1, DECODE (NVL(I.BLEVEL, 99), 99, '?', 'Rebuild'), 'Check') CNF
FROM USER_INDEXES I
WHERE I.BLEVEL > 4
ORDER BY I.BLEVEL DESC;

-- index rebuild
ALTER INDEX id_emp_name rebuild;	-- index를 rebuild

SELECT * FROM emp_copy90;

/*
 * Index를 사용해야 하는 경우
 * 	1. 테이블의 행(로우, 레코드)의 개수가 많을 경우
 * 	2. where 절에서 자주 사용되는 컬럼
 * 	3. Join 시 사용되는 키 컬럼
 * 	4. 검색 결과가 원본 테이블 데이터의 2% ~ 4% 정도 되는 경우
 * 	5. 해당 컬럼이 null을 포함하는 경우 ( 색인은 null 제외)
 * 
 * Index를 사용하면 안 좋은 경우
 * 	1. 테이블의 행 개수가 적은 경우
 * 	2. 검색 결과가 원본 테이블의 많은 비중(%)를 차지하는 경우
 * 	3. Insert, Update, Delete가 빈번하게 발생되는 컬럼
 */

/*
 * Index 종류
 * 	1. 고유 인덱스 (Unique Index) : 컬럼의 중복되지 않는 고유한 값을 갖는 Index (Primary Key, Unique)
 * 	2. 단일 인덱스 (Single Index) : 한 컬럼에 부여되는 Index
 *  3. 결합 인덱스 (Composite Index) : 여러 컬럼을 묶어서 생성한 Index
 * 	4. 함수 인덱스 (Function Base Index) : 함수를 적용한 컬럼에 생성한 Index
 */

SELECT * FROM EMP_COPY90;

-- 단일 인덱스 (SIngle Index) 생성
CREATE INDEX inx_emp_copy90_salary
ON emp_copy90(salary);

-- 결합 인덱스 (Composite Index) 생성
CREATE TABLE dept_copy90
AS
SELECT * FROM DEPARTMENT;

CREATE INDEX idx_dept_copy90_dname_loc
ON dept_copy90(dname, loc);

SELECT index_name, table_name, column_name
FROM USER_IND_COLUMNS
WHERE TABLE_NAME IN ('DEPT_COPY90');

-- 함수 기반(Function Base Index) 인덱스 생성
CREATE TABLE emp_copy70
AS
SELECT * FROM EMPLOYEE;

CREATE INDEX idx_empcopy70_allsal
ON emp_copy70(salary * 12);

-- 인덱스 삭제
DROP INDEX inx_emp_copy90_salary;
DROP INDEX idx_dept_copy90_dname_loc;
DROP INDEX idx_empcopy70_allsal;