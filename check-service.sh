#!/bin/bash

if [ -z ${PLUGIN_NAMESPACE} ]; then
  PLUGIN_NAMESPACE="default"
fi

if [ ! -z ${PLUGIN_CLUSTER} ]; then
  KUBERNETES_CLUSTER=$PLUGIN_CLUSTER
fi

if [ ! -z ${GOOGLE_CREDENTIALS} ]; then
  echo "$GOOGLE_CREDENTIALS" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' > /tmp/gcloud.json
fi

if [ ! -z ${PLUGING_ZONE} ]; then
  GCP_ZONE=$PLUGING_ZONE
fi

ls /tmp
cat /tmp/gcloud.json

SERVICE_NAME=$DRONE_REPO-$DRONE_REPO_BRANCH
echo $SERVICE_NAME

gcloud auth activate-service-account --key-file /tmp/gcloud.json
gcloud container clusters get-credentials ${KUBERNETES_CLUSTER}

EXTERNAL_IP=""
while [ -z $EXTERNAL_IP ]; do
  echo "Waiting for end point..."
  EXTERNAL_IP=$(kubectl get svc ${SERVICE_NAME} --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "$EXTERNAL_IP" ] && sleep 10
done
echo 'End point ready:' && echo $external_ip

