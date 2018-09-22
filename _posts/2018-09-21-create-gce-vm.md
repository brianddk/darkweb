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
