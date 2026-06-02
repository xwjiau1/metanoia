#!/bin/bash
# /workspace/design/tools/preview-design-system.sh
# 设计系统预览启动器 — 在本地浏览器中预览设计系统

SITE=$1
REPO_DIR="/workspace/design/awesome-design-md/design-md"

if [ -z "$SITE" ]; then
    echo "用法: preview-design-system.sh <site-name>"
    echo ""
    echo "示例:"
    echo "  preview-design-system.sh vercel"
    echo "  preview-design-system.sh stripe"
    echo "  preview-design-system.sh claude"
    echo ""
    echo "可用设计系统:"
    ls $REPO_DIR/ 2>/dev/null | head -20
    exit 1
fi

PREVIEW_DIR="$REPO_DIR/$SITE"

if [ ! -d "$PREVIEW_DIR" ]; then
    echo "❌ 未找到 $SITE 的设计系统"
    echo ""
    echo "可用系统:"
    ls $REPO_DIR/ 2>/dev/null | head -20
    exit 1
fi

if [ ! -f "$PREVIEW_DIR/preview.html" ]; then
    echo "⚠️ $SITE 没有预览文件，但 DESIGN.md 存在:"
    echo "  $PREVIEW_DIR/DESIGN.md"
    echo ""
    echo "📄 DESIGN.md 前30行预览:"
    head -30 "$PREVIEW_DIR/DESIGN.md"
    exit 0
fi

PORT=8888
while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; do
    PORT=$((PORT + 1))
done

echo "🚀 启动 $SITE 设计系统预览服务器..."
echo ""
echo "📎 浅色主题: http://localhost:$PORT/preview.html"
echo "📎 深色主题: http://localhost:$PORT/preview-dark.html"
echo "📎 DESIGN.md:  $PREVIEW_DIR/DESIGN.md"
echo ""
echo "按 Ctrl+C 停止服务器"
echo ""

cd "$PREVIEW_DIR" && python3 -m http.server $PORT
