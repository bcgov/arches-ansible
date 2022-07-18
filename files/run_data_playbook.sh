export ANSIBLE_COLLECTIONS_PATH=./collections
[ ! -f "./local_vars.yml" ] && touch ./local_vars.yml
ansible-playbook \
   -i collections/ansible_collections/bcgov_arches/arches_deployer/inventory/sandbox \
   --extra-vars @./local_vars.yml \
   collections/ansible_collections/bcgov_arches/arches_deployer/playbooks/bcrhp-data-legacy.yml

