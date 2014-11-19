#!/usr/bin/env bash
cd ../app/proto_file/proto
protoc -I=. --python_out=.. ./*
