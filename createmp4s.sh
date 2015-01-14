#!/bin/sh

rm _temp_list.txt 2> /dev/null
rm "output/export.mp4" 2> /dev/null

for f in output/*
do
  if [ -d $f ]
  then
    echo "Processing $f"
    rm _temp_list.txt 2> /dev/null
    printf "file '%s'\n" $f.gif >> _temp_list.txt
    printf "file '%s'\n" $f.gif >> _temp_list.txt
    printf "file '%s'\n" $f.gif >> _temp_list.txt
    ffmpeg -r 12 -f concat -i _temp_list.txt -c copy -c:v libx264 -crf 12 "$f.mp4"
  fi
done

rm _temp_list.txt 2> /dev/null

