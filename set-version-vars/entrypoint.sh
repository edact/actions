#!/bin/sh -l

VERSION=$(echo $GITHUB_REF| cut -d'/' -f 3)
MINOR=$(echo $VERSION| cut -d'.' -f 1,2)
MAJOR=$(echo $VERSION| cut -d'.' -f 1)

echo "::set-env name=VERSION_PATCH::${VERSION}"
echo "::set-env name=VERSION_MAJOR::${MAJOR}"
echo "::set-env name=VERSION_MINOR::${MINOR}"