#!/bin/bash

echo "protoc *.proto file"
protoc -I=app/proto_file/proto/ --python_out=app/proto_file/ app/proto_file/proto/*
echo "done"
exit
