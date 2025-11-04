/*
2006년 1월 1일 이후에 기록이 생성된 고객 중에, 이름이 Steven이거나 Young인 사람이 아닌 고객 정보 조회
*/

SELECT *
FROM customer
WHERE create_date > '2006-01-01 23:59:59'
AND first_name NOT IN ('STEVEN', 'YOUNG');

/*
2004년에 렌탈한 고객의 이름, 성 조회
*/

SELECT DISTINCT c.first_name, c.last_name
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
WHERE r.rental_date BETWEEN '2005-01-01 00:00:00' AND '2005-12-31 23:59:59'; 

/*
10달러에서 11.99달러 사이의 모든 결제 정보를 조회
표시컬럼 : 고객번호, 결제날짜, 금액
*/

SELECT customer_id, payment_date, amount
FROM payment
WHERE amount BETWEEN 10.00 AND 11.99;

/* 
FA와 FR사이에 성이 속하는 고객을 조회
표시컬럼 : 성, 이름
*/

SELECT first_name, last_name
FROM customer
WHERE last_name >= 'FA'
AND last_name < 'FS';

/*
영화 제목에 'PET'이 포함된 영화의 등급과 같은 영화들의 제목과 등급
*/

SELECT title, rating
FROM film
WHERE rating 
IN(SELECT rating
	FROM film
	WHERE title LIKE '%PET%');

/*
성이 Q로 시작하는 고객 조회
*/

SELECT *
FROM customer
WHERE left(last_name, 1) = 'Q';

SELECT *
FROM customer
WHERE last_name LIKE 'Q%';

SELECT *
FROM customer
WHERE last_name > 'Q' 
AND last_name < 'R';

/*
미반납자 정보 조회
표시컬럼 : 대여id, 고객id
*/

SELECT rental_id, customer_id
FROM rental
WHERE return_date IS NULL;

/*
고객 번호가 5가 아니면서 결제날짜가 '2005-08-23'이거나 결제금액이 8달러 이상인 payment_id를 조회
*/

SELECT payment_id
FROM payment
WHERE customer_id != 5
AND ((payment_date BETWEEN '2005-08-23' AND '2005-08-23 23:59:59') OR amount >= 8.00);

