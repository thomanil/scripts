#! /bin/bash

########
# Home dir backup to external disk, which must be named BACKUP
########



# Backup my user dir
sudo rsync --delete -rvu --exclude 'Downloads'  /users/thomas /Volumes/BACKUP/


