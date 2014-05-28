#!/usr/bin/env bash

LIST=`ls -1 bootstrap_*.css`

for FILE_NAME in $LIST; do
    THEME_NAME=`echo $FILE_NAME|sed 's/bootstrap_\(.*\).css/\u\1/'`
    #CREATE TABLE themes (id int primary key auto_increment, name character varying(255) NOT NULL, file character varying(255) NOT NULL) engine=innodb;
    echo "INSERT INTO themes (name, filename) VALUES ('$THEME_NAME', '$FILE_NAME');"
done
