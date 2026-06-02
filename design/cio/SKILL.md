# Metanoia Design Lab — 设计部审美提升与灵感检索 Skill

**版本：** V1.0
**生效日期：** 2026-05-13
**适用范围：** 启明科技设计部（Mery / CIO）
**责任人：** Mery（CIO）

---

## 一、Skill 定位

本 Skill 为启明科技设计部提供**高可用的设计案例检索途径**和**审美提升工具链**，基于开源项目 [awesome-design-md](https://github.com/VoltAgent/awesome-design-md) 构建。

**核心价值：**
- 每个 Idea 到来时，快速从 55+ 顶级网站设计系统中检索匹配的风格方案
- 将「令人眼前一亮」的设计从主观感受转化为可执行的设计系统文档
- 建立设计部专属的设计案例知识库，沉淀公司级设计资产

---

## 二、触发条件

当用户（JiaWen / Wenner / Mery）提及以下任一关键词时激活：

- "设计灵感" / "审美提升" / "设计风格"
- "参考网站" / "像 Stripe / Vercel / Linear"
- "DESIGN.md" / "design system"
- "帮我看看用什么风格" / "这个页面怎么设计好看"
- "设计案例" / "竞品设计分析"
- "产出令人眼前一亮的设计"

---

## 三、数据来源

### 3.1 主数据源：awesome-design-md

**仓库地址：** `https://github.com/VoltAgent/awesome-design-md`

**内容结构：**
```
awesome-design-md/
└── design-md/
    └── <site-name>/
        ├── DESIGN.md          # 结构化设计系统文档（AI可读）
        ├── preview.html       # 浅色主题视觉预览
        └── preview-dark.html  # 深色主题视觉预览
```

**55+ 设计系统分类：**

| 分类 | 代表网站 | 风格关键词 |
|------|----------|-----------|
| **AI & LLM** | Claude, ElevenLabs, Mistral, xAI | 温暖陶土、暗色电影感、紫色极简、 stark monochrome |
| **开发者工具** | Cursor, Vercel, Linear, Raycast |  sleek dark, 黑白精确, 紫色点缀, 渐变强调 |
| **后端/DevOps** | Supabase, PostHog, HashiCorp | 暗色翡翠、 playful dark、企业级简洁 |
| **生产力/SaaS** | Notion, Linear, Cal.com, Intercom | 温暖极简、 serif标题、 蓝色对话、 极度简洁 |
| **设计工具** | Figma, Framer, Webflow | 多彩活力、 黑蓝 bold、 蓝色营销 |
| **金融科技** | Stripe, Revolut, Coinbase | 紫色渐变、 sleek dark、 蓝色信任 |
| **电商零售** | Airbnb, Nike, Shopify | 温暖珊瑚、 大写 Futura、 暗色电影 |
| **媒体消费** | Apple, Spotify, Pinterest | 高级留白、 绿色活力、 红色瀑布流 |
| **汽车** | Tesla, BMW, Ferrari, Lamborghini | 减法式、 暗色高级、 黑白编辑、 金色点缀 |

### 3.2 每个 DESIGN.md 包含的 9 大模块

| # | Section | 内容 |
|---|---------|------|
| 1 | Visual Theme & Atmosphere | 情绪、密度、设计哲学 |
| 2 | Color Palette & Roles | 语义色名 + hex + 功能角色 |
| 3 | Typography Rules | 字体家族、完整层级表 |
| 4 | Component Stylings | 按钮/卡片/输入框/导航 + 状态 |
| 5 | Layout Principles | 间距尺度、网格、留白哲学 |
| 6 | Depth & Elevation | 阴影系统、表面层级 |
| 7 | Do's and Don'ts | 设计护栏、反模式 |
| 8 | Responsive Behavior | 断点、触控目标 |
| 9 | Agent Prompt Guide | 快速色值参考、即用提示词 |

---

## 四、核心功能

### 4.1 设计案例检索

**按项目类型推荐风格：**

| 项目类型 | 推荐设计系统 | 理由 |
|----------|-------------|------|
| AI 产品 | `claude`, `mistral.ai`, `x.ai` | 温暖/科技感并存，避免冷冰冰 |
| 开发者工具 | `vercel`, `linear.app`, `resend` | 精确、可信、专业 |
| 数据 dashboard | `supabase`, `posthog`, `sentry` | 暗色主题、数据密度高 |
| 电商/展示 | `apple`, `airbnb`, `nike` | 摄影驱动、留白大气 |
| 内容/阅读 | `notion`, `mintlify` | 阅读优化、温暖衬线 |
| 企业 SaaS | `stripe`, `ibm`, `hashicorp` | 稳重、信任、结构化 |
| 创意/娱乐 | `spotify`, `runwayml`, `figma` | 活力、多彩、大胆 |
| 金融/支付 | `stripe`, `revolut`, `mastercard` | 专业、安全、精致 |

**检索命令示例：**
```bash
# 克隆 awesome-design-md 到设计部工作目录
cd /workspace/design/
git clone --depth 1 https://github.com/VoltAgent/awesome-design-md.git

# 列出所有可用设计系统
ls awesome-design-md/design-md/

# 查看某个设计系统的预览
cat awesome-design-md/design-md/vercel/preview.html
```

### 4.2 设计风格对比分析

**对比维度：**
1. **色彩情绪** — 暖/冷、高饱和/低饱和、单色调/多彩
2. **排版气质** — 衬线/无衬线、大标题/密排版、几何/人文
3. **空间尺度** — 大气留白/紧凑信息密度
4. **交互暗示** — 圆角/直角、阴影/扁平、渐变/纯色
5. **品牌调性** — 专业/ playful / 极简 / 奢华

**对比输出格式：**
```markdown
## 风格对比：Vercel vs Stripe vs Linear

| 维度 | Vercel | Stripe | Linear |
|------|--------|--------|--------|
| 主色调 | 黑白精确 | 紫色渐变 | 紫色点缀 |
| 字体 | Geist Sans | Weight-300 优雅 | Inter 精确 |
| 留白 | 大量 | 中等 | 极度紧凑 |
| 圆角 | 小圆角 | 大圆角 pill | 极小圆角 |
| 适用场景 | 开发者平台 | 支付/企业 | 项目管理 |
```

### 4.3 DESIGN.md 应用流程

**步骤 1：检索匹配设计系统**
- 根据项目类型/关键词从 awesome-design-md 中筛选 3-5 个候选

**步骤 2：预览与对比**
- 查看 preview.html / preview-dark.html 了解视觉风格
- 对比分析，选择最契合项目气质的 1-2 个

**步骤 3：下载 DESIGN.md**
```bash
curl -O https://raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/{site}/DESIGN.md
```

**步骤 4：适配调整**
- 阅读 DESIGN.md 的 9 大模块
- 根据项目品牌色替换主色调
- 根据中文场景调整字体（替换为适合中文的字体栈）
- 调整间距尺度适配中文排版

**步骤 5：生成设计决策文档**
```markdown
# {项目名} 设计系统决策

## 参考来源
- 主参考：{site-name} DESIGN.md
- 辅助参考：{site-name-2} DESIGN.md

## 适配调整
- 主色替换：{原色} → {品牌色}
- 字体替换：{原字体} → {中文字体栈}
- 间距调整：{调整原因}

## 设计原则（从 DESIGN.md 提取并本地化）
...
```

### 4.4 审美提升训练

**定期训练机制：**
- 每周精选 1 个设计系统，Mery 深入研究其 9 大模块
- 分析「为什么这个设计令人心动」— 拆解到色彩/排版/动效/留白层面
- 沉淀为设计部内部笔记：`design/memory/审美笔记/{site-name}.md`

**心动设计拆解模板：**
```markdown
# {网站名} 心动设计拆解

## 第一眼感受
{一句话描述看到这个网站的第一印象}

## 色彩策略
- 主色：{hex} — 为什么选这个色？传递什么情绪？
- 辅助色：{hex} — 在什么场景使用？
- 背景色：{hex} — 如何衬托内容？

## 排版策略
- 字体选择逻辑
- 字号层级对比
- 行高/字间距的呼吸感

## 空间策略
- 留白节奏
- 信息密度控制
- 视觉焦点引导

## 可借鉴到启明项目的点
{具体哪些元素/手法可以复用到我们的设计中}
```

---

## 五、工具脚本

### 5.1 设计系统检索器

```bash
#!/bin/bash
# /workspace/design/tools/search-design-system.sh

KEYWORD=$1
REPO_DIR="/workspace/design/awesome-design-md/design-md"

echo "=== 搜索设计系统: $KEYWORD ==="
for dir in $REPO_DIR/*/; do
    site=$(basename "$dir")
    if grep -qi "$KEYWORD" "$dir/DESIGN.md" 2>/dev/null; then
        echo "  ✅ $site"
        # 提取 Visual Theme 第一句
        head -20 "$dir/DESIGN.md" | grep -i "theme\|atmosphere\|mood" | head -1
    fi
done
```

### 5.2 设计系统对比器

```bash
#!/bin/bash
# /workspace/design/tools/compare-design-systems.sh

SITE1=$1
SITE2=$2
REPO_DIR="/workspace/design/awesome-design-md/design-md"

echo "=== 对比: $SITE1 vs $SITE2 ==="
echo ""
echo "--- 色彩 ---"
grep -A 5 "Color Palette" "$REPO_DIR/$SITE1/DESIGN.md" | head -10
echo "---"
grep -A 5 "Color Palette" "$REPO_DIR/$SITE2/DESIGN.md" | head -10
```

### 5.3 快速预览启动器

```bash
#!/bin/bash
# /workspace/design/tools/preview-design-system.sh

SITE=$1
REPO_DIR="/workspace/design/awesome-design-md/design-md"

if [ -f "$REPO_DIR/$SITE/preview.html" ]; then
    echo "启动 $SITE 设计系统预览..."
    python3 -m http.server 8888 --directory "$REPO_DIR/$SITE" &
    echo "访问: http://localhost:8888/preview.html"
    echo "深色: http://localhost:8888/preview-dark.html"
else
    echo "未找到 $SITE 的预览文件"
    echo "可用系统:"
    ls $REPO_DIR/
fi
```

---

## 六、与启明工作流集成

### 6.1 在项目中的使用位置

```
design/projects/{project-name}/
├── 01-调研/
│   ├── 市场调研报告.md
│   └── 竞品分析报告.md
├── 02-PRD/
│   └── 产品需求文档.md
├── 03-设计/
│   ├── 设计系统决策.md      ← 本 Skill 产出
│   ├── 参考设计系统/
│   │   └── {site-name}/
│   │       ├── DESIGN.md     ← 从 awesome-design-md 下载
│   │       ├── preview.html
│   │       └── preview-dark.html
│   ├── 交互设计稿.fig
│   └── 视觉设计稿.fig
└── README.md
```

### 6.2 与 Irra（技术部）的交接

- Mery 产出 `设计系统决策.md` + `参考设计系统/DESIGN.md`
- Irra 直接读取 DESIGN.md 进行开发，无需 Figma 导出
- 若需 Figma 设计稿，Mery 基于 DESIGN.md 的 tokens 在 Figma 中搭建
- 技术评估阶段（设计部 Stage 9），Irra 可直接评估 DESIGN.md 中的技术可行性

---

## 七、知识库沉淀

### 7.1 设计部案例库

```
design/knowledge/
├── design-systems/              # 沉淀的设计系统分析
│   ├── vercel.md
│   ├── stripe.md
│   └── ...
├── 审美笔记/                    # 心动设计拆解
│   ├── 2026-05-13-apple.md
│   └── ...
└── 项目参考映射.md               # 项目类型 → 推荐设计系统
```

### 7.2 定期更新机制

- awesome-design-md 每月更新，Mery 定期 `git pull` 同步
- 新增设计系统时，Mery 快速分析并入库
- 启明科技可贡献自己的 DESIGN.md 回流社区

---

## 八、使用示例

### 场景 1：新项目启动，寻找设计风格

**用户：** "我要做一个 AI 助手产品，想要看起来专业又有温度，给我推荐几个设计风格"

**Skill 响应：**
1. 检索 awesome-design-md 中 AI 相关设计系统
2. 推荐：Claude（温暖陶土）、Mistral AI（紫色极简）、xAI（ stark monochrome）
3. 下载对应 DESIGN.md 到项目目录
4. 生成对比分析文档
5. 给出适配建议（中文场景字体替换等）

### 场景 2：已有项目，提升视觉品质

**用户：** "这个页面看起来太普通了，帮我参考 Stripe 的设计优化一下"

**Skill 响应：**
1. 下载 Stripe DESIGN.md
2. 分析 Stripe 的核心设计策略（紫色渐变、weight-300 优雅、大圆角 pill）
3. 对比当前项目设计，找出差距
4. 给出具体的 token 替换建议（色值、字体权重、圆角值）

### 场景 3：设计决策文档

**用户：** "帮我写一份设计系统决策文档，参考 Vercel 的风格"

**Skill 响应：**
1. 下载 Vercel DESIGN.md
2. 提取 9 大模块核心内容
3. 按启明项目需求本地化调整
4. 输出完整的设计系统决策文档

---

## 九、技术依赖

| 依赖 | 用途 | 安装 |
|------|------|------|
| git | 克隆 awesome-design-md | 已安装 |
| curl | 下载单个 DESIGN.md | 已安装 |
| python3 | 本地预览 preview.html | 已安装 |
| 浏览器 | 查看视觉预览 | 已安装 |

---

## 十、版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| V1.0 | 2026-05-13 | 基于 awesome-design-md 初始化设计部审美提升 Skill |

---

*Skill 维护人：Mery（CIO）*
*审核人：Wenner（CEO）*
*来源项目：[awesome-design-md](https://github.com/VoltAgent/awesome-design-md)*
