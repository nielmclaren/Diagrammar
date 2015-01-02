#!/bin/sh

#ffmpeg -i output/export0000.mp4 -i output/export0003.mp4 -filter_complex "
#nullsrc=size=540x360 [background];
#[0:v] setpts=PTS-STARTPTS, scale=270x360 [left];
#[1:v] setpts=PTS-STARTPTS, scale=270x360 [right];
#[background][left] overlay=shortest=1 [background+left];
#[background+left][right] overlay=shortest=1:x=270 [left+right]
#" -map "[left+right]" stitched.mp4

ffmpeg \
  -i output/export0000.mp4 \
  -i output/export0001.mp4 \
  -i output/export0002.mp4 \
  -i output/export0003.mp4 \
  -i output/export0004.mp4 \
  -i output/export0005.mp4 \
  -filter_complex "
nullsrc=size=810x720 [background];
[0:v] setpts=PTS-STARTPTS, scale=270x360 [tl];
[1:v] setpts=PTS-STARTPTS, scale=270x360 [tc];
[2:v] setpts=PTS-STARTPTS, scale=270x360 [tr];
[3:v] setpts=PTS-STARTPTS, scale=270x360 [ml];
[4:v] setpts=PTS-STARTPTS, scale=270x360 [mc];
[5:v] setpts=PTS-STARTPTS, scale=270x360 [mr];
[background][tl] overlay=shortest=1 [background+tl];
[background+tl][tc] overlay=shortest=1:x=270 [tl+tc];
[tl+tc][tr] overlay=shortest=1:x=540 [tl+tc+tr];
[tl+tc+tr][ml] overlay=shortest=1:y=360 [tl+tc+tr+ml];
[tl+tc+tr+ml][mc] overlay=shortest=1:x=270:y=360 [tl+tc+tr+ml+mc];
[tl+tc+tr+ml+mc][mr] overlay=shortest=1:x=540:y=360 [tl+tc+tr+ml+mc+mr]
" -map "[tl+tc+tr+ml+mc+mr]" stitched.mp4
