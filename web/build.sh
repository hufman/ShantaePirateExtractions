#!/bin/bash
SIZES="1 2 3 4"
for img in images/*; do
  echo "$img" | grep -q -E -e '-[0-9]+x\.gif' && continue
  for size in $SIZES; do
    dstimg=`echo "$img" | sed 's|\(-*[0-9]*x\)\?\.gif$|-'$size'x.gif|'`
    [ -e "$dstimg" ] ||
    convert -scale "$size"00% "$img" "$dstimg"
  done
done
./index.tplsh > index.html
