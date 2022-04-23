-- << OracleDB Quiz >> --

-- 문항 2. 월급이 1000이상 1500이하가 아닌 사원이름과 월급을 출력 하시오. 별칭 이름은 각각 "사원이름" , "월급" 으로 출력 하되  반드시 between 를 사용해서 출력 하시오.
SELECT ename AS 사원이름, salary AS 월급
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 1000 AND 1500;

-- 문항 3. 1981년도에 입사한 사원이름과 입사일을 출력 하시오. 단, LIKE  연산자와 와일드 카드 ( _ , %) 를 사용해서 출력 하시오. 별칭이름을 각각 "사원이름", "입사일" 로 출력하시오.
SELECT ename AS 사원이름, hiredate AS 입사일
FROM EMPLOYEE
WHERE HIREDATE LIKE '81%';

-- 문항 4. substr 함수를 사용해서 87년도에  입사한 사원의 모든 컬럼을 출력 하시오.
SELECT * FROM EMPLOYEE WHERE SUBSTR(HIREDATE, 1, 2) = 87;

-- 문항 5. 각 사원들이 현재 끼지 근무한 개월수를 출력 하시오.
SELECT ename, TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) AS 근무개월수 FROM EMPLOYEE;

-- 문항 6. 부서별 월급의 총액이 3000 이상인 부서의 부서 번호와 부서별 급여 총액을 출력 하시오.
SELECT dno, SUM(salary)
FROM EMPLOYEE 
GROUP BY dno
HAVING SUM(salary) >= 3000;

-- 문항 7. 부서별 사원수와 평균 급여를 출력하되, 평균급여는 소숫점 2자리 까지만 출력 하시오. 출력 컬럼은 부서번호, 부서별사원수, 평균급여 로 출력 하되 별칭이름도 "부서번호" , "부서별사원수", "평균급여"로 출력 하시오.
SELECT dno AS 부서번, count(*) AS 부서별사원수, ROUND(AVG(salary), 2) AS 평균급여
FROM EMPLOYEE
GROUP BY dno;

-- 문항 8. 2변 문항의 EMPLOYEE, 아래 DEPARTMENT 테이블을 활용하여 아래 물움에 답하시오. EQUI 조인을 사용하여 "SCOTT" 사원의 사원이름, 부서번호와 부서이름을 출력 하시요.
SELECT e.ename, e.dno, d.dname
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO
AND e.ename = 'SCOTT';

-- 문항 9. Natural Join을 사용하여 커밋션을 받는 모든 사원의 이름, 부서이름, 지역명을 출력 하시오. 별칭이름도 "사원이름", "부서이름", "지역명" 으로 출력하시오.
SELECT e.ename AS 사원이름, d.dname AS 부서이름, d.loc AS 지역명
FROM EMPLOYEE e NATURAL JOIN DEPARTMENT d
WHERE e.COMMISSION != 0;

-- 문항 10. 다음은 서브 쿼리를 사용하여 출력 하시오. 각 부서의 최소월급을 받는 사원의 이름, 급여, 부서번호를 표시하시오. 별칭이름은 "이름", "급여","부서번호" 로 출력 하시오
SELECT ename AS 이름, salary AS 급여, dno AS 부서번호
FROM EMPLOYEE
WHERE salary IN(SELECT MIN(salary) FROM EMPLOYEE GROUP BY DNO);
