#!/bin/bash

# requires https://stedolan.github.io/jq/download/

# config
KEYCLOAK_URL=http://keycloak-crw.apps.foo.sandbox563.opentlc.com/auth
KEYCLOAK_REALM=codeready
KEYCLOAK_CLIENT_ID=admin
KEYCLOAK_CLIENT_SECRET=admin
CODEREADY_API=http://codeready-crw.apps.foo.sandbox563.opentlc.com/api

export TKN=$(curl -X POST "${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token" \
 -H "Content-Type: application/x-www-form-urlencoded" \
 -d "username=${KEYCLOAK_CLIENT_ID}" \
 -d "password=${KEYCLOAK_CLIENT_SECRET}" \
 -d 'grant_type=password' \
 -d 'client_id=admin-cli' | jq -r '.access_token')

export STACK_ID=$(curl -v -X POST "${CODEREADY_API}/stack" \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: Bearer $TKN" \
--data-binary "@do500-raw-config.json" | jq -r '.id')

if [ ! -z "$STACK_ID" ]
then
  echo "Stack Id $STACK_ID"
  curl -X POST "${CODEREADY_API}/permissions" \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer $TKN" \
  -d "{ \"userId\": \"*\", \"domainId\": \"stack\", \"instanceId\": \"$STACK_ID\", \"actions\": [ \"read\", \"search\" ] }"
else
  echo "Stack not created"
fi

