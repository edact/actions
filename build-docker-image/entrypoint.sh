#!/bin/sh -l

# makes the script existing once an error occours
set -euo pipefail

# switch to working directory
cd ${INPUT_WORKING_DIRECTORY}

# log into docker registry
echo ${INPUT_DOCKER_REGISTRY_TOKEN} | docker login -u ${INPUT_DOCKER_REGISTRY_USER} --password-stdin ${INPUT_DOCKER_REGISTRY_URL}

FULL_IMAGE_NAME=${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}

# split image tags in array
IMAGE_TAGS=$(echo $INPUT_IMAGE_TAGS | tr ", " "\n")
FIRST_IMAGE_TAG=$(echo $INPUT_IMAGE_TAGS | cut -f1 -d",")

# pull image for caching
if [ "$INPUT_USE_CACHE" = true ] ; then
    docker pull ${FULL_IMAGE_NAME}:${FIRST_IMAGE_TAG} --quiet
fi

# build image
echo "::group::Build image"
docker build \
    --build-arg=DOCKER_REGISTRY_URL=${INPUT_DOCKER_REGISTRY_URL} \
    --build-arg=BASE_TAG=${INPUT_BUILD_BASE_TAG} \
    $( (("$INPUT_USE_CACHE" = true)) && printf %s "--cache-from=${FULL_IMAGE_NAME}:${FIRST_IMAGE_TAG}") \
    -t tempcontainer:latest .
echo "::endgroup::"

# set tags
for IMAGE_TAG in $IMAGE_TAGS
do
    docker tag tempcontainer:latest ${FULL_IMAGE_NAME}:${IMAGE_TAG}    
done

# push image to registry
echo "::group::Push image"
docker push ${FULL_IMAGE_NAME} --all-tags
echo "::endgroup::"