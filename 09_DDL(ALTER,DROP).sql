--DDL(Data Definition Language):데이터 정의 언어
--객체를 만들고(CREATE), 바꾸고(ALTER), 삭제(DROP)하는 데이터 정의 언어

--ALTER(바꾸다, 수정하다, 변조하다)
--테이블에서 바꿀!! 수 있는 것
--1)제약조건(추가/삭제) *제약조건 자체 수정구문 별도 없음, 삭제 후 추가!!
--2)컬럼(추가/수정/삭제)
--3)이름변경(테이블명, 컬럼명, 졔약조건명)


--1)제약조건(추가/삭제)
--[작성법]
--1)추가:ALTER TABLE 테이블명
--		ADD [CONSTRAINT 제약조건명] 제약조건(지정할컬럼명) <--PK시 여기까지
--		[REFERENCES 테이블명[(컬럼명)]; <--FK인 경우 추가, 없음 PK로 자동설정

--2)삭제:ALTER TABLE 테이블명 DROP CONSTARAINT 제약조건명;

--DEPARTMENT 테이블 복사 (컬럼명, 데이터타입, NOT NULL 조건만 복사)
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

--DEPT_COPY의 DEPT_TITLE 컬럼에 UNIQUE 추가
-->데이터 변경임, ALTER 써야돼
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_TITLE_U UNIQUE(DEPT_TITLE);
				--제약조건명

--DEPT_COPY의 DEPT_TITLE 컬럼에 설정된 UNIQUE 삭제
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_TITLE_U;

--**DEPT_COPY의 DEPT_TITLE 컬럼에 NOT NULL 제약조건 추가/삭제**
ALTER TABLE DEPT_COPY
DROP CONSTRAINT DEPT_COPY_TITLE_NN NOT NULL(DEPT_TITLE);
-- ORA-01735: 부적합한 ALTER TABLE 옵션입니다
-->NOT NULL 제약조건은 새조건을 추가하는게 아닌 컬럼 자체에
--NULL을 허용/비허용 제어하는 성질변경형태로 인식됨

--ㅡMODYFY(수정하다) 구문을 사용해 NULL 제어
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NOT NULL; --DEPT_TITLE 컬럼에 NULL 비허용

ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE NULL; --DEPT_TITLE 컬럼에 NULL 허용

---------------------------------

--2.컬럼(추가/수정/삭제)

--컬럼추가
--ALTER TABLE 테이블명 ADD(컬럼명 데이터타입 [DEFAULT '값'])

--컬럼수정
--ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입; --데이터타입 변경
--ALTER TABLE 테이블명 MODIFY DEFAULT '값'; --DEFAULT 값 변경

--컬럼삭제
--ALTER TABLE 테이블명 DROP (삭제할 컬럼명);
--ALTER TABLE 테이블명 DROP COLUMN 삭제할걸럼명;

SELECT * FROM DEPT_COPY;

--CNAME 컬럼추가
ALTER TABLE DEPT_COPY ADD (CNAME VARCHAR2(30));

--LNAME 컬럼추가 (기본값 '한국')
ALTER TABLE DEPT_COPY ADD (LNAME VARCHAR2(30) DEFAULT '한국');

SELECT * FROM DEPT_COPY;
-->컬럼이 생성되면서 DEFAULT 값 자동삽임됨 확인

--D10 개발1팀 추가
INSERT INTO DEPT_COPY
VALUES('D10', '개발1팀', 'L1', DEFAULT, DEFAULT);
--ORA-12899: "KH_CHJ"."DEPT_COPY"."DEPT_ID" 열에 대한 값이 너무 큼(실제: 3, 최대값: 2)
-->DEPT_ID의 데이터타입이 CHAR(2)이므로 영어+숫자 2글자까지 저장가능
-->D10은 영어+숫자 3글자!!
-->VARCHAR2(3)으로 변경해보기 (남는 바이트메모리 반환을 위해)

--DEPT_ID 컬럼 데이터타입 수정
ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(3);

SELECT * FROM DEPT_COPY;
-->컬럼의 데이터 타입 변경 후 위 INSERT 수행->삽입성공확인
-->INSERT시 컬럼 데이터는 다 채워야됨, 디폴트없으면 오류

--LNAME의 기본값을 'KOREA'로 수정
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT 'KOREA';
SELECT * FROM DEPT_COPY;
-->기본값 변경해도 소급적용안됨
-->새로 삽입될 행부터 변경된 기본값 적용

--LNAME '한국'->'KOREA' 변경
UPDATE DEPT_COPY SET 
LNAME=DEFAULT
WHERE LNAME='한국';

COMMIT;

--DEPT_COPY 모든 컬럼 삭제
ALTER TABLE DEPT_COPY DROP(LNAME);
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE; --삭제불가
--ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다

--테이블 삭제
DROP TABLE DEPT_COPY;

SELECT * FROM DEPT_COPY;
--ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

--DEPARTMENT 테이블 복사해서 DEPT_COPY 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;
-->컬럼명, 데이터타입, NOT NULL 여부만 복사

--DEPT_COPY 테이블에 PK 추가(컬럼:DEPT_ID, 제약조건명:D-COPY-PK)
ALTER TABLE DEPT_COPY ADD CONSTRAINT D_COPY_OK PRIMARY KEY(DEPT_ID);

--3.이름변경(컬럼, 테이블, 제약조건명)

--1)컬럼명 변경(DEPT_TITLE->DEPT_NAME)
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME; 

--2)제약조건명 변경(D_COPY_PK->DEPT_COPY_PK)
ALTER TABLE DEPT_COPY RENAME CONSTRAINT D_COPY_OK TO DEPT_COPY_PK;

--3)테이블명 변경(DEPT_COPY->DCOPY)
ALTER TABLE DEPT_COPY RENAME TO DCOPY;

SELECT * FROM DEPT_COPY;
--ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

SELECT * FROM DCOPY; --조회가능

-------------------------

--4.테이블삭제
--DROP TABLE 테이블명 [CASCADE CONSTRAINTS];

--1) 관계미형성 테이블삭제
DROP TABLE DCOPY;

--2) 관계형성된 테이블삭제
CREATE TABLE TB1(
TB1_PK NUMBER PRIMARY KEY ,
TB1_COL NUMBER
); --부모테이블

CREATE TABLE TB2(
TB2_PK NUMBER PRIMARY KEY,
TB2_COL NUMBER REFERENCES TB1
); --자식테이블

--TB1에 샘플데이터 삽입
INSERT INTO TB1 VALUES(1, 100); --1:PK
INSERT INTO TB1 VALUES(2, 100); --2:PK
INSERT INTO TB1 VALUES(3, 100); --3:PK

--TB2에 샘플데이터 삽입
INSERT INTO TB2 VALUES(11, 1); --1, 2, 3:FK
INSERT INTO TB2 VALUES(12, 2);
INSERT INTO TB2 VALUES(13, 3);

COMMIT;

--TB1과 TB2는 부모-자식 테이블 관계 형성

--부모인 TB1 테이블 삭제시
DROP TABLE TB1;
--ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
-->해결방법
--1)자식,부모테이블 순서로 삭제
-- 2) ALTER 를 이용해서 FK 제약조건 삭제 후 TB1 삭제
-- 3) DROP TABLE 삭제옵션 CASCADE CONSTRAINTS 사용
--> CASCADE CONSTRAINTS : 삭제하려는 테이블과 연결된 FK 제약조건을 모두 삭제

DROP TABLE TB1 CASCADE CONSTRAINTS; 
-- 테이블 삭제 시 FK 관계도 모두 삭제

SELECT * FROM TB1; -- 삭제확인됨
-- ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

SELECT * FROM TB2; -- TB2 테이블은 독립접인 테이블로 혼자 남게됨(아무 관계 없음) 

--------------------------------------------------------------

-- DDL 주의 사항
-- 1) DDL 은 COMMIT/ROLLBACK 의 대상이 아님. 
-- 2) DDL 과 DML 구문 섞어서 수행하면 안된다!
--> DDL은 수행 시 존재하고 있는 트랜잭션을 모두 DB에 강제 COMMIT 시킴!
--> DDL이 종료된 후 DML 구문을 수행할 수 있도록 하자 (권장)
-- DDL(CREATE,ALTER,DROP) : 객체 생성/수정/삭제
-- DML(INSERT/UPDATE/DELETE) : 데이터(행) 추가/갱신/삭제

SELECT * FROM TB2;

COMMIT;

-- DML 
INSERT INTO TB2 VALUES(14, 4);
INSERT INTO TB2 VALUES(15, 5);

SELECT * FROM TB2;

-- DDL (컬럼명 변경)
ALTER TABLE TB2 RENAME COLUMN TB2_COL TO TB2_COLUMN;

ROLLBACK;

SELECT * FROM TB2;
-- 롤백 안된다. 
-- 위에서 DDL 구문 중 ALTER 를 사용하여 그 시점에 COMMIT 됨