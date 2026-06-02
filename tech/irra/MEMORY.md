# CTO 记忆

## 项目经验

### SpireGuide（杀戮尖塔攻略平台）

**版本演进：**
- v0.1.0 → v0.1.3（上线） → **v0.2.0 Phase 1（2026-05-13 完成）**

**技术栈：**
- React Native + Expo
- better-sqlite3 本地数据库
- Express 后端API
- Kimi API（kimi-k2.6）AI策略助手

**v0.2.0 Phase 2 完成记录（2026-05-13）：**
1. **routes/archetypes.ts** — 流派路由（全新）
   - GET /api/archetypes — 列表查询（支持 game_version/character/difficulty_max 筛选），自动解析JSON字段
   - GET /api/archetypes/:id — 详情（含核心卡牌详情+关键遗物详情+避免遗物详情）
   - GET /api/archetypes/:id/attempts — 该流派的尝试记录（支持 device_id 过滤）
   - POST /api/archetypes — 录入新流派
   - PUT /api/archetypes/:id — 更新流派
   - DELETE /api/archetypes/:id — 删除流派
   - 核心卡牌查询：优先 JOIN card_archetype_links，为空时 fallback 到 core_cards 字段 LIKE 匹配 cards 表
2. **routes/attempts.ts** — 尝试记录路由（全新）
   - GET /api/attempts — 列表查询（支持 archetype_id/device_id/outcome 筛选）
   - POST /api/attempts — 创建记录（device_id 从 x-device-id header 或 body 获取）
   - PUT /api/attempts/:id — 更新（notes/outcome/final_floor/rating/is_favorite）
   - DELETE /api/attempts/:id — 删除记录
3. **routes/ai.ts** — AI完善（修改）
   - 新增 AiErrorType 枚举 + classifyError() 函数：401→api_key_invalid, 429→rate_limited, fetch failed→network_error, timeout→timeout
   - 降级时返回带 _fallback=true 的 Mock 结果（含 _fallback_reason/_fallback_message）
   - buildStrategyPrompt() 接收 archetype_id 参数，查询 archetypes 表注入流派攻略上下文
   - 追加 DISCLAIMER 免责声明到所有 answer 末尾
4. **index.ts** — 注册 archetypesRouter + attemptsRouter
5. **API测试**：curl 验证全部端点通过

**v0.2.0 Phase 1 完成记录（2026-05-13）：**
1. **数据库重建**：备份旧DB → 删除 → 用 schema-v0.2.0.sql 重建 → 运行 npm run seed 灌入基础数据
2. **ai_configs 保留**：Kimi API Key（sk-aVBHeol55uuBxi3aoX990T7aZbPGIo44EExkaXND9iX0zsQA）+ 模型 kimi-k2.6 已恢复，enabled=1
3. **流派种子数据**：21条流派记录灌入 archetypes 表（Ironclad×4, Silent×4, Defect×4, Watcher×4, Necrobinder×2, Regent×2, Colorless×1），所有23个字段完整填充，route_preferences JSON序列化正确
4. **翻译修正**：Swift Strike「科学方法」→「迅捷打击」，Quick Slash「急速斩」→「快斩」，colorless 卡牌19张英文名→中文译名
5. **数据库状态**：cards=295, relics=42, enemies=25, archetypes=21, archetype_attempts=0, ai_configs=1

**踩坑记录：**
1. **SQLite WAL模式**：备份时必须同时备份 .db-shm 和 .db-wal，否则可能丢失未提交数据
2. **schema.sql 是源文件**：db.ts 启动时自动执行 schema.sql 的 CREATE TABLE IF NOT EXISTS，但如果表已存在且结构旧，不会自动 ALTER。重建是更稳妥的策略。
3. **种子数据脚本注意**：archetypes.ts 中的数组字段需 JSON.stringify，route_preferences 对象也需 JSON.stringify
4. **colorless 卡牌翻译**：种子数据中大量英文名直接填入 name_cn，需批量修正

---

### HYROS Fit（健身训练App）

**版本演进：**
- v1.0 → v1.1 → v1.2 → v3.0 → v3.5+ → v4.0（个人版）

**技术栈：**
- React Native + Expo SDK 51
- SQLite 本地持久化
- Zustand 状态管理
- React Navigation 导航

**踩坑记录：**
1. **EAS构建：** 服务器无Android SDK，必须使用EAS云端构建，需Expo Access Token
2. **版本对齐：** package.json 和 app.json 的 version 必须一致，否则构建失败
3. **依赖管理：** 升级Expo SDK时需注意兼容性问题，建议lock版本
4. **数据库迁移：** Schema变更必须兼容旧数据，使用迁移脚本
5. **Metro缓存：** 遇到奇怪报错时，先 `npx expo start --clear` 清缓存

**最佳实践：**
- MVP优先：只做P0功能，砍掉社交/教练/商业化
- 代码注释用中文
- 文件命名用中文或英文，保持一致
- 测试用例不少于30条
- APK体积控制在100MB以内

### jd-review-scraper（京东评论抓取）

**技术方案：**
- Python + requests + BeautifulSoup
- SQLite 存储
- 模块化架构：fetcher/parser/classifier/pipeline
- 反爬策略：UA轮换、Cookie复用、请求频率控制（<300/h）

**经验：**
- 京东评论API不稳定，需多重fallback
- 模块化设计便于单元测试
- CLI接口设计要简洁，支持日期范围+商品ID列表

## 技术债务

| 项目 | 债务 | 优先级 |
|------|------|--------|
| HYROS Fit | 后端服务待建（社交/教练功能移除后暂无） | 低 |
| HYROS Fit | AI功能通过Kimi API实现，需优化调用成本 | 中 |

## 工具配置

- **EAS Token：** `tech/knowledge/tools/.expo_token`
- **构建命令：** `npx eas build --platform android --profile preview`

---

*维护人：CTO*
*更新规则：每完成一个项目或版本后更新*
