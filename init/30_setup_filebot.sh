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

wget -v -O /config/filebot.sh https://raw.githubusercontent.com/robshad/filebot/master/filebot.sh
echo "Wrote /config/filebot.sh"

wget -O /script/filebot.deb 'https://www.filebot.net/download.php?mode=s&type=deb&arch=amd64'
echo "Downloaded filebot.deb"

sudo dpkg -i /script/filebot.deb
echo "Installed filebot"

if [! -f /config/filebot.cfg ]
then
  echo "Config exists"
else
  wget -v -O /config/filebot.cfg https://raw.githubusercontent.com/robshad/filebot/master/filebot.cfg
  echo "Wrote /config/filebot.cfg"
fi

rm /script/filebot.deb
echo "Removed filebot"

chown -R abc:abc /config
chown -R abc:abc /script
chmod -v +x /config/filebot.sh
chmod -v +x /config/filebot.cfg
chmod -v +x /script/filebot-service.sh

crontab -l | { cat; echo "$(printenv CRON) /script/filebot-service.sh"; } | crontab -
echo "Added cron entry"