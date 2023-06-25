#!/bin/bash


# 遍历目录及子目录下所有超过100MB大小的文件
find . -type f -size +100M | while read file; do
  # 获取文件名并检查是否已经存在于.gitignore文件中
  filename="${file##*/}"
  if ! grep "$filename" .gitignore > /dev/null 2>&1 ; then
    # 如果文件名不存在于.gitignore文件中，则添加到末尾
    echo "$filename" >> .gitignore
  fi
done


git add .
date +%F > timefile
currentTime=$(<timefile)
git commit -m "Commit code. Update time: $currentTime "
git push
