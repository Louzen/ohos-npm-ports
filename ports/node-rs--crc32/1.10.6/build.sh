#!/bin/sh
set -e

# 准备编译环境
source ../../../setup-tools.sh

# ============================================================
# @ohos-npm-ports/node-rs__crc32 主包
# 下载原始 npm 包，应用 patch 修改 package.json 和 index.js，
# 添加 openharmony 平台支持和 optionalDependencies
# ============================================================

# 1. 下载原始 npm 包（保持 package/ 目录结构以匹配 patch 路径）
curl -fsSL https://registry.npmjs.org/@node-rs/crc32/-/crc32-1.10.6.tgz -o crc32-1.10.6.tgz
mkdir -p node-rs--node-rs-crc32-1.10.6
tar -zxf crc32-1.10.6.tgz -C node-rs--node-rs-crc32-1.10.6
rm  crc32-1.10.6.tgz

# 2. 应用 patch
cd node-rs--node-rs-crc32-1.10.6
patch -p1 < ../patchs/0001-update-package-json.patch
cd ..

# 3. 确认 prebuilds 目录存在（原始 npm 包自带的各平台 prebuilds）
echo "=== Main package contents ==="
ls -la node-rs--node-rs-crc32-1.10.6/package/
if [ -d node-rs--node-rs-crc32-1.10.6/package/prebuilds ]; then
  echo "=== Prebuilds ==="
  find node-rs--node-rs-crc32-1.10.6/package/prebuilds -type f
fi
