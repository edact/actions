#!/bin/sh -l

# makes the script existing once an error occours
set -e

# install dependencies
npm install

# run tests specified in package.json
npm run test --if-present

# set mode to production
export NODE_ENV="production"

# lint project
npm run lint --if-present --no-fix
