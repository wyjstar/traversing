#!/bin/bash

echo "> memcached restart"
killall memcached
memcached -d -m10
exit 0
