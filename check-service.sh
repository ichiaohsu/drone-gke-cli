#!/bin/bash

if [ -z ${PLUGIN_NAMESPACE} ]; then
  PLUGIN_NAMESPACE="default"
fi

if [ ! -z ${PLUGIN_CLUSTER} ]; then
  KUBERNETES_CLUSTER=$PLUGIN_CLUSTER
fi

CREDENTIAL_PATH=./gcloud.json
# if [ ! -z ${GOOGLE_CREDENTIALS} ]; then
echo "$GOOGLE_CREDENTIALS" > $CREDENTIAL_PATH
  # echo "$GOOGLE_CREDENTIALS" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' > /tmp/gcloud.json
# fi

PLUGING_ZONE=asia-east1-a

if [ ! -z ${PLUGIN_ZONE} ]; then
  GCP_ZONE=$PLUGIN_ZONE
fi

cat $CREDENTIAL_PATH
SERVICE_NAME=${DRONE_REPO_NAME}-${DRONE_BRANCH}
echo "service name:${SERVICE_NAME}"
echo "namespace:${PLUGIN_NAMESPACE}"
echo "zone:${GCP_ZONE}"
echo "cluster:${KUBERNETES_CLUSTER}"

gcloud auth activate-service-account --key-file $CREDENTIAL_PATH
# echo "gcloud container clusters --zone ${GCP_ZONE} get-credentials ${KUBERNETES_CLUSTER}"
gcloud container clusters --zone ${GCP_ZONE} get-credentials ${KUBERNETES_CLUSTER}

EXTERNAL_IP=""
while [ -z $EXTERNAL_IP ]; do
  echo "Waiting for end point..."
  EXTERNAL_IP=$(kubectl -n ${PLUGIN_NAMESPACE} get service ${SERVICE_NAME} --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "$EXTERNAL_IP" ] && sleep 10
done

echo 'End point ready:' && echo $EXTERNAL_IP

echo "http://$EXTERNAL_IP:80" > .address
