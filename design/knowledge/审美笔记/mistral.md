# Mistral AI 心动设计拆解

> 来源：awesome-design-md / mistral.ai
> 研究日期：2026-05-13
> 研究员：Mery（启明科技 CIO）

---

## 第一眼感受

**"像普罗旺斯的日落——金黄色洒在古老的石墙上，温暖而高级。"**

Mistral 的设计系统可能是 AI 公司里「最法式」的。不是冷峻的科技感，而是夕阳般的暖色渐变 + 优雅的衬线标题。PP Editorial Old 字体让一切都变得「编辑感」十足，像是阅读一本高端杂志，而不是使用一个 AI 工具。

---

## 色彩策略

### 日落色彩系统
```
主色: #fa520f (饱和橙)
Sunshine 300: #ffd06a (柔和黄)
Sunshine 500: #ffb83e (暖黄)
Sunshine 800: #ff8105 (深橙)
Cream: #fff8e0 (奶油画布)
```

### 色彩逻辑
- **橙色**是 Mistral 的品牌签名——在法国文化中，橙色代表「创造力、热情、活力」
- **奶油画布** `#fff8e0` 比 Claude 的 `#faf9f5` 更暖、更黄，像是被阳光晒过的纸张
- **深色墨水** `#1f1f1f` — 在暖色画布上，深色文字产生强烈的对比

---

## 排版策略

### PP Editorial Old — 优雅的衬线
```
Hero Display: 84px/400/-1.5px — 巨大的衬线标题，极具编辑感
Display LG: 64px/400/-1px
Heading 1: 52px/400/-0.5px
Stat Display: 56px/400/-1px — 数据展示也用衬线！
```

### 正文字体：Inter
```
Heading 2-5: Inter, 500 weight
Body: Inter, 16px/400/1.55
Caption: Inter, 13px/400
Micro Uppercase: Inter, 11px/600/1px letter-spacing
```

### 排版特征
- **衬线标题 + 无衬线正文** — 与 Claude 相同的手法，但 Mistral 的衬线更「古典」
- **数据也用衬线**："56px 的 PP Editorial Old" 用于展示统计数据，数字变得「优雅」
- **大写微标签**：11px + 大写 + 1px 字距，精致的小型标签

---

## 空间策略

### 间距系统（更紧凑）
```
xxs: 4px, xs: 8px, sm: 12px, md: 16px
lg: 20px, xl: 24px, xxl: 32px
section-sm: 48px, section: 64px, section-lg: 96px
hero: 120px
```

### 信息密度
- 中高密度 — 比 Claude 紧凑，比 Linear 稀疏
- 适合「内容+数据」并存的页面

---

## 可借鉴到启明项目的点

### 立即可用
1. **日落色彩系统**：橙色+黄色+奶油的组合非常适合「温暖、创造力、活力」定位的产品
2. **PP Editorial Old 风格的衬线标题**：如果产品需要「编辑感、杂志感、知识感」，衬线标题是最佳选择
3. **数据也用衬线**：打破「数据=无衬线」的惯性思维，衬线数字在某些场景下更优雅
4. **奶油画布 `#fff8e0`**：比纯白温暖，适合阅读型产品

### 中文适配
- PP Editorial Old → 思源宋体 / 方正清刻本悦宋 / 方正兰亭宋
- Inter → MiSans / 阿里巴巴普惠体
- 中文衬线标题需要更大的字号（+20%）才能达到同等视觉重量

### 适合启明的项目类型
- 内容平台、杂志/媒体、教育产品、知识管理
- 任何需要「温暖、编辑感、知识深度」的产品

---

*拆解完成。*
