# -*- coding:utf-8 -*-
"""
created by server on 14-6-16下午4:20.
"""
from collections import OrderedDict
import os
import xlrd
import json

PROP_TABLE = ['base_config']


def ExcelToJson(ExcelFileName, SheetName, json_path):
    data = xlrd.open_workbook(ExcelFileName)
    table = data.sheet_by_name(SheetName)
    objName = ExcelFileName[:len(ExcelFileName) - 5]
    jsonFileName = json_path + SheetName + ".json"

    if SheetName not in PROP_TABLE:
        table2jsn(table, jsonFileName, SheetName)
    else:
        table2jsn_prop(table, jsonFileName, SheetName)


def FloatToString(aFloat):
    if type(aFloat) != float:
        return ""
    strTemp = str(aFloat)
    strList = strTemp.split(".")
    if len(strList) == 1:
        return strTemp
    else:
        if strList[1] == "0":
            return strList[0]
        else:
            return strTemp


def format_by_type(format_type, value):
    format_type = str(format_type).lower()

    if format_type == 'int':
        return int(value)

    if format_type == 'float':
        return float(value)

    if format_type == 'dict':
        return eval(value)

    if format_type == 'list':
        return eval(value)

    if format_type == 'str':
        if type(value) is float:
            return str(value).split('.')[0]
        return value.encode("utf-8")


def table2jsn(table, jsonFileName, objName, cur=None):
    """标准表格式，每行一条数据"""
    nrows = table.nrows
    ncols = table.ncols

    obj_list = []
    for rownum in range(nrows):
        if rownum == 0 or rownum == 1 or rownum == 2:
            continue

        obj = OrderedDict()
        for c in range(ncols):
            print rownum, c, "+++++++++++++++++++++"
            prop_name = table.cell_value(1, c).encode("utf-8")
            prop_name = prop_name.strip()

            if prop_name == '#' or not prop_name:
                continue

            obj[prop_name] = format_by_type(table.cell_value(2, c), table.cell_value(rownum, c))

        obj_list.append(obj)


    with open(jsonFileName, mode='wb') as f:
        json.dump(obj_list, f)


def table2jsn_prop(table, jsonFileName, objName):
    """属性表格式，每行一个属性"""
    nrows = table.nrows

    obj = {}
    begin_cols = 0
    for col in range(table.ncols):
        if table.cell_value(1, col) == "#":
            begin_cols += 1
        else:
            break
    for rownum in range(nrows):
        if rownum == 0 or rownum == 1 or rownum == 2:
            continue
        #print rownum, "row num +++++++++++++++++++++++"
        prop_name = table.cell_value(rownum, 0 + begin_cols).encode("utf-8")
        prop_name = prop_name.strip()

        obj[prop_name] = format_by_type(table.cell_value(rownum, 1 + begin_cols),
                                        table.cell_value(rownum, 2 + begin_cols))
    with open(jsonFileName, mode='wb') as f:
        json.dump(obj, f)


if __name__ == "__main__":
    root_path = "data/"
    json_path = "configs_data/json_data/"
    content = []
    for file_name in os.listdir(root_path):
        if not file_name.endswith("xlsx"):
            continue
        file_path = root_path + file_name
        file_with_out_extension = os.path.splitext(file_name)[0]
        print file_path, file_with_out_extension
        ExcelToJson(file_path, file_with_out_extension, json_path)


