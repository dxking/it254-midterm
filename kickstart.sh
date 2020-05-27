#!/bin/bash

# update/upgrade and install docker/git
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install docker.io git -y

# configure ufw
sudo ufw allow ssh
sudo ufw allow http
# force is required to bypass prompt
sudo ufw --force enable

git clone https://github.com/dxking/it254-midterm

# launch an nginx container with port 80 exposed
sudo docker run --name midterm-nginx -v it254-midterm/html:/usr/share/nginx/html:ro -p 80:80 -d nginx
