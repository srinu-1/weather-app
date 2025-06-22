#!/bin/bash
TAG=$1
NAMESPACE=$2
CHART_NAME=$3
ACR_LOGIN_SERVER=$4

export KUBECONFIG=$HOME/.kube/config

# Move to the chart directory inside the pipeline workspace
cd $(System.DefaultWorkingDirectory)/_temp/charts  # Updated path based on artifact publish

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

