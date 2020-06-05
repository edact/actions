#!/bin/sh -l

# install dependencies needed for production
npm ci

# build for production
npm run build --if-present

# set version
npm --no-git-tag-version version $INPUT_PACKAGE_VERSION --force

# publish package to registry
npm publish --registry $INPUT_NPM_REGISTRY_URL