#!/bin/sh -l

npm ci

npm run build
        
V=$(echo $GITHUB_REF| cut -d'/' -f 3)
VERSION=$(echo $V| cut -d'v' -f 2)

npm --no-git-tag-version version $VERSION --force

npm publish