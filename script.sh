#!/bin/bash
TAG=$1
NAMESPACE=$2
CHART_NAME=$3
ACR_LOGIN_SERVER=$4

export KUBECONFIG=$HOME/.kube/config

helm ls -n $NAMESPACE | grep $CHART_NAME
if [ $? -ne "0" ]; then
  echo "Installing Helm chart..."
  helm install $CHART_NAME oci://$ACR_LOGIN_SERVER/helm/$CHART_NAME --version $TAG --namespace $NAMESPACE --create-namespace
else
  echo "Upgrading Helm chart..."
  helm upgrade $CHART_NAME oci://$ACR_LOGIN_SERVER/helm/$CHART_NAME --version $TAG --namespace $NAMESPACE
fi
