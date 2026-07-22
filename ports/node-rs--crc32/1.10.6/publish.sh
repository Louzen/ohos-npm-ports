#!/bin/sh
set -e

source ../../../setup-env.sh

cd node-rs--node-rs-crc32-1.10.6/package
npm stage publish --tag ohos --access public
