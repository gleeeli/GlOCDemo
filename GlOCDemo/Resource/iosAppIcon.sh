#!/bin/bash
#使用说明：将1024.png图片与本脚本放在同一目录，即可生成ios APP各尺寸图标
dir=$(cd $(dirname $0); pwd)
echo "当前目录：$dir"
logo1024Path=$dir"/1024.png"
newDir=$dir"/appIcon"
allIcons=("icon-20-ipad" "icon-20@2x-ipad" "icon-20@2x" "icon-20@3x" "icon-29" "icon-29@2x" "icon-29@3x" "icon-40" "icon-40@2x" "icon-40@3x" "icon-60@2x" "icon-60@3x" "icon-76" "icon-76@2x" "icon-83.5@2x" "icon-1024")
allSizes=(20 40 40 60 29 58 87 40 80 120 120 180 76 152 167 1024)
length=${#allIcons[*]}
echo "总个数：$length"
#创建目录
mkdir $newDir
#for item in ${allIcons[*]}
for (( k=0; k < $length; k++ ))
do
 name=${allIcons[$k]}
 width=${allSizes[$k]}
 tmpPath=$newDir"/"$name".png"
 #复制一张
 cp -Rf ${logo1024Path} $tmpPath
 #设置大小
 sips -z $width $width $tmpPath
done

echo success



