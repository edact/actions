#!/bin/sh -l

# install dependencies needed for production
rm package-lock.json

npm install --production

# run tests specified in package.json
npm run test --if-present

# lint project
npm run lint --if-present