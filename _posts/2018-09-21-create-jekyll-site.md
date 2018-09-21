---
layout: post
title:  "Creating A Jekyll Site"
date:   2018-09-21 17:40:00 -0500
# categories: jekyll update
---

To start, just follow the [github instructions](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/).  I'll go through a few of them here.  Change `{jksite}`, and `{userid}` appropriate (without `{}`). 


#### Install dependencies

```
sudo apt-get make gcc lynx ruby ruby-dev g++ zlib1g-dev
sudo gem install bundler
```

#### Create the repo

* Browse to github [new repo page](https://github.com/new)
* Set name to `{jksite}`
* Check `Initialize with Readme`
* Set `.gitignore` to `Ruby`
* Set `License` to `Apache`
* Click `Create Repository`

#### Create the branch

From the shell perform the following to checkout the repo and create a `gh-pages` branch
```
mkdir ~/src
cd ~/src
git clone https://github.com/{userid}/{jksite}.git
cd {jksite}
git config --local user.email "{userid}@users.noreply.github.com"
git config --local user.name "{userid}"
git checkout -b gh-pages
```

#### Install Jekyll
```
sudo apt-get install make gcc g++ zlib1g-dev ruby ruby-dev lynx
ruby --version
sudo gem install bundler
vi Gemfile # add the following to lines to Gemfile and save
   source 'https://rubygems.org'
   gem 'github-pages', group: :jekyll_plugins
bundle install
```

#### Create Jekyll site
```
cd ~/src
jekyll new {jksite}
cd {jksite}
vi Gemfile # modify the file to comment out jekyll and add github-pages 
   -> # gem "jekyll", "~> 3.7.4"
   -> gem "github-pages", group: :jekyll_plugins
bundle update
bundle install
```

#### Test the site
```
bundle exec jekyll serve &
lynx http://127.0.0.1:4000
kill %1
```

#### Push back to repo
```
git add -A
git commit -a -m "Jekyll Pages"
git push -u origin gh-pages
```

