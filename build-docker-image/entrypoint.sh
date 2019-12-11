#!/bin/sh -l

# log into docker registry
docker login ${INPUT_DOCKER_REGISTRY_URL} -u publisher -p "${REGISTRY_TOKEN}"

# build image
docker build \
    --build-arg REGISTRY_TOKEN=${REGISTRY_TOKEN} \
    --build-arg FONTAWESOME_TOKEN=${FONTAWESOME_TOKEN} \
    -t tempcontainer .

# split image tags in array
image_tags=$(echo $INPUT_IMAGE_TAGS | tr ", " "\n")

# set tags
for image_tag in $image_tags
do
    docker tag tempcontainer ${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}:${image_tag}    
done

# push image to registry
docker push ${INPUT_DOCKER_REGISTRY_URL}/${GITHUB_REPOSITORY}/${INPUT_IMAGE_NAME}