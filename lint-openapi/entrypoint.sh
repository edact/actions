#!/bin/bash

# makes the script existing once an error occours
set -euo pipefail

# find out folder name by repo name
FOLDER=$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)

# compute input and output path if not given
INPUT_INPUT_PATH=${INPUT_INPUT_PATH:-"$FOLDER/api/public/openapi.yml"}

if [ ! -f "$INPUT_INPUT_PATH" ]; then
    echo "::error::$INPUT_INPUT_PATH does not exist!"
    exit 1
fi

# lint
npx -p @stoplight/spectral spectral lint ${INPUT_INPUT_PATH} --skip-rule oas3-unused-components-schema
