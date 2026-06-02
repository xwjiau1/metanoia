# HYROS Fit v1.0 MVP

> 启明科技（Metanoia）首款健身训练记录App — MVP版本

## 项目简介

HYROS Fit 是一款面向健身爱好者的训练记录App，支持：
- 离线用户注册/登录
- 训练计划创建与管理（多分化模板）
- 50个常见动作库（搜索+分类）
- 日历视图与训练打卡
- 容量统计与连续打卡记录
- 组间计时器

**技术栈**：Expo SDK 51 / React Native 0.74 / expo-sqlite / React Navigation 6

## 文件索引

```
projects/hyros-fit/
├── 01-PRD/
│   └── HYROS_Fit_PRD.txt              # 产品需求文档
├── 02-设计/
│   ├── dev-plan.html                    # 开发方案
│   └── prototype.html                   # Figma原型（HTML可预览）
├── 03-源码/
│   └── src/                             # React Native完整项目
│       ├── App.js
│       ├── package.json
│       ├── database/
│       │   ├── init.js                  # 数据库初始化（8张表）
│       │   └── operations.js            # CRUD操作层
│       ├── screens/                     # 11个页面组件
│       │   ├── LoginScreen.js
│       │   ├── RegisterScreen.js
│       │   ├── HomeScreen.js
│       │   ├── TrainingScreen.js
│       │   ├── CreatePlanScreen.js
│       │   ├── PlanDetailScreen.js
│       │   ├── ExerciseLibraryScreen.js
│       │   ├── CalendarScreen.js
│       │   ├── WorkoutLogScreen.js
│       │   ├── TimerScreen.js
│       │   ├── StatsScreen.js
│       │   └── ProfileScreen.js
│       └── utils/
│           └── constants.js             # 配色、字体、动作库、模板
├── 04-文档/
│   ├── deployment-guide.html            # 配置与上线手册
│   └── user-manual.html                  # 产品使用说明书
├── 05-测试/
│   ├── test-cases.html                  # 42条测试用例
│   └── test-report.html                 # 测试报告（9项issue记录）
├── 06-构建/
│   └── HYROS-Fit-v1.0.apk              # Android构建产物（~75MB）
└── 07-过程/
    └── build-log.txt                    # 关键里程碑记录
```

## 版本历史

| 版本 | 日期 | 说明 |
|------|------|------|
| v1.0 MVP | 2026-05-07 | 首次发布，覆盖P0核心功能 |

## 已知限制

- 密码明文存储（V1.1计划引入哈希）
- 无云端同步，数据仅本地保存
- 无社交/分享功能
- 体重/体脂记录模块已预留表结构，UI未实现

## 快速开始

```bash
cd 03-源码/src
npm install
npx expo start
# 或构建APK
npx eas build -p android
```

---
© 2026 启明科技 Metanoia
