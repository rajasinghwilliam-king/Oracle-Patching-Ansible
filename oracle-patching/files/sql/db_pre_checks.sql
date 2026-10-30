whenever sqlerror exit failure rollback
set pagesize 0 feedback off heading off verify off trimspool on linesize 500
select 'DB_STATE|' || nvl((select open_mode || '|' || database_role || '|' || log_mode from v$database), 'UNKNOWN|||') from dual;
select 'INSTANCE|' || nvl((select instance_name || '|' || status || '|' || version_full from v$instance), 'UNKNOWN||') from dual;
select 'ACTIVE_SESSIONS|' || nvl((select to_char(count(*)) from v$session where type = 'USER' and status = 'ACTIVE'), '0') from dual;
select 'OPEN_TXNS|' || nvl((select to_char(count(*)) from v$transaction), '0') from dual;
select 'INVALID_BASELINE|' || nvl((select to_char(count(*)) from dba_objects where status = 'INVALID'), '0') from dual;
select 'REGISTRY_BAD|' || nvl((select to_char(count(*)) from dba_registry where status <> 'VALID'), '0') from dual;
select 'SQLPATCH_LAST|' || nvl((select to_char(max(action_time), 'YYYY-MM-DD HH24:MI:SS') from dba_registry_sqlpatch), 'NONE') from dual;
select 'TBS_MAX_USED_PCT|' || nvl((select to_char(round(max(used_percent), 2)) from dba_tablespace_usage_metrics), '0') from dual;
select 'FRA_USED_PCT|' || nvl((select to_char(round(max(space_used * 100 / nullif(space_limit, 0)), 2)) from v$recovery_file_dest), '0') from dual;
select 'LAST_BACKUP_HRS|' || nvl((select to_char(round((sysdate - max(end_time)) * 24, 2)) from v$rman_backup_job_details where status = 'COMPLETED'), '-1') from dual;
select 'APPLY_LAG_SEC|' || nvl((select to_char(extract(day from to_dsinterval(value)) * 86400 + extract(hour from to_dsinterval(value)) * 3600 + extract(minute from to_dsinterval(value)) * 60 + extract(second from to_dsinterval(value))) from v$dataguard_stats where name = 'apply lag'), '-1') from dual;
exit