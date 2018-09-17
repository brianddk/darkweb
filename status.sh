#!/bin/bash
echo "################ noip2 ################"
sudo noip2 -S
echo -e "\n\n################ vncserver ################"
ps -fp $(cat ~/.vnc/ubuntu-dvm\:1.pid)
echo -e "\n\n################ jekyll ################"
sudo ps -Af | grep -i jekyll | grep serve
echo -e "\n\n################ tor-server ################"
sudo systemctl is-active tor
echo -e "\n\n################ i2p-server ################"
sudo systemctl is-active i2p
echo -e "\n\n################ freenet ################"
~/Freenet/run.sh status
