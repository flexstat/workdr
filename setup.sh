#!/bin/bash

#OPTIONS!

MASTERONION="dreadytofatroptsdj6io7l3xptbet6onoyno2yv7jicoxknyazubrad.onion"
TORAUTHPASSWORD="changethispassowrd"
BACKENDONIONURL="biblemeowimkh3utujmhm6oh2oeb3ubjw2lpgeq3lahrfr2l6ev6zgyd.onion"

#set to true if you want to setup local proxy instead of proxy over Tor
LOCALPROXY=false
PROXYPASSURL="10.10.10.10:80"

#Shared Front Captcha Key. Key alphanumeric between 64-128. Salt needs to be exactly 8 chars.
KEY="encryption_key"
SALT="1saltkey"
SESSION_LENGTH=3600

#CSS Branding

HEXCOLOR="9b59b6"
HEXCOLORDARK="6d3d82"
SITENAME="dread"

#There is more branding you need to do in the resty/caphtml_d.lua file near the end.

clear

echo "Welcome To The End Game DDOS Prevention Setup..."
sleep 1
BLUE='\033[1;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color
printf "\r\nProvided by your lovely ${BLUE}/u/Paris${NC} from dread. \r\n"
printf "with help from ${BLUE}/u/mr_white${NC} from whitehousemarket.\n"
echo "For the full effects of the DDOS prevention you will need to make sure to setup v3 onionbalance."
echo "Onionbalance v3 does have distinct descriptors in a forked version. Read the README.MD in the onionbalance folder for more information."

if [ ${#MASTERONION} -lt 62 ]; then
 echo "MASTEWRONION doesn't have the correct length. The url needs to include the .onion at the end." 
 exit 0
fi

if [ -z "$TORAUTHPASSWORD" ]
then
  echo "you didn't enter your tor authpassword"
  exit 0
fi

shopt -s nullglob dotglob
directory=(dependencies/*)
if [ ${#directory[@]} -gt 0 ]
then
echo "Dependency Folder Found!"
else
echo "You need to get the dependencies first. Run './getdependencies.sh'"
exit 0
fi

echo "Proceeding to do the configuration and setup. This will take awhile."
sleep 5

### Configuration
string="s/masterbalanceonion/"
string+="$MASTERONION"
string+="/g"
sed -i $string site.conf

string="s/torauthpassword/"
string+="$TORAUTHPASSWORD"
string+="/g"
sed -i $string site.conf

string="s/backendurl/"
string+="$BACKENDONIONURL"
string+="/g"
sed -i $string site.conf

string="s/proxypassurl/"
string+="$PROXYPASSURL"
string+="/g"
sed -i $string site.conf

string="s/encryption_key/"
string+="$KEY"
string+="/g"
sed -i $string lua/cap.lua

string="s/salt1234/"
string+="$SALT"
string+="/g"
sed -i $string lua/cap.lua

string="s/sessionconfigvalue/"
string+="$SESSION_LENGTH"
string+="/g"
sed -i $string lua/cap.lua

string="s/HEXCOLOR/"
string+="$HEXCOLOR"
string+="/g"
sed -i $string cap_d.css

string="s/HEXCOLOR/"
string+="$HEXCOLOR"
string+="/g"
sed -i $string queue.html

string="s/HEXCOLORDARK/"
string+="$HEXCOLORDARK"
string+="/g"
sed -i $string queue.html

string="s/SITENAME/"
string+="$SITENAME"
string+="/g"
sed -i $string queue.html

string="s/SITENAME/"
string+="$SITENAME"
string+="/g"
sed -i $string resty/caphtml_d.lua

if $LOCALPROXY
then
string="s/#proxy_pass/"
string+="proxy_pass"
string+="/g"
sed -i $string site.conf
else
string="s/#socks_/"
string+="socks_"
string+="/g"
sed -i $string site.conf
fi

apt-get update
apt-get install -y tor nyx
apt-get install -y vanguards
apt-get install -y build-essential zlib1g-dev libpcre3 libpcre3-dev uuid-dev gcc git wget curl libgd3 libgd-dev

#https://github.com/c64bob/lua-resty-aes/raw/master/lib/resty/aes_functions.lua
mv resty/aes_functions.lua /usr/local/lib/lua/resty/aes_functions.lua 

mkdir /etc/nginx/resty/
#include seems to be a bit mssed up with luajit
ln -s /usr/local/lib/lua/resty/ /etc/nginx/resty/

cp -r objs modules
rm -R /etc/nginx/modules
mkdir /etc/nginx/modules
mv modules /etc/nginx/modules
cd ..

rm /etc/nginx/nginx.conf
mv nginx.conf /etc/nginx/nginx.conf
rm /etc/nginx/naxsi_core.rules
mv naxsi_core.rules /etc/nginx/naxsi_core.rules
rm /etc/nginx/naxsi_whitelist.rules
mv naxsi_whitelist.rules /etc/nginx/naxsi_whitelist.rules
rm -R /etc/nginx/lua/
mv lua /etc/nginx/
mv resty/* /etc/nginx/resty/resty/
rm /etc/nginx/resty/caphtml_d.lua
mv /etc/nginx/resty/resty/caphtml_d.lua /etc/nginx/resty/caphtml_d.lua
rm /etc/nginx/resty/resty/random.lua
mv random.lua /etc/nginx/resty/resty/random.lua
mv queue.html /etc/nginx/queue.html
rm -R /etc/nginx/sites-enabled/
mkdir /etc/nginx/sites-enabled/
mv site.conf /etc/nginx/sites-enabled/site.conf
rm /etc/nginx/cap_d.css
mv cap_d.css /etc/nginx/cap_d.css

chown -R www-data:www-data /etc/nginx/
chown -R www-data:www-data /usr/local/lib/lua

chmod 755 startup.sh
rm /startup.sh
mv startup.sh /startup.sh
chmod 755 rc.local
rm /etc/rc.local
mv rc.local /etc/rc.local

rm /etc/sysctl.conf
mv sysctl.conf /etc/sysctl.conf

pkill tor

mv torrc /etc/tor/torrc

if $LOCALPROXY
then
echo "localproxy enabled"
else
mv torrc2 /etc/tor/torrc2
mv torrc3 /etc/tor/torrc3
fi

torhash=$(tor --hash-password $TORAUTHPASSWORD| tail -c 62)
string="s/hashedpassword/"
string+="$torhash"
string+="/g"
sed -i $string /etc/tor/torrc

sleep 10

tor

sleep 20

HOSTNAME="$(cat /etc/tor/hidden_service/hostname)"

string="s/mainonion/"
string+="$HOSTNAME"
string+="/g"
sed -i $string /etc/nginx/sites-enabled/site.conf

echo "MasterOnionAddress $MASTERONION" > /etc/tor/hidden_service/ob_config

pkill tor
sleep 10

sed -i "s/#HiddenServiceOnionBalanceInstance/HiddenServiceOnionBalanceInstance/g" /etc/tor/torrc

tor

if $LOCALPROXY
then
echo "localproxy enabled"
else
tor -f /etc/tor/torrc2
tor -f /etc/tor/torrc3
fi

nginx
service vanguards start
nginx -s stop
nginx

clear

echo "ALL SETUP! Your new front address is"
echo $HOSTNAME
echo "Add it to your onionbalance configuration!"
