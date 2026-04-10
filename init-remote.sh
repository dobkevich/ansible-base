#!/usr/bin/env bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"

HOST_IP=$1

USAGE="
Connect to a remote host as root and perform initial access configuration
using Ansible (init-remote.yml and admin_user.yml playbooks):

* create automation user 'ansible' with passwordless sudo and add SSH key
* set root password
* remove /root/.ssh/authorized_keys to prevent direct root login
* create admin user 'z' with SSH key
* SSH server hardening (disable password auth etc)
* change SSH port to 54018

Usage:
$(basename $0) <remote host IP>
"

if [ $# -ne "1" ]
then
    echo "$USAGE"
    exit 1
fi

echo "Working directory is $THIS_DIR (it is expected to contain init-remote.yml and admin_user.yml playbooks)."

echo "Configuring remote host at $HOST_IP"

ansible-playbook -i "$HOST_IP," "$THIS_DIR/init-remote.yml"

ansible-playbook -i "$HOST_IP," "$THIS_DIR/admin_user.yml"

echo
echo "Completed."
echo
echo "Now you can log in to the remote host with 'ssh -p 54018 z@$HOST_IP'"
echo
echo "Next steps:"
echo
echo "1. Add new host to inventory/inventory.yml, for example:"
echo "   myhosts:"
echo "     hosts:"
echo "       ..."
echo "       $HOST_IP:"
echo
echo "2. This playbook is supposed to run just once during the initial OS configuration:"
echo "   ansible-playbook -l \"$HOST_IP\" base_init.yml"
echo
echo "3. This playbook can run as often as needed to change the base server configuration:"
echo "   ansible-playbook -l \"$HOST_IP\" base.yml"
echo 
echo "Playbooks use configuration in ansible.cfg (user 'ansible' and SSH port 54018)."
echo
echo "If everything is good, to clear bash history before creating a server image run"
echo '# cat /dev/null > ~/.bash_history && history -c && shutdown -hP now && exit'
echo
