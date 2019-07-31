#!/bin/bash

docker build -t stacks-node-rhel7-ansible .
docker tag stacks-node-rhel7-ansible:latest quay.io/rht-labs/stacks-node-rhel7-ansible:latest
docker push quay.io/rht-labs/stacks-node-rhel7-ansible:latest
