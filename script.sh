#!/bin/bash
TAG=$1
NAMESPACE=$2
CHART_NAME=$3
ACR_LOGIN_SERVER=$4
CHART_DIR=$5  # This is the new parameter

export KUBECONFIG=$HOME/.kube/config

cd $CHART_DIR  # Use passed-in chart path

helm ls -n $NAMESPACE | grep $CHART_NAME
if [ $? -ne 0 ]; then
  echo "Installing Helm chart..."
  helm install $CHART_NAME $CHART_NAME-$TAG.tgz \
    --set image.repository=$ACR_LOGIN_SERVER/$CHART_NAME \
    --set image.tag=$TAG \
    --namespace $NAMESPACE --create-namespace
else
  echo "Upgrading Helm chart..."
  helm upgrade $CHART_NAME $CHART_NAME-$TAG.tgz \
    --set image.repository=$ACR_LOGIN_SERVER/$CHART_NAME \
    --set image.tag=$TAG \
    --namespace $NAMESPACE
fi

