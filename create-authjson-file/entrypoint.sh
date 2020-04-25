#!/bin/sh -l

JSON_FMT='{"github-oauth":{"%s": "%s"} }\n'
printf "$JSON_FMT" "$INPUT_REGISTRY_URL" "$PHP_DEPLOY_TOKEN" > auth.json
mv auth.json ./$INPUT_LOCATION
