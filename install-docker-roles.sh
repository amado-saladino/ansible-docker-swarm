#! /bin/bash

ansible-galaxy install nickjj.docker
ansible-galaxy install atosatto.docker-swarm

# change python-pip to python3-pip
sed -i 's/python-pip/python3-pip/' ~/.ansible/roles/atosatto.docker-swarm/vars/Debian.yml