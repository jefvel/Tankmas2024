#!/bin/bash

echo
echo updating all core haxe libs
echo

install_or_update_lib() {
  echo "-------------------------------------------------------------------"
  echo "core/$1"
  echo "-------------------------------------------------------------------"
  if [ -d "$2/$1" ]
  then
    echo "updating $2/$1"
    cd $2/$1
    git pull
    cd ../..
  else
    echo "creating $2/$1"
    mkdir -p $2/$1
    cd $2
    git clone https://github.com/core-haxe/$1 && cd $1
    haxelib dev $1 .
    cd ../..
  fi  
  echo  
}

install_or_update_lib serializers common

install_or_update_lib promises utils
install_or_update_lib logging utils
install_or_update_lib haven utils

install_or_update_lib db-core db
install_or_update_lib db-sqlite db
install_or_update_lib sqlite3 db
install_or_update_lib libsqlite3 db
install_or_update_lib db-mysql db
install_or_update_lib mysql db
install_or_update_lib entities db

install_or_update_lib http comms
install_or_update_lib rest comms
install_or_update_lib ftp comms
install_or_update_lib websockets comms

install_or_update_lib queues-core messaging
install_or_update_lib queues-rabbitmq messaging
install_or_update_lib rabbitmq messaging
install_or_update_lib json-rpc messaging

install_or_update_lib libgit2 misc