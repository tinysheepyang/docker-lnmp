#!/bin/bash
mod_dir="/data/www/emao.com/trunk/serverconfig/nginx/online/conf.d/ssl"
if [ `pwd` = $mod_dir ]
then
	echo "build failed - already in correct directory"
	exit 1
else
	rm -drf $mod_dir
	cp -r ./ $mod_dir
	echo "build ok"
	exit 0
fi
