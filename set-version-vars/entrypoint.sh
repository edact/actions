#!/bin/sh -l

echo $TAGS;

tagsarr=$(echo $tags | tr ", " "\n")

for addr in $tagsarr
do
    echo "> [$addr]"
done

VERSION=$(echo $GITHUB_REF| cut -d'/' -f 3)
MINOR=$(echo $VERSION| cut -d'.' -f 1,2)
MAJOR=$(echo $VERSION| cut -d'.' -f 1)

echo "::set-env name=VERSION_PATCH::${VERSION}"
echo "::set-env name=VERSION_MAJOR::${MAJOR}"
echo "::set-env name=VERSION_MINOR::${MINOR}"