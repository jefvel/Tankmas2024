@echo off

echo.
echo updating all core haxe libs
echo.

call :install_or_update_lib serializers, common

call :install_or_update_lib promises, utils
call :install_or_update_lib logging, utils
call :install_or_update_lib haven, utils

call :install_or_update_lib db-core, db
call :install_or_update_lib db-sqlite, db
call :install_or_update_lib sqlite3, db
call :install_or_update_lib libsqlite3, db
call :install_or_update_lib db-mysql, db
call :install_or_update_lib mysql, db
call :install_or_update_lib entities, db

call :install_or_update_lib http, comms
call :install_or_update_lib rest, comms
call :install_or_update_lib ftp, comms
call :install_or_update_lib websockets, comms

call :install_or_update_lib queues-core, messaging
call :install_or_update_lib queues-rabbitmq, messaging
call :install_or_update_lib rabbitmq, messaging
call :install_or_update_lib json-rpc, messaging

call :install_or_update_lib libgit2, misc

exit /B %ERRORLEVEL%

:install_or_update_lib
echo --------------------------------------------------------------------
echo core\%~1
echo --------------------------------------------------------------------
if exist %~2\%~1 (
  echo updating %~2\%~1  
  cd %~2\%~1
  git pull
  cd ..\..
) else (
  echo creating %~2\%~1
  if not exist "%~2" mkdir %~2
  cd %~2
  git clone https://github.com/core-haxe/%~1 && cd %~1
  haxelib dev %~1 .
  cd ..\..
)
echo.
exit /B 0