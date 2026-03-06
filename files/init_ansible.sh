ansible-galaxy collection install git+https://www.github.com/bferguso/arches-ansible,endowment_provisioning -p ./collections
ansible-galaxy collection install community.postgresql
export ANSIBLE_COLLECTIONS_PATH=./collections
