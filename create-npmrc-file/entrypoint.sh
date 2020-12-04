#!/bin/sh -l

# makes the script existing once an error occours
set -e

printf "${INPUT_NPM_SCOPE}:registry=https://${INPUT_NPM_REGISTRY_URL}/ \n //${INPUT_NPM_REGISTRY_URL}/:_authToken=${REGISTRY_TOKEN}"> .npmrc