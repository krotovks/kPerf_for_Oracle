create user c##kperf identified by "Test1234!";
grant create session to c##kperf;
grant select on V_$SYSTEM_EVENT to c##kperf;
grant select on v_$sysstat to c##kperf;
grant select on v_$sqlarea to c##kperf;
grant select on V_$SYS_TIME_MODEL to c##kperf;
grant select on cdb_segments to c##kperf;
grant select on cdb_data_files to c##kperf;
ALTER USER c##kperf set container_data=all container = current;
