# GitHub推送指南 — 技术部标准流程

**版本：** V1.0  
**适用范围：** 所有AI应用项目  
**责任人：** CTO技术部

---

## 一、账户信息

| 项目 | 值 |
|------|-----|
| GitHub用户名 | `xwjiau1` |
| 注册邮箱 | `jiawenxu351@gmail.com` |
| Token | `[REDACTED]` |
| 权限 | `repo`（完整仓库读写） |

---

## 二、推送脚本

### 快速推送（推荐）

```bash
# 进入项目目录
cd /path/to/your-project

# 使用技术部标准脚本
bash /root/.openclaw/workspace/tech/knowledge/tools/github-push/github-push.sh
```

### 手动推送

```bash
cd /path/to/your-project

# 配置远程仓库
git remote add origin https://[REDACTED]@github.com/xwjiau1/REPO_NAME.git

# 推送
git push -u origin master
```

---

## 三、新建仓库流程

### 1. GitHub网页创建

1. 访问 https://github.com/new
2. Repository name: 项目名称（如 `spireguide`）
3. 选择 `Public`
4. 不勾选 README / .gitignore
5. 点击 `Create repository`

### 2. 本地推送

```bash
cd /path/to/project
git remote add origin https://[REDACTED]@github.com/xwjiau1/REPO_NAME.git
git push -u origin master
```

---

## 四、项目完成检查清单

| # | 检查项 | 标准 |
|---|--------|------|
| 1 | Git提交 | `git log` 显示完整提交历史 |
| 2 | 远程仓库 | `git remote -v` 显示 origin |
| 3 | GitHub可见 | 网页能访问 `github.com/xwjiau1/REPO_NAME` |
| 4 | README | 根目录有 README.md |
| 5 | LICENSE | 根目录有 LICENSE |

**CTO任务完成标准：** 以上5项全部通过才算交付完成。

---

## 五、安全说明

- Token仅保存在本地workspace，不对外传输
- 脚本已存储于 `tech/knowledge/tools/github-push/`
- 如Token失效，到 https://github.com/settings/tokens 重新生成
- 重新生成后更新此文件中的Token值

---

**创建日期：** 2026-05-10  
**维护人：** Irra (CTO)
