#!/bin/sh
set -e

source ../../../setup-env.sh

cd node-rs--node-rs-crc32-openharmony-arm64
npm stage publish --tag ohos --access public
