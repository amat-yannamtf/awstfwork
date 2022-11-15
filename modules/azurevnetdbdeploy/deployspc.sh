#!/bin/bash
sudo apt update
sudo apt install openjdk-11-jdk -y
sudo apt install apache2 -y
mkdir ~/apps 
cd ~/apps
wget https://mirrors.tuna.tsinghua.edu.cn/jenkins/war/2.377/jenkins.war
java -jar jenkins.war &
sleep 60s