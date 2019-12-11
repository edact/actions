#!/bin/sh -l

npm ci

npm run build

npm --no-git-tag-version version $INPUT_PACKAGE_VERSION --force

npm publish