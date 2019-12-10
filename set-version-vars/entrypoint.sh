#!/bin/sh -l

echo $INPUT_IMAGE_TAGS

tags=$(echo $IMAGE_TAGS | tr ", " "\n")

for addr in $tags
do
    echo "> [$addr]"
    echo $(echo '${'$addr'}')
done

VERSION=$(echo $GITHUB_REF| cut -d'/' -f 3)
MINOR=$(echo $VERSION| cut -d'.' -f 1,2)
MAJOR=$(echo $VERSION| cut -d'.' -f 1)

echo "::set-env name=VERSION_PATCH::${VERSION}"
echo "::set-env name=VERSION_MAJOR::${MAJOR}"
echo "::set-env name=VERSION_MINOR::${MINOR}"