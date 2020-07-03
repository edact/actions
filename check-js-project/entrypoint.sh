#!/bin/sh -l

# remove locked dependency versions
rm package-lock.json -f

# install dependencies
npm install

# run tests specified in package.json
npm run test --if-present

# lint project
npm run lint --if-present