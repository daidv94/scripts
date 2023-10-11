#!/usr/bin/env bash

LAYER_NAME=$1
ZIP_ARTIFACT=${LAYER_NAME}.zip
LAYER_BUILD_DIR="python"

rm -rf ${LAYER_BUILD_DIR} && mkdir -p ${LAYER_BUILD_DIR}

docker run --platform=linux/amd64 --rm -v `pwd`:/var/task:z lambci/lambda:build-python3.8 python3.8 -m pip --isolated install -t ${LAYER_BUILD_DIR} -r requirements.txt

zip -r ${ZIP_ARTIFACT} .

echo "Publishing layer to AWS..."
aws lambda publish-layer-version --layer-name ${LAYER_NAME} --zip-file fileb://${ZIP_ARTIFACT} --compatible-runtimes python3.8 --compatible-architectures x86_64

# clean up
rm -rf ${LAYER_BUILD_DIR}
rm -r ${ZIP_ARTIFACT}
