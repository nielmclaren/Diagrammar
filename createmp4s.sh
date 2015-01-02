#!/bin/sh

for f in output/*
do
  if [ -d $f ]
  then
    echo "Processing $f"
    rm "$f.mp4" 2> /dev/null
    rm _temp_list.txt 2> /dev/null
    for i in {1..8}; do printf "file '%s'\n" $f.gif >> _temp_list.txt; done
    ffmpeg -r 30 -f concat -i _temp_list.txt -c copy -c:v libx264 -crf 12 "$f.mp4"
  fi
done

