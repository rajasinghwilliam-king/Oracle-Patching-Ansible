whenever sqlerror exit failure rollback
set pagesize 0 feedback off heading off verify off trimspool on linesize 500
prompt SMOKE|CONNECT_OK
select 'SMOKE|DUAL|' || to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS') from dual;
exit