#!/bin/bash

echo ">>>> apt-get update"
sudo apt-get update -y

echo ">>>> apt update"
sudo apt update -y

echo ">>>> apt-get upgrade"
sudo apt-get upgrade -y

echo ">>>> apt upgrade"
sudo apt update -y

echo ">>>> apt autoremove"
sudo apt autoremove -y

echo ">>>> apt autoclean"
sudo apt autoclean -y

echo ">>>> apt clean"
sudo apt clean -y

echo ">>>> installing net-tools"
sudo apt-get install net-tools

echo ">>>> installing ssh"
sudo apt-get install openssh-server

echo ">>>> installing gcc"
sudo apt-get install gcc

echo ">>>> installing g++"
sudo apt-get install g++

echo ">>>> installing python3-pip"
sudo apt install python3-pip

echo ">>>> pip3 install regex"
sudo pip3 install regex

echo ">>>> pip3 install packaging"
sudo pip3 install packaging

echo ">>>> generating ssh key"
ssh-keygen -t rsa -b 4096 -C "rreddyk@cisco.com"
cat ~/.id_rsa.pub
echo ""
