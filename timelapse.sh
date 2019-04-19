#!/bin/bash
# usage: $0 <directory with images>

w=1920
h=1080

in_dir=$(basename $1)
tmp_dir=${in_dir}-${h}p

# GO Pro
# fps=25
# gravity=North
# yoffset=0

# Lumix
fps=16
gravity=Center
y_offset=160

im_opts='-quality 95 -unsharp 0x1'
if [ ! -d ${tmp_dir} ]; then
    mkdir -p ${tmp_dir}
    find ${in_dir} -iname '*.jpg' | sort | \
        parallel --bar \
            convert {} ${im_opts} \
                -resize ${w}x${w}^ \
                -gravity ${gravity} \
                -crop ${w}x${h}+0+${y_offset} \
                +repage \
                ${tmp_dir}/{= '$_=sprintf("%05d",seq())' =}.jpg
fi

# High quality
fm_opts='-preset slow -crf 18 -x264-params me=umh:merange=24:trellis=1:level=4.1:ref=5'
# Fast
# fm_opts='-preset veryfast'
ffmpeg -r ${fps} \
    -start_number 1 \
    -i ${tmp_dir}/%05d.jpg \
    -c:v libx264 \
    ${fm_opts} \
    ${in_dir}.mp4