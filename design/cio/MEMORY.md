# CIO 记忆 — Mery

## 项目经验

### 设计部成立
- **日期：** 2026-05-10
- **背景：** 公司从单一技术部扩展到技术+设计双部门
- **职能：** 市场调研、竞品分析、PRD、Figma设计、需求分析
- **首任负责人：** Mery（CIO）

## 设计方法论

### 市场调研框架
1. 市场规模估算（TAM/SAM/SOM）
2. 竞品清单（功能、定价、用户评价）
3. 用户痛点提炼（从评论、论坛、调研中提取）
4. 差异化机会（未被满足的需求）

### PRD撰写框架
1. 产品定位（一句话）
2. 目标用户（Persona）
3. 核心功能（P0必须/P1重要/P2可选）
4. 用户故事（As a... I want... So that...）
5. 验收标准（Given... When... Then...）
6. 数据指标（北极星指标）

### 设计原则
- 移动优先
- MVP优先
- 数据驱动
- 可落地（技术可实现）

## 踩坑记录

（待补充：第一个项目完成后记录）

## 技术协作经验

- Irra（CTO）评估技术可行性通常需要1-2天
- 设计稿中动画效果实现成本较高，需谨慎使用
- 深色模式是Irra的标准配置，设计时直接考虑
- SQLite是默认数据库，设计数据模型时需考虑

### RAG 中间件/插件项目（2026-06-02）
- **状态**：Stage 1 调研完成，项目规划书已编制
- **定位**：面向 Agent 应用的 RAG 插件/中间件（非知识库问答系统）
- **核心差异化**：可视化 RAG 全流程控制台 + 召回策略配置面板 + 错题本 + 多向量库切换
- **交付物**：
  - `design/projects/rag-middleware/01-调研/产品定位更新.md`
  - `design/projects/rag-middleware/01-调研/01-市场调研报告.md`
  - `design/projects/rag-middleware/01-调研/02-竞品分析报告.md`
  - `design/projects/rag-middleware/01-调研/03-用户画像.md`
  - `design/projects/rag-middleware/02-PRD/04-技术架构方案.md`
  - `design/projects/rag-middleware/02-PRD/05-商业模式与定价策略.md`
  - `design/projects/rag-middleware/02-PRD/06-风险分析与应对策略.md`
  - `design/projects/rag-middleware/项目规划书.md`
- **市场数据**：2025年 RAG 市场 17.5~54 亿美元，CAGR 32~49%，SAM 约 5.5~9.2 亿美元
- **竞品空白**：缺少"面向 RAG 运维的可视化控制台+API 层"，差异化空间明确
- **商业模式**：开源核心(Apache 2.0) + 云托管(¥99-1,999/月) + 企业版(定制)
- **技术选型**：Qdrant + BGE-M3 + FastAPI + React + Docker Compose
- **待办**：提交 Irra 技术评估、Wenner 审核、JiaWen 确认

## 用户洞察

（待补充：从用户调研中提炼的洞察）

## 设计趋势

（待补充：关注的设计趋势和新技术）

---

*维护人：Mery*
*更新规则：每完成一个项目或版本后更新*
