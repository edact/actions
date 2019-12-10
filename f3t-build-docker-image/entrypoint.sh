#!/bin/sh -l

docker login ${INPUT_DOCKER_REGISTRY_URL} -u publisher -p "${REGISTRY_TOKEN}"

docker build \
    --build-arg REGISTRY_TOKEN=${REGISTRY_TOKEN} \
    --build-arg FONTAWESOME_TOKEN=${FONTAWESOME_TOKEN} \
    -t tempcontainer .

docker tag tempcontainer ${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}:${INPUT_IMAGE_TAG}

docker push ${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}