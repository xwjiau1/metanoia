---
name: metanoia-github-push
description: 启明科技技术部专用GitHub推送技能。当需要将项目代码推送到GitHub仓库、创建GitHub仓库、或执行任何与GitHub相关的git操作时触发。适用于所有AI应用项目的归档入库阶段。CTO技术部交付完成前的必要步骤。
---

# Metanoia GitHub推送技能

## 账户信息

| 项目 | 值 |
|------|-----|
| GitHub用户名 | `xwjiau1` |
| 注册邮箱 | `jiawenxu351@gmail.com` |
| Token | `[REDACTED]` |
| 权限 | `repo`（完整仓库读写） |

## 使用脚本

脚本位置：`scripts/github-push.sh`

```bash
# 进入项目目录
cd /path/to/project

# 执行推送（自动处理初始化、提交、推送）
bash ~/.openclaw/workspace/skills/metanoia-github-push/scripts/github-push.sh
```

## 手动流程（脚本失败时备用）

```bash
cd /path/to/project

# 1. 配置远程
git remote add origin https://[REDACTED]@github.com/xwjiau1/REPO_NAME.git
# 或更新已有远程
git remote set-url origin https://[REDACTED]@github.com/xwjiau1/REPO_NAME.git

# 2. 提交
git add -A
git commit -m "$(date '+%Y-%m-%d %H:%M') 提交"

# 3. 推送
git push -u origin $(git branch --show-current)
```

## 新建仓库（通过API）

```bash
curl -s -X POST https://api.github.com/user/repos \
  -H "Authorization: token [REDACTED]" \
  -H "Accept: application/vnd.github.v3+json" \
  -d '{"name":"REPO_NAME","private":false}'
```

## 交付标准

| # | 检查项 | 要求 |
|---|--------|------|
| 1 | Git提交历史 | `git log` 显示完整提交 |
| 2 | 远程仓库 | `git remote -v` 显示 origin |
| 3 | GitHub可见 | 网页可访问仓库 |
| 4 | README | 根目录有 README.md |
| 5 | LICENSE | 根目录有 LICENSE |

**不满足以上5项 = 任务未完成。**
