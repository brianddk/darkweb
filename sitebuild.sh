#!/bin/bash
docroot="/var/lib/i2p/i2p-config/eepsite/docroot"
jsite_conf="${HOME}/Downloads/jSite.conf"
jsite_jar="${HOME}/Downloads/jSite-12-jSite-0.13-jar-with-dependencies.jar"

function mk_env() {
   sed 's#<#"\n#g;s#>#="#g;s#request-##g' $jsite_conf | \
      grep "^uri\|^edition\|^path\|^name"
}

function bld_docroot() {
   umask 0027
   sudo cat ${docroot}/hosts.txt > hosts.txt
   sudo bundle exec jekyll build -d ${docroot}
   sudo chown -R i2psvc:www-data $docroot
   sudo chmod -R o-rwx $docroot
   sudo chmod -R g-w $docroot
}

function upld_freesite() {
   source <(mk_env)
   echo > _freenet.yml "baseurl: \"/USK@${uri}/${path}/$(( edition + 1 ))\""
   bundle exec jekyll build --config _config.yml,_freenet.yml
   java -cp ${jsite_jar} \
      "de.todesbaum.jsite.main.CLI" \
      "--config-file=${jsite_conf}" \
      "--project=${name}"
}

bld_docroot
upld_freesite

