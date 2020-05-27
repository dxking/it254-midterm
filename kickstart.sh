#!/bin/bash

# update/upgrade and install docker
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install docker.io -y

# configure ufw
sudo ufw allow ssh
sudo ufw allow http
# force is required to bypass prompt
sudo ufw --force enable

# launch an nginx container with port 80 exposed
sudo docker run --name midterm-nginx -p 80:80 -d nginx
