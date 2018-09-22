---
layout: post
title:  "Installing Lighttpd Service"
date:   2018-09-22 12:00:00 -0500
# categories: jekyll update
---

Since `lighttpd` is a maintained package, just follow the Ubuntu [install instructions](https://help.ubuntu.com/community/lighttpd).
```
sudo apt-get install lighttpd
```

Once installed, you may want to tighten security a bit.
```
cd ~
vi .profile
# change umask to 027 and save
umask 027 # to apply to current session
```

Now we can create a build script for our site.  Go to the directory your Jekyll code is in and create `sitebuild.sh` containing
```
#!/bin/bash
sudo -- sh -c 'umask 0027; bundle exec jekyll build -d /var/www/html'
sudo chown -R root:www-data /var/www/html
sudo chmod -R o-rwx /var/www/html
sudo chmod -R g-w /var/www/html
```

Hopefully this will ensure that none of your site files have any lingering read attributes that they should not.

Finally, you will want to edit your `_config.yml` and add the following to the end (or at least uncomment some)
```
exclude:
  - sitebuild.sh
  - Gemfile
  - Gemfile.lock
  - node_modules
  - vendor/bundle/
  - vendor/cache/
  - vendor/gems/
  - vendor/ruby/
```

Now we can build our site and test it
```
chmod u+x sitebuild.sh
./sitebuild.sh
lynx localhost
```

If your happy with the content, then we can commit the changes to github
```
git add -A
git commit -m "automated our site build"
git push
```

#### Further tasks
To finish your clearnet site, you will want to

1. Open port 80 to serve your site
2. Get an SSL cert
3. Roll out your SSL cert and [move site to port 443](https://redmine.lighttpd.net/projects/1/wiki/HowToRedirectHttpToHttps)

<!-- todo: spell out HW-->