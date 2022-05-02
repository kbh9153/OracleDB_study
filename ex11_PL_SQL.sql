-- << PL/SQL >> --

/* 
 * PL/SQL : 오라클에 프로그래밍 요소를 가미하는 것
 *
 * SQL (Structured Query Language)
 * 구조화된 질의언어
 * 유연한 프로그래밍 기능을 적용할 수 없음
 * 이러한 단점을 극복한게 PL/SQL (오라클), T-SQL (MS-SQL)
 */
 
set serveroutput on            -- PL/SQL의 출력을 활성화
 
/* PL/SQL의 기본 작성 구문
begin
PL/SQL 구문 작성
end;
/
*/

-- PL/SQL에서 기본 출력
set serveroutput on
begin
    dbms_output.put_line('Welcom to Oracle');      -- Java의 System.out.println 과 같음, 작은따옴표 쓰는게 다르다.
end;
/

/* PL/SQL에서 변수 선언
    변수명 := 값
    := 은 자바의 대입연산자 = 과 같음
    
    자료형 선언
        1. oracle의 자료형을 사용
        2. 참조자료형 : 테이블의 컬럼에 선언된 자료형을 참조해서 사용
            %type : 테이블의 특정컬럼의 자료형을 참조해서 사용 (테이블의 1개 컬럼 자료형식을 참조)
            %rowtype : 테이블 전체의 컬럼의 자료형을 모두 참조 (테이블 모든 컬럼을 컬럼별로 자료형식을 참조)
*/

-- 변수 선언 (declare), 값 할당 (:=) -> = 와 같음. 값의 대입
set serveroutput on
declare
    v_eno number(4);                            -- 오라클의 자료형
    v_ename employee.ename%type;                -- 참조 자료형 : 테이블의 컬럼의 자료형을 참조해서 적용
begin
    v_eno := 7788;
    v_ename := 'SCOTT';
    
    DBMS_OUTPUT.PUT_LINE('사원번호 사원이름');
    DBMS_OUTPUT.PUT_LINE('---------------');
    DBMS_OUTPUT.PUT_LINE(v_eno || '     ' || v_ename);
end;
/

SET SERVEROUTPUT ON
declare
    v_eno employee.eno%type;
    v_ename employee.ename%type;
begin
    DBMS_OUTPUT.PUT_LINE('사원번호 사원이름');
    DBMS_OUTPUT.PUT_LINE('---------------');
    
    select eno, ename into v_eno, v_ename                   -- 특정 테이블의 값을 가져와서 값을 할당
    from employee
    where ename = 'SCOTT';
    
    DBMS_OUTPUT.PUT_LINE(v_eno || '     ' || v_ename);
end;
/

-- 제어문 사용하기
set serveroutput on
declare
    v_employee employee%rowtype;                            -- employee 테이블의 모든 컬럼의 자료형을 참조해서 사용
    
    annsal number(7,2);                                     -- 총연봉을 저장하는 변수
begin
    select * into v_employee
    from employee
    where ename = 'SCOTT';
    
    if (v_employee.commission is null) then
        v_employee.commission := 0;
    end if;
    
    annsal := v_employee.salary * 12 + v_employee.commission;
    
    DBMS_OUTPUT.PUT_LINE('사원번호   사원이름   연봉');
    DBMS_OUTPUT.PUT_LINE(v_employee.eno||'   '||v_employee.ename||'   '||annsal);
end;
/

-- 실습 : dno 가 20인 department 테이블을 변수에담어서 출력
set serveroutput on
declare
    v_dno department.dno%type;
    v_dname department.dname%type;
    v_loc department.loc%type;
begin
    select dno, dname, loc into v_dno, v_dname, v_loc
    from department
    where dno = 20;
    
    DBMS_OUTPUT.PUT_LINE('부서번호'||'   '||'부서이름'||'   '||'위치');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(v_dno || '   ' || v_dname || '   ' ||v_loc);
end;
/

set serveroutput on
declare
    v_department department%rowtype;
begin
    select * into v_department
    from department
    where dno = 20;
    
    DBMS_OUTPUT.PUT_LINE('부서번호'||'   '||'부서이름'||'   '||'위치');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(v_department.dno||'   '||v_department.dname||'   '||v_department.loc);
    
end;
/

select eno, ename
from employee
where ename = 'SCOTT';


-- IF ~ ELSIF ~ END IF
set serveroutput on
declare
    v_eno employee.eno%type;
    v_ename employee.ename%type;
    v_dno employee.dno%type;
    v_dname department.dname%type := null;
begin
    select eno, ename, dno into v_eno, v_ename, v_dno
    from employee
    where ename = 'SCOTT';
    
    if (v_dno = 10) then
        v_dname := 'ACCOUNT';
    elsif (v_dno = 20) then
        v_dname := 'SEARCH';
    elsif (v_dno = 30) then
        v_dname := 'SALES';
    elsif (v_dno = 40) then
        v_dname := 'OPERATIONS';
    end if;
    
    dbms_output.put_line('사원번호   사원명   부서명');
    dbms_output.put_line('---------------------');
    dbms_output.put_line(v_eno ||  '   ' || v_ename || '   ' || v_dname);
end;
/

/*
    실습
    
    employee 테이블의 eno, ename, salary, dno를 PL/SQL을 사용해서 출력
    조건 : 보너스 1400인 사원 출력
 */
 
 -- 1. %type
set serveroutput on
declare
    v_eno employee.eno%type;
    v_ename employee.ename%type;
    v_salary employee.salary%type;
    v_dno employee.salary%type;
begin
    select eno, ename, salary, dno into v_eno, v_ename, v_salary, v_dno
    from employee
    where commission = 1400;
    
    dbms_output.put_line('사원번호   사원이름   급여   부서번호');
    dbms_output.put_line('------------------------------');
    dbms_output.put_line(v_eno || '    ' || v_ename || '    ' || v_salary || '    ' || v_dno);
end; 
/

-- 2. %rowtype
set serveroutput on
declare
    v_emp employee%rowtype;
begin
    select * into v_emp
    from employee
    where commission = 1400;
    
    dbms_output.put_line('사원번호   사원이름   급여   부서번호');
    dbms_output.put_line('------------------------------');
    dbms_output.put_line(v_emp.eno || '    ' || v_emp.ename || '    ' || v_emp.salary || '    ' || v_emp.dno);
end;
/


-- 커서 (cursor) : PL/SQL에서 select한 결과가 단일 레코드가 아니라 레코드셋(여러 레코드)인 경우에 커서가 필요함

/*
    declare
        cursor 커서명      -- 커서 선언
        is
        커서를 장착할 select 구문
    begin
        open 커서명       -- 커서 오픈
        loop
            fetch 구문    -- 커서를 이동하고 출력
        end loop;
        close 커서명;      -- 커서를 종료
    end;
    /
 */
 
 -- 커서를 사용해서 department 테이블의 모든 내용 출력하기
set serveroutput on
declare
    v_dept department%rowtype;   -- 변수 선언
    cursor c1   -- 1. 커서 선언
    is
    select * from department;
begin
    dbms_output.put_line('부서번호   부서명   부서위치');
    dbms_output.put_line('----------------------');
    open c1;    -- 2. 커서 오픈
    loop
        fetch c1 into v_dept.dno, v_dept.dname, v_dept.loc;
        exit when c1%notfound;
        dbms_output.put_line(v_dept.dno || '   ' || v_dept.dname || '   ' || v_dept.loc);
    end loop;
    close c1;      -- 4. 커서 종료
end;
/

/*
    커서의 속성을 나타내는 속성값
    
    커서명%notfound : 커서영역 내의 모든 자료가 fetch 되었다면 true
    커서명%found : 커서영역 내의 모든 자료가 fetch 되지 않은 자료가 있다면 true
    커서명%isopen : 커서가 오픈되었다면 true
    커서명%rowcount : 커서가 얻어온 레코드 개수
 */
 
 /*
    실습
    
    사원명, 부서명, 부서위치, 월급을 PL/SQL을 사용하여 출력하세요.
  */
  
-- 1. %type
set serveroutput on
declare
    v_ename employee.ename%type;
    v_dname department.dname%type;
    v_loc department.loc%type;
    v_salary employee.salary%type;
    
    cursor c3
    is
    select e.ename, d.dname, d.loc, e.salary
    from employee e, department d
    where e.dno = d.dno;
begin
    dbms_output.put_line('사원명   부서명   부서위치   월급');
    dbms_output.put_line('---------------------------');
    open c3;
    loop
        fetch c3 into v_ename, v_dname, v_loc, v_salary;
        exit when c3%notfound;
        dbms_output.put_line(v_ename || '   ' || v_dname || '   ' || v_loc || '   ' || v_salary);
    end loop;
    close c3;
end;
/

-- 2. %rowtype
set serveroutput on
declare
    v_emp employee%rowtype;
    v_dept department%rowtype;
    
    cursor c2
    is
    select e.ename, d.dname, d.loc, e.salary
    from employee e, department d
    where e.dno = d.dno;
begin
    dbms_output.put_line('사원명   부서명   부서위치   월급');
    dbms_output.put_line('---------------------------');
    open c2;
    loop
        fetch c2 into v_emp.ename, v_dept.dname, v_dept.loc, v_emp.salary;
        exit when c2%notfound;
        dbms_output.put_line(v_emp.ename || '   ' || v_dept.dname || '   ' || v_dept.loc || '   ' || v_emp.salary);
    end loop;
    close c2;
end;
/
