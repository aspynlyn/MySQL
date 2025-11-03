USE test;

CREATE TABLE person(
	`name` VARCHAR(40),
	eye_color CHAR(2) CHECK (eye_color IN ('BL', 'BR', 'GR')),
	birth_date DATE,
	address VARCHAR(100),
	favorite_foods VARCHAR(200)
	);
	
INSERT INTO person(
	`name`, eye_color, birth_date, address, favorite_foods)
	VALUES ('류지민', 'BR', '2003-11-26', '대구 동구 경안로 790-53', '아나고'),
		('류지민', 'BR', '2003-11-26', '대구 동구 경안로 790-53', '아나고');
	
INSERT INTO person
SET `name` = '손준헌',
	eye_color = 'BR',
	birth_date = '1995-10-05',
	address = '경북 경산시 대학로28길 31',
	favorite_foods = '제육';
	
INSERT INTO person
SET `name` = '홍길동',
	eye_color = 'BR',
	birth_date = '1995-10-05',
	address = '경북 경산시 대학로28길 31',
	favorite_foods = '제육';

SELECT * FROM person;

-- 특정 컬럼만 보고싶은 경우
SELECT `name`, birth_date FROM person;

-- 표시 컬럼명을 변경하고 싶은 경우
SELECT `name` AS '이름', birth_date AS '생년월일' FROM person;

-- 대구 동구에 살고있는 사람 정보
SELECT *
from person
WHERE address = '대구 동구 경안로 790-53';

UPDATE person
SET eye_color = 'BL'
WHERE `name` = '류지민';

-- 홍길동, 눈색상 GR, 좋아하는 음식 '된장찌개'
UPDATE person
SET eye_color = 'GR',
	favorite_foods = '된장찌개'
WHERE `name` = '홍길동';

-- 경북 경산시 대학로28길 31에 살면서 눈 색상이 BR인 사람의 정보
SELECT *
FROM person
WHERE address = '경북 경산시 대학로28길 31' 
AND eye_color = 'BR';

SELECT *
FROM person
ORDER BY eye_color ASC;

SELECT *
FROM person
ORDER BY eye_color DESC;

SELECT *
FROM person
ORDER BY eye_color DESC, `name` DESC;

SELECT COUNT(*) FROM person;

SELECT MIN(address) FROM person;

SELECT MAX(address) FROM person;

SELECT eye_color
FROM person
GROUP BY eye_color;

SELECT *
FROM person
WHERE `name` LIKE '%준헌%';

SELECT *
FROM person
WHERE `name` LIKE '%준헌_';

SELECT `name`
FROM person
UNION
SELECT address
FROM person;

SELECT * 
FROM person
LIMIT 2;

SELECT *
FROM person 
ORDER BY eye_color
LIMIT 1;

SELECT *
FROM person
LIMIT 2, 3;

SELECT address FROM person WHERE address = '대구 동구 경안로 790-53';

SELECT `name`, (SELECT address FROM person WHERE address = '대구 동구 경안로 790-53') 
FROM person;

SELECT *
FROM (SELECT `name`, address FROM person) p;

SELECT *
FROM person
WHERE `name` = (
	SELECT `name` FROM person WHERE address = '대구 동구 경안로 790-53'
	); 

SELECT eye_color FROM person WHERE address = '경북 경산시 대학로28길 31';

SELECT *
FROM person
WHERE eye_color IN (SELECT eye_color 
							FROM person 
							WHERE address = '경북 경산시 대학로28길 31');
							
SELECT `name`, address
FROM person WHERE address LIKE '%경산%';

SELECT *
FROM person
WHERE (`name`, address) IN (SELECT `name`, address
										FROM person
										WHERE address LIKE '%경산%');
			
-- 오토커밋 여부 확인							
SELECT @@autocommit;

SET autocommit = 0;

DELETE FROM person
WHERE `name` = '홍길동';

ROLLBACK;

-- 최소 일주일동안 대여할 수 있는 G등급의 영화를 찾고 싶다.

SELECT *
FROM film
WHERE rental_duration >= 7 AND rating = 'G';

/*
최소 일주일 동안 대여할 수 있는 G등급(rating)의 영화이거나
PG-13등급이면서 3일 이하로만 대여할 수 있는 영화의 정보
rental_duration (대여가능기간)
*/

SELECT *
FROM film
WHERE (rental_duration >= 7 AND rating = 'G') 
OR (rating = 'PG-13' AND rental_duration <= 3);

/*
40편 이상의 영화를 대여한 모든 고객의 정보
표시 컬럼 : 이름, 성, 갯수
*/

SELECT c.first_name, c.last_name, r.rental_count
FROM customer AS c
JOIN (
  SELECT customer_id, COUNT(*) AS rental_count
  FROM rental
  GROUP BY customer_id
  HAVING COUNT(*) >= 40
) AS r
  ON r.customer_id = c.customer_id;


SELECT c.first_name, c.last_name, COUNT(*) AS rental_count
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY r.customer_id
HAVING COUNT(*) >= 40;

/*
2005년 06월 14일에 대여한 모든 고객 정보
*/

SELECT c.*
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id
WHERE DATE(r.rental_date) = '2005-06-14';

SELECT c.*
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id
WHERE r.rental_date BETWEEN '2005-06-14 00:00:00' AND '2005-06-14 23:59:59';

-- 프로파일링 상태 확인
SELECT @@profiling;

-- 프로파일링 활성화
SET profiling = 0;

-- 프로파일링 할 쿼리 실행 후 확인
SHOW PROFILES;
