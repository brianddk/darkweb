#!/bin/bash
sudo noip2
sudo swapon /mnt/2GB.swap
(cd ~/src/darkweb/; sudo bundle exec jekyll serve -P 80 -H $HOSTNAME -d /var/lib/i2p/i2p-config/eepsite/docroot --detach 1> /tmp/webserver.log 2>&1)
(cd ~/src/darkweb/; sudo chown -R i2psvc:i2psvc /var/lib/i2p/i2p-config/eepsite/docroot)
# ~/Freenet/run.sh start
vncserver
