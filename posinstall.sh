#!/bin/bash
# Здесь должно быть set -ex как минимум.

if [[ $EUID -ne 0 ]]; then
 echo "This script must be run as root" 
 exit 1
else
 #Update and Upgrade
 echo "Updating and Upgrading"
 apt-get update && sudo apt-get upgrade -y  # не нужно здесь sudo

sudo apt-get install dialog
 cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
 options=(1 "Installing common utlis(curl, build-essential, etc)" off # any option can be set to default to "on"
2 "Python 3.10 with pip" off
3 "Docker and docker-compose" off
4 "Terminator console" off
5 "Node.js, npm, yarn" off
)
 choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
 clear
 for choice in $choices
 do
 case $choice in
 1)
 #Install Build Essentials
 echo "Installing common utlis(curl, build-essential, etc)"
 apt install -y build-essential
 apt install -y apt-transport-https ca-certificates curl software-properties-common
 ;;
 2)
 #Install Python 3.10 with pip
 echo "installing Python 3.10 with pip"
 sudo add-apt-repository ppa:deadsnakes/ppa -y   # не нужно здесь sudo
 sudo apt -y install python3.10   # не нужно здесь sudo
 sudo apt -y install python3-pip  # не нужно здесь sudo
 sudo apt-get install python3-distutils -y  # не нужно здесь sudo
 python3 -m pip install --upgrade pip
 ;;
 3)
 #Install Docker and docker-compose
 echo "installing Docker"
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  # не нужно здесь sudo
 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" # имя релиза лучше не хардкодить
 apt update
 apt install -y docker-ce
 usermod -aG docker ${USER}
 echo "installing docker-compose"
 curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 chmod +x /usr/local/bin/docker-compose
 ;;
 4)
 #Install Terminator Console
 echo "Installing common utlis(curl, build-essential, etc)"
 apt install -y terminator
 ;;
 5)
 #Install Node.js, npm, yarn
 echo "Installing Node.js, npm, yarn"
 curl -fsSL https://deb.nodesource.com/setup_14.x | bash
 apt install -y nodejs=14.19.1-deb-1nodesource1  # точно-точно нужно настолько версии прибивать?
 npm install -g npm@6.14.13
 npm install -g yarn@1.22.15
 source ~/.bashrc  # зачем это?
 chown -R ${USER} "/usr/lib/node_modules"
 chmod -R 777 "${HOME}/.npm"
 npm config set prefix "${HOME}/.npm"
 export PATH="${PATH}:${HOME}/.npm/bin" # перестанет же работать в следующей оболчке
 ;;


 esac
 done
fi
