#!/bin/bash
shopt -s nullglob
for i in import/*.gif import/*/*.gif; do
  dst=`echo "$i" | sed 's/import/images/'`
  dstdir=`dirname "$dst"`
  [ -e "$dstdir" ] || mkdir -p "$dstdir"
  convert -scale 25% "$i" "$dst"
done
