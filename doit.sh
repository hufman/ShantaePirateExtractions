#!/bin/bash

BASE=`pwd`

[ -e quickbms.zip ] || wget http://aluigi.altervista.org/papers/quickbms.zip
[ -e quickbms.exe ] || unzip quickbms.zip
[ -x quickbms.exe ] || chmod +x quickbms.exe

[ -e MSFHDEx.zip ] || wget https://dl.dropboxusercontent.com/u/31816885/programs/MSFHDEx.zip
[ -e animEx.exe ] || unzip MSFHDEx.zip
[ -x animEx.exe ] || chmod +x animEx.exe
[ -x imageEx.exe ] || chmod +x imageEx.exe
[ -x volEx.exe ] || chmod +x volEx.exe

# remember where the utils are
animEx=`pwd`/animEx.exe
imageEx=`pwd`/imageEx.exe
volEx=`pwd`/imageEx.exe

# extraction functions
extractVol() {
  # assert(pwd==$BASE)
  vol="$1"
  extractedvol=`echo "$vol" | sed 's|extracted/|extractedvol/|' | sed -E 's|/([A-Z]+)/([^/]+)/|/\1/\2-|' | sed 's|\.[^/.]*$||'`
  [ -d "$extractedvol" ] && return
  mkdir -p "$extractedvol"
  ./quickbms.exe wayforward.bms "$vol" "$extractedvol" 2>/dev/null
}
extractAnim() {
  # assert(pwd==$BASE)
  anim="$1"
  name=`basename "$anim"`
  tmp=/tmp/"$name".$$
  output=`echo "$anim" | sed 's|extractedvol/|anim/|' | sed 's|\.[^/.]*$||'`
  [ -d "$output" ] && return
  mkdir "$tmp"
  cp "$anim" "$tmp"
  pushd "$tmp" >/dev/null
  "$animEx" "$name" 2>/dev/null
  popd >/dev/null
  mkdir -p "$output"
  mv "$tmp"/output/*/* "$output"
  rm -r "$tmp"
}
extractImage() {
  # assert(pwd==$BASE)
  image="$1"
  name=`basename "$image"`
  tmp=/tmp/"$name".$$
  output=`echo "$image" | sed 's|extractedvol/|image/|' | sed 's|\.[^/.]*$||'`
  [ -d "$output" ] && return
  mkdir "$tmp"
  cp "$image" "$tmp"
  pushd "$tmp" >/dev/null
  "$imageEx" "$tmp/$name" 2>/dev/null
  popd >/dev/null
  mkdir -p "$output"
  mv "$tmp"/output/* "$output"
  rm -r "$tmp"
}
dir2gif() {
  [ -e "$1".gif ] ||
  convert -scale 400% -dispose Background -loop 0 "$1"/*png "$1".gif
}

# begin extracting files
[ -e extracted ] || mkdir extracted
[ -e extracted/ANIM ] || ./quickbms.exe wayforward.bms ShantaeCurse.data extracted 2>/dev/null
[ -e extractedvol ] || mkdir extractedvol
[ -e anim ] || mkdir anim
[ -e image ] || mkdir image

for vol in extracted/*vol extracted/ANIM/*vol extracted/ANIM/*/*vol; do
  extractVol "$vol"
done
find extractedvol -name '*.anim' | while read name; do
  extractAnim "$name"
done
find extractedvol -name '*.image' | while read name; do
  extractImage "$name"
done
(find anim -type d; echo) | awk 'index($0,prev"/")!=1 && NR!=1 {print prev}
     1 {sub(/\/$/,""); prev=$0}' | while read anim; do
  dir2gif "$anim"
done
