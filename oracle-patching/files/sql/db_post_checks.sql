whenever sqlerror exit failure rollback
set pagesize 0 feedback off heading off verify off trimspool on linesize 500
select 'DB_STATE|' || nvl((select open_mode || '|' || database_role || '|' || log_mode from v$database), 'UNKNOWN|||') from dual;
select 'INSTANCE|' || nvl((select instance_name || '|' || status || '|' || version_full from v$instance), 'UNKNOWN||') from dual;
select 'INVALID_AFTER|' || nvl((select to_char(count(*)) from dba_objects where status = 'INVALID'), '0') from dual;
select 'REGISTRY_BAD|' || nvl((select to_char(count(*)) from dba_registry where status <> 'VALID'), '0') from dual;
select 'SQLPATCH_ERR|' || nvl((select to_char(count(*)) from dba_registry_sqlpatch where status <> 'SUCCESS' and action_time >= sysdate - 1), '0') from dual;
select 'SQLPATCH_LAST|' || nvl((select to_char(max(action_time), 'YYYY-MM-DD HH24:MI:SS') from dba_registry_sqlpatch), 'NONE') from dual;
select 'SERVICES|' || nvl((select listagg(name, ',') within group (order by name) from v$active_services), 'NONE') from dual;
exit