#!/bin/sh

for f in output/*
do
  if [ -d $f ]
  then
    echo "Processing $f"
    rm "$f.gif" 2> /dev/null
    gifsicle --delay=3 --loop --colors 256 $f/*.gif > "$f.gif"
  fi
done

