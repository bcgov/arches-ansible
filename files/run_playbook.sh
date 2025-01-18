#!/bin/bash
export ANSIBLE_COLLECTIONS_PATH=./collections
#export PLAYBOOK_DIR=.
export PLAYBOOK_DIR=$ANSIBLE_COLLECTIONS_PATH/ansible_collections/bcgov_arches/arches_deployer/playbooks
export INVENTORY_BASE=$ANSIBLE_COLLECTIONS_PATH/ansible_collections/bcgov_arches/arches_deployer/inventory
# Servers are sometimes VERY slow when authenticating
export ANSIBLE_TIMEOUT=60

if [ -z "$1" ]; then
  echo 'Must specify playbook to execute. eg ./run_playbook arches-app.yml [ dlvr | test| prod ]'
  exit 1
fi

if [ -z "$2" ]; then
  echo 'Must specify an instance. eg ./run_playbook arches-app.yml [ dlvr | test | prod ]'
  exit 1
fi

export PLAYBOOK_FILE=$PLAYBOOK_DIR/$1
echo "Playbook file: $PLAYBOOK_FILE"

if [ ! -f $PLAYBOOK_FILE ]; then
  echo 'Playbook does not exist: ' $PLAYBOOK_FILE
  exit 1
fi

export APP_INSTANCE=$2
echo "App instance: $APP_INSTANCE"

# Want to disable prod deployments by default. Need another check somewhere?
# Would be good to disable connections / deployments directly on EARLY somehow
if [ "$APP_INSTANCE" == "prod" ]; then
   echo "Need to enable script for PROD"
   exit 1
fi

if [ "$APP_INSTANCE" == "dlvr" ] || [ "$APP_INSTANCE" == "test" ]; then
   export INVENTORY_DIR=$INVENTORY_BASE/dlvr_test
else
   export INVENTORY_DIR=$INVENTORY_BASE/$APP_INSTANCE
fi
if [ ! -d "$INVENTORY_DIR" ]; then
   echo "Inventory $INVENTORY_DIR does not exist"
   exit 1
fi

[ ! -f "./local_vars.yml" ] && touch ./local_vars.yml

if [[ $PLAYBOOK_FILE =~ .*(arches-app|arches-data|arches-purge-backups)\.yml ]]; then
   if [ -z "$3" ]; then
     echo "Must specify target application. eg ./run_arches_playbook $PLAYBOOK_FILE <dlvr|test> <bcfms|bcrhp>"
     exit 1
   else
      export APP_ACRONYM=$3

      ansible-playbook \
         -i $INVENTORY_DIR \
         --vault-password-file=./vault_passwd.txt \
         --extra-vars @./local_vars.yml -vvv\
         --extra-vars "app_instance=$2 app_acronym=$3 $4 $5 $6" \
         $PLAYBOOK_FILE
   fi
else
  ansible-playbook \
     -i $INVENTORY_DIR \
     --vault-password-file=./vault_passwd.txt \
     --extra-vars @./local_vars.yml -vvv \
     $PLAYBOOK_FILE
fi
