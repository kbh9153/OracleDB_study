-- sale table
create table sale (
    sale_date date default sysdate not null constraint PK_sale_sale_date primary key,
    wine_code varchar2(6) not null,
    mem_id varchar2(30) not null,
    sale_amount varchar2(5) default 0 not null,
    sale_price varchar2(6) default 0 not null,
    sale_tot_price varchar2(15) default 0 not null
    );

alter table sale
add constraint FK_sale_wine_code
foreign key(wine_code) references wine(wine_code);

alter table sale
add constraint FK_sale_mem_id
foreign key(mem_id) references members(mem_id);

select * from user_constraints where table_name = 'SALE';

insert into sale
    values (default, 'W1111', 'M1111', '100', '100000', '80000');

insert into sale
    values (default, 'W2222', 'M2222', '200', '150000', '100000');
    
insert into sale
    values (default, 'W3333', 'M3333', '300', '200000', '150000');
    
select * from sale;
    
-- members table
create table members (
    mem_id varchar2(6) not null constraint PK_member_mem_id primary key,
    mem_grade varchar2(20) null,
    mem_pw varchar2(20) not null,
    mem_birth date default sysdate not null,
    mem_tel varchar2(20) null,
    mem_pt varchar2(10) default 0 not null
    );
    
alter table members
add constraint FK_members_mem_grade
foreign key(mem_grade) references grade_pt_rade(mem_grade);

select * from user_constraints where table_name = 'MEMBERS';

insert into members
    values('M1111', 'A', 'P1111', default, '01011111111', default);

insert into members
    values('M2222', 'B', 'P2222', default, '01022222222', default);
    
insert into members
    values('M3333', 'C', 'P3333', default, '01033333333', default);
    
select * from members;

-- grade_pt_rade table    
create table grade_pt_rade (
    mem_grade varchar2(20) not null constraint PK_grade_pt_rade_mem_grade primary key,
    grade_pt_rate number(3, 2) null
    );
    
insert into grade_pt_rade
    values('A', '3');

insert into grade_pt_rade
    values('B', '3');
    
insert into grade_pt_rade
    values('C', '3');
    
-- today table
create table today (
    today_code varchar2(6) not null constraint PK_today_today_code primary key,
    today_sens_value number(3) null,
    today_intell_value number(3) null,
    today_phy_value number(3) null
    );
    
insert into today
    values('T111', 30, 30, 50);
    
insert into today
    values('T222', 40, 40, 60);
    
insert into today
    values('T333', 50, 50, 70);
    
select * from today;

-- nation table
create table nation (
    nation_code varchar2(26) not null constraint PK_nation_nation_code primary key,
    nation_name varchar2(50) not null
    );
    
insert into nation
    values('CH123', 'Chile');
    
insert into nation
    values('FR123', 'France');

insert into nation
    values('IT123', 'Italy');
    
select * from nation;
    
-- wine table
create table wine (
    wine_code varchar2(26) not null constraint PK_wine_wine_code primary key,
    wine_name varchar2(100) not null,
    wine_url blob null,
    nation_code varchar2(6) null,
    wine_type_code varchar2(6) null,
    wine_sugar_code number(2) null,
    wine_pirce number(15) default 0 not null,
    wine_vintage date null,
    theme_code varchar2(6) null,
    today_code varchar2(6) null
    );
    
alter table wine
add constraint FK_wine_nation_code
foreign key(nation_code) references nation(nation_code);

alter table wine
add constraint FK_wine_wine_type_code
foreign key(wine_type_code) references wine_type(wine_type_code);

alter table wine
add constraint FK_wine_theme_code
foreign key(theme_code) references theme(theme_code);

alter table wine
add constraint FK_wine_today_code
foreign key(today_code) references today(today_code);

select * from user_constraints where table_name = 'WINE';

insert into wine
    values('W1111', 'WineSample1', null, 'CH123', 'R123', 3, 50000, '1990/11/12', 't111', 'T111');
    
insert into wine
    values('W2222', 'WineSample2', null, 'FR123', 'W123', 5, 70000, '1990/10/12', 't222', 'T222');
    
insert into wine
    values('W3333', 'WineSample3', null, 'IT123', 'W123', 5, 100000, '1930/12/03', 't222', 'T222');
    
select * from wine;

-- theme table
create table theme (
    theme_code varchar2(6) not null constraint PK_theme_theme_code primary key,
    theme_name varchar2(50) not null
    );
    
insert into theme
    values('t111', 'Best');
    
insert into theme
    values('t222', 'Steady');
    
select * from theme;
    
-- stock_management table
create table stock_management (
    stock_code varchar2(6) not null constraint PK_stock_management_stock_code primary key,
    wine_code varchar2(6) null,
    manager_id varchar2(30) null,
    ware_date date default sysdate not null,
    stock_amount number(5) default 0 not null
    );
    
alter table stock_management
add constraint FK_stock_management_wine_code
foreign key(wine_code) references wine(wine_code);

alter table stock_management
add constraint FK_stock_management_manager_id
foreign key(manager_id) references manager(manager_id);

select * from user_constraints where table_name = 'STOCK_MANAGEMENT';

insert into stock_management
    values('P111', 'W1111', 'ID111', default, 10);

insert into stock_management
    values('P222', 'W2222', 'ID222', default, default);

insert into stock_management
    values('P333', 'W3333', 'ID333', default, 20);
    
select * from stock_management;

-- manager table
create table manager (
    manager_id varchar2(30) not null constraint PK_manager_manager_id primary key,
    manager_pwd varchar2(20) not null,
    manager_tel varchar2(20) null
    );
    
insert into manager
    values('ID111', 'PW111', '01011111111');
    
insert into manager
    values('ID222', 'PW222', '01022222222');
    
insert into manager
    values('ID333', 'PW333', '01033333333');
    
select * from manager;
    
-- wine_type
create table wine_type (
    wine_type_code varchar2(6) not null constraint PK_wien_type_wine_type_code primary key,
    wine_type_name varchar2(50) null
    );
    
insert into wine_type
    values('R123', 'RED');

insert into wine_type
    values('W123', 'WHITE');
    
select * from wine_type;

commit;
    

    