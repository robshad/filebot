#!/bin/bash

cat >/script/filebot-service.sh <<EOL
#!/bin/bash

trap "rm -f /tmp/filebot.lock" SIGINT SIGTERM
if [ -e /tmp/filebot.lock ]
then
  exit 1
else
  touch /tmp/filebot.lock
  
  /config/filebot.sh

  rm -f /tmp/filebot.lock
  exit 0
fi

EOL
echo "Wrote /script/filebot-service.sh"

wget -v -O /config/filebot.cfg https://raw.githubusercontent.com/robshad/lftp-sync/master/lftp-sync-defaults.cfg
echo "Wrote /config/filebot.cfg"

wget -O /tmp/filebot.deb wget -O filebot-amd64.deb 'http://filebot.sourceforge.net/download.php?type=deb&arch=amd64'
echo "Downloaded filebot.deb"

dpkg -i /tmp/filebot.deb
echo "Installed filebot"

rm /tmp/filebot.deb
echo "Removed filebot"

chown -R abc:abc /config
chown -R abc:abc /script
chmod -v +x /config/filebot.sh
chmod -v +x /config/filebot-config.cfg
chmod -v +x /script/filebot-service.sh

crontab -l | { cat; echo "$(printenv CRON) /script/filebot-service.sh"; } | crontab -
