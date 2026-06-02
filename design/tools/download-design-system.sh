#!/bin/bash
# /workspace/design/tools/download-design-system.sh
# 设计系统下载器 — 下载指定设计系统到项目目录

SITE=$1
PROJECT_DIR=${2:-"."}
REPO_DIR="/workspace/design/awesome-design-md/design-md"

if [ -z "$SITE" ]; then
    echo "用法: download-design-system.sh <site-name> [项目目录]"
    echo ""
    echo "示例:"
    echo "  download-design-system.sh vercel ./my-project"
    echo "  download-design-system.sh stripe ./my-project"
    echo ""
    echo "可用设计系统:"
    ls $REPO_DIR/ 2>/dev/null | head -20
    exit 1
fi

SOURCE_DIR="$REPO_DIR/$SITE"
TARGET_DIR="$PROJECT_DIR/参考设计系统/$SITE"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ 未找到 $SITE 的设计系统"
    exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$SOURCE_DIR"/*.md "$SOURCE_DIR"/*.html "$TARGET_DIR/" 2>/dev/null

echo "✅ 已下载 $SITE 设计系统到:"
echo "   $TARGET_DIR/"
echo ""
echo "包含文件:"
ls -la "$TARGET_DIR/"
echo ""
echo "📖 使用方式:"
echo "   在项目中放置 DESIGN.md 后，告诉 AI agent '参照 DESIGN.md 的风格进行设计'"
