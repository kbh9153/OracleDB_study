-- 숫자 함수

/*
    ROUND : 특정 자리수에서 반올림
    TRUNC : 특정 자리수에서 잘라냄
    MOD : 입력 받은 수를 나눈 나머지 값만 출력
*/


-- ROUND(처리할 값) : 소수점 첫째짜리에서 반올림
-- ROUND(처리할 값, 반올림할 소수점 자리 수) : 
    -- => 소수점 자리수(양수) : 소수점 오른쪽으로 자리수만큼 이동해서 자리수 뒤에서 반올림
    -- => 소수점 자리수(음수) : 소수점 왼쪽으로 자리수만큼 이동하고 그 자리수에서 반올림
select 98.7654, round(98.7654), round(98.7654, 2), round(9878.7654, -1), round(12345.6789, -3) from dual;

-- TRUNC : 소수점 첫재짜리에서 자름
-- TRUNC(처리할 값, 잘라낼 소수점 자리 수) :  
select 98.7654, trunc(98.7654), trunc(98.7654, 2), trunc(98.7654, -1) from dual;

-- MOD(대상, 나누는 수) : 대상을 나눈 후 나머지값만 출력
select mod(31, 2), mod(31, 5), mod(31, 8) from dual;

select * from employee;

select salary, mod(salary, 30) from employee;

-- employees 테이블에서 사원번호가 짝수인 사원만 출력
select eno from employee where mod(eno, 2) = 0;


-- 날짜 함수

/*
    sysdate : 시스템에 저장된 현재 날짜를 출력
    months_between : 두 날짜 사이의 몇 개월인지를 반환
    add_months : 특정 날짜에 개월수를 더함
    next_day : 특정 날짜에서 최초로 도래하는 인자를 받은 요일의 날짜를 반환
    last_day : 달의 마지막 날짜를 반환
    round : 인자로 받은 날짜를 특정 기준으로 반올림
    trunc : 인자로 받은 날짜를 특정 기준으로 자름
*/

-- sysdate
select sysdate from dual;   -- 자신의 시스템에 표시되는 날짜 출력
select sysdate - 1 as 어제날짜, sysdate as 오늘날짜, sysdate + 1 내일날짜 from dual;

select * from employee order by hiredate asc;
desc employee;

select hiredate, hiredate - 1 from employee order by hiredate asc;

    -- 입사일부터 현재까지의 근무일수, 근무년수 출력
select ename, round(sysdate - hiredate) as 근무일수, round((sysdate - hiredate) / 365) 근무년수 from employee;
select ename, trunc(sysdate - hiredate) as 근무일수, trunc((sysdate - hiredate) / 365) 근무년수 from employee;

    -- 특정 날짜에서 월(month)을 기준으로 버림한 날짜 구하기
select hiredate, trunc(hiredate, 'MONTH') from employee;    -- DATE 타입의 값의 경우 'MONTH'를 사용하여 월(month), 'YEAR'를 사용하여 년도(year)를 인식
    -- 특정 날짜에서 월(month)을 기준으로 반올림한 날짜 구하기 : 15일 이상일 경우 반올림
select hiredate, round(hiredate, 'MONTH') from employee;

-- months_between(date1, date2) : date1과 date2 사이의 개월수를 출력
    -- 특정 날짜에서 각 사원들의 근무한 개월 수 구하기
select ename, sysdate, hiredate, round(months_between(sysdate, hiredate)) as "근무 개월수" from employee;
select ename, sysdate, hiredate, trunc(months_between(sysdate, hiredate)) as "근무 개월수" from employee;

-- add_months(date1, 더할 개월수)
    -- 입사한 후 6개월이 지난 시점을 출력
select hiredate, add_months(hiredate, 6) from employee;

-- next-day(date, '요일') : date의 도래하는 요일에 대한 날짜를 출력하는 함수
SELECT SYSDATE, NEXT_DAY(SYSDATE, '토요일') AS "이번 주 토요일의 날짜" FROM dual; 

-- last_day(date) : date에 들어간 달의 마지막 날짜
SELECT hiredate, LAST_DAY(hiredate) FROM EMPLOYEE; 

-- 형 변환 함수 ** 중요 **

/*
	TO_CHAR : 날짜형 또는 숫자형을 문자형으로 변환하는 함
	TO_DATE : 문자형을 날짜형으로 변환하는 함수
	TO_NUMBER : 문자형을 숫자형으로 변환하는 함수
*/

-- 날짜 함수 사용하기
-- TO_CHAR(date, 'YYYYMMDD')
SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYYMMDD'),
TO_CHAR(hiredate, 'YYMM'),
TO_CHAR(hiredate, 'YYYYMMDD DAY'),
TO_CHAR(hiredate, 'YYYYMMDD DY')
FROM EMPLOYEE;

-- 현재 시스템의 오늘 날짜를 출력하고 시간 초까지 출력
SELECT SYSDATE, TO_CHAR(sysdate, 'YYYYMMDD HH:MI:SS DY') FROM dual;

SELECT hiredate, TO_CHAR(hiredate, 'YYYY-MM-DD HH:MI:SS DAY')  FROM EMPLOYEE;


-- to_char에서 숫자와 관련된 형식

/*
	0 : 자리수를 나타내며 자리수가 맞지 않을 경우 0으로 채움
	9 : 자리수를 나타내며 자리수가 맞지 않을 경우 채우지 않음
	L : 각 지역별 통화 기호를 출력
	. : 소수점으로 표현
	, : 천단위의 구분자
*/

SELECT ename, salary, TO_CHAR(salary, 'L999,999'),
TO_CHAR(salary, 'L000,000')
FROM EMPLOYEE;	-- TO_CHAR() : number 타입의 salary 컬럼을 char 타입으로 변환


-- to_date('char', 'format') : 날짜 형식으로 변환

	-- 2000년 1월 1일에서 오늘까지의 일수
-- SELECT sysdate, sysdate - '20000101' FROM dual;	-- 오류 발생 : date - char 타입이 다른 컬럼을 연산하여 오류 발생
SELECT sysdate, trunc(sysdate - TO_DATE(20000101, 'YYYYMMDD')) FROM dual;

SELECT SYSDATE AS 오늘날짜, TO_DATE('02/10/10', 'YY/MM/DD') AS 대상날짜, TRUNC(SYSDATE - TO_DATE('021010', 'YYMMDD')) AS 날짜의차 FROM dual;

SELECT ename, hiredate FROM EMPLOYEE WHERE HIREDATE = '81/02/22';		-- 문자열 타입은 가능
SELECT ename, hiredate FROM EMPLOYEE WHERE HIREDATE = '1981-02-22';		-- 문자열 타입은 가능
-- SELECT ename, hiredate FROM EMPLOYEE WHERE HIREDATE = 1981-02-22;
-- SELECT ename, hiredate FROM EMPLOYEE WHERE HIREDATE = 810222;	-- HIREDATE 컬럼이 DATE 타입이기 떄문에 NUMBER 타입으로 비교시 오류 발
SELECT ename, hiredate FROM EMPLOYEE WHERE HIREDATE = TO_DATE(19810222, 'YYYYMMDD');
SELECT ename, hiredate FROM EMPLOYEE WHERE HIREDATE = TO_DATE('1981-02-22', 'YYYY-MM-DD');		-- 날짜에 -이 들어갔기 때문에 문자열 처리를 위해 ''를 사용해줘야함

	-- 2000년 12월 25일부터 오늘까지 총 몇 달이 지났는지 출력
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(20001225, 'YYYYMMDD'))) AS 달의차 FROM dual;

-- to_number : 문자형을 숫자형으로 변환하는 함수
SELECT 100000 - 50000 FROM dual;
SELECT TO_CHAR(100000 - 50000, '999,999') FROM dual;
-- SELECT '100000' - '50000' FROM dual;		-- 문자열은 연산이 불가
SELECT TO_NUMBER('100,000', '999,999') - TO_NUMBER('50,000', '999,999') FROM dual;	-- '999,999'은 단순히 처리할 값의 형식을 표시해주는 것. to_char처럼 형식을 변환하여 주지는 않음


-- NVL 함수 : null을 다른 값으로 치환해주는 함수
	-- nvl(expr1, expr2) : expr1 컬럼의 값 중 null을 expr2로 치환
SELECT commission FROM EMPLOYEE;
SELECT NVL(COMMISSION, 0) FROM EMPLOYEE;	-- commission 컬럼 중 NULL 값들은 0으로 치환하여 출력

SELECT manager FROM EMPLOYEE;
SELECT manager, NVL(manager, 1111) FROM EMPLOYEE;

-- NVL2 함수
	-- nvl2(expr1, expr2, expr3) : expr1 컬럼의 값이 null이 아니면 expr2를 출력, expr1 컬럼의 값이 null이면 expr3를 출력
SELECT salary, commission FROM EMPLOYEE;

	-- nvl 함수로 연봉 계산하기
SELECT ENO AS 사번, ENAME AS 이름, SALARY AS 월급여, NVL(COMMISSION, 0) AS 보너스, salary * 12 + NVL(commission, 0) AS 연봉 FROM EMPLOYEE;
	-- nvl2 함수로 연봉 계산하기
SELECT ENO AS 사번, ENAME AS 이름, SALARY AS 월급여, NVL(COMMISSION, 0) AS 보너스, NVL2(commission, (SALARY * 12) + COMMISSION, SALARY * 12) AS 연봉 FROM EMPLOYEE;

SELECT ENO AS 사번, ENAME AS 이름, TO_CHAR(SALARY, 'L999,999') AS 월급여, TO_CHAR(NVL(COMMISSION, 0), 'L999,999') AS 보너스,
TO_CHAR(NVL2(commission, (SALARY * 12) + COMMISSION, SALARY * 12), 'L999,999') AS 연봉 FROM EMPLOYEE;

-- nullif : 두 표현식을 비교해서 동일한 경우 null을 반환하고 동일하지 않는 경우 첫번째 표현식을 반환
	-- nullif (expr1, expr2) : 
SELECT NULLIF ('A', 'A'), NULLIF ('A', 'B') FROM dual;

-- coalesce 함수
	-- coalesce(expr1, expr2, expr3 ... expr-n) : expr1이 null이 아니면 expr1을 반환하고, expr1이 null이고 expr2가 null이 아니면 expr2를 반환하는 규칙으로 ... 계속 진행
		-- => 처리할 값들 중 null이 아닌 값이 나올 때까지 찾은 후 null이 아닌 값을 출력하고 종료
SELECT COALESCE ('abc', 'bcd', 'def', 'efg', 'fgi') FROM dual;	-- abc 출력
SELECT COALESCE (NULL , 'bcd', 'def', 'efg', 'fgi') FROM dual;	-- bcd 출력
SELECT COALESCE (NULL , NULL , 'def', 'efg', 'fgi') FROM dual;	-- def 출력
SELECT COALESCE (NULL , 'bcd', NULL , 'efg', 'fgi') FROM dual;	-- bcd 출력

SELECT ename, salary, commission, COALESCE (commission, salary, 0) FROM EMPLOYEE;


-- decode 함수 : java의 switch case 문과 동일한 구문

/*
 	DECODE (표현식, 조건1, 결과1,
 		조건2, 결과2,
 		조건3, 결과3,
 		기본결과n
 		);
 */

SELECT ename, dno, DECODE(dno, 10, 'ACCOUNTING',
	20, 'RESEARCH',
	30, 'SALES',
	40, 'OPERATIONS',
	'DEFAULT') AS DNAME FROM EMPLOYEE;

	-- dno 컬럼이 10번 부서일 경우 월급에서 + 300을 처리하고, 20번 부서일 경우 월급에서 + 500을 처리하고, 30번 부서일 경울 월급에서 + 700을 처리 => 이름, 월급, 부서별 + 처리된 월급을 출력
SELECT dno AS 부서번호, eno AS 사번, ename AS 이름,
	TO_CHAR(salary, 'L999,999') AS 월급여,
	TO_CHAR(DECODE(dno, 10, 300,
	20, 500,
	30, 700), 'L999,999') AS 보너스,
	TO_CHAR(DECODE(dno, 10, salary + 300,
	20, salary + 500,
	30, salary + 700), 'L999,999') AS 총급여
FROM EMPLOYEE ORDER BY dno ASC, SALARY ASC;


-- case : java의 if ~ else if, else if ~ 와 동일한 구문

/*
 	case 표현식 WHEN 조건1 THEN 결과1
 		WHEN 조건2 THEN 결과2
 		WHEN 조건3 THEN 결과3
 		ELSE 결과n
 	END
 */

SELECT ename, dno, CASE WHEN dno = 10 THEN 'ACCOUNTING'
		WHEN dno = 20 THEN 'RESEARCH'
		WHEN dno = 30 THEN 'SALES'
		WHEN dno = 40 THEN 'OPERATION'
		ELSE 'DEFAULT'
	END AS 부서명
FROM EMPLOYEE; 

