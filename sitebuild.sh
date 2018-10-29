#!/bin/bash
docroot="/var/www/html"
eval jsite_conf="~freenet/jSite.conf"
eval jsite_jar="~freenet/jSite-12-jSite-0.13-jar-with-dependencies.jar"

function mk_env() {
   sudo sed 's#<#"\n#g;s#>#="#g;s#request-##g' $jsite_conf | \
      grep "^uri\|^edition\|^path\|^name"
}

function bld_docroot() {
   #sudo groupadd www-i2psvc
   #sudo usermod -a -G www-i2psvc www-data
   #sudo usermod -a -G www-i2psvc i2psvc
   umask 0027
   #sudo chown root:www-i2psvc ${docroot}/..
   #sudo chown root:www-i2psvc ${docroot}
   sudo bundle exec jekyll build -d ${docroot}
   sudo chown -R root:www-data $docroot
   sudo chmod -R g+r,o-rwx,g-w $docroot
   sudo ln -s /var/lib/i2p/i2p-config/published.txt /var/www/html/hosts.txt
   sudo chown i2psvc:www-data ${docroot}/hosts.txt
}

function upld_freesite() {
   source <(mk_env)
   echo > _freenet.yml "baseurl: \"/USK@${uri}/${path}/$(( edition + 1 ))\""
   bundle exec jekyll build --config _config.yml,_freenet.yml
   sudo java -cp ${jsite_jar} \
      "de.todesbaum.jsite.main.CLI" \
      "--config-file=${jsite_conf}" \
      "--project=${name}"
}

IFS='' read -r -d '' header <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
EOF

function get_redirects() {
   sorts=$(sudo grep "\"\^/[^\n].*[$]\"" /etc/lighttpd/lighttpd.conf | sed 's#"\^/##g;s#\$"##g' | awk '{print $1}')
   longs=$(sudo grep -v "Port" /etc/lighttpd/lighttpd.conf | egrep "^var\." | sed 's/.*=//g;s/ //g;s/"//g')
   longs=$(sed 's#\(^USK.*/\)#\14#' <<< "$longs")
   redirects=$(echo -en "${sorts}\n${longs}" | tr "\n" "\n")
}

function mk_sitemap() {
   get_redirects
   bundle exec jekyll build
   uris=$(find _site -iname "*.html" | sed "s#/index.html#/#g;s#_site##g")
   uris=$(tr "\n" "\n" <<< "$uris")
   #selfhost="$(sudo noip2 -S 2>&1 | grep host | awk '{print $2}')"
   ghphost="dwghp.ddns.net"
   for line in $(egrep "^Sitemap:" robots.txt | awk '{print $2}'); do
      IFS='/' read -r proto null host sm null <<< "$line"
      echo "$header" > "$sm"
      for uri in $uris; do
         echo "<url><loc>${proto}//${host}${uri}</loc></url>" >> "$sm"
         if [ "$host" != "$ghphost" ]; then
            for rd in $redirects; do
               echo "<url><loc>http://${host}/${rd}${uri}</loc></url>" >> "$sm"
            done
         fi
      done
      echo "</urlset>" >> "$sm"
   done
}

function update_wa() {
   sudo rm /var/log/wa.log
   sudo /etc/cron.daily/web-archive-update
}

function ping_seo() {
   for uri in $(grep "^Sitemap:" robots.txt | awk '{print $2}'); do
      for engine in "http://google.com/ping" "http://www.bing.com/ping"; do
         curl -vv -s -o /dev/null --data-urlencode "sitemap=$uri" -G "$engine" 2>&1 | egrep "^> GET|^> Host:|^< HTTP"
      done
   done
}
echo "#### Building Sitemap"
#mk_sitemap
echo "#### Building Main"
bld_docroot
echo "#### Pinging SEO"
ping_seo
echo "#### Uploading Freesite"
#upld_freesite
echo "#### Updating Web-Archive"
update_wa
