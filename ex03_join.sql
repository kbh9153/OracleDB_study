-- << Join >> --

/*
 * Join
 * 	- DEPARTMENT와 EMPLOYEE는 원래 하나의 테이블이였으나 모델링(중복제거, 성능향상)을 위해서 테이블을 2개로 분리
 * 	- 두 테이블의 공통된 키컬럼(dno) => employee 테이블의 dno 컬럼은 department 테이블의 dno 컬럼을 참조하고 있음
 *	- 두 개이상의 테이블의 컬럼을 JOIN 구문을 사용해서 출력 
 */

SELECT * FROM DEPARTMENT; -- 부서정보를 저장하는 테이블
SELECT * FROM EMPLOYEE;	-- 사원정보를 저장하는 테이블

-- EQUI JOIN : Oracle JOIN 문법 중 가장 많이 사용하는 JOIN. Oracle에서만 사용 가능
	-- => (DNO, DNAME, LOC 컬럼)이 department 테이블의 컬럼
	-- => from 절 : Join할 테이블을 , 로 처리

	-- => where 절 : 두 테이블의 공통의 키컬럼을 " = "로 처리
	   -- => and : and를 사용하여 추가적인 조건을 처리(where 절을 사용한 경우)

	-- => 두 테이블의 공통된 키컬럼을 기본 테이블을 기본키라 칭하고 참조 테이블을 외래키라고 칭함

-- WHERE 절 : 공통키 컬럼을 처리한 경우
SELECT * FROM EMPLOYEE, DEPARTMENT
WHERE department.DNO = employee.DNO		-- 공통 키 적용
AND JOB = 'MANAGER';					-- 조건을 처리

-- Join시 테이블 Alias(별칭) => AS 사용시 오류 발생. AS 사용하지 않고 별칭을 작성할 것
SELECT * FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO AND SALARY > 1500;

-- SELECT 절에서 공통의 키 컬럼으르 출력시에 어느 테이블의 컬럼인지 명시해야 함
	-- => e.dno 또는 d.eno 작성 후 WHERE 절에서 두 컬럼은 동일하다고 명시해줘야 함
SELECT eno, job, e.dno, dname FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO;

	-- 두 테이블을 JOIN해서 부서별명(dname)으로 월급의 최대값을 출력
		-- 주의 : select 절에 컬럼을 작성시 group by에도 추가여부 확인할 것
SELECT dname, count(*), MAX(salary)
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO
GROUP BY dname; 


-- NATURAL JOIN : Oracle 9i 버전부터 지원이 시작된 문법
	-- EQUI JOIN의 WHERE 절을 삭제 : 두 테이블의 공통의 키컬럼을 " = "으로 정의
	-- 공통의 키컬럼을 Oracle 내부적으로 자동으로 감지해서 처리
	-- 공통키 컬럼을 별칭(Alias) 이름을 사용하면 오류 발생
	-- 공통키 컬럼들은 반드시 데이터 타입이 동일해야함
	-- FROM 절 : Join할 테이블을 "NATURAL JOIN" 키워드를 사용하여 처리
SELECT eno, ename, dname, dno
FROM EMPLOYEE e NATURAL JOIN DEPARTMENT d;

-- 주의 : SELECT 절에 공통된 키컬럼을 출력시 테이블명을 명시하면 오류 발생
	-- ex. e.dno / d.dno / employee.dno / department.dno

-- EQUI JONS vs NATURAL JOIN의 공통키 컬럼 처리
	-- EQUI JOIN : SELECT 절에 공통된 키컬럼을 출력할 때 반드시 테이블명을 반드시 명시해야함
	-- NATURAL JOIN : SELECT 절에 공통된 키컬럼을 출력시 테이블명을 명시하면 안됨

-- EQUI JOIN
SELECT ename, salary, dname, e.dno	-- e.dno : EQUI JOIN에서는 명시
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO
AND salary > 2000;

-- NATURAL JOIN
SELECT ename, salary, dname, dno	-- dno, NATURAL JOIN에서는 테이블명을 명시하면 안됨
FROM EMPLOYEE e NATURAL JOIN DEPARTMENT d;


-- ANSI 호환 : INNER JOIN. 모든 SQL에서 사용 가능한 JOIN
	-- => on 절 : 두 테이블의 공통의 키컬럼을 " = " 으로 처리
	-- => from 절 : 두 테이블을 "JOIN" 또는 'INNER JOIN" 으로 처리
	-- => where 절 : 조건을 처리

-- ON 절 : 공통키 컬럼을 처리한 경우
SELECT * FROM EMPLOYEE JOIN DEPARTMENT	-- FROM 절 : JOIN 사용
ON department.DNO = employee.DNO
WHERE JOB = 'MANAGER';

-- SELECT 절에서 공통의 키 컬럼으르 출력시에 어느 테이블의 컬럼인지 명시해야 함
SELECT ename, salary, dname, e.dno
FROM EMPLOYEE e JOIN DEPARTMENT d
ON e.dno = d.dno
WHERE SALARY > 2000;


-- NON EQUI JOIN : EQUI JOIN에서 WHERE 절의 " = " 을 사용하지 않는 JOIN
	-- => 두 테이블의 공통 키컬럼이 없는 경우를 뜻함
SELECT * FROM SALGRADE;	-- 월급의 등급을 표시하는 테이블

SELECT ename, salary, grade
FROM EMPLOYEE, SALGRADE
WHERE salary BETWEEN losal AND hisal;

-- 테이블 3개 JOIN
SELECT ename, dname, salary, grade
FROM EMPLOYEE e, DEPARTMENT d, SALGRADE s
WHERE e.DNO = d.DNO
AND salary BETWEEN losal AND hisal;


-- JOIN에서 USING을 사용하는 경우

/*
	NATURAL JOIN : 공통 키컬럼을 Oracle 내부에서 자동으로 찾아서 처리
	 => 반드시 두 테이블의 공통 키컬럼의 데이터 타입이 동일해야 자동으로 처리
	
	USING
	 - 두 테이블의 공통 키컬럼의 데이터 타입이 다른 경우 USING을 사용해서 처리
	 - 두 테이블의 공통 키컬럼이 여러개인 경우에도 USING을 사용해서 처리
*/


-- 제약 조건 : 테이블의 컬럼에 할당되어 데이터의 무결성을 확보(원하는 값, 오류 없는 데이터만 넣을 수 있도록 설정)

/*
 * Primary Key : 테이블에 한번만 사용할 수 있음. 하나의 컬럼, 두 개 이상을 그룹핑해서 적용
 * 	=> 중복된 값을 넣을 수 없음. null 값도 불가능
 * 	=> ex. ID와 같이 중복되지 않고 고유한 값을 가져야하며 빈 값이면 안되는 컬럼에 주로 사용
 * 
 * UNIQUE : 테이블에 여러 컬럼에 할당할 수 있음
 * 	=> 중복된 값을 넣을 수 없음. null 값은 가능
 * 	=> 단, 중복된 값을 넣을 수 없기 때문에 null 값도 한번만 넣을 수 있음
 * 
 * Foreign Key : 다른 테이블의 특정 컬럼의 값을 참조해서 넣을 수 있음
 * 	=> 자신의 컬럼에 임의의 값을 할당하지 못함
 * 
 * NOT NULL : null 값을 컬럼에 할당할 수 없음
 * 
 * CHECK : 컬럼에 값을 할당할 때 체크해서 조건에 만족되는 값만 할당
 * 
 * Default : 값을 넣지 않을 때 설정한 기본값이 들어가도록 설정
 */


-- Self JOIN : 자기 자신의 테이블을 JOIN 함
	-- => Alias(별칭)을 반드시 사용해야함
	-- => ex. 사원의 상사 정보를 출력, 조직도 등에 사용
	-- => select 절 : 테이블이름별칭.컬럼명 

	-- Self JOIN을 EQUI JOIN 방식으로 사용해서 사원의 이름과 직속 상관 이름 출력
SELECT e.eno AS 사원번호, e.ENAME AS 사원이름,
e.MANAGER AS 직속상관번호, e2.ENAME AS 직속상관이름
FROM EMPLOYEE e, EMPLOYEE e2
WHERE e.MANAGER = e2.ENO
ORDER BY e.ENAME ASC;

SELECT e.ename || '의 직속상관은 ' || m.ename || ' 입니다.'
FROM EMPLOYEE e, EMPLOYEE m
WHERE e.MANAGER = m.ENO
ORDER BY e.ENAME ASC;

	-- Self JOIN을 ANSI 호환(INNER JOIN) 방식으로 사용해서 사원의 이름과 직속 상관 이름 출력
SELECT e.eno AS 사원번호, e.ename AS 사원이름,
e.manager AS 직속상관번호, e2.ename AS 직속상관이름
FROM EMPLOYEE e JOIN EMPLOYEE e2
ON e.MANAGER = e2.ENO
ORDER BY e.ENAME ASC;

SELECT e.ename || '의 직속상관은 ' || m.ename || ' 입니다.'
FROM EMPLOYEE e INNER JOIN EMPLOYEE m
ON e.MANAGER = m.ENO
ORDER BY e.ENAME ASC;


-- OUTER JOIN
	-- 특정 컬럼의 두 테이블에서 공통적이지 않는 내용을 출력해야 할 때
	-- 공통적이지 않는 컬럼은 NULL 출력
	-- + 기호를 사용해서 출력 : Oracle
	-- ANSI 호환 : OUTER JOIN 구문을 사용해서 출력 => 모든 DBMS에서 호환

	-- Oracle. KING은 MANAGER가 없어서 공통된 컬럼이 아니기 때문에 출력되지 않아 (+) 사용해서 출력
SELECT e.ENAME, m.ENAME
FROM EMPLOYEE e JOIN EMPLOYEE m
ON e.MANAGER = m.ENO(+)		-- (+) : m.ename의 공통적이지 않는 내용도 출력

	-- ANSI 호환을 사용해서 출력
		-- (A) Left Outer JOIN (B) : (A) 컬럼 좌측의 컬럼인 (B)에 공통적인 부분이 없어도 무조건 모두 출력
		-- (A) Right Outer JOIN (B) : (A) 컬럼 우측의 컬럼인 (B)에 공통적인 부분이 없어도 무조건 모두 출력
		-- (A) FULL Outer JOIN (B) : (A), (B) 양쪽 컬럼에 있어 서로 공통적인 부분이 없어도 양쪽 컬럼 무조건 모두 출력
SELECT e.ENAME, m.ENAME 
FROM EMPLOYEE e LEFT OUTER JOIN EMPLOYEE m
ON e.MANAGER = m.ENO
ORDER BY e.ENAME ASC;