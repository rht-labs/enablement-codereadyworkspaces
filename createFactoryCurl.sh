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

export FACT_ID=$(curl -vvv -X POST "${CODEREADY_API}/factory" \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header "Authorization: Bearer $TKN" \
--data-binary "@do500-factory.json" | jq -r '.links')

if [ ! -z "$FACT_ID" ]
then
  echo "Factory Create URL $FACT_ID"
else
  echo "Factory not created"
fi

