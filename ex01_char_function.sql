-- �پ��� �Լ� ����ϱ�

/*
    1. ���ڸ� ó���ϴ� �Լ�
        - UPPER : �빮�ڷ� ��ȯ
        - LOWER : �ҹ��ڷ� ��ȯ
        - INITCAP : ù�ڴ� �빮�ڷ� �������� �ҹ��ڷ� ��ȯ
        
        dual ���̺� : �ϳ��� ����� ����ϵ��� �ϴ� ���̺� (���� ���̺�)
*/

select '�ȳ��ϼ���' as �λ� from dual;

select 'Oracle mania', upper('Oracle mania'), lower('Oracle mania'), initcap('Oracle mania')
from dual;

select * from employees;
select first_name, upper(first_name), initcap(first_name), lower(first_name) from employees;

select * from employees where first_name = 'amit';  -- first_name�� ���� Amit. A�� �빮���̱� ������ �˻��� �ȵ�
select * from employees where first_name = 'Amit';  -- ���� ��ҹ����� ��� �˻��� ���� ��ҹ��ڸ� ��ġ������� �˻��� ���� => ����
select * from employees where lower(first_name) = 'amit';   -- lower() �Լ��� ����Ͽ� �ҹ��ڷ� �˻��ǵ��� ó��

-- ���� ���̸� ����ϴ� �Լ�
    -- 1. length : ������ ���̸� ��ȯ, �����̳� �ѱ� ������� ���� ���� ����
    -- 2. lengthb : ������ ���̸� ��ȯ, ������ 1byte ��ȯ, �ѱ� 3byte�� ��ȯ
    
select length('Oracle mania'), length('����Ŭ �ŴϾ�') from dual;
select lengthb('Oracle mania'), lengthb('����Ŭ �ŴϾ�') from dual;

select * from employees;
select length(first_name), job_id, length(job_id) from employees;

-- ���� ���� �Լ�
    -- concat : ���ڿ� ���ڸ� �����ؼ� ���
    -- substr : ���ڸ� Ư�� ��ġ���� �߶���� �Լ� (����, �ѱ�, ��� 1byte�� ó��)
    -- substrb : ������ 1byte, �ѱ��� 3byte (������ 1byte, �ϴ��� 3byte�� ó��)
    -- instrb : ������ Ư�� ��ġ�� �ε��� ���� ��ȯ
    -- lpad, rpad : �Է� ���� ���ڿ����� Ư�����ڸ� ���� => lpad(����), rpad(������)
        -- => ex. lpad(���, ���ڿ� ũ�� ����(byte. = �� ũ��� ���� �ǹ�, '����ó���� Ư������')
    -- trim : ��������, Ư�� ���ڵ� ����

-- concat : ���ڿ� ���ڸ� ����    
select 'Oracle', 'mania', concat('Oracle', 'mania') from dual;

select concat(first_name, last_name) from employees;    -- first_name, last_name �÷��� ���յǾ� ���
select concat(first_name, ' ' || last_name) from employees;    -- ' ' || : ���� �����Ͽ� ���

    -- || : pipe. �յ� ���� ���
select '�̸��� : ' || concat(first_name, ' ' || last_name) || ' �̰�, ������ : ' || job_id || ' �Դϴ�.'
as �÷����� from employees;

select '�̸��� : ' || concat(first_name, ' ' || last_name) || ' �̰�, ���ӻ�� ����� : ' || manager_ID || ' �Դϴ�.' 
as ���ӻ����� from employees;

-- substr (substr ���, ������ġ, ���ⰳ��) : Ư�� ��ġ���� ���ڸ� �߶��
select 'Oracle mania', substr('Oracle mania', 4, 3), substr('����Ŭ �ŴϾ�', 2, 3) from dual;

select 'Oracle mania', substr('Oracle mania', -4, 3),
substr('����Ŭ �ŴϾ�', -6, 4) from dual;     -- ������ġ�� - �� ��� ������ ������ ã�� ����

select first_name, substr(first_name, 2, 3), substr(first_name, -5, 4) from employees;

select substrb('Oracle mania', 3, 3), substrb('����Ŭ �ŴϾ�', 4, 6) from employees;  -- �ѱ��� 3byte�� ó���Ͽ� '��Ŭ'�� ��� 

    -- �̸��� n���� ������ ����� ����ϱ� (substr �Լ��� ����ؼ� ���)
select concat(first_name, ' ' || last_name) from employees where substr(last_name, -1, 1) = 'n';
select concat(first_name, ' ' || last_name) from employees where last_name like '%n';

    -- 08�⵵ �Ի��� ����� ����ϱ� (substr �Լ��� ����ؼ� ���)
select concat(first_name, ' ' || last_name), hire_date from employees where substr(hire_date, 1, 2) = 08;
select concat(first_name, ' ' || last_name), hire_date from employees where hire_date like '08%';

-- instr (���, ã�� ����, ���� ��ġ, ���° �߰�) : ��󿡼� ã�� ������ �ε������� ���
select 'Oracle mania', instr('Oracle mania', 'm') from dual;    -- ���� ��ġ, ���° �߰��� ����
    -- 5��°���� ã�� �����Ͽ� ù��° a�� ����ġ�� �ι�°�� �߰ߵǴ� a�� ��ġ�� ���
select 'Oracle mania', instr('Oracle mania', 'a', 5, 2) from dual;
    -- (������ ����������)5��°���� ã�� �����Ͽ� ù��° a�� ����ġ�� �ι�° �߰ߵǴ� a�� ��ġ�� ��� => �ι�° a�� ��� 0 ���
select 'Oracle mania', instr('Oracle mania', 'a', -5, 2) from dual;

select distinct instr((job_id), 'R', 1, 1) from employees where lower(job_id) = 'st_clerk';

-- lpad, rpad : Ư�� ���̸�ŭ ���ڿ��� �����ؼ� ����, �����ʿ� ������ Ư�� ���ڷ� ó�� => lpad(����), rpad(������)
select rpad(salary, 10, '*') from employees;
select rpad(salary, 10) from employees;     -- Ư������ ���� ���ϸ� �������� ���
select lpad(1234, 10, '#') from dual;

-- TRIM : ��������, Ư�� ���ڵ� ����
    -- LTRIM : ������ ������ ����
    -- RTRIM : �������� ������ ����
    -- TRIM : �¿� ������ ����
select ltrim('   Oracle mania   ') as ���ʰ�������,
rtrim('   Oracle mania   ') as �����ʰ�������,
trim('   Oracle mania   ') as �¿��������
from employees;