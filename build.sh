#!/bin/sh

if [ "$1" != "" ]; then
    TERRAFORM_VERSION="$1"
else
    TERRAFORM_VERSION="latest"
fi

TERRAFORM_IMAGE=hashicorp/terraform:${TERRAFORM_VERSION}
MERGERMARKET_IMAGE="mergermarket/terraform:$TERRAFORM_VERSION"

docker build --build-arg terraform_image_name=${TERRAFORM_IMAGE} -t $MERGERMARKET_IMAGE .

docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD

docker push $MERGERMARKET_IMAGE