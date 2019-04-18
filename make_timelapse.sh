#!/bin/bash

FPS=25

indir=$(basename $1)
tmpdir=${indir}_resized

mkdir -p ${tmpdir}
i=1
for file in $(ls -1 ${indir}); do
    convert ${indir}/${file} -resize 640x640^ -gravity center -crop 640x480+0+0 +repage ${tmpdir}/$(printf "%05d" ${i}).jpg
    echo $(printf "%05d" ${i})
    i=$((1+$i))
    [ $i -eq 10 ] && break
done

ffmpeg -r ${FPS} -start_number 1 -i ${tmpdir}/%05d.jpg -c:v libx264 ${indir}.mp4