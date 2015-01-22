#!/bin/sh

for f in output/*
do
  if [ -d $f ]
  then
    echo "Processing $f"
    rm "$f.gif" 2> /dev/null
    gifsicle --delay=2 --loop --colors 48 $f/*.gif > "$f.gif"
  fi
done

