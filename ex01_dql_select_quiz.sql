--<< Select Quiz >>--

-- 1. 덧셈 연산자를 사용하여 모든 사원에 대해서 $300의 급여 인상을 계산한후 사원이름, 급여, 인상된 급여를 출력하세요. 
select first_name 성, last_name 이름, salary 급여, salary + 300 as 인상후급여 from employees;

-- 2. 사원의 이름, 급여, 연간 총 수입이 많은것 부터 작은순으로 출력 하시오. 연간 총 수입은 월급에 12를 곱한후 $100의 상여금을 더해서 계산 하시오. 
select first_name 성, last_name 이름, salary * 12 + nvl(commission_pct, 0) + 100 연간총수입 from employees order by salary asc;

-- 3. 급여가 2000을 넘는 사원의 이름과 급여를 급여가 많은것 부터 작은순으로 출력하세요. 
select first_name 성, last_name 이름, department_id 부서번호, salary 급여 from employees where salary > 2000 order by salary desc;

-- 4. 사원번호가 203인 사원의 이름과 부서번호를 출력하세요. 
select first_name 성, last_name 이름, department_id 부서번호 from employees where employee_id = 203;

-- 5. 급여가 2000에서 3000사이에 포함되지 않는 사원의 이름과 급여를 출력 하세요.
select first_name 성, last_name 이름, salary 급여 from employees where salary > 3000 or salary < 2000;
select first_name 성, last_name 이름, salary 급여 from employees where salary not between 2000 and 3000;

-- 6. 07년 2월 20일부터 07년 5월 1일 사이의 입사한 사원의 이름 담당업무, 입사일을 출력하시오.
select first_name 성, last_name 이름, job_id 직무, hire_date 입사일 from employees where hire_date between '07/02/20' and ' 07/05/01';

-- 7. 부서번호가 20및 30에 속한 사원의 이름과 부서번호를 출력하되 이름을 기준(내림차순)으로 출력하시오.
select first_name 성, last_name 이름, department_id 부서번호 from employees where department_id = 20 or department_id = 30 order by first_name desc;
select first_name 성, last_name 이름, department_id 부서번호 from employees where department_id in (20, 30) order by first_name desc;

-- 8. 사원의 급여가 2000에서 3000사이에 포함되고 부서번호가 20 또는 30인 사원의 이름, 급여와 부서번호를 출력하되 이름을 오름차순으로 출력하세요. 
select first_name 성, last_name 이름, salary 급여, department_id 부서번호 from employees where (salary between 2000 and 3000) and department_id in (20, 30);

-- 9. 08년도 입사한 사원의 이름과 입사일을 출력 하시오 (like 연산자와 와일드 카드 사용)
select first_name 성, last_name 이름, hire_date 입사일 from employees where hire_date like '08%';
select first_name 성, last_name 이름, hire_date 입사일 from employees where substr(hire_date, 1, 2) = 08;

-- 10. 관리자가 없는 사원의 이름과 담당업무를 출력하세요.
select first_name 성, last_name 이름, job_id 직책 from employees where manager_id is null;

-- 11. 커밋션을 받을 수 있는 자격이 되는 사원의 이름, 급여, 커미션을 출력하되 급여및 커밋션을 기준으로 내림차순 정렬하여 표시하시오. 
select first_name 성, last_name 이름, salary 급여, commission_pct 보너스 from employees where commission_pct is not null order by salary, commission_pct desc;

-- 12. 이름의 세번째 문자가 r인 사원의 이름을 표시하시오. 
select last_name from employees where last_name like '__r%';

-- 13. 이름에 T 와 a 를 모두 포함하고 있는 사원의 이름을 표시하시오.
select last_name from employees where last_name like '%T%a%';
select last_name from employees where last_name like '%T%' and last_name like '%a%';

-- 14. 담당 업무가 사무원(ST_CLERK) 또는 SA_REP 이면서 급여가 $3200, $2700, 또는 $2100 이 아닌 사원의 이름, 담당업무, 급여를 출력하시오. 
select first_name 성, last_name 이름, job_id 직무, salary 급여 from employees where (job_id in('ST_CLERK', 'SA_REP')) and (salary not in(3200, 2700, 2100));

-- 15. 커미션이 0.3 이상인 사원의 이름과 급여 및 커미션을 출력하시오.
select first_name 성, last_name 이름, salary 급여, commission_pct from employees where commission_pct >= 0.3;