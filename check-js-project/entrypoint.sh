#!/bin/sh -l

# install dependencies needed for production
npm install

# run tests specified in package.json
npm run test --if-present

# lint project
npm run lint --if-present