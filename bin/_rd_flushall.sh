#!/usr/bin/sh

echo "> flush redis"
telnet 127.0.0.1 6379 <<!
flushall
quit
!
exit 0
