create user kperf identified by "Test1234!";
grant create session to c##kperf;
grant select on V_$SYSTEM_EVENT to kperf;
grant select on v_$sysstat to kperf;
grant select on v_$sqlarea to kperf;
grant select on V_$SYS_TIME_MODEL to kperf;