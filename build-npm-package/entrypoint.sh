#!/bin/sh -l

# makes the script existing once an error occours
set -e

# install dependencies
npm install

# build for production
# npm run build --if-present
npm run build

# set version
npm --no-git-tag-version version $INPUT_PACKAGE_VERSION --force

# publish package to registry
npm publish