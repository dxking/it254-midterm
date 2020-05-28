#!/bin/bash

# update/upgrade and install docker/git
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install docker.io git -y

# configure ufw
sudo ufw allow ssh
sudo ufw allow http
# force is required to bypass prompt
sudo ufw --force enable

# this repo has a custom index.html i'd like to attach to my container
git clone https://github.com/dxking/it254-midterm /tmp/it254-midterm

# launch an nginx container with port 80 exposed and the custom index.html in place
sudo docker run --name midterm-nginx -v /tmp/it254-midterm/html:/usr/share/nginx/html:ro -p 80:80 -d nginx
