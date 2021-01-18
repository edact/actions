#!/bin/sh -l

# makes the script existing once an error occours
set -euo pipefail

# find out folder name by repo name
FOLDER=$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)

# compute input and output path if not given
if [ "${INPUT_INPUT_DIR}" = "defaultdir" ]
    then INPUT_INPUT_DIR="$FOLDER/api/public"
fi

if [ "${INPUT_OUTPUT_DIR}" = "defaultdir" ]
    then INPUT_OUTPUT_DIR="$FOLDER/api/public"
fi

if [ "${INPUT_INPUT_FILENAME}" = "defaultname" ]
    then INPUT_INPUT_FILENAME="openapi-raw.yml"
fi

if [ "${INPUT_OUTPUT_FILENAME}" = "defaultname" ]
    then INPUT_OUTPUT_FILENAME="openapi.yml"
fi

INPUT_PATH="$INPUT_INPUT_DIR/$INPUT_INPUT_FILENAME"
OUTPUT_PATH="$INPUT_OUTPUT_DIR/$INPUT_OUTPUT_FILENAME"

if [ ! -f "$INPUT_PATH" ]; then
    echo "::error::$INPUT_PATH does not exist!"
    exit 1
fi

# delete output file
echo "::group::Delete output file"
rm ${INPUT_OUTPUT_FILETYPE} -v -f
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