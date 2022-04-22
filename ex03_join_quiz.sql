-- << JOIN Quiz >> --

-- 두 테이블을 join할 때 공통 키컬럼을 찾아야함
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

-- 1. EQUI 조인을 사용하여 SCOTT 사원의 부서 번호와 부서 이름을 출력 하시오. 
SELECT ename, e.dno, dname		-- dno는 공통 키컬럼. 공통 키컬럼은 항상 명시해줘야함
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO		-- dno는 공통 키컬럼. 공통 키컬럼은 항상 명시해줘야함	
AND ename = 'SCOTT';

-- 2. INNER JOIN과 ON 연산자를 사용하여 사원이름과 함께 그 사원이 소속된 부서이름과 지역명을 출력하시오. 
SELECT ename, dname, loc
FROM EMPLOYEE JOIN DEPARTMENT	-- "JOIN" 대신 "INNER JOIN"도 가능
ON employee.DNO = department.DNO;

-- 3. INNER JOIN과 USING 연산자를 사용하여 10번 부서에 속하는 모든 담당 업무의 고유한 목록(한번씩만 표시)을 부서의 지역명과 포함하여 출력하시오.
SELECT dno, dname, job, loc
FROM EMPLOYEE INNER JOIN DEPARTMENT
USING(dno)
WHERE dno = 10;

-- 4. NATUAL JOIN을 사용하여 커미션을 받는 모든 사원의 이름, 부서이름, 지역명을 출력 하시오. 
SELECT ename, dname, loc
FROM EMPLOYEE NATURAL JOIN DEPARTMENT
WHERE COMMISSION IS NOT NULL
AND COMMISSION != 0;

-- 5. EQUI 조인과 WildCard를 사용하여 이름에 A 가 포함된 모든 사원의 이름과 부서명을 출력 하시오.
SELECT ename, dname
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DNO = d.DNO
AND ename like '%A%';

-- 6. NATURAL JOIN을 사용하여 NEW YORK에 근무하는 모든 사원의 이름, 업무, 부서번호 및 부서명을 출력하시오. 
SELECT ename, job, dno, dname, loc
FROM EMPLOYEE NATURAL JOIN DEPARTMENT
WHERE loc = 'NEW YORK';

-----------------------------------------------------

-- 7. SELF JOIN을 사용하여 사원의 이름 및 사원번호를 관리자 이름 및 관리자 번호와 함께 출력 하시오. 각열에 별칭값을 한글로 넣으시오. 
SELECT e.eno AS 사원번호, e.ename AS 사원이름, e.manager AS 관리자번호, e2.ENAME AS 관리자이름
FROM EMPLOYEE e, EMPLOYEE e2
WHERE e.MANAGER = e2.ENO;

-- 8. OUTER JOIN, SELF JOIN을 사용하여 관리자가 없는 사원을 포함하여 사원번호를 기준으로 내림차순 정렬하여 출력 하시오.
SELECT e.ENO AS 사원번호, e.ENAME AS 사원이름, e.manager AS 관리자번호, e2.ENAME AS 관리자이
FROM EMPLOYEE e LEFT OUTER JOIN EMPLOYEE e2
ON e.MANAGER = e2.ENO
ORDER BY e.eno DESC;

-- 9. SELF JOIN을 사용하여 'SCOTT' 사원의 이름, 부서번호, 'SCOTT' 사원과 동일한 부서에서 근무하는 사원을 출력하시오. 단, 각 열의 별칭은 이름, 부서번호, 동료로 하시오. 


-- 10. SELF JOIN을 사용하여 WARD 사원보다 늦게 입사한 사원의 이름과 입사일을 출력하시오. 


-- 11. SELF JOIN을 사용하여 관리자 보다 먼저 입사한 모든 사원의 이름 및 입사일을 관리자 이름 및 입사일과 함께 출력하시오. 단, 각 열의 별칭을 한글로 넣어서 출력 하시오. 
