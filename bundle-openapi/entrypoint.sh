#!/bin/sh -l
GITHUB_REPOSITORY="edact/a3t-provider-sql"
INPUT_PATH="defaultpath"

# find out folder name by repo name
FOLDER=$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)

# compute input and output path if not given
if [ "$INPUT_PATH" == "defaultpath" ]
    then INPUT_PATH="$FOLDER/api/public/openapi.yml"
fi

if [ "$OUTPUT_PATH" == "defaultpath" ]
    then OUTPUT_PATH="$FOLDER/api/public/openapi.yml"
fi

# bundle
# npx -p @apidevtools/swagger-cli swagger-cli bundle $INPUT_PATH -o $OUTPUT_PATH -t $OUTPUT_FILETYPE 

# delete sub files by glob
DIR=$(dirname "$INPUT_PATH")
cd $DIR
rm $DELETE_GLOB