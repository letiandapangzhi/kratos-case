#!/usr/bin/env bash
set -e

if [ -z "$FROM_MAKEFILE" ]; then
  echo -e "Error: 此脚本仅允许通过 Makefile 执行\n请使用 make new_mono SERVICE_NAME=<服务名称>" >&2
  exit 1
fi

# 检查参数数量
if [ $# -ne 1 ]; then
    echo "错误: <服务名称>缺失"
    exit 1
fi

service_name=$1
echo ">> 创建服务 $service_name"

current_dir=$(pwd)

# 判断操作系统，决定 sed 使用方式
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    SED_REPLACE=(-i '')
else
    # Linux (包括 Ubuntu)
    SED_REPLACE=(-i)
fi

# --- 创建 API 目录 ---
echo ">> 复制 api 模板..."
cp -r "$current_dir/.template/api/layout" "$current_dir/api/$service_name"
find "$current_dir/api/$service_name" -name "*.proto" | while read file; do
    sed "${SED_REPLACE[@]}" "s/layout/$service_name/g" "$file"
done

# --- 创建 APP 目录 ---
echo ">> 复制 app 模板..."
cp -r "$current_dir/.template/app/layout" "$current_dir/app/$service_name"

# 替换 conf 中 proto 引用
find "$current_dir/app/$service_name/internal/conf" -name "*.proto" | while read file; do
    sed "${SED_REPLACE[@]}" "s/layout/$service_name/g" "$file"
done

# 替换 .go 和 .yaml 文件中的 layout（排除 wire_gen.go 和 *pb.go）
find "$current_dir/app/$service_name" \( -name "*.go" -o -name "*.yaml" \) -type f ! -name "wire_gen.go" ! -name "*pb.go" | while read file; do
    sed "${SED_REPLACE[@]}" "s/layout/$service_name/g" "$file"
done

echo "✅ 创建服务 $service_name 完成"