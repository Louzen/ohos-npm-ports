#!/bin/sh
set -e

# 准备编译环境
source ../../../setup-tools.sh

# 准备源码
curl -fsSL https://github.com/newrelic/node-native-metrics/archive/refs/tags/v13.1.0.tar.gz -o native-metrics-v13.1.0.tar.gz
tar -zxf native-metrics-v13.1.0.tar.gz
mv node-native-metrics-13.1.0 native-metrics-v13.1.0
cd native-metrics-v13.1.0
patch -p1 < ../patchs/0001-update-package-json.patch
patch -p1 < ../patchs/0002-add-cpp20-flag.patch

# 构建 addon
npm install
npm run prebuild

# 把其他平台的预构建产物复制到包里面一起发布
cd ..
curl -fsSL https://registry.npmjs.org/@newrelic/native-metrics/-/native-metrics-13.1.0.tgz -o native-metrics-13.1.0.tgz
tar -zxf native-metrics-13.1.0.tgz
rm native-metrics-13.1.0.tgz
# 遍历 package/prebuilds/ 下的所有目录，复制到 native-metrics-v13.1.0/prebuilds/ 并给 .node 文件加前缀
for dir in package/prebuilds/*/; do
  dirname=$(basename "$dir")
  mkdir -p "native-metrics-v13.1.0/prebuilds/$dirname"
  cp -r "$dir"* "native-metrics-v13.1.0/prebuilds/$dirname/"
  # 给目录下所有 .node 文件加上前缀 @ohos-npm-ports+
  for nodefile in "native-metrics-v13.1.0/prebuilds/$dirname"/*.node; do
    [ -f "$nodefile" ] || continue
    filename=$(basename "$nodefile")
    dirpath=$(dirname "$nodefile")
    mv "$nodefile" "$dirpath/@ohos-npm-ports+$filename"
  done
done
echo "=== Listing all files in prebuilds directory ==="
find "$(pwd)/native-metrics-v13.1.0/prebuilds" -type f
echo "=== End of listing ==="
