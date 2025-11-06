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
SET PROFILING = 1;
SHOW PROFILES;
SELECT @@profiling;

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