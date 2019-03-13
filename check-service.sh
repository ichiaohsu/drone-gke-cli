#!/bin/bash
if [ -z ${PLUGIN_NAMESPACE} ]; then
  PLUGIN_NAMESPACE="default"
fi

if [ ! -z ${PLUGIN_CLUSTER} ]; then
  KUBERNETES_CLUSTER=$PLUGIN_CLUSTER
fi

# Create info from Environment Variables
CREDENTIAL_PATH=./gcloud.json
echo "$GOOGLE_CREDENTIALS" > $CREDENTIAL_PATH

PLUGING_ZONE=asia-east1-a

if [ ! -z ${PLUGIN_ZONE} ]; then
  GCP_ZONE=$PLUGIN_ZONE
fi

SERVICE_NAME=${DRONE_REPO_NAME}-${DRONE_BRANCH}

gcloud auth activate-service-account --key-file $CREDENTIAL_PATH
gcloud container clusters --zone ${GCP_ZONE} get-credentials ${KUBERNETES_CLUSTER}

EXTERNAL_IP=""
while [ -z $EXTERNAL_IP ]; do
  echo "Waiting for end point..."
  EXTERNAL_IP=$(kubectl -n ${PLUGIN_NAMESPACE} get service ${SERVICE_NAME} --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
  [ -z "$EXTERNAL_IP" ] && sleep 10
done

echo http://$EXTERNAL_IP > .address
