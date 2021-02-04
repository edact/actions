#!/bin/sh -l

# makes the script existing once an error occours
set -euo pipefail

# switch to working directory
cd ${INPUT_WORKING_DIRECTORY}

# log into docker registry
echo ${INPUT_DOCKER_REGISTRY_TOKEN} | docker login -u ${INPUT_DOCKER_REGISTRY_USER} --password-stdin ${INPUT_DOCKER_REGISTRY_URL}

FULL_IMAGE_NAME=${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}

# pull image for caching
docker pull ${FULL_IMAGE_NAME}

# build image
echo "::group::Build image"
docker build \
    --build-arg=DOCKER_REGISTRY_URL=${INPUT_DOCKER_REGISTRY_URL} \
    --build-arg=BASE_TAG=${INPUT_BUILD_BASE_TAG} \
    --cache-from=${FULL_IMAGE_NAME}
    -t tempcontainer:latest .
echo "::endgroup::"

# split image tags in array
image_tags=$(echo $INPUT_IMAGE_TAGS | tr ", " "\n")

# set tags
for image_tag in $image_tags
do
    echo $image_tag
    docker tag tempcontainer:latest ${FULL_IMAGE_NAME}:${image_tag}    
done

# push image to registry
echo "::group::Push image"
docker push ${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME} --all-tags
echo "::endgroup::"