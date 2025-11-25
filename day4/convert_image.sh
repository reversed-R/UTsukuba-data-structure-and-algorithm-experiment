#!/bin/zsh

for mmdfile in ./images/*.mmd
do
  echo "converting ${mmdfile} -> ${mmdfile:0:-4}.png"
  ../node_modules/.bin/mmdc -i $mmdfile -o ${mmdfile:0:-4}.png
done
