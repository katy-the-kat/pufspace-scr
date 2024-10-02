echo Pufferpanel install script by is-a.space Owner
echo discord.gg/hetzner !

echo Installing curl and wget
apt-get install -y curl wget > /dev/null
echo Done installing curl and wget

echo Adding repo
curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | sudo bash > /dev/null
echo Done adding repo

echo Installing pufferpanel
apt-get install -y pufferpanel > /dev/null
systemctl enable pufferpanel
systemctl start pufferpanel
echo Done installing pufferpanel

echo Adding user
pufferpanel user add --admin --email admin@is-a.space --password adminadmin --name admin
echo Done adding user

echo Installing cloudlared
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
apt-get install -y ./cloudflared-linux-amd64.deb
echo Done installing cloudflared

echo Use
echo cloudflared tunnel --url http://localhost:8080
echo to get access to your panel. Retry this command if it doesnt work or you restarted this server
echo Admin user is password adminadmin and email admin@is-a.space . You can change creds in panel
