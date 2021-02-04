#!/bin/bash -l

# makes the script existing once an error occours
set -euo pipefail

# switch to working directory
cd ${INPUT_WORKING_DIRECTORY}

# log into docker registry
echo ${INPUT_DOCKER_REGISTRY_TOKEN} | docker login -u ${INPUT_DOCKER_REGISTRY_USER} --password-stdin ${INPUT_DOCKER_REGISTRY_URL}

FULL_IMAGE_NAME=${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}

# split image tags in array
IFS=', ' read -r -a IMAGE_TAGS <<< "$INPUT_IMAGE_TAGS"

# pull image for caching
docker pull ${FULL_IMAGE_NAME}:${IMAGE_TAGS[0]} --quiet

# build image
echo "::group::Build image"
docker build \
    --build-arg=DOCKER_REGISTRY_URL=${INPUT_DOCKER_REGISTRY_URL} \
    --build-arg=BASE_TAG=${INPUT_BUILD_BASE_TAG} \
    --cache-from=${FULL_IMAGE_NAME}:${IMAGE_TAGS[0]} \
    -t tempcontainer:latest .
echo "::endgroup::"

# set tags
for IMAGE_TAG in "${IMAGE_TAGS[@]}"
do
    docker tag tempcontainer:latest ${FULL_IMAGE_NAME}:${IMAGE_TAG}    
done

# push image to registry
echo "::group::Push image"
docker push ${FULL_IMAGE_NAME} --all-tags
echo "::endgroup::"