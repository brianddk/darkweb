#!/bin/bash
docroot="/var/lib/i2p/i2p-config/eepsite/docroot"
sudo cat ${docroot}/hosts.txt > hosts.txt
sudo -- sh -c "umask 0027; bundle exec jekyll build -d $docroot"
sudo chown -R i2psvc:www-data $docroot
sudo chmod -R o-rwx $docroot
sudo chmod -R g-w $docroot
