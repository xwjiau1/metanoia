# HYROS Fit v4.0 个人版 — 过程文档

## 一、版本定位

- **版本号：** v4.0 Personal
- **目标：** 从生态版（v3.5+）裁剪为纯个人健身工具，去除所有社交/教练/商业化功能
- **AI策略：** 接入真实Kimi API（用户自填API Key），去除所有AI调用次数限制
- **核心原则：** 轻量、隐私优先、离线可用（除AI功能外）

---

## 二、变更清单

### 2.1 删除功能

| 功能 | 对应文件 | 删除原因 |
|------|----------|----------|
| 社区圈子 | `screens/CommunityScreen.js` | 社交功能，非个人使用必需 |
| 排行榜 | `screens/LeaderboardScreen.js` | 社交比较，非个人使用必需 |
| 会员订阅 | `screens/SubscriptionScreen.js` | 商业化功能 |
| 教练工作台 | `screens/CoachPortalScreen.js` | 教练-客户关系，非个人使用 |
| 客户详情 | `screens/CoachClientScreen.js` | 教练端附属 |
| 付费限制 | `store/monetizationStore.js` | AI次数限制、订阅状态管理 |

### 2.2 修改文件

| 文件 | 修改内容 |
|------|----------|
| `App.js` | 删除5个屏幕的import和Stack.Screen注册；删除monetizationStore引用和初始化；删除loading检查 |
| `screens/HomeScreen.js` | 删除社区入口卡片、教练工作台入口、底部社区快捷入口；优化首页布局填补空缺 |
| `screens/ProfileScreen.js` | 删除会员订阅入口、教练工作台入口；保留并优化数据管理功能 |
| `screens/AIPlanChatScreen.js` | 删除monetizationStore引用；删除canUseAI()次数检查；删除incrementAIUsage()；AI调用无限制 |
| `screens/AIImportScreen.js` | 删除monetizationStore引用；删除canUseAI()次数检查；删除incrementAIUsage() |
| `store/aiConfigStore.js` | 默认provider改为Kimi（`kimi-k2p6`）；默认API URL改为Moonshot |
| `utils/aiApi.js` | 无需修改，已支持真实API调用 |

### 2.3 保留并完善的功能

| 模块 | 功能 | 状态 |
|------|------|------|
| 训练 | 打卡、计时器、动作库150+、自定义动作、训练照片 | 完整保留 |
| 计划 | 创建/管理、模板库、AI导入（文本解析）、AI对话生成 | 完整保留，AI无限制 |
| 统计 | 数据面板、日历、搜索、导出Excel | 完整保留 |
| 设置 | 本地注册/登录、资料、通知提醒、AI配置、数据管理 | 完整保留 |
| AI | 计划生成（Kimi API）、智能建议、语音指令解析 | 接入真实API，无次数限制 |

---

## 三、AI功能实现细节

### 3.1 当前AI调用架构

```
AIPlanChatScreen.js → callAI() → utils/aiApi.js → 真实API (Kimi/OpenAI/etc)
AIImportScreen.js   → parseTrainingPlan() → 本地NLP（无需API）
utils/aiApi.js      → generateSmartSuggestion() → callAI() → 真实API
transcribeVoiceInstruction() → callAI() → 真实API（或离线降级）
```

### 3.2 v4.0修改点

1. **去除限制：** 删除所有`canUseAI()`和`incrementAIUsage()`调用
2. **默认Kimi：** aiConfigStore默认provider改为`kimi`，model改为`kimi-k2p6`
3. **错误提示优化：** AI调用失败时，提示用户检查API Key和网络，而非引导订阅
4. **离线降级保留：** 无API Key时，AI功能仍可降级到本地规则引擎（已有实现）

---

## 四、文件变更统计

| 操作 | 数量 |
|------|------|
| 删除屏幕文件 | 5个 |
| 删除store文件 | 1个 |
| 修改屏幕文件 | 4个 |
| 修改入口文件 | 1个（App.js） |
| 修改store文件 | 1个（aiConfigStore.js） |
| 净代码减少 | 预计 ~15-20KB |

---

## 五、版本说明

### v4.0 Personal 特性

- 纯本地运行，无云端依赖（除AI功能外）
- 数据完全本地存储（SQLite），用户拥有全部数据主权
- AI功能通过用户自填Kimi API Key启用，调用透明可控
- 无广告、无订阅、无社交干扰
- 轻量包体（预计较v3.5减少~5-8MB）

### 已知限制

- 数据无云端同步（换机需手动导出/导入）
- 认证仅为本地实现（无服务端验证）
- AI功能需要用户自行获取并配置Kimi API Key
- 截图OCR仍需手动输入文字（未接入OCR服务）

---

## 六、下一步建议

1. **打包APK** — v4.0完成后构建新APK
2. **数据备份增强** — 后续版本可增加自动备份到本地文件系统
3. **训练数据可视化** — 更丰富的图表和趋势分析
4. **导入导出格式** — 支持更多格式（CSV、JSON、其他健身App格式）

---

*文档生成时间：2026-05-09*
*版本：v4.0-Personal-Plan*
