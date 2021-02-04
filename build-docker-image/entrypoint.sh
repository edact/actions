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
    docker pull ${FULL_IMAGE_NAME}:${FIRST_IMAGE_TAG} --quiet || true
fi

# pull image for caching
if [ -n "$INPUT_CACHE_BUILD_STAGE" ]; then
    echo "::group::Build cache image"
    BUILD_STAGE_IMAGE_TAG="cache-${INPUT_CACHE_BUILD_STAGE}"
    docker pull ${FULL_IMAGE_NAME}:${BUILD_STAGE_IMAGE_TAG} --quiet || true

    docker build \
    --target ${INPUT_CACHE_BUILD_STAGE} \
    --build-arg=DOCKER_REGISTRY_URL=${INPUT_DOCKER_REGISTRY_URL} \
    --build-arg=BASE_TAG=${INPUT_BUILD_BASE_TAG} \
    --cache-from=${FULL_IMAGE_NAME}:${BUILD_STAGE_IMAGE_TAG} \
    -t ${FULL_IMAGE_NAME}:${BUILD_STAGE_IMAGE_TAG} .

    docker push ${FULL_IMAGE_NAME}:${BUILD_STAGE_IMAGE_TAG}
    echo "::endgroup::"
fi

# build image
echo "::group::Build image"
docker build \
    --build-arg=DOCKER_REGISTRY_URL=${INPUT_DOCKER_REGISTRY_URL} \
    --build-arg=BASE_TAG=${INPUT_BUILD_BASE_TAG} \
    $( (("$INPUT_USE_CACHE" = true)) && printf %s "--cache-from=${FULL_IMAGE_NAME}:${FIRST_IMAGE_TAG}") \
    $( (("$INPUT_USE_CACHE" = true)) && ((-n "$INPUT_CACHE_BUILD_STAGE")) && printf %s "--cache-from=${FULL_IMAGE_NAME}:${FIRST_IMAGE_TAG}") \
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