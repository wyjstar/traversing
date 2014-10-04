#!/bin/bash
# traversing project deploy scripts.
# include:
# . start cobar for mysql
# . create mysql db & table
# . import config data
# . test port available && start traversing server
./create_db.sh
./stop.sh
./start.sh
