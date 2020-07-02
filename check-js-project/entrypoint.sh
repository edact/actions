#!/bin/sh -l

# remove locked dependency versions
rm package-lock.json

# install dependencies needed for production
npm install --production

# run tests specified in package.json
npm run test --if-present

# lint project
npm run lint --if-present