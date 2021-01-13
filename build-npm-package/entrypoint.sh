#!/bin/sh -l

# makes the script existing once an error occours
set -e

npm adduser --registry=https://npm.pkg.github.com --scope=@edact

# install dependencies
echo "::group::Install package dependencies"
npm ci
echo "::endgroup::"

# build for production
echo "::group::Build package"
npm run build
echo "::endgroup::"

# set version
npm --no-git-tag-version version $INPUT_PACKAGE_VERSION --force

# publish package to registry
echo "::group::Publish package"
npm publish --registry https://npm.pkg.github.com
echo "::endgroup::"
