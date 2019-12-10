#!/bin/sh -l

printf "@edact:registry=https://$INPUT_NPM_REGISTRY_URL/ \n \
          //${INPUT_NPM_REGISTRY_URL}/:_authToken=${REGISTRY_TOKEN} \n \
          @fortawesome:registry=https://npm.fontawesome.com/ \n \
          //npm.fontawesome.com/:_authToken=$FONTAWESOME_TOKEN"> .npmrc