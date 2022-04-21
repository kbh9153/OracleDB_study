--<< 그룹함수 Quiz >>--

-- 1. 모든 사원의 급여 최고액, 최저액, 총액, 및 평균 급여를 출력 하시오. 컬럼의 별칭은 동일(최고액, 최저액, 총액, 평균)하게 지정하고 평균에 대해서는 정수로 반올림 하시오. 
SELECT MAX(salary) AS 최고액, MIN(salary) AS 최저액, SUM(salary) AS 총액, ROUND(AVG(salary)) AS 평균 FROM EMPLOYEE; 

-- 2. 각 담당업무 유형별로 급여 최고액, 최저액, 총액 및 평균액을 출력하시오. 컬럼의 별칭은 동일(최고액, 최저액, 총액, 평균)하게 지정하고 평균에 대해서는 정수로 반올림 하시오. 
SELECT JOB AS 담당업무, MAX(salary) AS 최고액, MIN(salary) AS 최저액, SUM(salary) AS 총액, ROUND(AVG(salary)) AS 평균 FROM EMPLOYEE GROUP BY JOB;

-- 3. count(*)함수를 사용하여 담당 업무가 동일한 사원수를 출력하시오. 
SELECT JOB, COUNT(job) FROM EMPLOYEE GROUP BY JOB; 

-- 4. 관리자 수를 나열 하시오. 컬럼의 별칭은 "관리자수" 로 나열 하시오.
SELECT COUNT(DISTINCT NVL(manager, 0)) AS 관리자수 FROM EMPLOYEE;

-- 5. 급여 최고액, 최저 급여액의 차액을 출력 하시오, 컬럼의 별칭은 "DIFFERENCE"로 지정하시오.
SELECT MAX(DISTINCT salary) - MIN(DISTINCT salary) AS DIFFERENCE FROM EMPLOYEE; 

-- 6. 직급별 사원의 최저 급여를 출력하시오. 관리자가 알 수 없는 사원 및 최저 급여가 2000미만인 그룹은 제외 시키고 결과를 급여에 대한 내림차순으로 정렬하여 출력 하시오. 
SELECT job, MIN(salary) FROM EMPLOYEE GROUP BY JOB ORDER BY MIN(SALARY) DESC; 

-- 7. 각 부서에대해 부서번호, 사원수, 부서내의 모든 사원의 평균 급여를 출력하시오. 컬럼의 별칭은 [부서번호, 사원수, 평균급여] 로 부여하고 평균급여는 소숫점 2째자리에서 반올림 하시오.
SELECT dno AS 부서번호, COUNT(ename) AS 사원수, ROUND(AVG(salary), 2) AS 평균급여 FROM EMPLOYEE GROUP BY DNO;

-- 8. 각 부서에 대해 부서번호, 이름, 지역명, 사원수, 부서내의 모든 사원의 평균 급여를 출력하시오.  결럼의 별칭은 [부서번호이름, 지역명, 사원수,평균급여] 로 지정하고 평균급여는 정수로 반올림 하시오. 
/*
[출력예시] 

dname		Location		Number of People		Salary
-----------------------------------------------------------------------------------------------
SALES		CHICAO				6					1567
RESERCH		DALLS				5					2175
ACCOUNTING   	NEW YORK		3					2917
*/

SELECT DECODE(dno, 10, 'ACCOUNTING',
	20, 'RESEARCH',
	30, 'SALES') AS dname,
DECODE(dno, 10, 'NEW YORK',
	20, 'DALLS',
	30, 'CHICAGO') AS Location,
COUNT(*) AS "Number of People", 
ROUND(AVG(salary)) AS Salary FROM EMPLOYEE GROUP BY DNO;
