-- << Quiz >> --

-- 테이블 생성시(Foreign Key) : 부모테이블 (FK 참조 테이블)을 먼저 생성하여 Primary Key or Unique 조건을 설정 후 자식 테이블 생성
	-- => 자식 테이블을 생성할 때 FK를 넣지 않고 부모테이블 생성하여 Primary Key or Unique 조건을 설정 후 Alter Table을 사용하여 나중에 FK를 설정해도 됨
CREATE TABLE tb_zipcode (
	zipcode varchar2(7) NOT NULL CONSTRAINT PK_tb_zipcode_zipcode  PRIMARY KEY,
	sido varchar2(30) NULL,
	gugum varchar2(30) NULL,
	dong varchar2(30) NULL,
	bungi varchar2(30) NULL
	);

-- 테이블 컬럼명 수정
ALTER TABLE TB_ZIPCODE RENAME COLUMN gugum TO gugun;
ALTER TABLE TB_ZIPCODE RENAME COLUMN bungi TO bunji;
-- 테이블 컬럼 추가
ALTER TABLE TB_ZIPCODE ADD (zip_seq varchar2(300));
-- 테이블 컬럼 자료형 수정
ALTER TABLE TB_ZIPCODE MODIFY dong varchar2(300);

-- 테이블 제약조건 확인
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'tb_zipcode';

-- 제약조건 삭제시 주의사항 : members 테이블의 zipcode 컬럼이 tb_zipcode의 zipcode 컬럼을 참조하고 있음
	-- => 자식 테이블의 Foreign Key를 삭제 후 부모 테이블의 Primary key를 삭제 가능
ALTER TABLE TB_ZIPCODE DROP CONSTRAINT PK_tb_zipcode_zipcode;

-- 제약조건 비활성화하기 => Bulk Insert (대량의 Insert)
	-- cascade를 사용하여 강제 비활성화 (부모테이블의 제약조건을 강제 비활성화하면 자식 테이블의 참조 제약조건도 강제 중지)
ALTER TABLE TB_ZIPCODE
disable CONSTRAINT PK_tb_zipcode_zipcode CASCADE;
-- ALTER TABLE TB_ZIPCODE disable CONSTRAINT PK_tb_zipcode_zipcode;	-- 오류발생. members 테이블에서 tb_zipcode의 zipcode 컬럼을 참조하고 있어 중지 불가능

-- 기존 테이블에 제약조건 추가 (Primary Key or Unique 조건을 추가하려면 데이터들의 중복이 없어야 추가 가능)
ALTER TABLE TB_ZIPCODE
ADD CONSTRAINT PK_tb_zipcode_zipcode
PRIMARY KEY(zipcode);

SELECT * FROM tb_zipcode;
-- zip_seq 컬럼을 숫자순서로 오름차순으로 정렬하기
	-- => zip_seq의 자료형이 varchar2이기 때문에 문자열로 정렬됨. to_number을 사용하여 정렬하면 숫자순으로 정렬됨
SELECT * FROM TB_ZIPCODE ORDER BY TO_NUMBER(ZIP_SEQ);

-----------------------------------------------------

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

-- 테이블 참조 제약조건 삭제
ALTER TABLE MEMBERS DROP CONSTRAINT FK_members_id_tb_zipcode;
SELECT * FROM members;

-- 테이블 제약조건 추가
ALTER TABLE members
ADD CONSTRAINT FK_members_id_tb_zipcode
FOREIGN KEY(zipcode) REFERENCES tb_zipcode(zipcode);

-----------------------------------------------------	

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

SELECT * FROM PRODUCTS;

-----------------------------------------------------

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

SELECT * FROM ORDERS;

COMMIT;