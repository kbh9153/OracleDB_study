-- SQL : 구조화된 질의 언어

-- DQL : Select

-- desc 테이블명; : 테이블의 구조 확인
desc departments;

select * from departments;

/*
select 구문의 전체 필드(컬럼) 내용
! 아래 구문 순위 순으로 작성 가능. ()은 구문 작성, => 구문 설명
(1순위) select (컬럼명)
(2순위) distint => 컬럼내의 중복된 값을 제거
(3순위) from (테이블명, 뷰명)
(4순위) where (조건)
(5순위) group by (특정 값을 그룹화)
(6순위) having => 그룹화한 값을 정렬
(7순위) order by => 값을 정렬해서 출력
*/

desc employees;

-- ; 이 작성되기 전까지는 개행되어도 하나의 구문으로 인식
select *
from
employees;

-- 특정 컬럼만 출력하기
select employee_id, last_name from employees;

-- 특정 컬럼을 여러번 출력
select employee_id, last_name, employee_id, last_name from employees;
select employee_id, first_name, last_name from employees;

-- 컬럼에 연산을 적용할 수 있음 => ex. salary * 12
select employee_id, first_name, last_name, salary, salary * 12 from employees;

-- 컬럼명 알리어스(Alias) : 컬럼의 이름을 변경 => as (바꿔 출력할 컬럼명)
    -- 컬럼에 연산을 하거나 함수를 사용하면 컬럼명이 없어짐
select employee_id, first_name, last_name, salary, salary * 12 as 연봉 from employees;
select employee_id as 사원번호, last_name as 사원명, salary as 월급, salary * 12 as 연봉 from employees;
    -- as 생략가능
select employee_id 사원번호, last_name 사원명, salary 월급, salary * 12 연봉 from employees;
    -- Alias 사용시 공백이나 특수문자가 들어갈 때는 오류 발생 => 공백이나 특수문자 사용시 " "으로 처리가 필요
-- select employee_id 사원 번호, last_name 사원 명, salary 월 급, salary * 12 연 봉 from employees; => 오류 발생
select employee_id "사원 번호", last_name 사원명, salary 월급, salary * 12 "#연봉" from employees;

-- nvl 함수 : 연산시에 null을 처리하는 함수
select * from employees;
    -- nvl 함수를 사용하지 않고 전체 연봉을 계산 => null이 포함된 컬럼에 연산을 적용하면 null이 출력
        -- null을 0으로 처리하여 연산하여야함 => nvl 함수 사용
select employee_id 사원번호, last_name 사원명, salary 월급, commission_pct 보너스,
salary * 12 연봉,
salary * 12 + ((salary * 12) * commission_pct) from employees;    -- 전체 연봉
    -- nvl 함수를 사용하여 전체 연봉을 계산 => nvl(commission_pct, 0) : null을 0으로 처리
select employee_id 사원번호, last_name 사원명, salary 월급, commission_pct 보너스,
salary * 12 연봉,
salary * 12 + ((salary * 12) * nvl(commission_pct, 0)) from employees;    -- 전체 연봉

-- 특정 컬럼의 내용을 중복값 제거후 출력 => distinct (select 바로 뒤에 위치하여야함)
select * from employees;
select department_ID from employees;
select distinct department_ID from employees;
-- select last_name, distinct department_ID from employees; => last_name 로우에는 중복값이 없는데 department_ID에 있는 중복값을 제거하여 출력을 시도하여 오류 발생

-- 조건을 사용해서 검색 (Where) => 필터 기능과 유사
select * from employees;
select employee_id 사원번호, last_name 사원명, job_ID 직무, manager_id 직속상관, hire_date 입사날짜,
salary 월급, commission_pct 보너스, department_ID 부서번호 from employees;
    -- 사원번호가 183인 사원의 이름을 검색
select * from employees where employee_id = 183;
select last_name from employees where employee_id = 183;

    -- 사원번호가 183인 사원의 부서번호, 입사날짜를 검색
select department_ID 사원명, salary 월급 , hire_date 입사날짜 from employees where employee_id = 183;

desc employees;

-- 레코드(= 로우) 가져올 때
    -- number 일 때는 ''를 붙이지 않음
    -- 문자 데이터(char, varchar2), 날짜(date)를 가져올 때는 ''를 사용
    -- 대소문자 구분
    
-- 입사날짜가 '07/03/17'인 사원 출력
select employee_id, last_name from employees where hire_date = '07/03/17';

-- 부서 코드가 100인 모든 사원들을 출력
select employee_id, last_name from employees where department_ID = 100;

select * from employees;

-- 월급이 10000 이상인 사원들을 모두 출력
select employee_id, last_name, department_ID, hire_date, salary * 12 from employees where salary >= 10000;

-- null 검색 : is 키워드 사용 => null을 검색할 때는 = null과 같이 = 사용하면 안됨. is null을 사용
select * from employees where commission_pct is null;

-- commission 비율이 0.3 이상인 사원의 이름, 직책, 월급 출력
select employee_id, job_id, salary from employees where commission_pct >= 0.3;

-- commission이 없는 사원의 이름, 직책, 월급 출력
select employee_id, job_id, salary from employees where commission_pct is null;

-- 비교연산자 and, or, not

-- 월급이 10000 이상 20000 미만인 사원들의 사원번호, 사원이름, 입사날짜 출력
select employee_id, first_name, last_name, hire_date, salary from employees where 10000 <= salary and salary <= 20000;

-- 1. 직책이 SA_MAN 이거나 부서번호가 50인 사원의 이름과, 직책, 월급, 부서번호를 출력
select * from employees;
select employee_id, job_id, salary, department_id from employees where job_id = 'sa_man' or department_id = 50;

-- 2. commission이 없는 사원 중에 부서코드가 50인 사원의 이름, 부서코드와 입사날짜를 출력
select employee_id, department_id, hire_date from employees where commission_pct is null and department_id = 50;

-- 3. commission이 null이 아닌 사원의 이름, 입사날짜, 월급
select employee_id, hire_date, salary from employees where commission_pct is not null;

-- 날짜 검색
    -- 03/01/01 ~ 08/12/31 입사한 사원의 이름, 직무, 입사날짜
select first_name, last_name, job_id, hire_date from employees where '03/01/01' <= hire_date and hire_date <= '08/12/31';
    -- (컬럼명) between A and B : A 이상 B 이하 => 위와 동일한 결과 출력
select first_name, last_name, job_id, hire_date from employees where hire_date between '03/01/01' and '08/12/31';

-- IN 연산자
    -- commission_pct이 0.25, 0.3, 0.35인 사원의 이름, 직책, 입사일을 출력
select first_name, last_name, hire_date from employees where commission_pct in(0.25, 0.3, 0.35);

-- whild card
-- like : 컬럼 내의 특정한 문자열을 검색 => 글 검색 기능을 사용할 때 사용
    -- % : 뒤에 어떤 글자가 와도 상관없음
    -- _ : 한글자가 어떤 값이 와도 상관없음
    
select * from employees where first_name like 'L%';
select last_name from employees where last_name like '%an';
    -- 이름이 D로 시작되고 an으로 마무리 되는 사원 추력 => _ 사용
    select * from employees;
select first_name from employees where first_name like 'N_%na';
    -- 마지막 글자가 x로 끝나는 사원 이름 출력
select first_name from employees where first_name like '%x';
    -- IT 단어가 들어간 직무를 출력
select job_id from employees where job_id like '%IT%';
    -- 08년도에 입사한 사원을 출력
select * from employees where hire_date >= '08/01/01' and  hire_date <= '08/12/31';    
select * from employees where hire_date between '08/01/01' and '08/12/31';
select * from employees where hire_date like '08%';
    -- 08년도 2월에 입사한 사원을 출력
select * from employees where hire_date like '08/02%';

-- 정렬 : order by. asc(오름차순 : 작은 값 -> 큰 값), desc(내림차순 : 큰값 -> 작은 값)
select * from employees order by employee_id desc;
select * from employees order by employee_id asc;
    -- 이름 컬럼을 정렬
select * from employees order by first_name desc;
select * from employees order by first_name asc;
    -- 날짜 정렬
select * from employees order by hire_date desc;
select * from employees order by hire_date asc;

-- 질문 답변형에서 게시판에서 주로 사용. 두 개 이상의 컬럼을 정렬할 때 => 제일 처음 컬럼이 정렬되고, 동일한 값에 대해서 두번째 컬럼을 정렬
select * from employees order by department_id desc;
select department_id, last_name from employees order by department_id, last_name;
select department_id, last_name from employees order by department_id desc, last_name asc;

-- where과 order by 절이 같이 사용될 때
select * from employees where commission_pct is null order by first_name asc;
select * from employees where commission_pct is null order by first_name desc;

-- 급여가 가장 낮은 사원 3명의 이름과 월급 출력
	-- rownum : 행 번호 할당
	-- 쿼리 구문의 순서가 SELECT -> FROM -> WHERE -> ORDER BY 순으로 실행되어 정렬이 가장 늦기 때문에 제대로 급여가 낮은 순으로 출력되지 않음
SELECT last_name, SALARY FROM EMPLOYEES WHERE rownum < 4 ORDER BY SALARY ASC;
	-- 정답 => from 절 안에서 구문을 작성하여 구문 실행 순서를 임의로 바꾸는 효과를 사용할 수 있음
SELECT last_name, salary FROM (SELECT last_name, salary FROM EMPLOYEES ORDER BY salary asc) WHERE rownum < 4;