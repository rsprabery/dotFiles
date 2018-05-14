#!/bin/sh

i3status | while :
do
  read line
  echo "`vmstat | awk '{ if (NR == 3) {print ($5 + $6) / 1024 " MB / " \
    ($4 + $5 + $6)/ 1024 " MB"  }}'` |" "$line" || exit 1
done
