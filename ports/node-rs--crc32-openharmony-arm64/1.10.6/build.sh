#!/bin/sh
set -e

# 准备编译环境
source ../../../setup-tools.sh

# ============================================================
# @ohos-npm-ports/crc32-openharmony-arm64 平台子包
# 编译 Rust 代码生成 OpenHarmony ARM64 的 .node 文件，打包为 npm 子包
# ============================================================

# 1. 下载 node-rs 源码
curl -fsSL https://github.com/napi-rs/node-rs/archive/refs/tags/@node-rs/crc32@1.10.6.tar.gz -o node-rs--node-rs-crc32-1.10.6.tar.gz
tar -zxf node-rs--node-rs-crc32-1.10.6.tar.gz
cd  node-rs--node-rs-crc32-1.10.6

# 2. Rust ohos target 由 OHOS_NDK_HOME（setup-tools.sh 中已导出）驱动 napi-rs 自动配置

# 3. 构建 addon（--ignore-scripts 跳过 devDependencies 中不需要的编译）
npm install --ignore-scripts
npm run build -w packages/crc32

# 4. napi build 输出 crc32.node，移到 prebuilds 目录
mkdir -p packages/crc32/prebuilds/openharmony-arm64
mv packages/crc32/crc32.node packages/crc32/prebuilds/openharmony-arm64/crc32.openharmony-arm64.node

# 5. 创建 npm 子包
cd ..
mkdir -p node-rs--node-rs-crc32-openharmony-arm64

cp packages/crc32/prebuilds/openharmony-arm64/crc32.openharmony-arm64.node \
   node-rs--node-rs-crc32-openharmony-arm64/crc32.openharmony-arm64.node

cat > node-rs--node-rs-crc32-openharmony-arm64/package.json << 'PKGJSON'
{
  "name": "@ohos-npm-ports/crc32-openharmony-arm64",
  "version": "1.10.6-1",
  "description": "OpenHarmony ARM64 platform binary for @ohos-npm-ports/node-rs__crc32",
  "keywords": ["SIMD", "NAPI", "napi-rs", "node-rs", "crc32", "crc32c", "openharmony"],
  "license": "MIT",
  "main": "crc32.openharmony-arm64.node",
  "os": ["openharmony"],
  "cpu": ["arm64"],
  "files": ["crc32.openharmony-arm64.node"],
  "engines": {
    "node": ">= 10"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/ohos-npm-ports/ohos-npm-ports"
  }
}
PKGJSON

# 6. 签名校验
echo "=== Sub-package contents ==="
ls -la node-rs--node-rs-crc32-openharmony-arm64/

if [ -f node-rs--node-rs-crc32-openharmony-arm64/crc32.openharmony-arm64.node ]; then
  if llvm-readelf -S node-rs--node-rs-crc32-openharmony-arm64/crc32.openharmony-arm64.node 2>/dev/null | grep -q '\.codesign'; then
    echo "[SIGNED]   crc32.openharmony-arm64.node"
  elif readelf -S node-rs--node-rs-crc32-openharmony-arm64/crc32.openharmony-arm64.node 2>/dev/null | grep -q '\.codesign'; then
    echo "[SIGNED]   crc32.openharmony-arm64.node"
  else
    echo "[UNSIGNED] crc32.openharmony-arm64.node"
  fi
fi
