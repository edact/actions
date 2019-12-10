#!/bin/sh -l

printf '@edact:registry=${1} \n \
          //npm.pkg.github.com/:_authToken=${2} \n \
          @fortawesome:registry=https://npm.fontawesome.com/ \n \
          //npm.fontawesome.com/:_authToken=${3}
          ' > .npmrc

npm ci

npm run build
      
        
#V=$(echo $GITHUB_REF| cut -d'/' -f 3)
#VERSION=$(echo $V| cut -d'v' -f 2)

#npm --no-git-tag-version version $VERSION --force

#npm publish