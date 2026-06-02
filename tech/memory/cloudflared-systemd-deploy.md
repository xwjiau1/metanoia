# Cloudflared Systemd 服务部署标准

**版本：** V1.0
**创建日期：** 2026-06-12
**适用范围：** 技术部临时项目部署
**责任人：** Irra（CTO）

---

## 一、前置条件

| 检查项 | 命令 | 要求 |
|--------|------|------|
| cloudflared 已安装 | `which cloudflared` | 返回路径 |
| 版本 ≥ 2026.x | `cloudflared version` | 确认版本 |
| 拥有 Cloudflare 账户 | — | 需登录 Cloudflare Dashboard |
| 已有隧道 Token | — | 从 Cloudflare Dashboard 获取 |

**安装 cloudflared（如未安装）：**
```bash
curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared.deb
cloudflared version
```

---

## 二、获取隧道 Token

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com)
2. 进入 Zero Trust → Networks → Tunnels
3. 创建新隧道（Create a tunnel）
4. 选择 **Cloudflared** 连接器类型
5. 命名隧道（如 `metanoia-dev-01`）
6. 在"Choose your environment"选择 **Debian (.deb)**
7. 复制页面显示的 **Token**（一长串字符，以 `eyJ` 开头）

⚠️ **安全注意：** Token 即密码，勿提交到 Git，勿泄露到公开渠道。

---

## 三、部署 Systemd 服务

### 方式 A：使用 cloudflared 内置命令（推荐）

```bash
sudo cloudflared service install <YOUR_TUNNEL_TOKEN>
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

### 方式 B：手动创建服务文件

如需自定义参数或内置命令不适用时，使用本方式。

**1. 创建服务文件**

```bash
sudo tee /etc/systemd/system/cloudflared.service << 'EOF'
[Unit]
Description=Cloudflare Tunnel for Metanoia
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/cloudflared tunnel --no-autoupdate run --token <YOUR_TUNNEL_TOKEN>
Restart=always
RestartSec=10
KillMode=process
StandardOutput=journal
StandardError=journal
SyslogIdentifier=cloudflared

[Install]
WantedBy=multi-user.target
EOF
```

**2. 替换 Token**

```bash
sudo sed -i 's/<YOUR_TUNNEL_TOKEN>/你的实际Token/g' /etc/systemd/system/cloudflared.service
```

**3. 加载并启动**

```bash
sudo systemctl daemon-reload
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

---

## 四、验证服务状态

```bash
# 查看运行状态
sudo systemctl status cloudflared

# 查看实时日志
sudo journalctl -u cloudflared -f

# 查看启动历史（含重启记录）
sudo journalctl -u cloudflared --since "1 hour ago"

# 测试隧道连通性
curl -I http://localhost:8080  # 或实际暴露的端口
```

**正常状态标志：**
- `Active: active (running)` — 绿色
- 日志出现 `Connection registered` — 已连接到 Cloudflare 边缘节点
- Cloudflare Dashboard 显示隧道状态为 **Healthy**

---

## 五、服务配置说明

| 配置项 | 值 | 作用 |
|--------|-----|------|
| `Restart=always` | 自动重启 | 任何退出（包括崩溃、信号终止）都自动重启 |
| `RestartSec=10` | 10秒间隔 | 避免重启风暴，给网络恢复留时间 |
| `KillMode=process` | 主进程模式 | 确保只杀主进程，不波及子进程 |
| `--no-autoupdate` | 禁用自动更新 | 避免更新时服务中断，需手动更新版本 |
| `After=network-online.target` | 网络就绪后启动 | 确保有网络才启动隧道 |

---

## 六、自动重启场景测试

部署后必须验证自动重启功能：

```bash
# 1. 记录当前 PID
pgrep cloudflared

# 2. 模拟崩溃（强制 kill）
sudo kill -9 $(pgrep cloudflared)

# 3. 等待 10 秒
sleep 10

# 4. 验证进程已恢复
pgrep cloudflared

# 5. 验证日志中有重启记录
sudo journalctl -u cloudflared --since "1 min ago" | grep -E "(Started|Restart)"
```

**通过标准：** kill 后 10 秒内新进程启动，服务重新注册到 Cloudflare。

---

## 七、开机自启验证

```bash
# 查看是否已启用开机启动
sudo systemctl is-enabled cloudflared
# 应返回：enabled

# 模拟重启后检查（如可接受短暂停机）
sudo reboot
# 重启后执行：
sudo systemctl status cloudflared
```

---

## 八、常用运维命令

```bash
# 重启服务
sudo systemctl restart cloudflared

# 停止服务
sudo systemctl stop cloudflared

# 查看配置（确认 Token 正确）
sudo cat /etc/systemd/system/cloudflared.service

# 更新 cloudflared 版本
sudo cloudflared update
sudo systemctl restart cloudflared

# 查看隧道列表
cloudflared tunnel list

# 删除隧道（如需要重建）
cloudflared tunnel delete <隧道名>
```

---

## 九、故障排查

| 现象 | 排查命令 | 解决方案 |
|------|----------|----------|
| 服务启动失败 | `sudo journalctl -u cloudflared -n 50` | 检查 Token 是否有效/过期 |
| 连接反复断开 | `sudo journalctl -u cloudflared -f` | 检查网络稳定性；降低并发 |
| 端口未暴露 | `sudo netstat -tlnp \| grep cloudflared` | 检查隧道配置中的 Ingress 规则 |
| 权限拒绝 | `sudo systemctl status cloudflared` | 检查 service 文件权限（应 root:root 644） |

---

## 十、安全规范

1. **Token 管理：** Token 存储在 systemd 服务文件中，权限设为 644（仅 root 可写），切勿加入 Git
2. **最小权限：** Cloudflare Dashboard 中给隧道配置最小必要权限（只暴露需要的服务）
3. **日志审查：** 定期执行 `sudo journalctl -u cloudflared --since "7 days ago"` 检查异常连接
4. **更新策略：** 每季度手动更新 cloudflared 版本，更新前在测试环境验证

---

## 十一、流程图

```
获取 Token → 安装/确认 cloudflared → 部署 systemd 服务 → 验证状态
                                                  ↓
                                         测试 kill -9 自动恢复
                                                  ↓
                                         验证开机自启
                                                  ↓
                                         记录到项目部署文档
```

## SpireGuide v0.1.0 临时部署记录

**部署时间：** 2026-06-12
**部署方式：** Cloudflared Quick Tunnel + Systemd
**域名：** https://manuals-navigator-magnificent-restaurants.trycloudflare.com

### 部署状态
| 检查项 | 状态 | 说明 |
|--------|------|------|
| 后端服务 | ✅ 运行中 | spireguide.service，端口 3001 |
| 隧道服务 | ✅ 运行中 | cloudflared-spireguide.service |
| 公网访问 | ✅ 可用 | Cloudflare Quick Tunnel |
| 开机自启 | ✅ 已启用 | 两个服务均 systemctl enable |
| 自动重启 | ✅ 已配置 | Restart=always |

### 已知限制
- Quick Tunnel 域名是临时的，cloudflared 重启后会变化
- 如需固定域名，需登录 Cloudflare 账户创建 Named Tunnel

### 运维命令
```bash
# 查看服务状态
systemctl status spireguide
systemctl status cloudflared-spireguide

# 查看日志
journalctl -u spireguide -f
journalctl -u cloudflared-spireguide -f

# 重启服务
systemctl restart spireguide
systemctl restart cloudflared-spireguide
```

---

**下次评审：** 域名备案完成后，迁移到 Named Tunnel + 自有域名

*记录人：wenner*
