#!/bin/sh
set -e

source ../../../setup-env.sh

cd build/node-rs--node-rs-crc32-openharmony-arm64
npm stage publish --tag ohos --access public
