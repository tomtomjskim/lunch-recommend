#!/usr/bin/env bash
# Deploy the backend container to AWS Elastic Container Service (ECS).
#
# Required environment variables:
#   AWS_ACCOUNT_ID  - AWS account ID that owns the ECR repository
#   AWS_REGION      - AWS region (e.g. us-east-1)
#   ECR_REPOSITORY  - Name of the ECR repository (without registry hostname)
#   IMAGE_TAG       - Tag to apply to the built image (e.g. latest)
#   ECS_CLUSTER     - Name of the ECS cluster to update
#   ECS_SERVICE     - Name of the ECS service to update
#
# This script builds the backend Docker image, pushes it to ECR,
# and triggers a new deployment on the specified ECS service.
set -euo pipefail

if [[ -z "${AWS_ACCOUNT_ID:-}" || -z "${AWS_REGION:-}" || -z "${ECR_REPOSITORY:-}" || -z "${IMAGE_TAG:-}" || -z "${ECS_CLUSTER:-}" || -z "${ECS_SERVICE:-}" ]]; then
  echo "One or more required environment variables are missing." >&2
  exit 1
fi

REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE="$REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"

# Authenticate Docker to ECR
aws ecr get-login-password --region "$AWS_REGION" |
  docker login --username AWS --password-stdin "$REGISTRY"

# Build and push the image
DOCKER_BUILDKIT=1 docker build -t "$IMAGE" ../../..
docker push "$IMAGE"

# Update the ECS service to use the new image tag
aws ecs update-service \
  --cluster "$ECS_CLUSTER" \
  --service "$ECS_SERVICE" \
  --force-new-deployment > /dev/null

echo "Deployment triggered for $ECS_SERVICE using image $IMAGE"
