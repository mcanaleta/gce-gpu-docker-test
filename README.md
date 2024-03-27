# Test case for running GPU code on Google Compute Engine


About regions and GPU types:
- https://cloud.google.com/compute/docs/gpus/gpu-regions-zones
- GPU types in europe-west1-b: L4, T4, P100, K80	

Edit deploy.sh to change the zone and GPU type.
```bash
IMAGE_NAME="gpu-test"
IMAGE_TAG="latest"
INSTANCE_NAME="gpu-test"
ZONE="europe-west1-b"
CONTAINER_IMAGE="gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG}"
INSTANCE_TYPE="n1-standard-4"
GPU_TYPE="nvidia-l4"
```

The deploy.sh script will build the image, upload it to Google Container Registry, and deploy it to Google Compute Engine. It needs a gcloud default project to be set. The instance name will be gpu-test.

To deploy 

```bash
gcloud config set project <project-id>
./deploy.sh
```