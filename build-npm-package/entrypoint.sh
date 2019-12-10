#!/bin/sh -l

npm ci

npm run build

npm --no-git-tag-version version $VERSION_PATCH --force

npm publish