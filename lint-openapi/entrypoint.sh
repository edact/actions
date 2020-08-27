#!/bin/sh -l

# find out folder name by repo name
FOLDER=$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)

# compute input and output path if not given
if [ "${INPUT_INPUT_PATH}"=="defaultpath" ]
    then INPUT_INPUT_PATH="$FOLDER/api/public/openapi.yml"
fi

if [ ! -f "$INPUT_INPUT_PATH" ]; then
    echo "::error::$INPUT_INPUT_PATH does not exist!"
    exit 1
fi

# lint
npx -p @stoplight/spectral spectral lint e3t-module-school/api/public/openapi.yml --skip-rule oas3-unused-components-schema