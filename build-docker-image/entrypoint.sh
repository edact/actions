#!/bin/sh -l

# switch to working directory
cd ${INPUT_WORKING_DIRECTORY}

# log into docker registry
echo ${INPUT_DOCKER_REGISTRY_TOKEN} | docker login -u ${INPUT_DOCKER_REGISTRY_USER} --password-stdin ${INPUT_DOCKER_REGISTRY_URL}

# build image
docker build \
    --build-arg=DOCKER_REGISTRY_URL=${INPUT_DOCKER_REGISTRY_URL} \
    --build-arg=BASE_TAG=${INPUT_BUILD_BASE_TAG} \
    -t tempcontainer:latest .

# split image tags in array
image_tags=$(echo $INPUT_IMAGE_TAGS | tr ", " "\n")

# set tags
for image_tag in $image_tags
do
    docker tag tempcontainer:latest ${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}:${image_tag}    
done

# push image to registry
docker push ${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}