# 踩坑记录（Troubleshooting Log）

## 2026-05-08 — Edit工具误用于目录

**现象：**
`Edit: in ~/.openclaw/workspace/projects/hyros-fit/03-源码 failed`
调用edit工具时传入了目录路径而非文件路径。

**原因：**
edit工具只能用于**文件**的精确文本替换，不能用于目录。
当时试图对一个目录执行edit操作，导致失败。

**解决方案：**
1. 确认目标路径是文件还是目录：`ls -la path` 或 `file path`
2. 如需修改目录下的文件，指定具体文件路径
3. 如需批量修改目录内容，用exec执行shell命令（sed/find）

**预防措施：**
- 每次edit前先确认路径存在且是文件
- 对目录操作时优先用exec + shell

---

## 2026-05-08 — EAS Build需Expo账号Token

**现象：**
`eas build` 报错：`An Expo user account is required to proceed.`

**原因：**
EAS云端构建必须登录Expo账号，服务器无图形界面无法浏览器登录。

**解决方案：**
1. CEO在 expo.dev 注册账号
2. 在 expo.dev/settings/access-tokens 生成 Personal Access Token
3. 服务器使用 `EXPO_TOKEN=xxx npx eas build` 非交互式构建
4. 如需初始化项目：`eas init --force --non-interactive`

**预防措施：**
- 新项目提前准备Expo Access Token
- 记录Token到安全位置

---

## 2026-05-08 — Node.js v24与Expo SDK 51不兼容

**现象：**
`npm install` 后 Expo 报错，Metro Bundler启动失败。

**原因：**
服务器Node.js v24.15.0较新，Expo SDK 51配套React Native 0.74未完全兼容。

**解决方案：**
1. 使用 `n` 或 `nvm` 安装 Node 20.x LTS
2. 用 `/usr/local/bin/node` 启动Expo
3. 项目package.json中添加engines字段限制Node版本

**预防措施：**
- 新项目开发前确认Node版本兼容性
- 在README中记录推荐Node版本

---

## 2026-05-08 — CTO子agent thread模式不可用

**现象：**
`sessions_spawn` 设置 `mode=session, thread=true` 报错：
`thread=true is unavailable because no channel plugin registered subagent_spawning hooks`

**原因：**
当前channel配置（openclaw-weixin）未注册subagent线程持久化hooks。

**解决方案：**
- 仅使用 `mode=run`（单次任务模式）
- 每次任务完成后由主脑重新spawn新CTO
- 通过文件系统共享状态（工作目录）

**预防措施：**
- 所有CTO任务使用run模式
- 不尝试thread/session持久化

---

## 2026-05-08 — EAS Build排队时间长

**现象：**
`eas build` 后状态长时间停留在 `IN_QUEUE`（16-20分钟）。

**原因：**
Expo免费账号云端构建队列较长，高峰期等待更久。

**解决方案：**
1. 提交构建后立即监控状态
2. 使用后台脚本轮询（每5分钟检查一次）
3. 构建完成后自动下载APK

**预防措施：**
- 心流模式下：开发阶段不构建APK，仅在最终版本时构建
- 减少不必要的构建次数

---

## 2026-05-08 — 监工脚本Shell算术运算空值错误

**现象：**
`flow-monitor-011.sh` 触发"10分钟无产出变化"警告，但CTO实际正在产出。
监工报告标注："脚本有语法错误（line 28/36 算术运算表达式问题）"。

**原因：**
```bash
LAST_SIZE=$(cat "$STATE_FILE" | grep '"web_size"' | cut -d: -f2 | tr -d ' ,')
```
当STATE_FILE不存在或grep未匹配到内容时，`LAST_SIZE`为空字符串。
```bash
SIZE_DELTA=$((WEB_SIZE - LAST_SIZE))
```
空字符串参与算术运算导致bash报错："operand expected (error token is "")"
进而 `SIZE_DELTA`也为空，`if [ $SIZE_DELTA -gt 0 ]` 报错。

**解决方案：**
1. 提取LAST_SIZE时追加 `|| echo 0` 确保默认值：
   ```bash
   LAST_SIZE=$(cat "$STATE_FILE" 2>/dev/null | grep '"web_size"' | cut -d: -f2 | tr -d ' ,' || echo 0)
   ```
2. 计算后做空值保护：
   ```bash
   SIZE_DELTA=${SIZE_DELTA:-0}
   ```

**预防措施：**
- 所有shell监工脚本中，从JSON提取的字段值必须带默认值保护
- 算术运算前用 `${VAR:-0}` 语法确保非空
- 新监工脚本写完后先手动执行一次验证

---

## 2026-05-08 — 京东抓取：云服务器IP风控不可穿透

**现象：**
- requests直接请求 → "系统繁忙"
- Playwright+Cookie(PC端) → 重定向到 `jd.com?reason=403`
- Playwright+Cookie(H5端) → 跳转登录页
- 所有策略（API/浏览器/移动端）全部失效

**原因：**
京东对数据中心IP（云服务器）的风控是IP级别的。Cookie与浏览器指纹+IP深度绑定，换IP即失效。

**结论：**
云服务器上无法直接抓取京东评论。可行路径：
1. 在家庭宽带IP（本地PC）上运行
2. 使用住宅代理IP（付费）

**预防措施：**
- 电商抓取类项目需提前确认运行环境IP类型
- 在PRD中标注"需在家庭IP环境运行"的约束

---

**监工脚本硬编码路径导致假阳性告警（已修复）**

**现象：**
JD-001监工脚本硬编码了旧项目路径（`projects/jd-review-scraper/03-源码`），该项目5月8日已完成。但监工持续运行，每次检查都报"10分钟无产出变化"，持续骚扰CEO微信。

**原因：**
1. 监工脚本路径硬编码，任务完成后未销毁
2. 没有任务生命周期管理机制
3. 多个旧监工脚本散落在/tmp目录下（flow-monitor-006~011, jd-001），都是已完成项目的残留

**修复：**
1. 清理所有旧监工脚本和状态文件
2. 建立通用监工管理器（`flow-monitor-manager.sh`），支持注册/注销/检查/清理
3. 建立注册表（`flow-monitor-registry.json`），追踪活跃vs已完成任务
4. 监工与任务绑定：任务启动时注册，完成时注销，自动清理临时文件
5. 更新STANDARDS.md监工规范

**预防措施：**
- 所有新任务启动时必须通过管理器注册监工
- 任务完成后必须通过管理器注销
- 定期检查 `/tmp/flow-monitor-manager.sh list` 是否有僵尸监工
- 旧监工脚本的cron定时任务必须清理

**日期：** 2026-05-10

---

*记录维护：wenner*
*更新日期：2026-05-10*
