-- << Stored Procedure, Function, Trigger >> --

/*
    저장 프로시져의 장점
        1. PL/SQL을 사용 가능. 자동화
        2. 성능이 우수하여 빠른 실행
         - 일반적인 SQL 구문 : 구문분석 -> 개체이름확인 -> 사용권한확인 -> 최적화(ex. index를 사용하여 검색할지 테이블스캔할지) -> 컴파일 -> 실행
         - 저장프로시저 처음 실행 : 구문분석 -> 개체이름확인 -> 사용권한확인 -> 최적화 -> 컴파일 -> 실행
         - 저장프로시저 두번째부터 실행 : 컴파일(메모리에 로드) -> 실행
        3. 입력 매개변수 , 출력 매개변수를 사용할 수 있음
        4. 일련의 작업을 그룹화하여 저장 (모듈화된 프로그래밍이 가능)
 */
 
 -- 1. 저장프로시져 생성
    -- 스콧 사원의 월급을 출력하는 저장 프로시져
create procedure sp_salary
is
    v_salary employee.salary%type;   -- 저장 프로시져는 is 블록에서 변수를 선언
begin
    select salary into v_salary
    from employee
    where ename = 'SCOTT';
    
    dbms_output.put_line('SCOTT의 급여는 : ' || v_salary || '입니다');
end;
/

-- 저장프로시져 정보를 확인하는 데이터 사전
select * from user_source
where name = 'SP_SALARY';

-- 저장 프로시져 실행
execute sp_salary;  -- 전체 이름
exec sp_salary;     -- 약식 (exectue -> exec)

-- 저장 프로시져 수정
create or replace procedure sp_salary   -- 저장 프로시져가 존재하지 않으면 생성, 존재하면 수정
is
    v_salary employee.salary%type;   -- 저장 프로시져는 is 블록에서 변수를 선언
    v_commission employee.commission%type;
begin
    select salary, commission into v_salary, v_commission
    from employee
    where ename = 'SCOTT';
    
    dbms_output.put_line('SCOTT의 급여는 : ' || v_salary || '입니다.');
    dbms_output.put_line('SCOTT의 보너스는 : ' || nvl(v_commission, 0) || '입니다.');
end;
/

exec sp_salary;

-- 저장 프로시져 삭제
drop procedure sp_salary;

--------------------------------------------------

-- 인풋 매개변수를 처리하는 저장 프로시져
create or replace procedure sp_salary_ename(    -- () 안에 인풋(입력) 매개변수와 아웃풋(출력) 매개변수를 정의
    v_ename in employee.ename%type     -- 구문 : 변수명 in 자료형, 매개변수가 여러개일 경우 , 로 구분 => 주의 : ; 사용하면 오류 발생
)
is      -- 변수 선언 (저장 프로시져에서 사용할 변수선언)
    v_salary employee.salary%type;
begin
    select salary into v_salary
    from employee
    where ename = v_ename;  -- 인풋 매개변수로 받은 값 (v_ename)
    
    DBMS_OUTPUT.put_line(v_ename || '의 급여는 ' || v_salary || ' 입니다.');
end;
/

exec sp_salary_ename('SCOTT');
exec sp_salary_ename('SMITH');
exec sp_salary_ename('KING');

-- 부서번호를 인풋 받아서 이름, 직책, 부서번호를 출력하는 저장 프로시져를 생성하세요.(커서 사용)
create or replace procedure sp_ename_dno (
    v_dno in employee.dno%type
)
is
    v_ename employee.ename%type;
    v_job employee.job%type;
    
    cursor c1
    is
    select ename, job into v_ename, v_job
    from employee
    where dno = v_dno;
begin
    DBMS_OUTPUT.PUT_LINE('이름   직책   부서번호');
    open c1;
    loop
        fetch c1 into v_ename, v_job;
        exit when c1%notfound;
        DBMS_OUTPUT.PUT_LINE(v_ename || '   ' || v_job || '   ' || v_dno);
    end loop;
    close c1;
end;
/

exec sp_ename_dno(20);

-- 테이블 이름을 인풋 받아서 employee 테이블을 복사하여 생성하는 저장 프로시져를 생성하세요 (인풋값 : emp_copy33)
create or replace procedure sp_copy_table (
    v_name in varchar2
)
is
    cursor1 INTEGER;
    v_sql varchar2(100);  -- sql 쿼리를 저장하는 변수
begin
    v_sql := 'CREATE TABLE ' || v_name || ' as select * from employee';  -- 테이블 생성쿼리를 변수에 할당
    cursor1 := dbms_sql.open_cursor;    -- 커서 사용
    dbms_sql.parse(cursor1, v_sql, dbms_sql.v7);    -- 커서를 사용해서 sql 쿼리 실행
    dbms_sql.close_cursor(cursor1);        -- 커서 중지
end;
/

drop table emp_copy33;

exec sp_copy_table('emp_copy33');

--------------------------------------------------

-- 출력 매개변수를 처리하는 저장프로시저
    -- out 키워드를 사용
    -- 저장프로시저를 호출 시, 먼저 출력 매개변수 변수선언 후 호출이 가능함
    -- 호출시 출력매개변수 이름앞에 ' :변수명(출력매개변수명) '
    -- 출력 매개변수를 출력하기 위해서 PRINT 명령문이나 PL/SQL을 사용해서 출력 가능
    
create or replace procedure sp_salary_ename2 (
    v_ename in employee.ename%type,      -- 입력매개변수
    v_salary out employee.salary%type    -- 출력매개변수 (자바에서 return과 같음)
)
is
begin
    select salary into v_salary
    from employee
    where ename = v_ename;
end;
/

select * from user_source     -- 데이터 사전에서 저장프로시저 생성 확인
where name ='SP_SALARY_ENAME2';

variable var_salary
exec sp_salary_ename2 ('SCOTT', :var_salary);

print var_salary;

create or replace procedure sp_salary_ename2 (  -- 입력/출력 매개변수 선언부
    v_ename in employee.ename%type,     -- 입력 매개변수
    v_salary out employee.salary%type   -- 출력 매개변수
    )
is
begin
    select salary into v_salary
    from employee
    where ename = v_ename;
end;
/

select * from user_source where name = 'SP_SALARY_ENAME2';

-- 주석 처리 주의 : 선언시 주석이 있으면 오류 발생
-- 호출부에서 아웃풋 매개변수를 선언
-- :var_salary => 주의
variable var_salary number(10)   
exec sp_salary_ename2('KING', :var_salary);    

print var_salary;   -- 출력

-- OUTPUT 파라미터를 여러개인 저장프로시져 생성 및 출력
    -- 출력방법 : print or PL/SQL 둘 다 가능
-- 사원번호를 인풋받아서 사원이름, 급여, 직책을 출력 OUT 프라미터에 넘겨주는 프로시져를 PL/SQL 방식으로 출력
create or replace procedure sp_empno (      -- IN, OUT : 자료형은 참조자료형(%type)을 사용 가능, 기본 자료형을 사용할 때는 바이트 수를 생략
    v_eno in number,
    v_ename out varchar2,
    v_sal out number,
    v_job out varchar2
    )
is
begin
    select ename, salary, job into v_ename, v_sal, v_job
    from employee
    where eno = v_eno;
end;
/

declare
    var_ename varchar2(50);
    var_sal number;
    var_job varchar2(50);
begin
    -- 익명 블록에서는 저장 프로시져 호출시 exec/execute를 붙이지 않음
    sp_empno (7788, var_ename, var_sal, var_job);      -- 저장 프로시져 호출
    DBMS_OUTPUT.put_line('조회결과 : ' || var_ename || '   ' || var_sal || '   ' || var_job);
end;
/


/*
    function (함수) : 값을 넣어서 하나의 값을 반환받아옴 => SQL 구문 내에서 사용 가능
        - 비교, 저장프로시져는 output 매개변수를 여러개 반환받아올 수 있음 => 단, SQL 구문 내에서는 사용 불가능
 */
 
-- 함수 생성
create or replace function fn_salary_ename(    -- 인풋 매개변수
        v_ename in employee.ename%type
    )
return number       -- 호출하는 곳으로 값을 전달. 리턴할 자료형
is
    v_salary number(7, 2);
begin
    select salary into v_salary
    from employee
    where ename = v_ename;  -- 인풋 매개변수
    return v_salary;
end;
/

-- 함수의 데이터사전
select * from user_source
where name = 'FN_SALARY_ENAME';

-- 함수 사용 방법 #1
variable var_salary number
exec :var_salary := fn_salary_ename('SCOTT');

print var_salary;   -- 호출

-- 함수 사용 방법 #2 (SQL 구문 내에서 함수 사용)
select ename, fn_salary_ename('SCOTT')  -- employee 테이블과 관계없는 별도의 가상 컬럼(함수를 통해서 SCOTT의 급여 데이터를 가져옴)
from employee
where ename = 'SCOTT';