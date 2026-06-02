#!/bin/bash
# GitHub推送脚本 — 技术部标准流程
# 用法: bash /tmp/github-push.sh <本地项目路径> <GitHub用户名> <仓库名>

set -e

PROJECT_PATH="${1:-.}"
GITHUB_USER="${2:-xwjiau1}"
REPO_NAME="${3:-spireguide}"
TOKEN="${GITHUB_TOKEN:-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}"

cd "$PROJECT_PATH" || { echo "目录不存在: $PROJECT_PATH"; exit 1; }

# 检查git仓库
if [ ! -d .git ]; then
    echo "初始化git仓库..."
    git init
fi

# 设置用户信息（避免commit失败）
git config user.email "jiawenxu351@gmail.com" 2>/dev/null || true
git config user.name "xwjiau1" 2>/dev/null || true

# 检查远程仓库
REMOTE_URL="https://${TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"
EXISTING_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")

if [ -z "$EXISTING_REMOTE" ]; then
    echo "添加远程仓库: ${GITHUB_USER}/${REPO_NAME}"
    git remote add origin "$REMOTE_URL"
else
    echo "更新远程仓库URL"
    git remote set-url origin "$REMOTE_URL"
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo "检测到未提交的更改，自动提交..."
    git add -A
    git commit -m "$(date '+%Y-%m-%d %H:%M') 自动提交"
fi

# 推送
echo "推送到 GitHub..."
git push -u origin $(git branch --show-current 2>/dev/null || echo "master")

echo "✅ 推送完成: https://github.com/${GITHUB_USER}/${REPO_NAME}"
