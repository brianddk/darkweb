#!/bin/bash
sudo noip2
sudo swapon /mnt/2GB.swap
(cd ~/src/darkweb/; sudo bundle exec jekyll serve -P 80 -H $HOSTNAME -d /var/lib/i2p/i2p-config/eepsite/docroot --detach)
# ~/Freenet/run.sh start
vncserver
