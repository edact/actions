#!/bin/sh -l

# makes the script existing once an error occours
set -eu

# install dependencies
echo "::group::Install package dependencies"
npm install
echo "::endgroup::"

# build for production
echo "::group::Build package"
npm run build
echo "::endgroup::"