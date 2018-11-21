#!/bin/bash

if [ -z $KUBERNETES_SERVER ]; then
  echo "Server is not specified!"
  exit 1
fi

if [ -z $KUBERNETES_TOKEN ]; then
  echo "Token is not specified!"
  exit 1
fi

if [ -z $PLUGIN_DEPLOYMENT ]; then
  echo "Deployment is not specified!"
  exit 1
fi

if [ -z $PLUGIN_CONTAINER ]; then
  echo "Container is not specified!"
  exit 1
fi

if [ -z $PLUGIN_REPO ]; then
  echo "Repository is not specified!"
  exit 1
fi

if [ -z $PLUGIN_TAG ]; then
  PLUGIN_TAG="latest"
fi

if [ -z $PLUGIN_NAMESPACE ]; then
  PLUGIN_NAMESPACE="default"
fi

kubectl config set-credentials default --token=$KUBERNETES_TOKEN
if [ -n "$KUBERNETES_CERT" ]; then
  echo "$KUBERNETES_CERT" > ca.crt
  kubectl config set-cluster default --server=$KUBERNETES_SERVER --certificate-authority=ca.crt
else
  echo "WARNING: Using insecure connection to cluster"
  kubectl config set-cluster default --server=$KUBERNETES_SERVER --insecure-skip-tls-verify=true
fi

kubectl config set-context default --cluster=default --user=default

kubectl config use-context default

IFS=',' read -r -a DEPLOYMENTS <<< "$PLUGIN_DEPLOYMENT"
IFS=',' read -r -a CONTAINERS <<< "$PLUGIN_CONTAINER"
for DEPLOYMENT in ${DEPLOYMENTS[@]}; do
  echo "Deploying to $KUBERNETES_SERVER"
  for CONTAINER in ${CONTAINERS[@]}; do
    kubectl -n $PLUGIN_NAMESPACE set image deployment/$DEPLOYMENT $CONTAINER=$PLUGIN_REPO:$PLUGIN_TAG --record
  done
done
