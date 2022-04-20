-- 다양한 함수 사용하기

/*
    1. 문자를 처리하는 함수
        - UPPER : 대문자로 변환
        - LOWER : 소문자로 변환
        - INITCAP : 첫자는 대문자로 나머지는 소문자로 변환
        
        dual 테이블 : 하나의 결과를 출력하도록 하는 테이블 (가상 테이블)
*/

select '안녕하세요' as 인사 from dual;

select 'Oracle mania', upper('Oracle mania'), lower('Oracle mania'), initcap('Oracle mania')
from dual;

select * from employees;
select first_name, upper(first_name), initcap(first_name), lower(first_name) from employees;

select * from employees where first_name = 'amit';  -- first_name의 값이 Amit. A가 대문자이기 때문에 검색이 안됨
select * from employees where first_name = 'Amit';  -- 값이 대소문자의 경우 검색할 때도 대소문자를 일치시켜줘야 검색이 가능 => 불편
select * from employees where lower(first_name) = 'amit';   -- lower() 함수를 사용하여 소문자로 검색되도록 처리

-- 문자 길이를 출력하는 함수
    -- 1. length : 문자의 길이를 반환, 영문이나 한글 관계없이 글자 수를 리턴
    -- 2. lengthb : 문자의 길이를 반환, 영문은 1byte 반환, 한글 3byte로 반환
    
select length('Oracle mania'), length('오라클 매니아') from dual;
select lengthb('Oracle mania'), lengthb('오라클 매니아') from dual;

select * from employees;
select length(first_name), job_id, length(job_id) from employees;

-- 문자 조작 함수
    -- concat : 문자와 문자를 연결해서 출력
    -- substr : 문자를 특정 위치에서 잘라오는 함수 (영문, 한글, 모두 1byte로 처리)
    -- substrb : 영문은 1byte, 한글은 3byte (영문은 1byte, 하늘은 3byte로 처리)
    -- instrb : 문자의 특정 위치의 인덱스 값을 반환
    -- lpad, rpad : 입력 받은 문자열에서 특수문자를 적용 => lpad(왼쪽), rpad(오른쪽)
        -- => ex. lpad(대상, 문자열 크기 지정(byte. = 방 크기와 같은 의미, '공백처리용 특수문자')
    -- trim : 공백제거, 특정 문자도 제거

-- concat : 문자와 문자를 연결    
select 'Oracle', 'mania', concat('Oracle', 'mania') from dual;

select concat(first_name, last_name) from employees;    -- first_name, last_name 컬럼이 병합되어 출력
select concat(first_name, ' ' || last_name) from employees;    -- ' ' || : 공백 삽입하여 출력

    -- || : pipe. 앞뒤 연결 기능
select '이름은 : ' || concat(first_name, ' ' || last_name) || ' 이고, 직무는 : ' || job_id || ' 입니다.'
as 컬럼연결 from employees;

select '이름은 : ' || concat(first_name, ' ' || last_name) || ' 이고, 직속상관 사번은 : ' || manager_ID || ' 입니다.' 
as 직속상관출력 from employees;

-- substr (substr 대상, 시작위치, 추출개수) : 특정 위치에서 문자를 잘라옴
select 'Oracle mania', substr('Oracle mania', 4, 3), substr('오라클 매니아', 2, 3) from dual;

select 'Oracle mania', substr('Oracle mania', -4, 3),
substr('오라클 매니아', -6, 4) from dual;     -- 시작위치가 - 일 경우 오른쪽 끝부터 찾기 시작

select first_name, substr(first_name, 2, 3), substr(first_name, -5, 4) from employees;

select substrb('Oracle mania', 3, 3), substrb('오라클 매니아', 4, 6) from employees;  -- 한글은 3byte씩 처리하여 '라클'만 출력 

    -- 이름이 n으로 끝나는 사원들 출력하기 (substr 함수를 사용해서 사용)
select concat(first_name, ' ' || last_name) from employees where substr(last_name, -1, 1) = 'n';
select concat(first_name, ' ' || last_name) from employees where last_name like '%n';

    -- 08년도 입사한 사원들 출력하기 (substr 함수를 사용해서 사용)
select concat(first_name, ' ' || last_name), hire_date from employees where substr(hire_date, 1, 2) = 08;
select concat(first_name, ' ' || last_name), hire_date from employees where hire_date like '08%';

-- instr (대상, 찾을 글자, 시작 위치, 몇번째 발견) : 대상에서 찾을 글자의 인덱스값을 출력
select 'Oracle mania', instr('Oracle mania', 'm') from dual;    -- 시작 위치, 몇번째 발견은 생략
    -- 5번째부터 찾기 시작하여 첫번째 a는 지나치고 두번째에 발견되는 a의 위치를 출력
select 'Oracle mania', instr('Oracle mania', 'a', 5, 2) from dual;
    -- (오른쪽 끝에서부터)5번째부터 찾기 시작하여 첫번째 a는 지나치고 두번째 발견되는 a의 위치를 출력 => 두번째 a가 없어서 0 출력
select 'Oracle mania', instr('Oracle mania', 'a', -5, 2) from dual;

select distinct instr((job_id), 'R', 1, 1) from employees where lower(job_id) = 'st_clerk';

-- lpad, rpad : 특정 길이만큼 문자열을 지정해서 왼쪽, 오른쪽에 공백을 특정 문자로 처리 => lpad(왼쪽), rpad(오른쪽)
select rpad(salary, 10, '*') from employees;
select rpad(salary, 10) from employees;     -- 특수문자 설정 안하면 공백으로 출력
select lpad(1234, 10, '#') from dual;

-- TRIM : 공백제거, 특정 문자도 제거
    -- LTRIM : 왼쪽의 공백을 제거
    -- RTRIM : 오른쪽의 공백을 제거
    -- TRIM : 좌우 공백을 제거
select ltrim('   Oracle mania   ') as 왼쪽공백제거,
rtrim('   Oracle mania   ') as 오른쪽공백제거,
trim('   Oracle mania   ') as 좌우공백제거
from employees;