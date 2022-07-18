#!/bin/bash
export ANSIBLE_COLLECTIONS_PATH=./collections
export PLAYBOOK_DIR=$ANSIBLE_COLLECTIONS_PATH/ansible_collections/bcgov_arches/arches_deployer/playbooks

if [ -z "$1" ]; then
  echo 'Must specify playbook to execute. eg ./run_playbook bchp-legacy.yml'
  exit 1
fi

export PLAYBOOK_FILE=$PLAYBOOK_DIR/$1
echo "Playbook file: $PLAYBOOK_FILE"

if [ ! -f $PLAYBOOK_FILE ]; then
  echo 'Playbook does not exist: ' $PLAYBOOK_FILE
  exit 1
fi


[ ! -f "./local_vars.yml" ] && touch ./local_vars.yml

ansible-playbook \
   -i collections/ansible_collections/bcgov_arches/arches_deployer/inventory/sandbox \
   --extra-vars @./local_vars.yml \
   $PLAYBOOK_FILE


