# kPerf For Oracle

kPerf provides a graphical view of activity in Oracle Database.
In the current implementation, statistics are collected at the instance level, including waits and some key statistics for sqlid:phv.

kPerf is free to use but protected by Pyarmor with an integrated license that expires on 2025-05-10.
The license will be updated in the next release. 
<img src="images/kPerfImages/sysEvent.png" alt="System Events">
<img src="images/kPerfImages/GrafVarEvents.png" alt="Select various types of database waits">
<img src="images/kPerfImages/SQLmodule.png" alt="SQL Module">
<img src="images/kPerfImages/SQLmodule_SQLID.png" alt="SQL Module">
<img src="images/kPerfImages/SQLmoduleDeepLevel.png" alt="SQL Module Level ">
<img src="images/kPerfImages/SQLmoduleDeepLevel_varible.png" alt="SQL Module Level SQLID PHV">

---

## Table of Contents
1. [Features](#features)
2. [Usage](#usage)
3. [Installation](#installation)

---

## Features

It is not required to create objects inside the Oracle database.
You only need to create a user in the database and grant the necessary privileges.
All collected data is processed in kPerf(Python).
The collected data is stored in Prometheus.
Grafana is used for data visualization (dashboards are included).
Currently, data is collected from v$system_event, v$sysstat, v$sqlarea, and v$sys_time_model.

Additional features will be available in the next release.

## Usage
	
1. kperf_Docker_Image - An autonomous image that includes kPerf, Prometheus, and Grafana.
The image is fully configured; you only need to run it by specifying your parameters (more details in the "Installation" section).
   
2. kPerf_Standalone - For standalone use. kPerf and Grafana dashboards are included (more details in the "Installation" section).

Both options can be used in the cases listed below and beyond:

- Database Performance Monitoring: The system allows real-time analysis of database activity, identifying bottlenecks and problematic queries.
- Performance Issue Diagnosis: Use data on wait events, system statistics, and SQL execution to detect and resolve performance issues.
- Long-term Trend Analysis: Store historical data in Prometheus to identify patterns in database resource usage.
- Integration with Existing Monitoring Systems: Visualization via Grafana can be seamlessly integrated into existing infrastructure.
	
Real-World Use Cases of kPerf:
- [The impact of a commit on task execution time.](https://krotovks.com/2024/05/19/oracle-the-impact-of-a-commit-on-task-execution-time/)
- [Unexplained growth a table size. Oracle 19.19, bug 30265523.](https://krotovks.com/2024/05/04/unexplained-growth-a-table-size-oracle-19-19-bug-30265523/)
- [Log file sync switching to post/wait.](https://krotovks.com/2023/02/21/log-file-sync-switching-to-post-wait-eng/)

and there's more to come.

	


## Installation

### Requirements

  - Python >= 3.9
  - target platforms: linux.x86_64
  - git-lfs
  - Docker (Optional)

### Installation Steps

0. Install git-lfs to download the Docker image.
1. Clone the repository:
   git clone https://github.com/krotovks/kPerf_for_Oracle.git
   	
	#### kperf_Docker_Image
		cd kperf_Docker_Image
		podman load -i kperf.2.0.9.tar
		Create a user in the Oracle database using createSQLuser.sql.
		The file kPerfENV_Docker contains the parameters for running the container:
		ORACLE_USER=c##kperf       --- Oracle user
		ORACLE_PASSWORD=Test1234!  --- User password
		ORACLE_HOST=10.1.61.128	   --- Ip addres of Oracle DB
		ORACLE_PORT=1521           --- Oracle port
		ORACLE_SERVICE_NAME=boston --- Service name
		HTTPPORT=9180			   --- Http for kPerf
		SNAPINTERVAL=2			   --- Interval between data collection
		
		Example of execution:
		podman run -it --env-file kPerfENV_Docker -p 3000:3000 -p 9180:9180 -p 9090:9090 kperf:2.0.9

	    CRIT Supervisor is running as root.  Privileges were not dropped because no user is specified in the config file.  If you intend to run as root,     you can set user=root in the config file to avoid this message.
	    INFO RPC interface 'supervisor' initialized
	    CRIT Server 'unix_http_server' running without any HTTP authentication checking
	    INFO supervisord started with pid 1
	    INFO spawned: 'grafana' with pid 8
	    INFO spawned: 'kPerf' with pid 9
	    INFO spawned: 'prometheus' with pid 10
	    INFO success: grafana entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
	    INFO success: kPerf entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
	    INFO success: prometheus entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)

	- Grafana URL:    http://Docker_IP:3000
	- kPerf URL:   	http://Docker_IP:9180
	- Prometheus URL: http://Docker_IP:9090/targets?search=
	- Inside the container, logs are available in /var/log/supervisor.
	
	#### kPerf_Standalone
	 The standalone version consists of kPerf and a Grafana dashboard located in the 'Boards' folder.
		
		cd kPerf_Standalone
		Create a user in the Oracle database using createSQLuser.sql.
		The kPerfENV file contains the startup parameters:
		ORACLE_USER=c##kperf       --- Oracle user
		ORACLE_PASSWORD=Test1234!  --- User password
		ORACLE_HOST=10.1.61.128	   --- Ip addres of Oracle DB
		ORACLE_PORT=1521           --- Oracle port
		ORACLE_SERVICE_NAME=boston --- Service name
		HTTPPORT=9180			   --- Http for kPerf
		SNAPINTERVAL=2			   --- Interval between data collection
		
		Example of execution:
		python3.9 ./kPerf.py
