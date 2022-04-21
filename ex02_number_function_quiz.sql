--<< Quiz >>--

SELECT * FROM EMPLOYEE;

-- 1. SUBSTR 함수를 사용하여 사원들의 입사한 년도와 입사한 달만 출력 하시오.
SELECT SUBSTR(hiredate, 1, 5) FROM EMPLOYEE;

-- 2. SUBSTR 함수를 사용하여 4월에 입사한 사원을 출력 하시오.
SELECT ename, hiredate FROM EMPLOYEE WHERE SUBSTR(hiredate, 4, 2) = '04'; 

-- 3. MOD 함수를 사용하여 직속상관이 홀수인 사원만 출력하시오. 
SELECT ename, MANAGER FROM EMPLOYEE WHERE MOD(MANAGER, 2) = 1;

-- 3-1. MOD 함수를 사용하여 월급이 3의 배수인 사원들만 출력하세요.
SELECT ename FROM EMPLOYEE WHERE MOD(SALARY, 3) = 0;

-- 4. 입사한 년도는 2자리 (YY), 월은 (MON)로 표시하고 요일은 약어 (DY)로 지정하여 출력 하시오.
SELECT HIREDATE, TO_CHAR(hiredate, 'YY/MM DY') FROM EMPLOYEE;
SELECT HIREDATE, TO_CHAR(hiredate, 'YY MON DY') AS 출력결과 FROM EMPLOYEE;

-- 5. 올해 몇 일이 지났는지 출력 하시오. 현재 날짜에서 올해 1월 1일을 뺀 결과를 출력하고 TO_DATE 함수를 사용하여 데이터 형식을 일치 시키시오. 
SELECT TRUNC(SYSDATE - TO_DATE(20220101, 'YYYYMMDD')) AS 올해지난날짜수 FROM dual;

-- 5-1. 자신이 태어난 날짜에서 현재까지 몇 일이 지났는지 출력 하세요. 
SELECT TRUNC(SYSDATE - TO_DATE(19931113, 'YYYYMMDD')) AS 생존날짜 FROM dual;

-- 5-2. 자신이 태어난 날짜에서 현재까지 몇 개월이 지났는지 출력 하세요.
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(19931113, 'YYYYMMDD'))) AS 올해지난개월수 FROM dual; 

-- 6. 사원들의 상관 사번을 출력하되 상관이 없는 사원에 대해서는 null 값 대신 0으로 출력 하시오.
SELECT ENAME, NVL2(manager, manager, 0) AS 사원번호 FROM EMPLOYEE;

-- 7. DECODE 함수로 직급에 따라 급여를 인상하도록 하시오. 직급이 'ANAIYST' 사원은 200 , 'SALESMAN' 사원은 180, 'MANAGER'인 사원은 150, 'CLERK'인 사원은 100을 인상하시오.
SELECT ENAME, SALARY, DECODE(job, 'ANALYST', salary + 200,
	'SALESMAN', salary + 180,
	'MANAGER', salary + 150,
	'CLERK', salary + 100,
	SALARY) AS "인상된 급여"
FROM EMPLOYEE;

-- 8. 사원번호, [사원번호 2자리만 출력 나머지는 * 처리] as 가린번호, 이름, [이름의 첫자만 출력하고 나머지는 * 처리 - 총 4자리로 처리] as 가린이름
SELECT eno, RPAD(SUBSTR(eno,1, 2), 4, '*') AS 가린번호, ename, RPAD(SUBSTR(ENAME, 1, 1), 4, '**') AS 가린이름 FROM EMPLOYEE;
SELECT eno, RPAD(SUBSTR(eno,1, 2), LENGTH(ENO), '*') AS 가린번호, ename, RPAD(SUBSTR(ENAME, 1, 1), LENGTH(ENAME), '**') AS 가린이름 FROM EMPLOYEE;

-- 9. 주민번호를 출력, 801234-1****** 형식으로 출력, 전화번호 출력, 전화번호 : 010-12******
-- SELECT RPAD(801234, 7, '-') || RPAD(1, 7, '*') AS 주민번호, RPAD('010', 4, '-') || RPAD(12, 8, '*') AS 전화번호 FROM dual;
SELECT RPAD(SUBSTR('801234-1234567', 1, 8), LENGTH('801234-1234567'), '*') AS 주민번호, RPAD(SUBSTR('010-1234-5678', 1, 6), LENGTH('010-1234-5678'), '*') AS 전화번호 FROM dual; 

-- 10. 사원번호, 사원명, 직속상관, [직속상관의 번호가 없을 경우 : 0000, 앞 2자리가 75일 경우 : 5555, 76일 경우 : 6666, 77일 경우 : 7777, 78일 경우 : 8888 그 외는 그대로 출력
SELECT eno, ename, manager, DECODE(TRUNC(MANAGER / 100), NULL, '0000',
	75, '5555',
	76, '6666',
	77, '7777',
	78, '8888',
	MANAGER) AS "바뀐 직속상사 사번" FROM EMPLOYEE;
	
SELECT eno, ename, manager, CASE WHEN manager IS NULL THEN '0000'
			WHEN substr(manager, 1, 2) = 75 THEN '5555'
			WHEN substr(manager, 1, 2) = 76 THEN '6666'
			WHEN substr(manager, 1, 2) = 77 THEN '7777'
			WHEN substr(manager, 1, 2) = 78 THEN '8888'
			ELSE to_char(MANAGER)
		END AS 직속상관처리
FROM EMPLOYEE;

SELECT eno, ename, manager, CASE WHEN manager IS NULL THEN '0000'
			WHEN trunc(manager / 100) = 75 THEN '5555'
			WHEN trunc(manager / 100) = 76 THEN '6666'
			WHEN trunc(manager / 100) = 77 THEN '7777'
			WHEN trunc(manager / 100) = 78 THEN '8888'
			ELSE to_char(MANAGER)
		END AS 직속상관처리
FROM EMPLOYEE;
