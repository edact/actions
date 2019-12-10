#!/bin/sh -l

echo HALLO WELT

echo $tagges

echo $image_tags

tags=$(echo $image_tags | tr ", " "\n")

for addr in $tags
do
    echo "> [$addr]"
done

tagsarr=$(echo $tagges | tr ", " "\n")

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