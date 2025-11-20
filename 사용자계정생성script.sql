--SQL (Structured Query Language, 구조적 질의 언어)
--데이터베이스와 상호작용을 하기 위해 사용하는 표준언어
--데이터의 조회, 삽입, 수정, 삭제 등

--선택한 SQL 수행 : 구문에 커서두고 CTRL+ENTER
--전체 SQL 수행 : ALT+X

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--11G 이전 문법 사용 허용

CREATE USER todo_server IDENTIFIED BY todo1234;
--새로운 사용자 계정 생성 (sys:최고 관리자 계정)
--계정 생성 구문 (kh_chj : USERNAME / kh1234 : PASSWORD)
--ORA-65096: 공통 사용자 또는 롤 이름이 부적합합니다.

GRANT RESOURCE, CONNECT TO todo_server;
--사용자 계정에 권한 부여 설정
--RESOURCE : 테이블이나 인덱스 같은 DB 객체 생성할 권한
--CONNECT : DB에 연결하고 로그인 할 수 있는 권한

ALTER USER todo_server DEFAULT TABLESPACE SYSTEM QUOTA
UNLIMITED ON SYSTEM;
--객체가 생성될 수 있는 공간 할당량 무제한 지정

