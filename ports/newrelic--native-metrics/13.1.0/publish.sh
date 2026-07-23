#!/bin/sh
set -e

source ../../../setup-env.sh

cd native-metrics-v13.1.0
npm stage publish --tag latest --access public
