---
layout: post
title:  "Creating A GCE VM"
date:   2018-09-21 17:30:00 -0500
# categories: jekyll update
---
If you decide to use Google Compute Engine to host your webserver, simply [install the sdk](https://cloud.google.com/sdk/install) then run the following, where `{zone}`, `{disk-name}`, and `{vm-name}` are chosen by you.  Obviously strip out the `{}`.

```
gcloud config set compute/zone {zone}
gcloud compute instances create \
 --image-family=ubuntu-1804-lts \
 --image-project=ubuntu-os-cloud \
 --machine-type=f1-micro \
 --preemptible {vm-name}
gcloud compute ssh {vm-name}
```

Once your VM is running, you might want to consider adding some cache.  You won't need it for the clearnet config, but you will need it as you start to set up some of the darknet services.  I'd suggest you simply follow [this procedure](https://www.tecmint.com/create-a-linux-swap-file/) to set a swap file instead of a partition for simplicity.

```
sudo fallocate --length 2GiB /var/swapfile
sudo chmod 600 /var/swapfile
sudo mkswap /var/swapfile
sudo swapon /var/swapfile
sudo vi /etc/fstab # add the following line
   /var/swapfile swap swap defaults 0 0
```
