# Create swarm cluster

This set up a docker swarm cluster in [this environment](https://kodekloud.com/topic/playground-ubuntu-20-04-multi-node/)

## Role installations

```
ansible-galaxy install nickjj.docker
ansible-galaxy install atosatto.docker-swarm
```

## Python pip library

Upon installing `atosatto.docker-swarm` role

edit this file:

```
~/.ansible/roles/atosatto.docker-swarm/vars/Debian.yml
```

under `python_pip_packages` map, change the package name from `python-pip` to `python3-pip`

## Create user for all hosts

This will create a local user with ssh key, it will also create a remote user on all hosts

```
cd user
ansible-playbook playbook.yml -i inventory
```

## Distribute keys

Log in with the newly created user `ahmed` and use `distribute-key` directory

> Notice: `ansible.cfg` has been added to disable key check, because it would be the first time to log in to the hosts without keys

```
cd distribute-key
ansible-playbook playbook.yml -i inventory --ask-pass --ask-become-pass
```

## docker installation

Run `install-docker-roles.sh` script before proceeding.

Use `playbook-all-nodes.yml` playbbok with `inventory-all-nodes` inventory file

```
ansible-playbook playbook-all-nodes.yml -i inventory-all-nodes
```

## Network interface

One interface should be selected for Swarm interconnection between nodes.

Check the available interfaces:

```
ip route
```

Test the connectivity for each interface, you can ping each host from the others to detect the valid interface

Pass swarm interface as a command line argument

## jump host model with 2 node clusters

This will set `node01` only as a jump host with `docker-client` installed on this node

It will create 2-node cluster from `node03` as a manager node and `node02` as a worker node

```
ansible-playbook playbook.yml -i inventory -e docker_swarm_interface=eth0
```

## playbook including all nodes

```
ansible-playbook playbook-all-nodes.yml -i inventory-all-nodes -e docker_swarm_interface=eth0 --ask-pass --ask-become-pass
```

## Change context

You need to change the current context upon running the playbook

```
docker context use remote-docker
```

## demo stack

Now the jump host is ready to connect to the remote context

Run this command from the jump host

```
docker stack deploy --compose-file mongo-stack.yml mongo
```

## References

- [docker role](https://galaxy.ansible.com/nickjj/docker)
- [docker swarm role](https://galaxy.ansible.com/atosatto/docker-swarm)