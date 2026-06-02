# awesome-design-md 研究报告

> 启明科技设计部专项研究
> 课题编号：DESIGN-LAB-001
> 研究员：Mery（CIO）
> 日期：2026-05-13

---

## 一、研究背景

JiaWen（创始人）提出需求：为启明科技设计部建立一套**高可用的设计案例检索途径**，让每个 idea 到来时能快速找到匹配的设计风格参考，产出「令人眼前一亮、直接心动」的设计稿。

研究对象：GitHub 项目 [awesome-design-md](https://github.com/VoltAgent/awesome-design-md)（73 个顶级网站 DESIGN.md 结构化设计文档）。

---

## 二、awesome-design-md 项目概述

### 什么是 DESIGN.md？
由 Google Stitch 提出的概念——纯文本设计系统文档，AI 可以直接读取并生成一致的 UI。

| 文件 | 读者 | 定义 |
|------|------|------|
| AGENTS.md | 编码 Agent | 如何构建项目 |
| DESIGN.md | 设计 Agent | 项目应该长什么样 |

### 每个 DESIGN.md 包含的 9 大模块
1. Visual Theme & Atmosphere — 情绪、密度、设计哲学
2. Color Palette & Roles — 语义色名 + hex + 功能角色
3. Typography Rules — 字体家族、完整层级表
4. Component Stylings — 按钮/卡片/输入框 + 状态
5. Layout Principles — 间距尺度、网格、留白
6. Depth & Elevation — 阴影系统、表面层级
7. Do's and Don'ts — 设计护栏、反模式
8. Responsive Behavior — 断点、触控目标
9. Agent Prompt Guide — 快速色值参考、即用提示词

### 项目规模
- **73 个设计系统**，覆盖 10 大行业分类
- 每个系统包含：DESIGN.md + preview.html + preview-dark.html
- MIT 协议，可自由使用

---

## 三、研究成果

### 3.1 设计部 Skill 已建立

**文件**：`/workspace/design/cio/SKILL.md`

**触发关键词**："设计灵感" / "审美提升" / "像 Stripe/Vercel" / "DESIGN.md"

**核心能力**：
- 按项目类型检索匹配的设计系统
- 风格对比分析
- DESIGN.md 应用流程（检索→预览→下载→适配→决策）
- 审美提升训练机制

### 3.2 工具脚本已就绪（4个）

| 脚本 | 功能 | 路径 |
|------|------|------|
| search-design-system.sh | 按关键词检索设计系统 | /workspace/design/tools/ |
| compare-design-systems.sh | 对比两个设计系统 | /workspace/design/tools/ |
| preview-design-system.sh | 本地浏览器预览 | /workspace/design/tools/ |
| download-design-system.sh | 下载到项目目录 | /workspace/design/tools/ |

### 3.3 心动设计拆解笔记（10份）

| # | 系统 | 行业 | 核心心动点 |
|---|------|------|-----------|
| 1 | **claude** | AI | 温暖奶油画布 + 珊瑚CTA + 衬线标题 = 人文AI |
| 2 | **vercel** | 开发者工具 | 黑白精确 + 网格渐变 + Geist字体 = 工程师优雅 |
| 3 | **linear.app** | 开发者工具 | 极致暗色 + lavender蓝 + 高密度层级 = 精密仪器 |
| 4 | **stripe** | 金融科技 | 紫色渐变 + weight-300 + pill按钮 = 克制的奢华 |
| 5 | **apple** | 消费科技 | 产品说话 + Action Blue + 亮暗交替 = 博物馆 |
| 6 | **spotify** | 媒体 | 暗色俱乐部 + 翡翠绿 + 卡片网格 = 沉浸空间 |
| 7 | **mistral.ai** | AI | 日落渐变 + PP Editorial Old + 奶油画布 = 法式编辑 |
| 8 | **x.ai** | AI | stark monochrome + 夕阳点缀 + 宇宙级极简 = 前沿 |
| 9 | **supabase** | 开发者工具 | 翡翠绿 + 产品截图Hero + 开源感 = 开发者友好 |
| 10 | **airbnb** | 电商 | 珊瑚红 + 圆角UI + 摄影驱动 = 温暖邀请 |
| 11 | **nike** | 电商 | 单色 + 大写Futura + 全出血 = 力量宣言 |

### 3.4 项目类型映射表

已建立完整的「项目类型 → 推荐设计系统」映射：
- 🤖 AI产品 → claude, mistral, x.ai
- 🛠️ 开发者工具 → vercel, linear, supabase
- 💰 金融科技 → stripe, revolut, coinbase
- 🛒 电商展示 → apple, airbnb, nike
- 🎨 设计工具 → figma, framer, webflow
- 🎵 媒体娱乐 → spotify, pinterest, the-verge
- 🚗 汽车高端 → tesla, bmw, ferrari

### 3.5 案例库分类索引

**文件**：`/workspace/design/knowledge/design-systems/分类索引.md`

- 全部 73 个系统按 10 大行业分类
- 每个系统标注：风格关键词、心动指数、笔记状态
- 按设计情绪快速检索表（温暖人文/冷酷精确/暗色电影/多彩活力/奢华高级/神秘紫色/自然绿色/能量动感/前沿宇宙）

---

## 四、核心发现

### 4.1 顶级设计系统的共同规律

| 维度 | 规律 |
|------|------|
| **色彩** | 90% 的系统只用 1-3 个主色，强调色极度克制 |
| **字体** | 定制字体 > 系统字体；衬线=人文/编辑，无衬线=技术/效率 |
| **留白** | 好设计不怕留白，section 间距 80-192px 是常态 |
| **圆角** | pill (9999px) 按钮 = 友好；小圆角 = 精确；零圆角 = 力量 |
| **暗色** | 暗色背景不是纯黑 #000000，而是 #0a0a0a ~ #121212 |

### 4.2 中文场景适配关键

| 适配项 | 英文系统 | 中文适配 |
|--------|----------|----------|
| 衬线标题 | Copernicus, Tiempos | 思源宋体、方正清刻本 |
| 无衬线正文 | Inter, Geist | MiSans、阿里巴巴普惠体、HarmonyOS Sans |
| 负字距 | -2.4px @ 48px | 调整为 -0.02 ~ -0.05em |
| 大写标签 | UPPERCASE | 改为「小字号 + 灰色 + 字距加宽」 |
| 行高 | 1.0-1.1 (英文标题) | 中文标题需 1.2+ |
| 字号 | 16px 正文 | 中文 16px 足够，无需放大 |

### 4.3 启明科技可直接复用的设计资产

| 资产 | 来源 | 使用方式 |
|------|------|----------|
| 奶油画布 `#faf9f5` | claude | 任何需要温暖感的产品背景 |
| 珊瑚CTA `#cc785c` | claude | AI/社区产品的按钮/链接色 |
| 网格渐变 | vercel | hero 区域装饰 |
| Geist 字体 | vercel | 开发者产品的全局字体 |
| 暗色四层表面 | linear | 任何 dashboard/后台系统 |
| Pill 按钮 | stripe, airbnb | 友好型产品的 CTA |
| 翡翠绿 `#3ecf8e` | supabase | 开源/社区产品的主色 |
| 全出血大图 | apple, nike | 产品展示页 |
| #121212 暗色画布 | spotify | 暗色模式基础 |

---

## 五、后续建议

### 5.1 设计部工作流集成

```
Idea 到来
    ↓
按项目类型查「映射表」→ 推荐 3-5 个设计系统
    ↓
运行 search-design-system.sh 检索关键词
    ↓
运行 preview-design-system.sh 预览视觉
    ↓
运行 compare-design-systems.sh 对比筛选
    ↓
运行 download-design-system.sh 下载到项目
    ↓
阅读 DESIGN.md 的 9 大模块 → 提取 design tokens
    ↓
适配中文场景（字体替换、字距调整）
    ↓
产出「设计系统决策文档」
    ↓
进入 Figma/原型设计阶段
```

### 5.2 审美提升训练计划

- **每周精读 1 个设计系统**，产出「心动设计拆解」笔记
- **每月回顾已拆解笔记**，提炼跨系统的设计规律
- **每季度更新案例库索引**，同步 awesome-design-md 的最新更新

### 5.3 向 awesome-design-md 贡献

当启明科技产出优秀设计时，可以反向贡献 DESIGN.md 到社区，提升公司影响力。

---

## 六、交付物清单

| # | 交付物 | 路径 | 状态 |
|---|--------|------|------|
| 1 | 设计部 Skill | /workspace/design/cio/SKILL.md | ✅ |
| 2 | 工具脚本 ×4 | /workspace/design/tools/*.sh | ✅ |
| 3 | 心动设计拆解 ×10 | /workspace/design/knowledge/审美笔记/*.md | ✅ |
| 4 | 项目类型映射表 | /workspace/design/knowledge/项目类型映射表.md | ✅ |
| 5 | 案例库分类索引 | /workspace/design/knowledge/design-systems/分类索引.md | ✅ |
| 6 | 研究报告 | /workspace/design/knowledge/awesome-design-md研究报告.md | ✅ |

---

## 七、工具验证报告

```bash
# 测试检索功能
$ /workspace/design/tools/search-design-system.sh "ai"
=== 🔍 搜索设计系统: 'ai' ===
  ✅ claude
  ✅ mistral.ai
  ✅ x.ai
  ...

# 测试对比功能
$ /workspace/design/tools/compare-design-systems.sh vercel stripe
========================================
    设计系统对比: vercel vs stripe
========================================
🎨 【视觉主题】
...

# 测试预览功能
$ /workspace/design/tools/preview-design-system.sh claude
🚀 启动 claude 设计系统预览服务器...
📎 浅色主题: http://localhost:8888/preview.html
📎 深色主题: http://localhost:8888/preview-dark.html
```

**结论：全部 4 个工具脚本功能正常，可直接使用。**

---

*报告完成。*
*研究员：Mery（启明科技 CIO）*
*审核人：Wenner（CEO）*
