-- 인덱스 없이 작은 규모의 데이터를 조회하는 나쁜 SQL문
EXPLAIN
SELECT *
FROM employees
WHERE last_name = 'Wielonsky'
  AND first_name = 'Georgi';

ALTER TABLE employees
    ADD INDEX i_이름_성 (first_name, last_name);

DROP INDEX i_이름_성 ON employees;

DROP INDEX i_성_이름 ON employees;

CREATE INDEX i_성_이름 ON employees (last_name, first_name);

-- 인덱스를 하나만 사용하는 나쁜 SQL문
EXPLAIN
SELECT *
FROM employees
WHERE first_name = 'matt'
  AND hire_date = '1987-03-31';

SELECT COUNT(DISTINCT hire_date)
FROM employees;
SELECT COUNT(DISTINCT first_name)
FROM employees;

CREATE INDEX i_이름 ON employees (first_name);

DROP INDEX i_이름 ON employees;

-- 큰 규모의 데이터 변경으로 인덱스에 영향을 주는 나쁜 SQL문
SELECT @@autocommit;
SET AUTOCOMMIT = 1;

UPDATE emp_access_logs
SET door = 'X'
WHERE door = 'B';

-- 300,000rows
EXPLAIN
SELECT COUNT(1)
FROM emp_access_logs
WHERE door = 'X';

ROLLBACK;
-- I_출입문 인덱스 존재할 때 : 5.453초
-- I_출입문 인덱스 존재하지 않을 때 : 0.484초

CREATE INDEX i_출입문 ON emp_access_logs (door);

# 기존 인덱스 삭제 후 변경 인덱스 추가
ALTER TABLE employees
    DROP INDEX i_성별_성,
    ADD INDEX i_lastname_gender (last_name, gender);

# 변경 인덱스 삭제 후 기존 인덱스 추가
ALTER TABLE employees
    DROP INDEX i_lastname_gender,
    ADD INDEX i_성별_성 (gender, last_name);
-- 비효율적인 인덱스를 사용하는 나쁜 SQL문
EXPLAIN
SELECT emp_no, first_name, last_name
FROM employees
WHERE gender = 'M'
  AND last_name = 'Baba';

-- 잘못된 열 속성으로 비효율적으로 작성한 나쁜 SQL
SELECT dept_name, remark
FROM departments
WHERE remark = 'active'
  AND ASCII(SUBSTR(remark, 1, 1)) = 97 -- a
  AND ASCII(SUBSTR(remark, 2, 1)) = 99; -- b

SELECT dept_name, remark
FROM departments
WHERE remark = 'active';

-- remark 컬럼의 collate general -> bin
ALTER TABLE departments
    CHANGE COLUMN remark remark VARCHAR(40) NULL DEFAULT NULL
        COLLATE 'utf8mb4_bin';

-- remark 컬럼의 collate bin -> general
ALTER TABLE departments
    CHANGE COLUMN remark remark VARCHAR(40) NULL DEFAULT NULL
        COLLATE 'utf8mb4_general_ci';

-- 대소문자가 섞인 데이터와 비교하는 나쁜 SQl문
EXPLAIN
SELECT first_name, last_name, gender, birth_date
FROM employees
WHERE first_name = 'MARY'
  AND hire_date >= '1990-01-01';

-- 컬럼 하나 추가 lower_first_name
ALTER TABLE employees
    ADD COLUMN lower_first_name VARCHAR(14) NOT NULL COLLATE 'utf8mb4_general_ci' AFTER first_name;

SELECT *
FROM employees;

UPDATE employees
SET lower_first_name = LOWER(first_name);

-- 분산 없이 큰 규모의 데이터를 사용하는 나쁜 SQL문
-- 0.719
EXPLAIN ANALYZE
SELECT COUNT(1)
FROM salaries
WHERE from_date BETWEEN '2000-01-01' AND '2000-12-31';

SELECT YEAR(from_date) AS from_year, COUNT(1)
FROM salaries
GROUP BY from_year;

-- 전체 파티셔닝 제거
ALTER TABLE salaries REMOVE PARTITIONING;
-- 파티셔닝 제거
ALTER TABLE salaries DROP PARTITION p00;
-- 파티셔닝 생성
ALTER TABLE salaries
PARTITION BY RANGE COLUMNS (from_date)
(
	PARTITION p85 VALUES LESS THAN ('1985-12-31'),
	PARTITION p86 VALUES LESS THAN ('1986-12-31'),
	PARTITION p87 VALUES LESS THAN ('1987-12-31'),
	PARTITION p88 VALUES LESS THAN ('1988-12-31'),
	PARTITION p89 VALUES LESS THAN ('1989-12-31'),
	PARTITION p90 VALUES LESS THAN ('1990-12-31'),
	PARTITION p91 VALUES LESS THAN ('1991-12-31'),
	PARTITION p92 VALUES LESS THAN ('1992-12-31'),
	PARTITION p93 VALUES LESS THAN ('1993-12-31'),
	PARTITION p94 VALUES LESS THAN ('1994-12-31'),
	PARTITION p95 VALUES LESS THAN ('1995-12-31'),
	PARTITION p96 VALUES LESS THAN ('1996-12-31'),
	PARTITION p97 VALUES LESS THAN ('1997-12-31'),
	PARTITION p98 VALUES LESS THAN ('1998-12-31'),
	PARTITION p99 VALUES LESS THAN ('1999-12-31'),
	PARTITION p00 VALUES LESS THAN ('2000-12-31'),
	PARTITION p01 VALUES LESS THAN ('2001-12-31'),
	PARTITION p02 VALUES LESS THAN ('2002-12-31'),
	PARTITION p03 VALUES LESS THAN (maxvalue)
);

-- 파티션 스캔 비율
SELECT partition_name, table_rows, AVG_ROW_LENGTH, data_length / 1024 / 1024 AS data_size_mb
FROM information_schema.partitions
WHERE table_schema = 'tuning2'
AND TABLE_NAME = 'salaries'
AND partition_name IS NOT NULL
ORDER BY partition_ordinal_position;
