-- << Quiz >> --

CREATE TABLE tb_zipcode (
	zipcode varchar2(7) NOT NULL CONSTRAINT PK_tb_zipcode_zipcode  PRIMARY KEY,
	sido varchar2(30) NULL,
	gugum varchar2(30) NULL,
	dong varchar2(30) NULL,
	bungi varchar2(30) NULL
	);

ALTER TABLE TB_ZIPCODE RENAME COLUMN gugum TO gugun;
ALTER TABLE TB_ZIPCODE RENAME COLUMN bungi TO bunji;

ALTER TABLE TB_ZIPCODE ADD (zip_seq varchar2(300));
ALTER TABLE TB_ZIPCODE MODIFY dong varchar2(300);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'tb_zipcode';
ALTER TABLE TB_ZIPCODE DROP CONSTRAINT PK_tb_zipcode_zipcode;

INSERT INTO TB_ZIPCODE
	VALUES (12345, '서울특별시', '강남구', '개포동', '123번지');

INSERT INTO TB_ZIPCODE
	VALUES (23421, '서울특별시', '강서구', '화곡동', '253번지');

INSERT INTO TB_ZIPCODE
	VALUES (54812, '서울특별시', '강동구', '강일동', '754번지');

SELECT * FROM tb_zipcode;

CREATE TABLE members (
	id varchar2(20) NOT NULL CONSTRAINT PK_member_id PRIMARY KEY,
	pwd varchar2(20) NULL,
	name varchar2(50) NULL,
	zipcode varchar2(7) NULL,
	CONSTRAINT FK_members_id_tb_zipcode FOREIGN KEY(zipcode) REFERENCES tb_zipcode(zipcode),
	address varchar2(20) NULL,
	tel varchar2(13) NULL,
	indate DATE DEFAULT sysdate
	);

ALTER TABLE TB_ZIPCODE DROP CONSTRAINT PK_tb_zipcode_zipcode;

INSERT INTO MEMBERS
	VALUES (10, 'A1234', '홍길동', 12345, '강남구 개포동', '010-1111-1111', DEFAULT);

INSERT INTO MEMBERS
	VALUES (20, 'B1234', '이순신', 23421, '강서구 화곡동', '010-2222-2222', DEFAULT);

INSERT INTO MEMBERS
	VALUES (30, 'C1234', '김유신', 54812, '강동구 강일동', '010-3333-3333', DEFAULT);

SELECT * FROM members;
	
CREATE TABLE products (
	product_code varchar2(20) NOT NULL CONSTRAINT PK_products_product_code PRIMARY KEY,
	product_name varchar2(100) NULL,
	product_kind char(1) NULL,
	product_price1 varchar2(10) NULL,
	product_price2 varchar2(10) NULL,
	product_content varchar2(1000) NULL,
	product_image varchar2(50) NULL,
	sizeSt varchar2(5) NULL,
	sizeEt varchar2(5) NULL,
	product_quantity varchar2(5) NULL,
	useyn char(1) NULL,
	indate DATE NULL
	);

INSERT INTO PRODUCTS
	VALUES ('PD1234', '연필', 'A', 300, 1000, '연필입니다.', '연필이미지', 10, 20, 100, 'O', sysdate);

INSERT INTO PRODUCTS
	VALUES ('PD5678', '지우개', 'B', 100, 3000, '지우개입니다.', '지우개이미지', 10, 20, 100, 'O', sysdate);

INSERT INTO PRODUCTS
	VALUES ('PD9876', '필통', 'C', 1000, 5000, '필통입니다.', '필통이미지', 10, 20, 100, 'O', sysdate);
	
SELECT * FROM PRODUCTS;


CREATE TABLE orders (
	o_seq number(10) NOT NULL CONSTRAINT PK_orders_o_seq PRIMARY KEY,
	product_code varchar2(20) NULL,
	CONSTRAINT FK_orders_product_code FOREIGN KEY(product_code) REFERENCES products(product_code),
	id varchar2(16) NULL,
	CONSTRAINT FK_orders_id_members FOREIGN KEY(id) REFERENCES members(id),
	product_size varchar2(5) NULL,
	quantity varchar2(5) NULL,
	resutl char(1) NULL,
	indate DATE NULL
	);
	
INSERT INTO ORDERS
	VALUES (1111111, 'PD1234', 10, 20, 1, 'O', sysdate);
	
INSERT INTO ORDERS
	VALUES (2222222, 'PD5678', 10, 20, 1, 'O', sysdate);
	
INSERT INTO ORDERS
	VALUES (3333333, 'PD9876', 10, 20, 1, 'O', sysdate);
	
SELECT * FROM ORDERS;

COMMIT;