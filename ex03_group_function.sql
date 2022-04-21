-- 집계 함수

/*
	그룹 함수 : 동일한 값에 대해서 그룹핑해서 처리하는 함수
	 => GROUP BY 절에 특정 컬럼을 정의할 경우, 해당 컬럼의 동일한 값들을 그룹핑해서 연산을 적용

	집계함수 :
	 - sum : 그룹의 합계
	 - avg : 그룹의 평균
	 - max : 그룹의 최대값
	 - min : 그룹의 최소값
	 - count : 그룹의 총 개수(레코드 수, 로우 수)
*/

SELECT SUM(salary), AVG(salary), MAX(salary) FROM EMPLOYEE;
SELECT SUM(salary), ROUND(AVG(salary), 2), MAX(salary) FROM EMPLOYEE;

-- 주의 : 집계 함수 처리할 때, 출력 컬럼의 로우 개수가 다르면 오류발생
	-- => sum(salary)는 하나의 로우가 출력되는데, ename의 경우 여러 값을 가진 여러개의 로우가 출력되어 오류 발생
SELECT SUM(salary), ename FROM EMPLOYEE; 

-- 집계 함수는 null 값을 자동으로 처리하여 연산함 => null은 제외하여 연산
SELECT SUM(commission), AVG(commission), MAX(commission), MIN(commission) FROM EMPLOYEE;  

-- count() : 레코드(로우) 수
	-- 주의 : count()는 null은 포함하지 않고 처리
	-- 테이블의 전체 레코드 수를 가져올 경우 : count(*) 또는 not null 컬럼을 count() 해야함
SELECT COUNT(eno) FROM EMPLOYEE;
SELECT COUNT(commission) FROM EMPLOYEE;		-- null을 포함하지 않아 4를 출력
SELECT COUNT(*) FROM EMPLOYEE;	-- * 는 전체를 의미. 모든 레코드 수를 출력
SELECT COUNT(NVL(commission, 0)) FROM EMPLOYEE;		-- null을 포함하여 처리 
SELECT COUNT(NVL(commission, 0)) - COUNT(commission) FROM EMPLOYEE;		-- null 값을 가진 로우의 개수만 출력

	-- 중복되지 않는 직업(job)의 개수
SELECT DISTINCT job FROM EMPLOYEE;
SELECT COUNT(DISTINCT job) FROM EMPLOYEE;	-- DISTINCT 사용하여 중복값 제거 후 개수 출력

	-- 부서(dno)의 개수
SELECT DISTINCT dno FROM EMPLOYEE;
SELECT COUNT(DISTINCT dno) FROM EMPLOYEE;


-- Group by : 특정 컬럼의 값을 그룹핑. 주로 집계 함수와 함께 사용
	-- => 컬럼의 값 중 중복값들을 그룹핑

/*
 * 구문 순서
 * 
 * 	select 컬럼명, 집계함수처리된 컬럼
 * 	from 테이블
 * 	where 조건
 * 	group by 컬럼명
 * 	having 조건(group by한 결과의 조건)
 * 	order by 정렬할컬럼명 정렬
 */

-- 그룹핑하기
	-- 전체 평균 급여
SELECT AVG(salary) AS 평균급여 FROM EMPLOYEE;
	-- 부서별 평균 급여
SELECT dno AS 부서번호, AVG(salary) AS 평균급여 FROM EMPLOYEE GROUP BY DNO;	-- dno 컬럼의 중복된 것들을 그룹핑함

SELECT dno AS 부서번호, COUNT(DNO), SUM(salary), AVG(salary), MAX(commission)  FROM EMPLOYEE GROUP BY DNO;	-- count(dno) : 그룹핑된 로오 개수 

	-- 출력 컬럼들이 로우 수가 일치하지 않아 오류 발생(그룹핑된 컬럼들만 출력 가능)
	-- group by를 사용하면서 select 절에 가져올 컬럼을 주의하여 지정해야함
-- SELECT dno AS 부서번호, COUNT(DNO), ename, SUM(salary) FROM EMPLOYEE GROUP BY DNO;

	-- 동일한 직책을 그룹핑해서 급여의, 평균, 합계, 최대값, 최소값을 출력
SELECT job, COUNT(JOB), AVG(salary), SUM(salary), MAX(salary), MIN(salary) FROM EMPLOYEE GROUP BY JOB; 

-- 여러 컬럼을 그룹핑 하기
	-- 컬럼값의 종류가 모두 일치하는 두 컬럼을 그룹핑
SELECT dno, job, COUNT(*), SUM(SALARY)  FROM EMPLOYEE GROUP BY DNO, JOB;
	-- 확인
SELECT dno, job FROM EMPLOYEE WHERE DNO = 20 AND JOB = 'CLERK';

-- having : group by에서 나온 결과를 조건으로 처리할 때
	-- => 주의 : HAVING 절에서는 별칭(Alias)이름을 조건으로 사용하면 안됨
SELECT dno, count(*), SUM(salary) AS 부서별합계, ROUND(AVG(salary), 2) AS 부서별평균 FROM EMPLOYEE GROUP BY DNO;

	-- 부서별 월급의 합계가 9000이상만 출력
SELECT dno, count(*), SUM(salary) AS 부서별합계,
ROUND(AVG(salary), 2) AS 부서별평균 
FROM EMPLOYEE GROUP BY DNO
HAVING SUM(SALARY) > 9000;

	-- 부서별 월급의 평균이 2000이상만 출력
SELECT dno, count(*), SUM(salary) AS 부서별합계,
ROUND(AVG(salary), 2) AS 부서별평균 
FROM EMPLOYEE GROUP BY DNO
HAVING ROUND(AVG(salary), 2) > 2000.00;

-- where와 having 절이 같이 사용되는 경우
	-- where : 실제 테이블의 조건으로 검색
	-- having : group by 결과에 대해서 조건으로 검색

	-- 월급이 1500 이하인 사원은 제외하고 각 부서별로 월급의 평균을 구하되 월급의 평균이 2000 이상인 사원만 출력
SELECT dno AS 부서번호, COUNT(*), ROUND(AVG(salary), 2) AS 부서별평균 
FROM EMPLOYEE
WHERE SALARY > 1500
GROUP BY DNO
HAVING ROUND(AVG(salary), 2) >= 2000;


-- ROLLUP
-- CUBE
	-- Group by 절에서 사용하는 특수한 함수
	-- 여러 컬럼을 나열할 수 있음
	-- Group by 절에 자세한 정보를 출력

-- roll up을 사용하지 않았을 때 : 부서별 합계와 평균을 출력
SELECT dno, COUNT(*), SUM(salary), ROUND(AVG(salary))
FROM EMPLOYEE
GROUP BY dno
ORDER BY dno ASC;
-- roll up을 사용하였을 때 : 부서별 합계와 평균을 출력 후, 마지막 로우에 전체 합계, 평균을 출력
SELECT dno, COUNT(*), SUM(salary), ROUND(AVG(salary))
FROM EMPLOYEE
GROUP BY ROLLUP(dno)
ORDER BY dno ASC;

-- cube를 사용하였을 때 : 부서별 합계와 평균을 출력 후, 마지막 로우에 전체 합계, 평균을 출력
SELECT dno, COUNT(*), SUM(salary), ROUND(AVG(salary))
FROM EMPLOYEE
GROUP BY CUBE(dno)
ORDER BY dno ASC;

-- << 여러 컬럼을 기준으로 하는 roll up과 cube >>-- => 소계, 합계와 유사
-- roll up : 두 컬럼 이상(n 컬럼)이 적용됨. n 컬럼의 동일한 컬럼들 값들끼리 그룹핑
	-- => 기준 컬럼에 null 값이 있는 로우의 경우 소계와 같은 기능을 담당
	-- => 마지막 로우에 전체 처리값이 출력
	-- => 첫 컬럼이 우선 기준으로 차례대로 그룹핑
SELECT dno, job, count(*), MAX(salary), SUM(salary), ROUND(AVG(salary))  
FROM EMPLOYEE
GROUP BY ROLLUP(dno, job);

-- cube : roll up에서 두번째 컬럼만을 기준으로 그룹핑하여 처리한 값들을 소계와 같이 추가적으로 출력
SELECT dno, job, count(*), MAX(salary), SUM(salary), ROUND(AVG(salary))  
FROM EMPLOYEE
GROUP BY CUBE(dno, job)
ORDER BY dno ASC, job ASC;

