#!/bin/bash

DOILUA_IP="192.168.1.10"
USERNAME="giacomo"
LAP_IP="192.168.1.7"

echo "Updating package list and installing SSH server..."
sudo apt update
sudo systemctl enable ssh
sudo systemctl start ssh
sudo ufw allow from 192.168.1.7 to any port 22
sudo ufw deny 22
sudo ufw enable

echo "Configuring UFW to allow only LAP_IP..."
sudo ufw allow from $LAP_IP to any port 22
sudo ufw deny 22
sudo ufw enable


echo "SSH configuration to Allow User"
echo "AllowUsers $USERNAME@$LAP_IP" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart ssh