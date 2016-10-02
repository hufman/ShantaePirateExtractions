#!/bin/bash
for i in import/*; do
  dst=`echo "$i" | sed 's/import/images/'`
  convert -scale 25% "$i" "$dst"
done
