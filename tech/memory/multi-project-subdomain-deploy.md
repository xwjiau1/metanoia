# 技术部多项目子域名部署标准（V1.0）

**版本：** V1.0
**生效日期：** 2026-05-12
**适用范围：** 技术部临时项目部署
**责任人：** Irra（CTO）

---

## 一、方案概述

**部署模式：** 子域名分流
**技术栈：** Cloudflare Tunnel + systemd + 独立端口
**域名示例：**
```
spire.metanoia-labs.com    →  localhost:3001  (尖塔项目)
hyros.metanoia-labs.com    →  localhost:3002  (新项目示例)
app.metanoia-labs.com      →  localhost:3003  (新项目示例)
```

**不需要：** Nginx、路径前缀改动、代码适配

---

## 二、新项目上线路线图

```
Step 1: 本地起服务（选择新端口，避免冲突）
    ↓
Step 2: 编写 systemd 服务文件
    ↓
Step 3: 启动并验证本地端口
    ↓
Step 4: Cloudflare Dashboard 添加 Public Hostname
    ↓
Step 5: 验证公网访问
    ↓
Step 6: 记录到本项目部署文档
```

---

## 三、端口分配表（技术部全局）

| 端口 | 项目 | 域名 | 状态 |
|------|------|------|------|
| 3001 | SpireGuide（尖塔） | spire.metanoia-labs.com | ✅ 已部署 |
| 3002 | （预留） | hyros.metanoia-labs.com | 待分配 |
| 3003 | （预留） | app.metanoia-labs.com | 待分配 |
| 3004 | （预留） | api.metanoia-labs.com | 待分配 |

**端口分配原则：**
- 每个项目独占一个端口
- 端口从 3001 开始递增
- 已分配端口永久锁定，不得复用
- 新项目启动前必须先查此表

---

## 四、新项目部署步骤（详细版）

### Step 1: 确认端口与域名

1. 查看端口分配表，选一个未使用的端口（比如 3002）
2. 确定子域名（比如 `hyros` → `hyros.metanoia-labs.com`）
3. 在端口分配表登记

### Step 2: 编写 systemd 服务文件

```bash
sudo tee /etc/systemd/system/{project-name}.service << 'EOF'
[Unit]
Description={项目描述}
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory={项目绝对路径}
ExecStart=/usr/bin/node {入口文件}
Environment=NODE_ENV=production PORT={端口}
Restart=always
RestartSec=5
KillMode=process
StandardOutput=journal
StandardError=journal
SyslogIdentifier={project-name}

[Install]
WantedBy=multi-user.target
EOF
```

**尖塔项目示例：**
```bash
sudo tee /etc/systemd/system/hyros.service << 'EOF'
[Unit]
Description=HYROS Fit Backend Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/root/.openclaw/workspace/tech/projects/hyros-fit/03-源码/src/backend
ExecStart=/usr/bin/node dist/index.js
Environment=NODE_ENV=production PORT=3002
Restart=always
RestartSec=5
KillMode=process
StandardOutput=journal
StandardError=journal
SyslogIdentifier=hyros

[Install]
WantedBy=multi-user.target
EOF
```

### Step 3: 启动并验证本地端口

```bash
# 加载配置
sudo systemctl daemon-reload

# 开机自启
sudo systemctl enable hyros.service

# 启动服务
sudo systemctl start hyros.service

# 验证状态
sudo systemctl status hyros.service --no-pager

# 测试本地端口
curl -s http://localhost:3002/api/health
```

**通过标准：** `systemctl status` 显示 `active (running)`，curl 返回 200。

### Step 4: Cloudflare Dashboard 配置

1. 登录 [dash.cloudflare.com](https://dash.cloudflare.com)
2. 进入 **Zero Trust → Networks → Tunnels**
3. 找到已有隧道（如 `metanoia`），点进去
4. 切换到 **Published application routes** 标签页
5. 点 **+ Add a published application route**
6. 填写：

| 字段 | 值 |
|------|-----|
| Subdomain | `hyros`（或你选的子域名） |
| Domain | `metanoia-labs.com` |
| Path | 留空（匹配所有路径） |
| Type | HTTP |
| URL | `localhost:3002` |

7. 点 **Save**

**注意：** 如果提示 "A, AAAA, or CNAME record already exists"，去 DNS → Records 删除同名记录后再保存。

### Step 5: 验证公网访问

```bash
# 测试 HTTPS 访问
curl -s -o /dev/null -w "HTTP %{http_code}" https://hyros.metanoia-labs.com/api/health --connect-timeout 15

# 测试首页
curl -s -o /dev/null -w "HTTP %{http_code}" https://hyros.metanoia-labs.com/ --connect-timeout 15
```

**通过标准：** 两个都返回 200。

### Step 6: 记录部署信息

在端口分配表中更新状态，并在项目目录下创建 `部署记录.md`：

```markdown
## 部署信息
- 域名：https://hyros.metanoia-labs.com
- 本地端口：3002
- systemd 服务：hyros.service
- 部署日期：2026-05-12
- 部署人：wenner
```

---

## 五、多项目共存状态查询

```bash
# 查看所有项目服务状态
systemctl status spireguide.service hyros.service --no-pager

# 查看所有监听端口
ss -tlnp | grep -E "(spireguide|hyros|node)"

# 查看所有隧道路由（通过日志）
journalctl -u cloudflared-spireguide -f

# 批量测试所有项目
for domain in spire.metanoia-labs.com hyros.metanoia-labs.com; do
  echo -n "$domain: "
  curl -s -o /dev/null -w "%{http_code}" https://$domain/api/health --connect-timeout 5
done
```

---

## 六、运维命令速查

| 操作 | 命令 |
|------|------|
| 启动项目 | `sudo systemctl start {项目}.service` |
| 重启项目 | `sudo systemctl restart {项目}.service` |
| 停止项目 | `sudo systemctl stop {项目}.service` |
| 查看日志 | `sudo journalctl -u {项目}.service -f` |
| 查看所有日志 | `sudo journalctl -f` |
| 重启隧道 | `sudo systemctl restart cloudflared-spireguide.service` |
| 隧道日志 | `sudo journalctl -u cloudflared-spireguide -f` |
| 开机自启列表 | `systemctl list-unit-files --state=enabled \| grep -E "(spireguide\|cloudflared)"` |

---

## 七、故障排查

### 场景 1：域名返回 530

**原因：** Cloudflare 边缘节点找不到隧道连接器

**排查：**
```bash
# 1. 检查本地服务是否运行
curl http://localhost:{端口}/api/health

# 2. 检查隧道是否连接
sudo systemctl status cloudflared-spireguide.service

# 3. 检查 Dashboard 中 Public Hostname 是否存在
```

**修复：**
- 本地服务挂了 → `sudo systemctl restart {项目}.service`
- 隧道断了 → `sudo systemctl restart cloudflared-spireguide.service`
- Dashboard 配置丢失 → 重新添加 Public Hostname

### 场景 2：域名返回 404

**原因：** 服务运行了，但路径不匹配

**排查：**
```bash
# 本地测试具体路径
curl http://localhost:{端口}/
curl http://localhost:{端口}/api/health
```

**修复：**
- 前端路由问题 → 检查 SPA 的 fallback 配置
- API 路径问题 → 检查后端的静态文件和 API 路由定义

### 场景 3：端口冲突（EADDRINUSE）

**原因：** 两个项目用了同一个端口

**修复：**
1. 查看端口占用：`lsof -i :{端口}` 或 `ss -tlnp | grep {端口}`
2. 杀掉占用进程
3. 修改项目代码中 PORT 环境变量
4. 更新 systemd 服务文件中的 Environment=PORT

---

## 八、安全规范

1. **Token 保密：** cloudflared 的 Token 只存在于 systemd 服务文件和 /etc/cloudflared/ 下，权限 600
2. **最小暴露：** 每个项目只暴露需要的端口和服务
3. **日志审查：** 每月执行 `journalctl -u cloudflared-spireguide --since "30 days ago"` 检查异常
4. **版本更新：** cloudflared 每季度手动更新，更新前测试

---

## 九、示例：完整部署一个新项目

假设新项目叫 `Demo App`，端口 3003，域名 `demo.metanoia-labs.com`：

```bash
# 1. 写 systemd 服务
sudo tee /etc/systemd/system/demo.service << 'EOF'
[Unit]
Description=Demo App Backend
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/root/.openclaw/workspace/tech/projects/demo-app/03-源码
ExecStart=/usr/bin/node dist/index.js
Environment=NODE_ENV=production PORT=3003
Restart=always
RestartSec=5
KillMode=process
StandardOutput=journal
StandardError=journal
SyslogIdentifier=demo

[Install]
WantedBy=multi-user.target
EOF

# 2. 启动
sudo systemctl daemon-reload
sudo systemctl enable demo.service
sudo systemctl start demo.service

# 3. 验证本地
curl http://localhost:3003/api/health

# 4. Dashboard 添加 Public Hostname（demo.metanoia-labs.com → localhost:3003）

# 5. 验证公网
curl https://demo.metanoia-labs.com/api/health
```

---

## 十、版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| V1.0 | 2026-05-12 | 基于 SpireGuide 部署经验固化多项目子域名部署标准 |

---

*文档维护人：Irra（CTO）*
*审批人：wenner（CEO）*
