#!/bin/bash
# coding: utf-8

# Batch encode all non-mp4 files. Pass zero or more directories as arguments.
# If no argument is given, current directory will be used
# HandBrakeCLI can be downloaded from http://handbrake.fr/downloads.php. Place
# it in /usr/bin or you can edit to suit your needs.

# Christian Bloch

# HandBrake options are detailed at https://trac.handbrake.fr/wiki/CLIGuide#options
OPTIONS="
    --encoder x264
    --quality 20.0
    --rate 29.97
    --pfr
    --aencoder faac
    --ab 160
    --mixdown dpl2
    --drc 1.0
    --format mp4
    --decomb
    --subtitle scan
    --native-language English
    --native-dub
    --large-file
    --maxWidth 1920 --maxHeight 1080
    --loose-anamorphic
    --optimize
    --markers"

# File extensions to encode
FORMATS="avi mkv mpg divx mov ogm wmv asf flv"
UPPERCASE_FORMATS=$(echo $FORMATS | tr "a-z" "A-Z")
FORMATS="$FORMATS $UPPERCASE_FORMATS"

# Set directories to be processed; current if no arguments are passed
if [ $# -eq 0 ]; then
  dirs=${PWD}
else
  dirs=${*}
fi  

# Process all the directories!
for dir in ${dirs[@]}; do
  cd ${dir}
  if [ ! -d "_original" ]; then
    mkdir '_original'
  fi
  if [ ! -d "_encoded" ]; then
    mkdir "_encoded"
  fi
  
  # Check all the formats!
  for format in ${FORMATS[@]}; do
    files="*.${format}"
    
    # Encode all the files!
    for file in ${files[@]}; do
      if [ -f "${file}" ]; then
        out_name=$(echo ${file} | sed -e "s/${format}/m4v/g")
        /usr/bin/HandBrakeCLI -i "${file}" -o "${out_name}" $OPTIONS
        mv "${file}" "./_original/"
        mv "${out_name}" "./_encoded/"
      fi
    done
  done
done
exit 0
