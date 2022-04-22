-- Sub Query : Select 문 내에 Select 문이 있는 쿼리

/*
 * from 조건절 : sub query
 * where 조건절 : sub query
 * having 조건절 : sub query
 */

SELECT ename, salary FROM EMPLOYEE;
SELECT salary FROM EMPLOYEE WHERE ename = 'SCOTT';

	-- SCOTT의 월급보다 같거나 많은 사용자를 출력 (Sub Query를 사용하지 않을 경우)
SELECT ename, salary FROM EMPLOYEE WHERE salary >= 3000;
	-- SCOTT의 월급보다 같거나 많은 사용자를 출력 (Sub Query를 사용할 경우)
		-- => Select 문이 한번 더 사용됨
SELECT ename, salary
FROM EMPLOYEE
WHERE salary >= (SELECT salary FROM EMPLOYEE WHERE ename = 'SCOTT');
	-- => 주의 : 비교하는 컬럼들 값의 개수가 동일해야함

-- From 절에서 Sub Query 사용
	-- 급여가 가장 낮은 사원 순으로 3명의 이름과 월급 출력
		-- rownum : 행 번호 할당
		-- 쿼리 구문의 순서가 SELECT -> FROM -> WHERE -> ORDER BY 순으로 실행되어 정렬이 가장 늦기 때문에 제대로 급여가 낮은 순으로 출력되지 않음
SELECT last_name, SALARY
FROM EMPLOYEES
WHERE rownum < 4
ORDER BY SALARY ASC;

	-- 정답 => from 절 안에서 구문을 작성하여 구문 실행 순서를 임의로 바꾸는 효과를 사용할 수 있음
SELECT last_name, salary
FROM (SELECT last_name, salary FROM EMPLOYEES ORDER BY salary asc)
WHERE rownum < 4;

-- Where 절에서 Sub Query 사용

	-- SCOTT과 동일한 부서에 근무하는 사원들 출력하기
SELECT ename, dno
FROM EMPLOYEE
WHERE dno = (SELECT dno FROM EMPLOYEE WHERE ename = 'SCOTT');

	-- 최소 급여를 받는 사원의 이름, 담당업무, 급여 출력하기
SELECT ename, job, salary
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(salary) FROM EMPLOYEE); 

-- Having 절에서 Sub Query 사용
	-- 30번 부서의 최소월급보다 큰 각 부서의 최소 월급
SELECT dno, MIN(salary), COUNT(dno)
FROM EMPLOYEE
WHERE dno != 30
GROUP BY DNO
HAVING MIN(salary) > (SELECT MIN(salary) FROM EMPLOYEE WHERE dno = 30); 
	
	-- 30번 부서(dno)에서 급여가 최소 급여보다 많은 사원들의 이름, 부서번호, 월급을 출력
SELECT ename, dno, salary
FROM EMPLOYEE
WHERE dno = 30
GROUP BY DNO, ENAME, SALARY
HAVING salary > (SELECT MIN(salary) FROM EMPLOYEE WHERE dno = 30)
ORDER BY salary ASC, ename ASC;


/*
 * 단일행 서브 쿼리 : Sub Query의 결과값이 단 하나이면 출력
 * 	=> 단일행 비교 연산자 : >, =, >=, <, <=, !=(<>)
 * 다중행 서브 쿼리 : Sub Query의 결과값이 여러개이면 출력
 * 	=> 다중행 비교 연산자 : IN, ANY, SOME, ALL, EXISTS
 * 		- IN : 메인 쿼리의 비교 조건(' = ' 연산자로 비교할 경우)이 서브 쿼리의 결과값 중 하나라도 일치하면 true
 * 		- ANY, SOME : 메인 쿼리의 비교 조건이 서브 쿼리의 검색 결과와 하나 이상 일치하면 true
 * 		- ALL : 메인 쿼리의 비교 조건이 서브 쿼리의 검색 결과와 모든 값이 모두 일치하면 true
 * 		- EXIST : 메인 쿼리의 비교 조건이 서브 쿼리의 결과값 중에서 만족하는 값이 하나라도 존재하면 true
 */

-- IN 연산자 사용하기

	-- 부서별로 최소 월급을 받는 사원 정보 출력
SELECT dno, MIN(salary)
FROM employee
GROUP BY dno
ORDER BY dno ASC;

SELECT dno, ename, salary
FROM EMPLOYEE
WHERE SALARY IN (1300, 800, 950);

SELECT dno, ename, salary
FROM EMPLOYEE
WHERE salary IN (SELECT MIN(salary) FROM EMPLOYEE GROUP BY DNO);

-- ANY 연산자 사용
	-- 서브 쿼리가 반환하는 각각의 값과 비교
	-- ' < any ' 는 최대값보다 작음을 나타냄
	-- ' > any ' 는 최소값보다 큼을 나타냄
	-- ' = any ' 는 IN과 동일함

	-- 직급이 SALESMAN이 아니면서 SALESMAN 직급 사원의 최고 급여보다 급여가 작은 사원을 출력
SELECT eno, ename, job, salary
FROM EMPLOYEE
WHERE SALARY < ANY(SELECT salary FROM EMPLOYEE WHERE job = 'SALESMAN')
AND job != 'SALESMAN';

SELECT ename, job, salary FROM EMPLOYEE ORDER BY job ASC;

-- ALL 연산자 사용
	-- 서브 쿼리의 반환하는 모든 값과 비교
	-- ' > all ' : 최대값보다 큼을 나타냄
	-- ' < all ' : 최소값보다 작음을 나타냄

	-- 직급이 SALESMAN이 아니면서 SALESMAN 직급 사원의 최저 급여보다 적은 사원을 모두 출력
SELECT eno, ename, job, salary
FROM EMPLOYEE 
WHERE salary < ALL(SELECT salary FROM employee WHERE job = 'SALESMAN')
AND job != 'SALESMAN';

	-- 담당 업무가 분석가가 아니면서 분석가 직급 사원의 최저 급여보다 적은 사원을 모두 출력
SELECT job, MIN(salary) 
FROM EMPLOYEE
WHERE job = 'ANALYST'
GROUP BY JOB;

SELECT eno, ename, job, salary
FROM EMPLOYEE
WHERE SALARY < ALL(SELECT salary FROM EMPLOYEE WHERE job = 'ANALYST')
AND job != 'ANALYST';

	-- 급여가 평균 급여보다 많은 사원들의 사원번호와 이름을 급여 오름차순으로 출력
SELECT ROUND(AVG(salary)) FROM EMPLOYEE;

SELECT ename, salary
FROM EMPLOYEE
WHERE salary > (SELECT ROUND(AVG(salary)) FROM EMPLOYEE)
ORDER BY SALARY ASC;
