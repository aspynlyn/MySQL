CREATE TABLE 개인고객2(
    고객번호 BIGINT PRIMARY KEY
  , 주민등록번호 VARCHAR(14) NOT NULL UNIQUE
  , 생년월일 DATE
  , 성별 VARCHAR(1) CHECK (성별 IN ('F', 'M'))
  , 결혼여부 VARCHAR(1) CHECK (결혼여부 IN ('O', 'X'))
);

CREATE TABLE 법인고객2(
    고객번호 BIGINT PRIMARY KEY
  , 법인등록번호 VARCHAR(14) NOT NULL UNIQUE
  , 대표자명 VARCHAR(5)
  , 설립일자 DATE
);

CREATE TABLE 고객2 (
    고객번호 BIGINT PRIMARY KEY
  , 고객명 VARCHAR(5) NOT NULL
  , 고객구분코드 VARCHAR(2) NOT NULL
);

-- 개인고객 트리거 생성
DROP TRIGGER if EXISTS tg_insert_개인고객_고객번호2;
DELIMITER $$

CREATE TRIGGER tg_insert_개인고객_고객번호2
BEFORE INSERT ON 개인고객2
FOR EACH ROW
BEGIN
    DECLARE num INT;
	SET num = 0;

	SELECT COUNT(1) INTO num FROM 법인고객2 WHERE 고객번호 = NEW.고객번호;

	if num != 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '법인 고객2에 존재하는 중복된 고객번호입니다.';
	END if;

END; $$
DELIMITER ;

DROP TRIGGER if EXISTS tg_update_개인고객_고객번호2;
DELIMITER $$

CREATE TRIGGER tg_update_개인고객_고객번호2
BEFORE UPDATE ON 개인고객2
FOR EACH ROW
BEGIN
	DECLARE num INT;
	SET num = 0;

	SELECT COUNT(1) INTO num FROM 법인고객2 WHERE 고객번호 = NEW.고객번호;

	if num != 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '법인 고객2에 존재하는 중복된 고객번호입니다.';
	END if;

END; $$
DELIMITER ;

-- 법인고객 트리거 생성
DROP TRIGGER if EXISTS tg_insert_법인고객_고객번호2;
DELIMITER $$

CREATE TRIGGER tg_insert_법인고객_고객번호2
BEFORE INSERT ON 법인고객2
FOR EACH ROW
BEGIN
	DECLARE num INT;
	SET num = 0;

	SELECT COUNT(1) INTO num FROM 개인고객2 WHERE 고객번호 = NEW.고객번호;

	if num != 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '개인 고객2에 존재하는 중복된 고객번호입니다.';
	END if;

END; $$
DELIMITER ;


DROP TRIGGER if EXISTS tg_update_법인고객_고객번호2;
DELIMITER $$

CREATE TRIGGER tg_update_법인고객_고객번호2
BEFORE update ON 법인고객2
FOR EACH ROW
BEGIN
	DECLARE num INT;
	SET num = 0;

	SELECT COUNT(1) INTO num FROM 개인고객2 WHERE 고객번호 = NEW.고객번호;

	if num != 0 then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '개인 고객2에 존재하는 중복된 고객번호입니다.';
	END if;

END; $$
DELIMITER ;

-- 기초자료 입력
INSERT INTO 개인고객2
   SET 고객번호 = 1
     , 주민등록번호 = '901010-1770001';

INSERT INTO 고객2
   SET 고객번호 = 1
     , 고객명 = '개인고객1'
     , 고객구분코드 = '개인';

INSERT INTO 법인고객2
   SET 고객번호 = 2
     , 법인등록번호 = '130111-0006246';

INSERT INTO 고객2
   SET 고객번호 = 2
     , 고객명 = '삼성전자'
     , 고객구분코드 = '법인';

-- 트리거로 인한 에러 발생
INSERT INTO 개인고객2
   SET 고객번호 = 2
     , 주민등록번호 = '901011-1770002';

UPDATE 개인고객2
   SET 고객번호 = 2
 WHERE 고객번호 = 1;

INSERT INTO 법인고객2
   SET 고객번호 = 1
     , 법인등록번호 = '130111-0006247';

UPDATE 법인고객2
   SET 고객번호 = 1
 WHERE 고객번호 = 2;

-- 중복되지 않은 고객번호는 insert성공
INSERT INTO 개인고객2
   SET 고객번호 = 3
     , 주민등록번호 = '901010-1770002';

INSERT INTO 고객2
   SET 고객번호 = 3
     , 고객명 = '개인고객2'
     , 고객구분코드 = '개인';