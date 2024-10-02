echo Pufferpanel install script by is-a.space Owner
echo discord.gg/hetzner !

echo Installing curl
apt-get install -y curl > /dev/null
echo Done installing curl

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
echo Done adding user if you done the inputs

echo Installing ported / portip
echo '#!/bin/bash

PORTS_FILE="/ports.info.txt"

add_port() {
    local local_port=$1
    if [[ -z "$local_port" ]]; then
        echo "Please provide a local port to forward."
        exit 1
    fi
    
    local random_port
    random_port=$(shuf -i 1024-65535 -n 1)
    
    ssh -o StrictHostKeyChecking=no -f -N -R ${random_port}:localhost:${local_port} serveo.net > /dev/null &
    ssh_pid=$!
    
    echo "${random_port}:${local_port}" >> $PORTS_FILE
    
    echo "${local_port} is now on 138.68.79.95:${random_port}"
}

remove_port() {
    local local_port=$1
    if [[ -z "$local_port" ]]; then
        echo "Please provide a local port to remove."
        exit 1
    fi
    
    random_port=$(grep ":${local_port}$" $PORTS_FILE | cut -d':' -f1)
    
    if [[ -z "$random_port" ]]; then
        echo "Port ${local_port} not found."
        exit 1
    fi
    
    pkill -f "ssh -o StrictHostKeyChecking=no -f -N -R ${random_port}:localhost:${local_port} serveo.net" > /dev/null
    
    sed -i "/${random_port}:${local_port}/d" $PORTS_FILE > /dev/null
    
    echo "Port ${local_port} has been removed."
}

refresh_ports() {
    if [[ ! -f "$PORTS_FILE" ]]; then
        echo "No ports to refresh."
        exit 1
    fi
    
    while IFS= read -r line; do
        random_port=$(echo $line | cut -d':' -f1)
        local_port=$(echo $line | cut -d':' -f2)
        
        ssh -o StrictHostKeyChecking=no -f -N -R ${random_port}:localhost:${local_port} serveo.net > /dev/null &
    done < $PORTS_FILE
    
    echo "Ports have been successfully restarted."
}

list_ports() {
    if [[ ! -f "$PORTS_FILE" ]]; then
        echo "No ports to list."
        exit 1
    fi
    
    echo "Current port mappings:"
    while IFS= read -r line; do
        random_port=$(echo $line | cut -d':' -f1)
        local_port=$(echo $line | cut -d':' -f2)
        echo "Local port ${local_port} -> Public port ${random_port} (138.68.79.95)"
    done < $PORTS_FILE
}

# Main function to parse the input commands
case "$1" in
    add)
        add_port "$2"
        ;;
    remove)
        remove_port "$2"
        ;;
    refresh)
        refresh_ports
        ;;
    list)
        list_ports
        ;;
    *)
        echo "Usage: $0 {add|remove|refresh|list} [port]"
        exit 1
        ;;
esac
' > /bin/portip

chmod +x /bin/portip
echo Done installing ported / portip
echo Now do 
echo portip add 8080
echo to get port 8080 and access your panel
echo Admin user is password adminadmin and email admin@is-a.space . You can change creds in panel







