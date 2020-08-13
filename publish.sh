#!/bin/sh

get_terraform_version()
{
    TERRAFORM_LATEST= wget -q https://registry.hub.docker.com/v1/repositories/hashicorp/terraform/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | sort --version-sort -t . | sed -ne 's/[^0-9]*\(\([0-9]*\.\)\{0,4\}[0-9][^.]\)/\1/p' | tail -n 1
}

get_mergermarket_version()
{
    MERGERMARKET_LATEST= wget -q https://registry.hub.docker.com/v1/repositories/mergermarket/terraform/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}' | sort --version-sort -t . | sed -ne 's/[^0-9]*\(\([0-9]*\.\)\{0,4\}[0-9][^.]\)/\1/p' | tail -n 1
}

BUILD_LATEST= false

if [[ "$1" != "" ]]; then
    TERRAFORM_VERSION="$1"
else
    TERRAFORM_LATEST="$(get_terraform_version)"
    MERGERMARKET_LATEST="$(get_mergermarket_version)"

    echo "Terraform Version: $TERRAFORM_LATEST"
    echo "Mergermarket Version: $MERGERMARKET_LATEST"

    if [ $TERRAFORM_LATEST != $MERGERMARKET_LATEST ]; then
        TERRAFORM_VERSION="$TERRAFORM_LATEST"
        BUILD_LATEST= true

    else
        echo "Mergermarket version is up to date, nothing to do here!"
        exit 0
    fi
fi

TERRAFORM_IMAGE="hashicorp/terraform:$TERRAFORM_VERSION"
MERGERMARKET_IMAGE="mergermarket/terraform:$TERRAFORM_VERSION"

docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD
if $BUILD_LATEST ; then
    echo 'Building latest terraform version'
    docker build --build-arg terraform_image_name=${TERRAFORM_IMAGE} -t $MERGERMARKET_IMAGE -t mergermarket/terraform:latest .
    docker push $MERGERMARKET_IMAGE
    docker push "mergermarket/terraform:latest"
else 
    echo 'Building version: $TERRAFORM_VERSION' 
    docker build --build-arg terraform_image_name=${TERRAFORM_IMAGE} -t $MERGERMARKET_IMAGE .
    docker push $MERGERMARKET_IMAGE
fi