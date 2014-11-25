#!/usr/bin/bash

echo "> start"
sh bin/_db_create.sh
sh bin/_db_update.sh
sh bin/_db_insert.sh
sh bin/_mc_restart.sh
sh bin/_rd_flushall.sh
echo "> done"
