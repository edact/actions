#!/bin/sh -l

printf '@edact:registry=${1} \n \
          //npm.pkg.github.com/:_authToken=${REGISTRY_TOKEN} \n \
          @fortawesome:registry=https://npm.fontawesome.com/ \n \
          //npm.fontawesome.com/:_authToken=${FONTAWESOME_TOKEN}'> .npmrc



npm ci

npm run build
      
        
#V=$(echo $GITHUB_REF| cut -d'/' -f 3)
#VERSION=$(echo $V| cut -d'v' -f 2)

#npm --no-git-tag-version version $VERSION --force

#npm publish