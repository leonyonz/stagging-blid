#!/bin/bash

#add file and directory

git add .

#add commit message
read -p "Masukan Commit : " commit
echo ""
git commit -m "$commit"

#push to master
git push origin master
