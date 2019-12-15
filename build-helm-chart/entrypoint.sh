#!/bin/sh -l

export HELM_EXPERIMENTAL_OCI=1

# switch to working directory
cd ${INPUT_WORKING_DIRECTORY}

# log into helm registry
helm registry login -u "${INPUT_HELM_REGISTRY_USER}" -p "${INPUT_HELM_REGISTRY_TOKEN}" ${INPUT_HELM_REGISTRY_URL}

# split chart tags in array
chart_tags=$(echo $INPUT_CHART_TAGS | tr ", " "\n")

# set tags
for chart_tag in $chart_tags
do 
    helm chart save . ${INPUT_HELM_REGISTRY_URL}/helm/${GITHUB_REPOSITORY}/${INPUT_CHART_NAME}:${chart_tag}
    helm chart push ${INPUT_HELM_REGISTRY_URL}/helm/${GITHUB_REPOSITORY}/${INPUT_CHART_NAME}:${chart_tag}
done