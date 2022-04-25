-- << Sub Query >> --

-- 1. 사원번호가 7788인 사원과 담당 업무가 같은 사원을 표시(사원이름 과 담당업무) 하시오.
SELECT ename, job
FROM EMPLOYEE
WHERE job = (SELECT job FROM EMPLOYEE WHERE eno = 7788);

-- 2. 사원번호가 7499인 사원보다 급여가 많은 사원을 표시 (사원이름 과 담당업무) 하시오.
SELECT ename, job
FROM EMPLOYEE
WHERE salary > (SELECT salary FROM EMPLOYEE WHERE eno = 7499);

-- 3. 직급별로 최소 급여를 받는 사원의 이름, 담당 업무 및 급여를 표시 하시오(그룹 함수 사용)
SELECT ename, job, salary
FROM EMPLOYEE
WHERE salary IN(SELECT MIN(salary) FROM EMPLOYEE GROUP BY JOB);

-- 4. 평균 급여가 가장 작은 부서 내에서 급여가 가장 작은 사원의 직급과 급여를 표시하시오.
SELECT ename, job, salary
FROM EMPLOYEE
WHERE job = (SELECT job FROM EMPLOYEE GROUP BY job HAVING AVG(salary) <= ALL(SELECT AVG(salary) FROM EMPLOYEE GROUP BY job))
AND salary = (SELECT MIN(salary) FROM EMPLOYEE
WHERE job = (SELECT job FROM EMPLOYEE GROUP BY job HAVING AVG(salary) <= ALL(SELECT AVG(salary) FROM EMPLOYEE GROUP BY job)));

SELECT ename, job, salary
FROM EMPLOYEE
WHERE salary = (SELECT MIN(salary) FROM EMPLOYEE
	GROUP BY job HAVING AVG(salary) = (SELECT MIN(AVG(salary))
	FROM EMPLOYEE GROUP BY JOB));

-- 5. 각 부서의 최소 급여를 받는 사원의 이름, 급여, 부서번호를 표시하시오.
SELECT ename, salary, dno
FROM EMPLOYEE
WHERE salary IN(SELECT MIN(salary) FROM EMPLOYEE GROUP BY DNO);

-- 6. 담당 업무가 분석가(ANALYST)인 사원보다 급여가 적으면서 업무가 분석가가 아닌 사원들을 표시 (사원번호, 이름, 담당업무, 급여) 하시오.
SELECT eno, ename, job, salary
FROM EMPLOYEE
WHERE SALARY < ALL(SELECT salary FROM EMPLOYEE WHERE job = 'ANALYST')
AND job != 'ANALYST';

-- 7. 부하직원이 없는 사원의 이름을 표시 하시오.
SELECT ename, JOB
FROM EMPLOYEE
WHERE eno NOT IN (SELECT manager FROM EMPLOYEE WHERE manager IS NOT NULL);

-- 8. 부하직원이 있는 사원의 이름을 표시 하시오.
SELECT ename, JOB
FROM EMPLOYEE
WHERE eno IN (SELECT manager FROM EMPLOYEE WHERE manager IS NOT NULL);

-- 9. BLAKE와 동일한 부서에 속한 사원의 이름과 입사일을 표시하는 질의를 작성하시오(단, BLAKE 는 제외)
SELECT ename, hiredate
FROM EMPLOYEE
WHERE ename != 'BLAKE'
AND dno = (SELECT dno FROM EMPLOYEE WHERE ename = 'BLAKE'); 

-- 10. 급여가 평균보다 많은 사원들의 사원번호와 이름을 표시하되 결과를 급여에 대해서 오름 차순으로 정렬 하시오.
SELECT ename, eno, salary
FROM EMPLOYEE
WHERE salary > (SELECT AVG(salary) FROM EMPLOYEE)
ORDER BY salary ASC;

-- 11. 이름에 K 가 포함된 사원과 같은 부서에서 일하는 사원의 사원번호와 이름을 표시하는 질의를 작성하시오.
SELECT eno, ename
FROM employee
WHERE dno IN (SELECT dno FROM EMPLOYEE WHERE ename LIKE '%K%');

-- 12. 부서 위치가 DALLAS 인 사원의 이름과 부서 번호 및 담당 업무를 표시하시오.
SELECT e.ENAME, e.DNO, e.JOB
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO
AND e.DNO = (SELECT dno FROM DEPARTMENT WHERE loc = 'DALLAS');

SELECT ename, e.dno, job, loc
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO
AND e.DNO IN (SELECT dno FROM DEPARTMENT WHERE loc = 'DALLAS');

-- 13. KING에게 보고하는 사원의 이름과 급여를 표시하시오.
SELECT e.ENAME, e.SALARY
FROM EMPLOYEE e, EMPLOYEE m
WHERE e.MANAGER = m.ENO
AND e.MANAGER = (SELECT eno FROM EMPLOYEE WHERE ename = 'KING');

-- 14. RESEARCH 부서의 사원에 대한 부서번호, 사원이름 및 담당 업무를 표시 하시오.
SELECT e.DNO, e.ENAME, e.JOB 
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO
AND e.DNO = (SELECT dno FROM DEPARTMENT WHERE dname = 'RESEARCH');

-- 15. 평균 급여보다 많은 급여를 받고 이름에 M이 포함된 사원과 같은 부서에서 근무하는 사원의 사원번호, 이름, 급여를 표시하시오.
SELECT dno, ename
FROM EMPLOYEE
WHERE salary > (SELECT AVG(salary) FROM EMPLOYEE)
AND dno IN (SELECT dno FROM EMPLOYEE WHERE ename LIKE '%M%'); 

-- 16. 평균 급여가 가장 적은 업무를 찾으시오.
SELECT job
FROM EMPLOYEE
GROUP BY job
HAVING AVG(salary) <= ALL(SELECT AVG(salary) FROM EMPLOYEE GROUP BY job);

-- 17. 담당업무가 MANAGER인 사원이 소속된 부서와 동일한 부서의 사원을 표시하시오.
SELECT ename
FROM employee
WHERE dno IN (SELECT dno FROM EMPLOYEE WHERE job = 'MANAGER');

