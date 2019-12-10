#!/bin/sh -l


printf "@edact:registry=$INPUT_NPM_REGISTRY_URL \n \
          //npm.pkg.github.com/:_authToken=${REGISTRY_TOKEN} \n \
          @fortawesome:registry=https://npm.fontawesome.com/ \n \
          //npm.fontawesome.com/:_authToken=${FONTAWESOME_TOKEN}"> .npmrc

docker login ${INPUT_DOCKER_REGISTRY_URL} -u publisher -p "${REGISTRY_TOKEN}"

docker build \
    --build-arg REGISTRY_TOKEN=${REGISTRY_TOKEN} \
    --build-arg FONTAWESOME_TOKEN=${FONTAWESOME_TOKEN} \
    -t tempcontainer .

docker tag tempcontainer ${INPUT_DOCKER_REGISTRY_URL}${GITHUB_REPOSITORY}${IMAGE_NAME}:${IMAGE_TAG}

docker push ${INPUT_DOCKER_REGISTRY_URL}${GITHUB_REPOSITORY}${IMAGE_NAME}