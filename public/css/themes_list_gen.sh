#!/usr/bin/env bash

LIST=`ls -1 bootstrap_*.css`

for FILE_NAME in $LIST; do
    THEME_NAME=`echo $FILE_NAME|sed 's/bootstrap_\(.*\).css/\u\1/'`
    echo "INSERT INTO themes (name, filename) VALUES ('$THEME_NAME', '$FILE_NAME');"
done
