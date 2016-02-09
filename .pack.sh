#!/bin/sh
echo "current branch:"
git rev-parse --abbrev-ref HEAD
# make sure
echo "package type: $1"
#echo -n "version: "
#read version
version="unset"

while true;
do
    #echo "The version exist! please input a new version!"
    echo -n "version: "
    read version
    tagname="master-$version"
    git rev-parse --verify $tagname>/dev/null 2>&1
    #echo "tagname: $tagname result $?"
    if [ "$?" == "0" ]; then
        echo "The version exist! please input a new version!"
    else
        break
    fi
done

tagname="master-$version"
package="traversing_v$version"
temp_dir=/var/tmp/$package
echo $tagname
echo $package

proj_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp md5.sh /var/tmp
#[[ ! -d $proj_dir ]]&&proj_dir=~/traversing
echo -n "package: $package.tar.gz (Y/n):"
read confirm
if [ "$confirm" != "Y" ];then
    echo "abandoned pack"
    exit 0
fi

# copy to temp directory
if [ -d $temp_dir ];then
    rm -rf $temp_dir
fi
echo "mkdir $temp_dir"
mkdir $temp_dir

for dir in gfirefly gtwisted config test shared app deploy tool sdk appmain.py models.json mgc.config template.json startmaster.py push_dev.pem kuaiyong_pub.pem; do
    echo "cp -fr $dir $temp_dir"
    cp -fr $dir $temp_dir/
done

cd $temp_dir
echo "compile *.py to *.pyc"
find ./ -name '*.py' -exec python -m py_compile {} \;
cp startmaster.py ..
cp appmain.py ..
echo "clear useless files"
# find ./ -name '.*' -exec rm -rf {} \;
find ./ -name '~*' -exec rm -rf {} \;
find ./ -name '*.log' -exec rm -rf {} \;
# find ./ -name '*.py' -exec rm -rf {} \;
find ./ -name '*.zip' -exec rm -rf {} \;
find ./ -name '*.xls' -exec rm -rf {} \;

mv ../startmaster.py .
mv ../appmain.py .

rm startmaster.pyc
rm appmain.pyc
rm config/config.db
rm -fr config/excel
rm -fr config/json
rm -fr config/lua
rm -fr config/sql
rm -fr app/logs

cd ../
echo "tar -czf $package.tar.gz $package"
tar -czf $package.tar.gz $package
rm -rf $package

cd /var/tmp
echo "md5 $package.tar.gz"
./md5.sh $package.tar.gz > $package.md5

echo "pack $package success"

#echo -n "tag: $tagname (Y/n):"


#read confirm
#if [ "$confirm" == "Y" ];then
cd $proj_dir
git tag $tagname && git push --tags
echo "tag $tagname success"
#fi

echo -n "upload ftp (Y/n):"
read confirm

if [ "$confirm" != "Y" ];then
    exit 0
fi

echo "echo:" $1
ftp -n<<!
open 192.168.1.90 21003
user server server
cd server
cd $1
bin
put $package.tar.gz
put $package.md5
close
bye
!

