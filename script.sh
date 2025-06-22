#!/bin/bash
TAG=$1
NAMESPACE=$2
CHART_NAME=$3
ACR_LOGIN_SERVER=$4
CHART_DIR=$5

export KUBECONFIG=$HOME/.kube/config

cd "$CHART_DIR"

if ! helm ls -n "$NAMESPACE" | grep -q "$CHART_NAME"; then
  echo "Installing Helm chart..."
  helm install "$CHART_NAME" "$CHART_NAME-$TAG.tgz" \
    --set image.repository="$ACR_LOGIN_SERVER/$CHART_NAME" \
    --set image.tag="$TAG" \
    --namespace "$NAMESPACE" --create-namespace
else
  echo "Upgrading Helm chart..."
  helm upgrade "$CHART_NAME" "$CHART_NAME-$TAG.tgz" \
    --set image.repository="$ACR_LOGIN_SERVER/$CHART_NAME" \
    --set image.tag="$TAG" \
    --namespace "$NAMESPACE"
fi

