#!/bin/bash
export ANSIBLE_COLLECTIONS_PATH=./collections
#export PLAYBOOK_DIR=.
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

if [[ $PLAYBOOK_FILE =~ .*(arches|data|arches-purge-backups)\.yml ]]; then
   if [ -z "$3" ]; then
     echo "Must specify playbook to execute. eg ./run_arches_playbook $PLAYBOOK_FILE <dlvr|test> <bcfms|bcrhp>"
     exit 1
   else
      export APP_INSTANCE=$2
      export APP_ACRONYM=$3
      ansible-playbook \
         -i collections/ansible_collections/bcgov_arches/arches_deployer/inventory/sandbox \
         --vault-password-file=./vault_passwd.txt \
         --extra-vars @./local_vars.yml -vvv \
         --extra-vars "app_instance=$2 app_acronym=$3 $4 $5 $6" \
         $PLAYBOOK_FILE
   fi
else
  ansible-playbook \
     -i collections/ansible_collections/bcgov_arches/arches_deployer/inventory/sandbox \
     --vault-password-file=./vault_passwd.txt \
     --extra-vars @./local_vars.yml -vvv \
     $PLAYBOOK_FILE
fi
