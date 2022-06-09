TF_VERSION=${1:-"2.5.0"}

echo "Tensorflow version: ${TF_VERSION}"

docker build \
    -f tfod-jupyter.dockerfile \
    -t xentilzax/tensorflow-objectdetection-jupyter:tensorflow${TF_VERSION} \
    --build-arg "TF_VERSION=$TF_VERSION" \
    .

