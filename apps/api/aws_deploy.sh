#!/usr/bin/env bash

COMMAND=${1:-"help"}
ENVIRONMENT=${2:-""}

ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
REGION=us-east-1
REGISTRY_PATH=${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
ECR_IMAGE_NAME=${REGISTRY_PATH}/${ENVIRONMENT}-api

ecr_login() {
  aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${REGISTRY_PATH}
}

build() {
  docker build -t ${ECR_IMAGE_NAME}:latest --build-arg ENVIRONMENT=${ENVIRONMENT} .
}

push() {
  docker push ${ECR_IMAGE_NAME}:latest
}

case "${COMMAND}" in
  ecr_login) ecr_login ;;
  build) build ;;
  push) push ;;
esac
