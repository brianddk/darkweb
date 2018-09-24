---
layout: post
title:  "Hidden Services HowTo"
date:   2018-09-20 14:17:00 -0500
# categories: jekyll update
---

I'll begin by laying out the basics of setting up a VM, a web-server and some hidden services.  I'll likely do this in a few posts, possibly over a few days, so check back often.

If you want to host a web-page there are a few options available to you.  One of the most obvious is to use something like [foursquare](https://www.squarespace.com/) or some other site-builder.  Although this is a simple enough solution there are a few drawbacks.  Primary among these are the fact that you do not have the ability to do anything but what the provider (foursquare) offers.  If you wanted to "draw outside the lines" you may quickly find yourself up against some restriction.

On the other-hand, self-hosting your content gives you all the flexibility you need as well as giving you the freedom to post opinions that your provider may disagree with.  I'll give a (very) rough outline of what the steps to do this are, then we will drill into each individual step later.

## Clearnet Setup

The first few steps will be to make content available on the clearnet.  This will make your information available on the normal internet using the normal tools.  You may choose to only host on the clearnet, or only host on the darknet.  For this experiment I'm hosting on both.

#### Create a VM

Hosting a website on anything other than a dedicated web-server is probably not a good idea.  Especially if you open the site up to the web at large.  So in an attempt to find a cheep I choose [**Google Compute Engine**](https://cloud.google.com/compute/).  If you are using the `f1-micro` preemptible image, you can usually stay pretty close to the [always free](https://cloud.google.com/free/docs/always-free-usage-limits) usage limits.  I tend to run a few things on GCE, but my bills are usually only a dollar or two every other month or so.  If you end up with a site that you want 24x7 up-time there are likely some plans from [discount providers](http://www.servermom.org/low-end-cloud-server-providers/) at around $5 / mo.

* [Creating A GCE VM]({{ site.baseurl }}{% post_url 2018-09-21-create-gce-vm %}) - Setting up `f1-micro` GCE instances.

#### Generating a Site

There are multiple options of site builders to choose from.  I choose [**Jekyll**](https://jekyllrb.com/) because it is included in [Github Pages](https://pages.github.com/), and seems the simplest of the most popular solutions.

* [Creating A Jekyll Site]({{ site.baseurl }}{% post_url 2018-09-21-create-jekyll-site %}) - A more detailed Jekyll walk through.

#### Choose a Web-server

Originally I glossed over this piece, but shortly after hosting I noticed some really weird intrusion probing on my site and decided to rebuild from scratch.  Opinions on which server software to run will vary wildly, but I'm going to try [**`lighttpd`**](https://www.lighttpd.net/) for the task.  Key take away is that it has to have a small footprint and be secure enough that our VM doesn't get overrun.

* [Installing Lighttpd Service]({{ site.baseurl }}{% post_url 2018-09-22-install-lighttpd %}) - How to install Lighttpd server.

#### Choose a DynDNS

This allows us to pick a site-name and dynamically update the IP address as our instance moves.  I know there are a few services out there, but I happened upon [**`noip`**](https://www.noip.com/) and have been pretty happy with it.  It gives me three records.  I use one for the Github Hosted page, one for my self-hosted page, and I have not yet figured out what to do with the third.

* [Installing NoIP Service]({{ site.baseurl }}{% post_url 2018-09-22-install-noip %}) - How to install noip as a service.

#### Configure Up-time Monitor

If you are using the GCE always-free tier, you will likely want an up-time monitor to determine when your instance preempts.  I was pleased to see that GCE integrates Stackdriver to allow up to now receive notifications when you are preempted.  You can even restart your instances via the [Android](https://play.google.com/store/apps/details?id=com.google.android.apps.cloudconsole) or [iOS](https://itunes.apple.com/us/app/google-cloud-console/id1005120814/iTunes?mt=8).

* [Configure GCE Up-time Monitor](https://cloud.google.com/monitoring/quickstart-lamp) - Step by step guide with Stackdriver.

## Darknet Setup

At this point your clearnet site should be up and running.  If you only want to host on the darknet, you can stop your web-server since it is only used for clearnet content currently.

The darknet services will run something similar to a web-server, but for vary specific networks.  I choose to run what looked like the three most popular [darknet](https://en.wikipedia.org/wiki/Darknet#Active) services.  Much beyond this would start to make my poor `f1-micro` VM sweat.

#### I2P

Although Tor is more popular, I set up [**I2P**](https://geti2p.net/) first since it serves content by default.  I'll use the I2P web server to serve on Tor as well.  There are many [comparisons](https://www.makeuseof.com/tag/i2p-vs-tor-vs-vpn-secure/) of I2P and Tor if your interested.  The basic difference I see is that I2P is peer-to-peer.  All browsers are also relays (if their ports are open).  This is similar to how bitcoin or bittorrent networks work.  Tor on the other hand seems to have separate "participants" and "maintainers" or relays.  If your using Debian, a [pre-packaged](https://geti2p.net/el/download/debian) installer is available.  Once installed, it is polite to open the I2P ports so that your node can contribute to the network.  Keep in mind that this will count against your VM's bandwidth quota, so it is something you will want to keep an eye on.

* [Installing I2P Service]({{ site.baseurl }}{% post_url 2018-09-23-install-i2p %}) - How to install the I2P service.

#### Tor

By far the most popular darknet protocol, [**Tor**](https://www.torproject.org/) has an integrated and hardened browser as well as the tor service / proxy.  I deviated about from the normal install instructions and did everything through `apt`

* [Installing Tor Service/Browser]({{ site.baseurl }}{% post_url 2018-09-23-install-i2p %}) - How to install the TOR service and browser.

#### Freenet

Of all the hidden services, I found [**Freenet**](https://freenetproject.org/) to be the most interesting.  One of the coolest things about freenet is that the content (if popular) will stay on the network even if the site / server that created the content goes down.  Once content is on freenet it is mirrored and shared by all the nodes and propagated.

Installation on the VM was a little weird on freenet as well.  Since I was trying to run as close to headless as possible, my JVM was throwing up some errors.  Luckily simply [disabling accessibility](https://askubuntu.com/questions/695560/assistive-technology-not-found-awterror) features seemed to do the trick.

## All Done

At this point you should have your site mirrored on two clearnet services and 3 darknet services.  Obviously this is way overkill for a simple blog, but I demonstrate it simply to show how it can be done.