#!/bin/bash
# /workspace/design/tools/compare-design-systems.sh
# 设计系统对比器 — 对比两个设计系统的核心差异

SITE1=$1
SITE2=$2
REPO_DIR="/workspace/design/awesome-design-md/design-md"

if [ -z "$SITE1" ] || [ -z "$SITE2" ]; then
    echo "用法: compare-design-systems.sh <site1> <site2>"
    echo ""
    echo "示例:"
    echo "  compare-design-systems.sh vercel stripe"
    echo "  compare-design-systems.sh linear notion"
    exit 1
fi

FILE1="$REPO_DIR/$SITE1/DESIGN.md"
FILE2="$REPO_DIR/$SITE2/DESIGN.md"

if [ ! -f "$FILE1" ]; then
    echo "❌ 未找到 $SITE1 的设计系统"
    echo "可用系统:"
    ls $REPO_DIR/ 2>/dev/null | head -20
    exit 1
fi

if [ ! -f "$FILE2" ]; then
    echo "❌ 未找到 $SITE2 的设计系统"
    echo "可用系统:"
    ls $REPO_DIR/ 2>/dev/null | head -20
    exit 1
fi

echo "========================================"
echo "    设计系统对比: $SITE1 vs $SITE2"
echo "========================================"
echo ""

# 1. Visual Theme 对比
echo "🎨 【视觉主题】"
echo "--- $SITE1 ---"
grep -A 3 "Visual Theme\|Theme\|Overview" "$FILE1" | head -5
echo "--- $SITE2 ---"
grep -A 3 "Visual Theme\|Theme\|Overview" "$FILE2" | head -5
echo ""

# 2. 色彩对比
echo "🌈 【色彩策略】"
echo "--- $SITE1 ---"
grep -B 1 -A 5 "Color Palette\|Primary\|主色" "$FILE1" | head -15
echo "--- $SITE2 ---"
grep -B 1 -A 5 "Color Palette\|Primary\|主色" "$FILE2" | head -15
echo ""

# 3. 字体对比
echo "🔤 【字体策略】"
echo "--- $SITE1 ---"
grep -B 1 -A 5 "Typography\|Font\|字体" "$FILE1" | head -15
echo "--- $SITE2 ---"
grep -B 1 -A 5 "Typography\|Font\|字体" "$FILE2" | head -15
echo ""

# 4. 布局对比
echo "📐 【布局策略】"
echo "--- $SITE1 ---"
grep -B 1 -A 5 "Layout\|Spacing\|留白" "$FILE1" | head -10
echo "--- $SITE2 ---"
grep -B 1 -A 5 "Layout\|Spacing\|留白" "$FILE2" | head -10
echo ""

echo "========================================"
echo "对比完成。建议查看完整 DESIGN.md 获取细节。"
echo ""
echo "预览文件:"
echo "  $SITE1: $FILE1"
echo "  $SITE2: $FILE2"
