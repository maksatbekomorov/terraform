#! /bin/bash
apt-add-repository ppa:ansible/ansible
apt update && sudo apt install -y ansible git
chown ubuntu:ubuntu /etc/ansible
cd /etc/ansible
rm -rf /etc/ansible/*
git clone https://github.com/maksatbekomorov/maksatbek-ansible.git . || git pull
ansible-playbook mariadb_installation.yml