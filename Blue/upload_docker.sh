#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
# dockerpath=<your docker ID/path>
dockerpath=udacitybluecap

# Step 2:  
# Authenticate & tag
docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
docker tag udacitybluecap nakotisanthosh/udacitybluecap

# Step 3:
# Push image to a docker repository
docker push nakotisanthosh/udacitybluecap
