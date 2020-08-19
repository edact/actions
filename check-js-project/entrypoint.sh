#!/bin/sh -l

# remove locked dependency versions
rm package-lock.json -f

# set mode to production
$NODE_ENV="production"

# install dependencies
npm install --production

# run tests specified in package.json
npm run test --if-present

# lint project
npm run lint --if-present