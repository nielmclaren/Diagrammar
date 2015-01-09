#!/bin/sh

rm _temp_list.txt 2> /dev/null
rm "output/export.mp4" 2> /dev/null

for f in output/*
do
  if [ -d $f ]
  then
    echo "Processing $f"
    printf "file '%s'\n" $f.gif >> _temp_list.txt
  fi
done

ffmpeg -r 3 -f concat -i _temp_list.txt -c copy -c:v libx264 -crf 12 "output/export.mp4"
rm _temp_list.txt 2> /dev/null

