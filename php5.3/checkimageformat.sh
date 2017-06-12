#!/bin/bash
export PATH=/usr/local/image/bin:$PATH
for format in JPG JPEG JP2 PNG GIF BMP ICO WBMP XBM TIFF
do
	if [ `identify -list format | grep $format | wc -l` -gt 0 ]
	then
		echo "$format - ok"
	else
		echo "$format - fail"
	fi
done
