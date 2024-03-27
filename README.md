# Test case for running GPU code on Google Compute Engine


About regions and GPU types:
- https://cloud.google.com/compute/docs/gpus/gpu-regions-zones
- GPU types in europe-west1-b: L4, T4, P100, K80	

Preparation:
```bash
gcloud auth login
gcloud auth configure-docker gcr.io
gcloud config set project <project-id>
```

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

The deploy.sh script will:
- build the image,
- upload it to Google Container Registry
- create a GCE instance with GPU and this container image

To deploy 

```bash
./deploy.sh
```

After the deploy is finished, check logs, and when the container finishes downloading (several minutes), open a browser http://(public-ip).

It should just say:

```
The result from the GPU is: 256
```
