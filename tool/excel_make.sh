#!/usr/bin/env bash
cd ~/work/traversing/config/
git clean -df
echo "1========"
cd ~/work/traversing/tool/excel_maker
echo "2========"
cp cjson.so ~/work/traversing/tool/excel_maker/
python excel_maker.py "../../config/" $1 

