#!/bin/sh -l

# makes the script existing once an error occours
set -eu

# compute values
VERSION=$(echo $GITHUB_REF| cut -d'/' -f 3)
MINOR=$(echo $VERSION| cut -d'.' -f 1,2)
MAJOR=$(echo $VERSION| cut -d'.' -f 1)

# set output for github actions
echo "::set-output name=version_major::${MAJOR}"
echo "::set-output name=version_minor::${MINOR}"
echo "::set-output name=version_patch::${VERSION}"