create database XE;
use XE;

create table department(
	dno int(2) not null,
    dname varchar(14) null,
    loc varchar(13) null,
    constraint PK_DEPT primary key(dno)
    );
    
insert into department(dno, dname, loc)
	values(10,'ACCOUNTING','NEW YORK');
    
insert into department(dno, dname, loc)
	values(20,'RESEARCH','DALLAS');
    
insert into department(dno, dname, loc)
	values(30,'SALES','CHICAGO');
    
insert into department(dno, dname, loc)
	values(40,'OPERATIONS','BOSTON');

desc department;
select * from department;

create table employee(
	eno int(4) not null,
    ename varchar(10) null,
    job varchar(9) null,
    manager int(4) null,
    hiredate date null,
    salary double(7, 2) null,
    commission double(7, 2) null,
    dno int(2) null,
    constraint PK_EMP primary key(eno),
    constraint FK_DNO foreign key(dno) references department(dno)
    );
    
insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7369, 'SMITH', 'CLERK', 7902, str_to_date('17,2,1980', '%d,%m,%Y'), 800, NULL, 20);

insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7499, 'ALLEN', 'SALESMAN', 7698, str_to_date('20, 2, 1981', '%d,%m,%Y'), 1600, 300, 30);

insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7521, 'WARD', 'SALESMAN', 7698, str_to_date('22, 2, 1981', '%d,%m,%Y'), 1250, 500, 30);
    
insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7566, 'JONES', 'MANAGER', 7839, str_to_date('2, 4, 1981', '%d,%m,%Y'), 2975, NULL, 20);
    
insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7654, 'MARTIN', 'SALESMAN', 7698, str_to_date('28, 9, 1981', '%d,%m,%Y'), 1250, 1400, 30);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7698, 'BLAKE', 'MANAGER', 7839, str_to_date('1, 5, 1981', '%d,%m,%Y'), 2850, NULL, 30);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7782, 'CLARK', 'MANAGER', 7839, str_to_date('9, 6, 1981', '%d,%m,%Y'), 2450, NULL, 10);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7788, 'SCOTT', 'ANALYST', 7566, str_to_date('13,07,1987', '%d,%m,%Y'), 3000, NULL, 20);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7839, 'KING', 'PRESIDENT', NULL, str_to_date('17, 11, 1981', '%d,%m,%Y'), 5000, NULL, 10);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7844, 'TURNER', 'SALESMAN', 7698, str_to_date('8, 9, 1981', '%d,%m,%Y'), 1500, 0, 30);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7876, 'ADAMS', 'CLERK', 7788, str_to_date('13, 07, 1987', '%d,%m,%Y'), 1100, NULL, 20);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7900, 'JAMES', 'CLERK', 7698, str_to_date('3, 12, 1981', '%d,%m,%Y'), 950, NULL, 30);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7902, 'FORD', 'ANALYST', 7566, str_to_date('3, 12, 1981', '%d,%m,%Y'), 3000, NULL, 20);
    
    insert into employee(eno, ename, job, manager, hiredate, salary, commission, dno)
	values(7934, 'MILLER', 'CLERK', 7782, str_to_date('23, 1, 1982', '%d,%m,%Y'), 1300, NULL, 10);

desc employee;
select * from employee;

create table salgrade(
	grade int null,
    losal int null,
    hisal int null
    );
    
insert into salgrade
	values(1, 700, 1200);

insert into salgrade
	values(2, 1201, 1400);
    
insert into salgrade
	values(3, 1401, 2000);
    
insert into salgrade
	values(4, 2001, 3000);
    
insert into salgrade
	values(3, 3001, 9999);
    
desc salgrade;
select * from salgrade;
    
    
	