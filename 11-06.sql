# 성이 'Radwan'이고 성별이 남자인 사원 조회
EXPLAIN
SELECT *
FROM employees
WHERE gender = 'M'
  AND last_name = 'Radwan';

SELECT *
FROM employees
WHERE CONCAT('1', '2');

# 부서 관리자의 사원번호, 이름, 성, 부서번호 데이터를 중복 제거하여 조회
EXPLAIN
SELECT DISTINCT d.emp_no, e.first_name, e.last_name, d.dept_no
FROM dept_manager d
         JOIN employees e
              ON d.emp_no = e.emp_no;

# 성이 'Baba'이면서 성별이 남자인 사원과 성이 'Baba'이면서 성별이 여자인 사원을 조회
SELECT *
FROM employees
WHERE gender IN ('F', 'M')
  AND last_name = 'Baba';

# 성과 성별 순서로 그룹핑하여 몇건의 데이터가 있는지 구하시오
SELECT last_name, gender, COUNT(1) AS count
FROM employees
GROUP BY gender, last_name;

# 사원의 입사일자 값이 '1989'로 시작하면서 사원번호가 100,000을 초과하는 사원의 데이터 조회

EXPLAIN
SELECT *
FROM employees
WHERE hire_date BETWEEN '1989-01-01' AND '1989-12-31'
  AND emp_no > 100000;

EXPLAIN
SELECT *
FROM employees USE INDEX (i_입사일자)
WHERE hire_date BETWEEN '1989-01-01' AND '1989-12-31'
  AND emp_no > 100000;

# emp_access_logs(사원출입기록), door(출입문) 'B'출입문으로 출입한 이력이 있는 정보를 모두 조회
SELECT *
FROM emp_access_logs
WHERE door = 'B';

# 입사일자가 1994년 1월 1일부터 2000년 12월 31일까지인 사원들의 이름과 성

EXPLAIN
SELECT first_name, last_name
FROM employees FORCE INDEX (i_입사일자)
WHERE hire_date BETWEEN '1994-01-01' AND '2000-12-31';


# 부서사원 테이블(dept_emp)과 부서(departments)테이블을 조인하여 부서 시작일자가 '2002-03-01'부터인 사원의 데이터를 조회
# 표시컬럼 : 사원번호, 부서번호

EXPLAIN
SELECT STRAIGHT_JOIN e.emp_no, e.dept_no
FROM dept_emp e
         JOIN departments d
              ON e.dept_no = d.dept_no
WHERE e.from_date >= '2002-03-01';

# 4.3.2 사원번호가 450,000보다 크고 최대 연봉이 100,000보다 큰 데이터를 찾아 출력하시오.
# 즉, 사원번호가 450,000번을 초과하면서 그동안 받은 연봉 중 한 번이라도 100,000달러를
# 초과한 적이 있는 사원의 정보를 출력

SELECT DISTINCT e.emp_no, e.first_name, e.last_name
FROM employees e
         JOIN salaries s
              ON e.emp_no = s.emp_no
WHERE e.emp_no > 450000
  AND salary > 100000;

# 'A'출입문으로 출입한 사원이 총 몇명인지 구하시오
SELECT COUNT(DISTINCT emp_no)
FROM emp_access_logs
WHERE door = 'A';

SELECT e.emp_no, s.avg_salary, s.max_salary, s.min_salary
FROM employees e
         INNER JOIN (SELECT emp_no,
                            ROUND(AVG(salary), 0) AS avg_salary,
                            ROUND(MAX(salary), 0) AS max_salary,
                            ROUND(MIN(salary), 0) AS min_salary
                     FROM salaries
                     GROUP BY emp_no) s
                    ON s.emp_no = e.emp_no
WHERE e.emp_no BETWEEN 10001 AND 10100;

SELECT e.emp_no,
       e.first_name,
       e.last_name,
       ROUND(AVG(salary), 0) AS avg_salary,
       ROUND(MAX(salary), 0) AS max_salary,
       ROUND(MIN(salary), 0) AS min_salary
FROM employees e
         JOIN salaries s
              ON e.emp_no = s.emp_no
WHERE e.emp_no BETWEEN 10001 AND 10100
GROUP BY e.emp_no;

SELECT e.emp_no, e.first_name, e.last_name, e.hire_date
FROM employees e
         INNER JOIN salaries s
                    ON s.emp_no = e.emp_no
WHERE e.emp_no BETWEEN 10001 AND 50000
GROUP BY e.emp_no
ORDER BY SUM(s.salary) DESC
LIMIT 150, 10;

SELECT e.emp_no, e.first_name, e.last_name, e.hire_date
FROM employees e
         JOIN (SELECT s.emp_no
               FROM salaries s
               WHERE s.emp_no BETWEEN 10001 AND 50000
               GROUP BY s.emp_no
               ORDER BY SUM(s.salary) DESC
               LIMIT 150, 10) sa
              ON sa.emp_no = e.emp_no;
SET PROFILING = 1;
SHOW PROFILES;
SELECT @@profiling;

-- 5.1.3 필요 이상으로 많은 정보를 가져오는 나쁜 SQL 문

SELECT COUNT(s.emp_no) AS cnt
FROM (SELECT e.emp_no, dm.dept_no
      FROM (SELECT *
            FROM employees
            WHERE gender = 'M'
              AND emp_no > 300000) e
               LEFT JOIN dept_manager dm
                         ON dm.emp_no = e.emp_no) s;

SELECT COUNT(s.emp_no) AS cnt
FROM (SELECT e.emp_no
      FROM (SELECT *
            FROM employees
            WHERE gender = 'M'
              AND emp_no > 300000) e) s;

EXPLAIN
SELECT COUNT(e.emp_no) AS cnt
FROM employees e FORCE INDEX (`PRIMARY`)
WHERE gender = 'M'
  AND emp_no > 300000;

SHOW VARIABLES LIKE 'profiling%';

SET profiling_history_size = 20;

# 대랑의 데이터를 가져와 조인하는 나쁜 sql문
SELECT DISTINCT de.dept_no
FROM dept_manager dm
         INNER JOIN dept_emp de
                    ON de.dept_no = dm.dept_no
ORDER BY de.dept_no;

