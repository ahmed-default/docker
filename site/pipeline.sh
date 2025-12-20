#!/bin/bash

set -e

# ============================= VARIABLES =============================== #

IMAGE_NAME="ahmedz9/deploy-site"
TAG=$(date +%Y.%m.%d-%H.%M)
CONTAINER_NAME="ahmed-con"
PORT=8080

# ============================= PIPELINE STEPS =========================== #

echo "Building Image..."
docker build -t $IMAGE_NAME:$TAG -t $IMAGE_NAME:latest .

echo "Running container..."
docker run -d --rm \
  -p $PORT:80 \
  --name $CONTAINER_NAME \
  $IMAGE_NAME:$TAG

echo "Smoke Testing..."

sleep 3

# ======================================================================== #

if ! curl -f http://localhost:$PORT; then
  echo "Smoke test failed"
  docker stop $CONTAINER_NAME
  exit 1
fi
echo "Smoke test passed"

docker stop $CONTAINER_NAME

echo "Pushing image..."
docker push $IMAGE_NAME:$TAG
docker push $IMAGE_NAME:latest


# ======================================================================== #

echo "Deploying with Ansible..."

ansible-playbook -i ansible/inventory.ini ansible/deploy.yml

#docker rmi $IMAGE_NAME:$TAG || true
#docker rmi $IMAGE_NAME:latest || true

echo "docker.hub https://hub.docker.com/repository/docker/ahmedz9/deploy-site/tags"


echo "you can access the site at http://44.222.155.138:$PORT"

# ============================= END OF PIPELINE ========================== #