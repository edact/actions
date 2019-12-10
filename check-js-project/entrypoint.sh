#!/bin/sh -l

npm ci

npm run test --if-present

npm run lint --if-present