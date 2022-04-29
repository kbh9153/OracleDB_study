CREATE TABLE grade_pt_rade
(
	mem_grade            VARCHAR2(20 BYTE) NOT NULL ,
	grade_pt_rate        NUMBER(3,2) NULL 
);



ALTER TABLE grade_pt_rade
	ADD CONSTRAINT  XPK마일리지율 PRIMARY KEY (mem_grade);



CREATE TABLE manager
(
	manager_id           varchar2(30 BYTE) NOT NULL ,
	manager_pwd          varchar2(20 BYTE) NOT NULL ,
	manager_tel          varchar2(20 BYTE) NULL 
);



ALTER TABLE manager
	ADD CONSTRAINT  XPK관리자 PRIMARY KEY (manager_id);



CREATE TABLE member
(
	mem_id               VARCHAR2(6 BYTE) NOT NULL ,
	mem_grade            VARCHAR2(20 BYTE) NOT NULL ,
	mem_pw               VARCHAR2(20 BYTE) NOT NULL ,
	mem_birth            DATE DEFAULT  sysdate  NOT NULL ,
	mem_tel              VARCHAR2(20 BYTE) NULL ,
	mem_pt               VARCHAR2(10 BYTE) DEFAULT  0  NOT NULL 
);



ALTER TABLE member
	ADD CONSTRAINT  XPK회원 PRIMARY KEY (mem_id);



CREATE TABLE nation
(
	nation_code          VARCHAR2(26 BYTE) NOT NULL ,
	nation_name          VARCHAR2(50 BYTE) NOT NULL 
);



ALTER TABLE nation
	ADD CONSTRAINT  XPK국가 PRIMARY KEY (nation_code);



CREATE TABLE sale
(
	sale_date            DATE DEFAULT  sysdate  NOT NULL ,
	wine_code            VARCHAR2(26 BYTE) NOT NULL ,
	mem_id               VARCHAR2(6 BYTE) NOT NULL ,
	sale_amount          VARCHAR2(5 BYTE) DEFAULT  0  NOT NULL ,
	sale_price           VARCHAR2(6 BYTE) DEFAULT  0  NOT NULL ,
	sale_tot_price       VARCHAR2(15 BYTE) DEFAULT  0  NOT NULL 
);



ALTER TABLE sale
	ADD CONSTRAINT  XPK판매 PRIMARY KEY (sale_date);



CREATE TABLE stock_management
(
	stock_code           varchar2(6 BYTE) NOT NULL ,
	wine_code            VARCHAR2(26 BYTE) NOT NULL ,
	manager_id           varchar2(30 BYTE) NOT NULL ,
	ware_date            DATE DEFAULT  sysdate  NOT NULL ,
	stock_amount         NUMBER(5) DEFAULT  0  NOT NULL 
);



ALTER TABLE stock_management
	ADD CONSTRAINT  XPK재고 PRIMARY KEY (stock_code);



CREATE TABLE theme
(
	theme_code           VARCHAR2(6 BYTE) NOT NULL ,
	theme_name           VARCHAR2(50 BYTE) NOT NULL 
);



ALTER TABLE theme
	ADD CONSTRAINT  XPK테마 PRIMARY KEY (theme_code);



CREATE TABLE today
(
	today_code           VARCHAR2(6 BYTE) NOT NULL ,
	today_sens_value     NUMBER(3) NULL ,
	today_intell_value   NUMBER(3) NULL ,
	today_phy_value      NUMBER(3) NULL 
);



ALTER TABLE today
	ADD CONSTRAINT  XPK오늘의와인 PRIMARY KEY (today_code);



CREATE TABLE wine
(
	wine_code            VARCHAR2(26 BYTE) NOT NULL ,
	wine_name            varchar2(100 BYTE) NOT NULL ,
	wine_url             BLOB NULL ,
	nation_code          VARCHAR2(26 BYTE) NOT NULL ,
	wine_type_code       varchar2(6 BYTE) NOT NULL ,
	wine_sugar_code      NUMBER(2) NULL ,
	wine_price           NUMBER(15) DEFAULT  0  NOT NULL ,
	wine_vintage         DATE NULL ,
	theme_code           VARCHAR2(6 BYTE) NOT NULL ,
	today_code           VARCHAR2(6 BYTE) NOT NULL 
);



ALTER TABLE wine
	ADD CONSTRAINT  XPK와인 PRIMARY KEY (wine_code);



CREATE TABLE wine_type
(
	wine_type_code       varchar2(6 BYTE) NOT NULL ,
	wine_type_name       varchar2(50 BYTE) NULL 
);



ALTER TABLE wine_type
	ADD CONSTRAINT  XPK와인종류 PRIMARY KEY (wine_type_code);



ALTER TABLE member
	ADD (CONSTRAINT R_6 FOREIGN KEY (mem_grade) REFERENCES grade_pt_rade (mem_grade));



ALTER TABLE sale
	ADD (CONSTRAINT R_4 FOREIGN KEY (wine_code) REFERENCES wine (wine_code));



ALTER TABLE sale
	ADD (CONSTRAINT R_5 FOREIGN KEY (mem_id) REFERENCES member (mem_id));



ALTER TABLE stock_management
	ADD (CONSTRAINT R_11 FOREIGN KEY (manager_id) REFERENCES manager (manager_id));



ALTER TABLE stock_management
	ADD (CONSTRAINT R_12 FOREIGN KEY (wine_code) REFERENCES wine (wine_code));



ALTER TABLE wine
	ADD (CONSTRAINT R_7 FOREIGN KEY (nation_code) REFERENCES nation (nation_code));



ALTER TABLE wine
	ADD (CONSTRAINT R_8 FOREIGN KEY (wine_type_code) REFERENCES wine_type (wine_type_code));



ALTER TABLE wine
	ADD (CONSTRAINT R_9 FOREIGN KEY (theme_code) REFERENCES theme (theme_code));



ALTER TABLE wine
	ADD (CONSTRAINT R_10 FOREIGN KEY (today_code) REFERENCES today (today_code));


