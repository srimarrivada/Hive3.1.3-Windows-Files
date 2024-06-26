@echo off
@rem Licensed to the Apache Software Foundation (ASF) under one or more
@rem contributor license agreements.  See the NOTICE file distributed with
@rem this work for additional information regarding copyright ownership.
@rem The ASF licenses this file to You under the Apache License, Version 2.0
@rem (the "License"); you may not use this file except in compliance with
@rem the License.  You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.

set CLASS=org.apache.hadoop.hive.metastore.HiveMetaStore
pushd %HIVE_LIB%
for /f %%a IN ('dir /b hive-metastore-*.jar') do (
	set JAR=%HIVE_LIB%\%%a
)
popd
if [%1]==[metastore_help] goto :metastore_help

if [%1]==[metastore_catservice] goto :metastore_catservice

:metastore
	echo "Starting Hive Metastore Server"
	@rem hadoop 20 or newer - skip the aux_jars option and hiveconf
	set HADOOP_OPTS=%HIVE_METASTORE_HADOOP_OPTS% %HADOOP_OPTS%
	call %HIVE_BIN_PATH%\ext\util\execHiveCmd.cmd %JAR% %CLASS%
goto :EOF

:metastore_help
	set HIVEARGS=-h
	call %HIVE_BIN_PATH%\ext\util\execHiveCmd.cmd %JAR% %CLASS%
goto :EOF

:metastore_catservice
@echo ^<service^>
@echo   ^<id^>Metastore^</id^>
@echo   ^<name^>Metastore^</name^>
@echo   ^<description^>Hadoop Metastore Service^</description^>
@echo   ^<executable^>%JAVA_HOME%\bin\java^</executable^>
@echo   ^<arguments^>%JAVA_HEAP_MAX% %HADOOP_OPTS% %AUX_PARAM% -classpath %CLASSPATH% %CLASS% %HIVE_OPTS%^</arguments^>
@echo ^</service^>
goto :EOF
