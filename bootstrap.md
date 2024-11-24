# Bootstrap
- Create a bootable USB key with the Ubuntu Server ISO.
- Connect the device to the router via Ethernet and insert the USB key.
- Turn on the device and repeatedly press **F1** or **ESC** to access the BIOS/UEFI settings.
- Set the boot priority to start from the USB key.
- Let it update to the most recent version.
- Select **English** as the preferred language.
- Choose **Italian** as the keyboard layout.
- Accept the default network configuration.
- Select the option to use the entire disk with the default storage setup.
- Set **username**: `giacomo` and a secure **password**.
- Install **OpenSSH** (configure SSH keys later).
- Install **microk8s** and **Docker**.

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

sudo apt remove --purge docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
sudo systemctl daemon-reload
sudo systemctl start docker.service
sudo vim /lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl start docker.service
systemctl status docker.service
journalctl -u docker.service --no-pager -n 50
which dockerd
sudo systemctl enable docker.socket
sudo systemctl start docker.socket
sudo systemctl start docker.service
docker ps
docker-compose up -d
```