# drone-gke-cli
Drone.io plugin for Google Container Engine CLI usage

## How to use with Docker
```bash
docker run -it --name [CONTAINER_NAME] \
           -e DRONE_BRANCH=[BRANCH_NAME] \
           -e DRONE_REPO_NAME=[REPO_NAME] \
           -e PLUGIN_CLUSTER=[K8S_CLUSTER_NAME] \
           -e PLUGIN_ZONE=[K8S_CLUSTER_ZONE] \
           -e PLUGIN_NAMESPACE=[DESIRED_NAMESPACE] \
           -e GOOGLE_CREDENTIALS="$([SERVICEACCOUNT_PATH])" \
           drone-gke-cli:latest
```
