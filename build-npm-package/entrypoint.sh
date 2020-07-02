#!/bin/sh -l

# remove locked dependency versions
rm package-lock.json -f

# install dependencies needed for production
npm install

# build for production
npm run build --if-present

# set version
npm --no-git-tag-version version $INPUT_PACKAGE_VERSION --force

# publish package to registry
npm publish