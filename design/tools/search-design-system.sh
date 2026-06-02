#!/bin/bash
# /workspace/design/tools/search-design-system.sh
# 设计系统检索器 — 按关键词搜索 awesome-design-md 中的设计系统

KEYWORD=${1:-""}
REPO_DIR="/workspace/design/awesome-design-md/design-md"

if [ ! -d "$REPO_DIR" ]; then
    echo "❌ awesome-design-md 未克隆，请先执行: cd /workspace/design && git clone https://github.com/VoltAgent/awesome-design-md.git"
    exit 1
fi

if [ -z "$KEYWORD" ]; then
    echo "用法: search-design-system.sh <关键词>"
    echo ""
    echo "可用分类:"
    echo "  ai / llm / developer / saas / fintech / ecommerce / media / automotive"
    echo ""
    echo "所有可用设计系统:"
    for dir in $REPO_DIR/*/; do
        site=$(basename "$dir")
        echo "  - $site"
    done
    exit 0
fi

echo "=== 🔍 搜索设计系统: '$KEYWORD' ==="
echo ""

found=0
for dir in $REPO_DIR/*/; do
    site=$(basename "$dir")
    design_md="$dir/DESIGN.md"
    
    if [ ! -f "$design_md" ]; then
        continue
    fi
    
    # 搜索关键词（不区分大小写）
    if grep -qi "$KEYWORD" "$design_md" 2>/dev/null; then
        found=1
        echo "  ✅ $site"
        
        # 提取前5行 theme 描述
        theme_line=$(head -30 "$design_md" | grep -i "theme\|atmosphere\|mood\|overview" | head -1)
        if [ -n "$theme_line" ]; then
            echo "     $theme_line"
        fi
        
        # 提取主色（如果有）
        primary_color=$(grep -i "primary\|主色" "$design_md" | head -1 | grep -o '#[0-9A-Fa-f]\{6\}' | head -1)
        if [ -n "$primary_color" ]; then
            echo "     主色: $primary_color"
        fi
        echo ""
    fi
done

if [ $found -eq 0 ]; then
    echo "  ❌ 未找到匹配 '$KEYWORD' 的设计系统"
    echo ""
    echo "建议尝试以下关键词:"
    echo "  dark / minimal / gradient / purple / green"
    echo "  developer / enterprise / playful / premium"
fi
