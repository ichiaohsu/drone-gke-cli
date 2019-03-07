#!/bin/bash

if [ -z ${PLUGIN_NAMESPACE} ]; then
  PLUGIN_NAMESPACE="default"
fi

if [ ! -z ${PLUGIN_KUBERNETES_CLUSTER} ]; then
  KUBERNETES_CLUSTER=$PLUGIN_KUBERNETES_CLUSTER
fi

if [ ! -z ${GOOGLE_CREDENTIALS} ]; then
  echo -e "$GOOGLE_CREDENTIALS" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' > /tmp/gcloud.json
fi

SERVICE_NAME=$DRONE_REPO-$DRONE_REPO_BRANCH
echo $SERVICE_NAME

gcloud auth activate-service-account --keyfile /tmp/gcloud.json
gcloud container clusters get-credentials ${KUBERNETES_CLUSTER}

EXTERNAL_IP=""
while [ -z $EXTERNAL_IP ]; do
  echo "Waiting for end point..."
  EXTERNAL_IP=$(kubectl get svc ${SERVICE_NAME} --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "$EXTERNAL_IP" ] && sleep 10
done
echo 'End point ready:' && echo $EXTERNAL_IP

