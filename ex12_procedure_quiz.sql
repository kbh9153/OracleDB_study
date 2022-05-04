-- 1. 각 부서별로 최소급여, 최대급여, 평균급여를 출력하는 저장프로시져를 생성하시오. 
    -- [employee, department ] 테이블 이용
set serveroutput on;
create or replace procedure sp_salary_info
is  -- 변수 선언부, 커서 선언
    v_dno employee.dno%type;
    v_min_salary employee.salary%type;
    v_max_salary employee.salary%type;
    v_avg_salary employee.salary%type;

    cursor c1
    is
    select dno, min(salary), max(salary), round(avg(salary), 2)
    from employee
    group by dno;
begin
    DBMS_OUTPUT.PUT_LINE('부서번호   최소급여   최대급여   평균급여');
    open c1;    -- 커서 시작
    loop
        fetch c1 into v_dno, v_min_salary, v_max_salary, v_avg_salary;
        exit when c1%notfound;
        dbms_output.put_line(v_dno || '   ' || v_min_salary || '   ' || v_max_salary || '   ' || v_avg_salary);
    end loop;
    close c1;
end;
/

exec sp_salary_info;

-- 2.  사원번호, 사원이름, 부서명, 부서위치를 출력하는 저장프로시져를 생성하시오.  
    -- [employee, department ] 테이블 이용
create or replace procedure sp_info
is
    v_emp employee%rowtype;
    v_dept department%rowtype;
    
    cursor c2
    is
    select e.eno, e.ename, d.dname, d.loc
    from employee e, department d
    where e.dno = d.dno;
begin
    dbms_output.put_line('사원번호   사원이름   부서명   부서위치');
    open c2;
    loop
        fetch c2 into v_emp.eno, v_emp.ename, v_dept.dname, v_dept.loc;
        exit when c2%notfound;
        dbms_output.put_line(v_emp.eno || '   ' || v_emp.ename || '   ' || v_dept.dname || '   ' || v_dept.loc);
    end loop;
    close c2;
end;
/

exec sp_info;

-- 3. 급여를 입력 받아  입력받은 급여보다 높은 사원의 사원이름, 급여, 직책을 출력 하세요.
    -- 저장프로시져명 : sp_salary_b
create or replace procedure sp_salary_b (
    v_salary in employee.salary%type
)
is
    v_emp employee%rowtype;
    
    cursor c3
    is
    select ename, salary, job
    from employee
    where salary > v_salary;
begin
    dbms_output.put_line('사원이름   급여   직책');
    for v_emp in c3 loop
        dbms_output.put_line(v_emp.ename || '   ' || v_emp.salary || '   ' || v_emp.job);
    end loop;
end;
/

exec sp_salary_b(1000);

-- 4. 인풋 매개변수 : emp_c10, dept_c10  두개를 입력 받아 각각 employee, department 테이블을 복사하는 저장프로시져를 생성하세요. 
    -- 저장프로시져명 : sp_copy_table
    
    -- PL/SQL 내부에서 익명 블록에서 테이블을 생성 : grant create table to public; < sys 계정으로 접속 >
    -- 저장 프로시져 실행 후 revoke create table from public;
create or replace procedure sp_copy_table (
    v_emp_copy in varchar2, v_dept_copy in varchar2     -- 매개변수 입력시 주의 : ';' 끝에 세미콜론을 입력하면 안됨, 자료형의 크기를 지정하면 안됨
)
is
    cursor1 INTEGER;    -- 커서 변수 선언
    v_sql1 varchar2(100);   -- 테이블 생성 쿼리를 담을 변수
    v_sql2 varchar2(100);
begin
    v_sql1 := 'CREATE TABLE ' || v_emp_copy || ' as select * from employee';
    v_sql2 := 'CREATE TABLE ' || v_dept_copy || ' as select * from department';
    cursor1 := dbms_sql.open_cursor;
    
    dbms_sql.parse(cursor1, v_sql1, dbms_sql.v7);
    dbms_sql.parse(cursor1, v_sql2, dbms_sql.v7);
    
    dbms_sql.close_cursor(cursor1);
end;
/

exec sp_copy_table('emp_c10', 'dept_c10');

-- 5. dept_c10 테이블에서 dno, dname, loc 컬럼의 값을 인풋 받아 인풋 받은 값을 insert하는 저장프로시져를 생성하시요. 
    -- 입력 값 : 50  'HR'  'SEOUL'
    -- 입력 값 : 60  'HR2'  'PUSAN' 
create or replace procedure sp_dept_c10_insert (
    v_dno in number, v_dname in varchar2, v_loc in varchar2
)
is
begin
    insert into dept_c10 values(v_dno, v_dname, v_loc);
end;
/

exec sp_dept_c10_insert(2, 'HR', 'SEOUL');

-- 6. emp_c10 테이블에서 모든 컬럼의 값을 인풋 받아 인풋 받은 값을 insert하는 저장프로시져를 생성하시요. 
    -- 입력 값 : 8000  'SONG'    'PROGRAMMER'  7788  sysdate  4500  1000  50
create or replace procedure sp_emp_c10_insert (
    v_eno in emp_c10.eno%type,
    v_ename in emp_c10.ename%type,
    v_job in emp_c10.job%type,
    v_mamager in emp_c10.manager%type,
    v_hiredate in emp_c10.hiredate%type,
    v_salary in emp_c10.salary%type,
    v_commission in emp_c10.commission%type,
    v_dno in emp_c10.dno%type
)
is
begin
    insert into emp_c10 values(v_eno, v_ename, v_job, v_mamager, v_hiredate, v_salary, v_commission, v_dno);
end;
/

exec sp_emp_c10_insert(2938, 'HYEON', 'MANAGER', null, sysdate, 5000, 200, 20);

-- 7. dept_c10 테이블에서 4번문항의 부서번호 50의 HR 을 'PROGRAM' 으로 수정하는 저장프로시져를 생성하세요. 
    -- <부서번호와 부서명을 인풋받아 수정하도록 하시오.> 
    -- 입력값 : 50  PROGRAMMER 
create or replace procedure sp_dept_c10_update (
    v_dname in varchar2,
    v_dno in number
)
is
begin
    update dept_c10
    set dname = v_dname
    where dno = 50;
end;
/

exec sp_dept_c10_update('PROGRAM', 50);

-- 8. emp_c10 테이블에서 사원번호를 인풋 받아 월급을 수정하는 저장 프로시져를 생성하시오. 
	-- 입력 값 : 8000  6000
create or replace procedure sp_emp_c10_update (
    v_eno in number, v_salary in number
)
is
begin
    update emp_c10
    set salary = v_salary
    where eno = v_eno;
end;
/

exec sp_emp_c10_update(8000, 6000); 

-- 9. 위의 두 테이블명을 인풋 받아 두 테이블을 삭제하는 저장프로시져를 생성 하시오.
create or replace procedure sp_table_drop (
    v_emp_drop in varchar2, v_dept_drop in varchar2
)
is
    cursor1 INTEGER;
    v_sql1 varchar2(100);
    v_sql2 varchar2(100);
begin
    v_sql1 := 'drop table ' || v_emp_drop;
    v_sql2 := 'drop table ' || v_dept_drop;
    cursor1 := dbms_sql.open_cursor;
    
    dbms_sql.parse(cursor1, v_sql1, dbms_sql.v7);
    dbms_sql.parse(cursor1, v_sql2, dbms_sql.v7);
    
    dbms_sql.close_cursor(cursor1);
end;
/

exec sp_table_drop('emp_c10', 'dept_c10');

-- 10. 이름을 인풋 받아서 사원명, 급여, 부서번호, 부서명, 부서위치을 OUT 파라미터에 넘겨주는 프로시저를 PL / SQL에서 호출
create or replace procedure sp_output (
    v_ename in varchar2,
    v_ename2 out varchar2,
    v_salary out number,
    v_dno out number,
    v_dname out varchar2,
    v_loc out varchar2
    )
is
begin
    select e.ename, e.salary, e.dno, d.dname, d.loc into v_ename2, v_salary, v_dno, v_dname, v_loc
    from employee e, department d
    where e.dno = d.dno
    and e.ename = v_ename;
end;
/

declare
    var_ename varchar2(50);
    var_salary number;
    var_dno number;
    var_dname varchar2(50);
    var_loc varchar2(50);
begin
    sp_output ('SCOTT', var_ename, var_salary, var_dno, var_dname, var_loc);
    dbms_output.put_line('결과 : ' || var_ename || '  ' || var_salary || '   ' || var_dno || '   ' || var_dname || '   ' || var_loc);
end;
/

-- 11. 사원번호를 받아서 사원명, 급여, 직책, 부서명을 OUT 파라미터에 넘겨주는 프로시저를 PL / SQL에서 호출
create or replace procedure sp_output2 (
    v_eno in number,
    v_ename out varchar2,
    v_salary out number,
    v_job out varchar2,
    v_dname out varchar2
    )
is
begin
    select e.ename, e.salary, e.job, d.dname into v_ename, v_salary, v_job, v_dname
    from employee e, department d
    where e.dno = d.dno
    and e.eno = v_eno;
end;
/

declare
    var_ename varchar2(50);
    var_salary number;
    var_job varchar2(50);
    var_dname varchar2(50);
begin
    sp_output2 (7788, var_ename, var_salary, var_job, var_dname);
    dbms_output.put_line('결과 : ' || var_ename || '   ' || var_salary || '   ' || var_job || '   ' || var_dname);
end;
/