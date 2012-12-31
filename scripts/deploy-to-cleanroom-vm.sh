#!/bin/bash

TARGET_VM_HOSTNAME="cleanroom.test"

# Deploys gitorious development code from host machine into host
# running at specified IP address.

# Assumes that the destination host
# has been set up using the standard Puppet recipe, ie with standard
# locations, services etc set up.

# Take ip or hostname of target server as parameter
HOST_IP=$TARGET_VM_HOSTNAME

echo "Starting deployment to $HOST_IP..."

echo "Updating gitorius submodules on $HOST_IP..."
ssh root@$HOST_IP "cd /var/www/gitorious/app && git submodule init && git submodule update"

echo "Updating gitorious code on $HOST_IP"
RSYNC_EXCLUDES="--exclude config/gitorious.yml --exclude config/database.yml --exclude log --exclude test --exclude doc"
rsync -ar $RSYNC_EXCLUDES ~/gitorious/thomas-mainline/ root@$HOST_IP:/var/www/gitorious/app/

UPDATE_PERMS_CMD="echo 'Updating permissions' && chown -R git:git /var/www/gitorious"

#DEPENDENCIES_UPDATE_CMD="echo 'Updating dependencies' && cd /var/www/gitorious/app && bundle install"
DEPENDENCIES_UPDATE_CMD="echo '<Not running bundler>'"

#RUN_MIGRATIONS="echo 'Running migrations' && cd /var/www/gitorious/app && env RAILS_ENV=production bundle exec rake db:migrate --trace"
RUN_MIGRATIONS="echo '<Not running migrations>'"

#CLEAR_ASSETS_CMD="echo 'Clearing asset pipeline' && cd /var/www/gitorious/app && RAILS_ENV=production bundle exec rake assets:clear"
CLEAR_ASSETS_CMD="echo '<Not clearing assets>'"

RAILS_RESTART_CMD="echo 'Restarting Rails' && touch /var/www/gitorious/app/tmp/restart.txt"
ssh root@$HOST_IP "$DEPENDENCIES_UPDATE_CMD && $UPDATE_PERMS_CMD && $RUN_MIGRATIONS && $CLEAR_ASSETS_CMD && $RAILS_RESTART_CMD"

echo "Deployment to $HOST_IP done."
