#!/bin/bash
npm list forever -g || sudo npm install -g forever
if [ -f /etc/init.d/node-server.sh ]; then
	echo "node-server.sh already installed"
else
	sudo mv ~/app/node-server.sh /etc/init.d/
	sudo sed -i -e "s/ReplaceWithUser/$USER/g" /etc/init.d/node-server.sh
	cd /etc/init.d
	sudo chmod 755 node-server.sh
	sudo update-rc.d node-server.sh defaults
	cd ~/app
	echo "installed node-server.sh"
fi
if [ -f ~/.bash_aliases ]; then
	echo ".bash_aliases already installed"
else
	sudo mv ~/app/.bash_aliases ~
	echo "installed .bash_aliases"
fi
echo '>>> Enable UART'

sudo raspi-config nonint do_serial 2

# Bluetooth uses the primary uart so it needs to be disabled
# Only applies to RPi's with built-in Bluetooth (3A+, 3B, 3B+, 4B and Zero W)
if grep -qE "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F](08|0c|0d|0e|11)[0-9a-fA-F]$" /proc/cpuinfo; then
	echo '>>> Disable bluetooth'
	sudo raspi-config nonint set_config_var dtoverlay pi3-disable-bt /boot/config.txt
	sudo systemctl disable hciuart
fi

echo "finished installing PiPowerMeter" 
