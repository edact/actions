#!/bin/sh -l

# find out folder name by repo name
FOLDER=$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)

# compute input and output path if not given
if [ "${INPUT_INPUT_PATH}"=="defaultpath" ]
    then INPUT_INPUT_PATH="$FOLDER/api/public/openapi-raw.yml"
fi

if [ "${INPUT_OUTPUT_PATH}"=="defaultpath" ]
    then INPUT_OUTPUT_PATH="$FOLDER/api/public/openapi.yml"
fi

if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist!"
    exit 1
fi

# delete output file
rm ${INPUT_OUTPUT_FILETYPE} -v -f

# bundle
npx -p @apidevtools/swagger-cli swagger-cli bundle -r ${INPUT_INPUT_PATH} -o ${INPUT_OUTPUT_PATH} -t ${INPUT_OUTPUT_FILETYPE} 

# delete sub files by glob
DIR=$(dirname "${INPUT_INPUT_PATH}")
cd ${DIR}
rm ${INPUT_DELETE_GLOB} -v -f
