#!/bin/bash

TAG=$1
NAMESPACE=$2
IMAGE_NAME=$3
ACR_LOGIN_SERVER=$4
CHART_DIR=$5

export KUBECONFIG=$HOME/.kube/config

cd "$CHART_DIR" || exit 1

CHART_PACKAGE="${NAMESPACE}-${TAG}.tgz"
# The actual tgz file should be <chartName>-<version>.tgz
# To make it generic:
CHART_PACKAGE_FILE=$(ls *-"$TAG".tgz | head -1)

if [ -z "$CHART_PACKAGE_FILE" ]; then
  echo "Error: Helm chart package for version $TAG not found!"
  exit 1
fi

if ! helm ls -n "$NAMESPACE" | grep -q "$IMAGE_NAME"; then
  echo "Installing Helm chart..."
  helm install "$IMAGE_NAME" "$CHART_PACKAGE_FILE" \
    --set image.repository="$ACR_LOGIN_SERVER/$IMAGE_NAME" \
    --set image.tag="$TAG" \
    --namespace "$NAMESPACE" --create-namespace
else
  echo "Upgrading Helm chart..."
  helm upgrade "$IMAGE_NAME" "$CHART_PACKAGE_FILE" \
    --set image.repository="$ACR_LOGIN_SERVER/$IMAGE_NAME" \
    --set image.tag="$TAG" \
    --namespace "$NAMESPACE"
fi

