#!/bin/bash

# makes the script existing once an error occours
set -euo pipefail

# find out folder name by repo name
FOLDER=$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)

# compute input and output path if not given
INPUT_INPUT_DIR=${INPUT_INPUT_DIR:-"$FOLDER/api/public"}
INPUT_OUTPUT_DIR=${INPUT_OUTPUT_DIR:-"$FOLDER/api/public"}
INPUT_INPUT_FILENAME=${INPUT_INPUT_FILENAME:-"openapi-raw.yml"}
INPUT_OUTPUT_FILENAME=${INPUT_OUTPUT_FILENAME:-"openapi.yml"}

INPUT_PATH="$INPUT_INPUT_DIR/$INPUT_INPUT_FILENAME"
OUTPUT_PATH="$INPUT_OUTPUT_DIR/$INPUT_OUTPUT_FILENAME"

if [ ! -f "$INPUT_PATH" ]; then
    echo "::error::$INPUT_PATH does not exist!"
    exit 1
fi

# check if requested filetype is correct
if [ "$INPUT_OUTPUT_FILETYPE" != "yaml" ] && [ "$INPUT_OUTPUT_FILETYPE" != "json" ] ; then
    echo "::error::FILETYPE must be either 'yaml' or 'json'!"
    exit 1
fi

# delete output file
echo "::group::Delete output file"
if ["$INPUT_PATH" != "$OUTPUT_PATH"] then
    rm ${OUTPUT_PATH} -v -f
fi
echo "::endgroup::"

# bundle
echo "::group::Bundle file"
if [ "$INPUT_DEREFERENCE" = true ] ; then
    npx -p @apidevtools/swagger-cli swagger-cli bundle -r ${INPUT_PATH} -o ${OUTPUT_PATH} -t ${INPUT_OUTPUT_FILETYPE} 
else
    npx -p @apidevtools/swagger-cli swagger-cli bundle ${INPUT_PATH} -o ${OUTPUT_PATH} -t ${INPUT_OUTPUT_FILETYPE} 
fi
echo "::endgroup::"


# delete sub files by glob
echo "::group::Delete sub files"
if [ "$INPUT_DELETE_FILES" = true ] ; then
    DIR=$(dirname "${INPUT_PATH}")
    cd ${DIR}
    rm ${INPUT_DELETE_GLOB} -v -f
fi
echo "::endgroup::"
