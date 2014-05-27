#!/bin/sh

DEPLOY_DIR='/opt/webmotion'
USER='www-data'
GROUP='emergy'

[ -d $DEPLOY_DIR ] || sudo mkdir -p $DEPLOY_DIR && sudo chown $USER:$GROUP $DEPLOY_DIR && sudo chmod 775 $DEPLOY_DIR || exit 1

sudo rsync -av --delete -d ./* $DEPLOY_DIR/
sudo chown -R www-data $DEPLOY_DIR/logs

sudo mkdir -p $DEPLOY_DIR/var
sudo chown -R www-data $DEPLOY_DIR/var

sudo service webmotion restart
