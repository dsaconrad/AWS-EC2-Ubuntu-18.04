#pull into your instance using sudo git clone https://github.com/dsaconrad/lampstack-aws-ec2.git .
#run script with sudo ./lampstack.sh

#!/bin/bash

echo "User instructions will be provided as installtion progresses."

sudo apt update -y
sudo apt upgrade -y

echo "installing Apache"
sudo apt install -y apache2 apache2-utils
sudo systemctl start apache2
sudo systemctl enable apache2
apache2 -v
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo ufw allow http
sudo chown www-data:www-data /var/www/html/ -R

echo "installing MYSql Here"

sudo apt install mariadb-server mariadb-client -y
systemctl status mariadb
sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "Password protecting mysql installation"
sudo mysql_secure_installation
echo "You will be asked Y/n to set up root password. Press enter. It will ask you to enter a password and confirm."

echo "Press enter for the next 4 questions."
echo "MySQL has been installed, and you must now enter the root password that you have set." 
echo "Loading into Mysql Commandline"
sudo mariadb -u root


echo "Installing PHP"
sudo apt install php7.2 libapache2-mod-php7.2 php7.2-mysql php-common php7.2-cli php7.2-common php7.2-json php7.2-opcache php7.2-readline
sudo a2enmod php7.2 -y

echo "restarting apache to enable PHP"
sudo systemctl restart apache2

echo "disabling certain php features"
sudo a2dismod php7.2

echo "Installing FPM and Fast CGI"
sudo apt install php7.2-fpm
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php7.2-fpm

echo "APACHE will now be reloaded and restarted"

sudo systemctl reload apache2
sudo systemctl restart apache2

#Do you want to Install Git

read -p "Install GIT.$foo? [yn]" answer
if [[ $answer = y ]] ; then
    sudo apt install git-core -y
    git --version 
fi

sudo systemctl restart apache2

