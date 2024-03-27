set -e

# get project using gcloud config get project
PROJECT_ID=$(gcloud config get-value project)

# if no project, exit
if [ -z "$PROJECT_ID" ]; then
  echo "Could not determine GCP project ID - you must set using 'gcloud config set project YOUR_PROJECT_ID'"
  exit 1
fi

IMAGE_NAME="gpu-test"
IMAGE_TAG="latest"
INSTANCE_NAME="gpu-test"
ZONE="europe-west1-b"
CONTAINER_IMAGE="gcr.io/${PROJECT_ID}/${IMAGE_NAME}:${IMAGE_TAG}"
INSTANCE_TYPE="n1-standard-4"
GPU_TYPE="nvidia-tesla-k80"
# GPU_TYPE="nvidia-tesla-k80"
# GPU_TYPE="nvidia-tesla-p100"
# GPU_TYPE="nvidia-tesla-p4"

# are you sure?
echo Will launch container in project $PROJECT_ID
read -p "Are you sure you want to continue? (y/n)" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo Exiting
    exit 1
fi

echo "Building image $CONTAINER_IMAGE"



# Build the Docker image
docker build -t ${CONTAINER_IMAGE} --platform linux/amd64 .

echo "Pushing image $CONTAINER_IMAGE"
# Push the image to Google Container Registry
docker push ${CONTAINER_IMAGE}

# INSTANCE_EXISTS=$(gcloud compute instances list --filter="name=${INSTANCE_NAME}" --format="value(name)")


# if [ ! -z "$INSTANCE_EXISTS" ]; then
#   echo "Instance $INSTANCE_NAME already exists, deleting"
#   gcloud compute instances delete ${INSTANCE_NAME} --zone ${ZONE} --quiet
# fi

gcloud compute instances create-with-container ${INSTANCE_NAME} \
  --container-image ${CONTAINER_IMAGE} \
  --machine-type ${INSTANCE_TYPE} \
  --maintenance-policy=TERMINATE \
  --accelerator type=${GPU_TYPE},count=1 \
  --boot-disk-size 200GB \
  --metadata="install-nvidia-driver=True" \
  --tags http-server \
  --zone ${ZONE}
