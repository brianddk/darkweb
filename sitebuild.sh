#!/bin/bash
sudo -- sh -c 'umask 0027; bundle exec jekyll build -d /var/www/html'
sudo chown -R root:www-data /var/www/html
sudo chmod -R o-rwx /var/www/html
sudo chmod -R g-w /var/www/html

