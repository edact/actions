#!/bin/sh -l

JSON_FMT='{"github-oauth":{"%s": "%s"} }\n'
printf "$JSON_FMT" "$INPUT_REGISTRY_URL" "$REGISTRY_TOKEN" > auth.json