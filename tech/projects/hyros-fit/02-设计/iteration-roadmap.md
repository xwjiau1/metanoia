# HYROS Fit 迭代路线图

**文档版本：** V1.0
**制定日期：** 2026-05-08
**制定人：** wenner（启明科技主脑/CEO助理）
**适用范围：** HYROS Fit 从v1.1 MVP到最终版本的完整迭代规划

---

## 一、版本总览

| 版本 | 代号 | 定位 | 核心目标 | 预计工期 |
|------|------|------|----------|----------|
| **v1.2** | Hotfix | 紧急修复 | 解决真机测试阻塞性问题 | 3-5天 |
| **v2.0** | 增强版 | P1功能补齐 | 补齐PRD所有P1功能 + 基础安全 | 4-6周 |
| **v2.5** | AI版 | P2核心功能 | OCR识别 + 智能建议 + 模型配置 | 4-6周 |
| **v3.0** | 智能版 | AI深度集成 | 对话式计划生成 + 全AI能力 | 4-6周 |
| **v3.5+** | 生态版 | P3扩展 | 社交 + 教练端 + 商业化 | 待定 |

---

## 二、v1.2 Hotfix（紧急修复）

**目标：** 解决嘉文真机测试发现的阻塞性问题，让v1.1真正"开箱即用"
**工期：** 3-5天
**优先级：** 最高（阻塞用户体验）

### FIX-001: 首次登录后无法直接进入App

**问题描述：** 用户首次注册/登录后，界面停留在登录页或空白页，必须退出App重新进入才能看到主界面。

**根因分析：**
- `App.js` 的登录状态监听使用 `AsyncStorage.getItem('userToken')`，首次登录时虽然写入了token，但App根组件的状态未同步刷新
- `navigation.replace` 在已登录分支Stack中调用，路由树中不存在Login Screen的反向导航路径
- 缺乏全局登录状态管理（Context/Zustand），各Screen各自读取AsyncStorage，状态不一致

**修复方案：**

步骤1: 引入全局状态管理
```javascript
// store/authStore.js
import { create } from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';

export const useAuthStore = create((set, get) => ({
  userToken: null,
  isLoading: true,
  
  initialize: async () => {
    const token = await AsyncStorage.getItem('userToken');
    set({ userToken: token, isLoading: false });
  },
  
  login: async (token) => {
    await AsyncStorage.setItem('userToken', token);
    set({ userToken: token });
  },
  
  logout: async () => {
    await AsyncStorage.removeItem('userToken');
    set({ userToken: null });
  }
}));
```

步骤2: 修改App.js根组件
```javascript
// App.js 使用全局状态驱动路由切换
export default function App() {
  const { userToken, isLoading, initialize } = useAuthStore();
  
  useEffect(() => {
    initialize();
  }, []);
  
  if (isLoading) return <LoadingScreen />;
  
  return (
    <NavigationContainer>
      {userToken ? <MainStack /> : <AuthStack />}
    </NavigationContainer>
  );
}
```

步骤3: 所有Screen统一使用 `useAuthStore` 替代直接操作AsyncStorage
- LoginScreen: 登录成功调用 `authStore.login(token)`
- ProfileScreen: 退出调用 `authStore.logout()`
- 删除所有 `AsyncStorage.getItem('userToken')` 的零散调用

**验收标准：**
- [ ] 新用户注册后自动进入首页
- [ ] 已登录用户冷启动App直接进入首页
- [ ] 退出登录后自动回到登录页
- [ ] 整个过程无需手动退出App

---

### FIX-002: 手机顶部状态栏重叠覆盖

**问题描述：** App内容区域与手机系统状态栏（显示时间/电量/WiFi的区域）重叠，文字和按钮被遮挡。

**根因分析：**
- MVP代码未使用 `SafeAreaView` 或 `react-native-safe-area-context`
- 所有Screen的顶部直接贴边渲染，未预留状态栏高度
- 不同手机厂商状态栏高度不同（刘海屏/水滴屏/普通屏）

**修复方案：**

步骤1: 安装safe-area依赖
```bash
npm install react-native-safe-area-context
```

步骤2: 全局SafeAreaProvider包裹
```javascript
// App.js
import { SafeAreaProvider } from 'react-native-safe-area-context';

export default function App() {
  return (
    <SafeAreaProvider>
      <NavigationContainer>
        {/* ... */}
      </NavigationContainer>
    </SafeAreaProvider>
  );
}
```

步骤3: 所有Screen顶部使用SafeAreaView
```javascript
// 每个Screen的render
import { SafeAreaView } from 'react-native-safe-area-context';

return (
  <SafeAreaView style={{ flex: 1, backgroundColor: '#212121' }}>
    {/* Screen内容 */}
  </SafeAreaView>
);
```

步骤4: 导航栏适配
```javascript
// App.js 的 Stack.Navigator 添加header配置
<Stack.Navigator
  screenOptions={{
    headerStyle: { backgroundColor: '#212121' },
    headerTintColor: '#fff',
    contentStyle: { backgroundColor: '#212121' }
  }}
>
```

步骤5: 特殊处理全屏页面（训练打卡页）
- 训练打卡页使用沉浸式体验
- 状态栏文字颜色改为白色（配合深色背景）
- 使用 `expo-status-bar` 控制状态栏样式
```javascript
import { StatusBar } from 'expo-status-bar';
// 在训练页面
<StatusBar style="light" />
```

**验收标准：**
- [ ] 所有页面顶部内容与状态栏不重叠
- [ ] 刘海屏/水滴屏/普通屏均正常显示
- [ ] 状态栏文字颜色在深色背景下清晰可见（白色）
- [ ] 训练打卡页沉浸式体验正常

---

### FIX-003: v1.1已知限制修复（MVP遗留）

**FIX-003A: 密码加密**
- 引入 `bcryptjs` 库
- 注册时对密码做bcrypt哈希（salt rounds: 10）
- 登录时bcrypt.compare验证
- 数据库中的存量明文密码：首次登录时自动迁移为哈希

**FIX-003B: 输入防抖写入**
- 重量/次数输入框引入 `lodash.debounce`（300ms延迟）
- 用户停止输入后才触发数据库写入
- 页面卸载时flush pending writes

**FIX-003C: 数据库事务保护**
- `deletePlan` 使用 `db.withTransactionAsync` 包裹3条DELETE
- `setActivePlan` 使用事务包裹UPDATE+UPDATE
- 失败时自动回滚

**验收标准：**
- [ ] 新注册密码为bcrypt哈希
- [ ] 快速输入重量/次数不卡顿
- [ ] 删除计划时中途失败数据不损坏

---

### FIX-004: UI/UX紧急优化

**FIX-004A: 按钮点击反馈**
- 所有可点击元素添加 `TouchableOpacity` 或 `Pressable`
- activeOpacity: 0.7
- 点击时有0.95缩放的触觉反馈（`react-native-haptic-feedback`）

**FIX-004B: 加载状态**
- 所有异步操作（登录/创建计划/加载数据）显示加载指示器
- 使用 `ActivityIndicator` 统一组件，颜色 `#E53935`
- 禁止操作期间重复点击

**FIX-004C: 错误提示**
- 所有错误用 `Alert` 或自定义Toast提示，不用console.log
- 网络错误提示"网络异常，请检查连接"
- 数据库错误提示"操作失败，请重试"

**验收标准：**
- [ ] 点击按钮有视觉反馈
- [ ] 异步操作有加载指示
- [ ] 所有错误用户可见

---

## 三、v2.0 增强版（P1功能补齐）

**目标：** 补齐PRD中所有P1功能，解决MVP安全/性能问题，UI对标Keep
**工期：** 4-6周
**版本定位：** 从"可用"到"好用"

---

### Feature 1: 密码安全与数据加密（Security）

**FE-1.1: bcrypt密码哈希**
- 依赖：`bcryptjs`
- 注册：`bcrypt.hashSync(password, 10)`
- 登录：`bcrypt.compareSync(inputPassword, storedHash)`
- 存量迁移：登录时检测明文密码，自动重哈希

**FE-1.2: 本地数据库加密**
- 依赖：`expo-sqlite` 后续版本或 `sqlcipher`
- 数据库文件加密，密钥派生自用户密码
- 防止设备被root后数据泄露

**FE-1.3: 生物识别登录**
- 依赖：`expo-local-authentication`
- 支持指纹/面容识别快速登录
- 设置中可开关

---

### Feature 2: 动作库扩展（Exercise Library）

**FE-2.1: 动作数量扩展**
- MVP: 50个 → v2.0: 300个
- 分类体系：胸/背/腿/肩/手臂/腹/有氧/全身
- 每个动作包含：名称、英文、别名、分类、器械、难度、要点

**FE-2.2: 用户自定义动作**
- 用户可添加自己的动作到个人动作库
- 自定义动作包含：名称、分类、器械、备注
- 自定义动作仅自己可见

**FE-2.3: 动作搜索优化**
- 拼音首字母搜索（如"bp"匹配"卧推"）
- 模糊匹配（编辑距离<2）
- 最近使用排序

**FE-2.4: 动作详情页**
- 点击动作查看详情
- 显示：要点说明、常见错误、相关动作
- 示意图占位（P2补充真实图片）

---

### Feature 3: AI文本导入计划（核心差异化）

**FE-3.1: NLP规则引擎**
- 纯前端正则解析，无需联网
- 支持格式：
  ```
  周一 胸+三头
  平板杠铃卧推 4组x8-10次 休息90s
  ```
- 解析维度：日期、训练主题、动作名、组数、次数范围、休息时长

**FE-3.2: 模糊匹配算法**
- 动作名与库中300个动作做模糊匹配
- 置信度>80%直接匹配，50-80%提示用户确认，<50%标记未识别
- 使用编辑距离 + 拼音相似度混合评分

**FE-3.3: 导入预览与编辑**
- 左右分栏：原始文本 vs 解析结果
- 未识别项红色高亮
- 点击可手动修正动作名/组数/次数
- 确认后一键生成训练计划

**FE-3.4: 碳循环识别**
- 识别行首"高碳"/"中碳"/"低碳"标记
- 自动标记训练日为对应碳水日

---

### Feature 4: 超级组支持（Superset）

**FE-4.1: 超级组创建**
- 创建计划时，两个动作间点击"链接"图标标记为超级组
- 视觉显示：动作A → 动作B（超级组）

**FE-4.2: 超级组打卡逻辑**
- 训练界面：超级组展开为A/B两个子卡片
- 完成A→完成B→启动休息计时
- 进度显示："超级组 1/3"

**FE-4.3: 数据库Schema扩展**
- `plan_day_exercises` 表新增 `superset_group_id` 字段
- 同组ID的动作连续执行

---

### Feature 5: 补签功能（Retroactive Check-in）

**FE-5.1: 补签入口**
- 日历点击过去未完成的日期
- 长按日期 → 快捷菜单 → "补签"

**FE-5.2: 补签方式**
- 按原计划执行并记录（进入训练界面回溯）
- 标记为已完成（不记录具体数据）
- 标记为休息日（后续计划顺延1天）
- 跳过（记录原因：伤病/器械被占/时间不够/其他）

**FE-5.3: 顺延逻辑**
- 选择"顺延"后询问"后续所有计划顺延1天？"
- 确认后更新所有未来训练日的日期
- 数据库级联更新

---

### Feature 6: 身体数据追踪（Body Metrics）

**FE-6.1: 记录页面**
- 体重（每日晨起空腹）
- 体脂率（可选）
- 体围：胸围/腰围/臀围/臂围/腿围
- 照片：正面/侧面/背面

**FE-6.2: 数据展示**
- 体重变化曲线（7天/30天/90天/全部）
- BMI自动计算
- 体围变化表
- 照片对比（同日期滑动对比）

**FE-6.3: 数据库扩展**
- `body_metrics` 表已存在，补充照片路径字段
- 照片本地存储在App专属目录

---

### Feature 7: 计划模板库（Template Library）

**FE-7.1: 内置模板（10个）**
| 模板名称 | 分化 | 周期 | 适用人群 |
|----------|------|------|----------|
| HYROS PPL | 6分化 | 8周 | 增肌进阶 |
| 上下肢分化 | 4分化 | 8周 | 增肌中级 |
| 5x5力量基础 | 3分化 | 12周 | 力量新手 |
| 施瓦辛格计划 | 6分化 | 6周 | 高级增肌 |
| HIIT燃脂 | 3分化 | 4周 | 减脂 |
| 全身循环 | 2分化 | 4周 | 减脂新手 |
| 碳循环配合 | 5分化 | 16周 | 增肌减脂 |
| 女性塑形 | 4分化 | 8周 | 女性用户 |
| 居家哑铃 | 3分化 | 4周 | 无健身房 |
| 力量举专项 | 4分化 | 12周 | 力量举 |

**FE-7.2: 模板使用流程**
- 首页 → "从模板创建" → 选择模板 → 预览周视图 → 可编辑后保存

**FE-7.3: 用户分享模板**
- 我的计划 → "分享为模板" → 填写介绍 → 本地保存为模板

---

### Feature 8: 成就系统（Achievements）

**FE-8.1: 徽章类型**
- 连续打卡：7天/30天/100天/365天
- 容量里程碑：单次1万kg/累计100万kg
- PR突破：每个动作首次突破重量
- 计划完成：完成首个4周/8周/12周计划
- 早起训练者：6:00前开始训练

**FE-8.2: 徽章展示**
- 个人资料页展示已解锁徽章
- 新徽章解锁时弹出动画 + 震动提示
- 徽章可分享到社交媒体

**FE-8.3: 数据库扩展**
- 新增 `achievements` 表
- 每次训练完成后检查条件，触发解锁

---

### Feature 9: 通知提醒系统（Notifications）

**FE-9.1: 训练提醒**
- 训练日前一晚21:00推送："明天练胸，记得准备"
- 训练日早起6:00推送："早安！今日训练计划已就绪"
- 用户可自定义提醒时间

**FE-9.2: 组间计时结束**
- 震动 + 声音提醒（可自定义音效）
- 屏幕常亮选项

**FE-9.3: 休息日复盘**
- 周日推送："本周训练回顾"

**FE-9.4: 技术实现**
- 依赖：`expo-notifications`
- 本地通知（无需云端）
- 训练计划数据驱动通知时间

---

### Feature 10: 数据导出与备份（Data Export）

**FE-10.1: 导出格式**
- JSON（完整数据结构，用于备份）
- 文本（人类可读，适合分享）
- CSV（适合Excel分析，P2补充）

**FE-10.2: 导出范围**
- 全部数据
- 单个计划
- 某时间段训练记录

**FE-10.3: 分享方式**
- 保存到本地文件
- 分享到微信/QQ/邮件
- 依赖：`expo-sharing` + `expo-file-system`

---

### Feature 11: UI/UX全面升级（对标Keep）

**FE-11.1: 视觉风格升级**
- 保留深色模式主色调，但引入更丰富的层次
- 卡片设计：圆角16px，微阴影，渐变背景
- 图标：统一使用 `react-native-vector-icons` (Ionicons/MaterialCommunityIcons)
- 动画：页面切换使用React Navigation原生转场 + 自定义淡入淡出

**FE-11.2: 首页重构**
- 参考Keep：大卡片式布局
- 顶部：用户信息 + 连续打卡火焰动画
- 中部：今日训练大卡片（占屏幕40%）
- 下部：快捷入口（日历/统计/动作库/设置）

**FE-11.3: 训练打卡页重构**
- 沉浸式全屏体验
- 动作卡片可展开/收起（手风琴式）
- 组打卡使用大按钮（手指友好）
- 计时器悬浮在底部，不占主内容区

**FE-11.4: 数据统计页重构**
- 引入 `victory-native` 专业图表库
- 容量趋势：平滑曲线图
- 部位分布：环形图（带动画）
- 训练热力图：GitHub风格

**FE-11.5: 字体与排版**
- 数字：等宽字体 `Roboto Mono`
- 中文：系统默认（或引入 `Noto Sans SC`）
- 标题层级：24sp/18sp/16sp/14sp
- 行高：1.5倍

**FE-11.6: 交互细节**
- 列表下拉刷新（`RefreshControl`）
- 上拉加载更多
- 空状态插画（Notion风格简笔画）
- Toast提示（成功/失败/警告）

---

### Feature 12: 性能优化（Performance）

**FE-12.1: 启动优化**
- 目标：冷启动 < 2秒
- 数据库初始化延迟到首屏渲染后
- Splash Screen展示直到数据加载完成

**FE-12.2: 渲染优化**
- 大列表使用 `FlashList` 替代 `FlatList`
- 图表懒加载
- 图片缓存

**FE-12.3: 存储优化**
- 数据库查询加索引
- 批量写入（事务包裹）
- 过期数据清理（3个月前的详细训练记录可归档）

---

## 四、v2.5 AI版（P2核心功能）

**目标：** 引入OCR识别、语音输入、智能建议，建立AI配置系统
**工期：** 4-6周
**版本定位：** 从"好用"到"智能"

---

### Feature 13: AI截图/拍照导入（OCR）

**FE-13.1: 图片选择**
- 相册选择或相机拍照
- 裁剪框：支持手动调整识别区域

**FE-13.2: OCR识别**
- 依赖：`expo-camera` + 云端OCR API 或 Google ML Kit
- 识别图片中的文字 → 转为文本 → 复用文本导入的NLP解析
- 识别进度条 + 可取消

**FE-13.3: 识别结果修正**
- 同文本导入的预览界面
- 图片上高亮已识别区域
- 点击未识别区域手动输入

**FE-13.4: 准确率目标**
- 动作名识别 > 85%
- 组数/次数识别 > 90%
- 整体可用率 > 80%

---

### Feature 14: 语音输入打卡（Voice Input）

**FE-14.1: 语音采集**
- 依赖：`expo-av` (Audio)
- 长按输入框 → 开始录音
- 录音波形动画反馈

**FE-14.2: 语音转文字**
- 依赖：用户配置的AI模型API（见FE-20）
- 支持中文语音指令："卧推八十公斤八次"
- 解析为 weight=80, reps=8

**FE-14.3: 快捷语音指令**
- "完成" → 标记当前组完成
- "下一组" → 跳转下一组
- "休息60秒" → 设置计时器60秒

---

### Feature 15: 智能训练建议（Smart Suggestions）

**FE-15.1: 进度停滞检测**
- 逻辑：某动作连续3次训练重量或次数无进步
- 建议内容：减载方案 + 辅助训练建议 + 技术检查提示

**FE-15.2: 容量过载检测**
- 逻辑：本周容量较上周增长 > 30%
- 建议：增加休息日或降低强度

**FE-15.3: 训练频率优化**
- 逻辑：某部位每周容量占比 < 10%
- 建议：增加该部位训练频率

**FE-15.4: 休息不足提醒**
- 逻辑：连续训练5天无休息
- 建议：安排休息日或低强度恢复

**FE-15.5: 建议展示**
- 训练总结页底部显示智能建议卡片
- 首页显示今日建议（如有）
- 建议可点击"查看详情"或"忽略"

---

### Feature 16: 社交分享（Social Sharing）

**FE-16.1: 训练打卡分享**
- 训练总结页 → "分享"按钮
- 生成分享图片（卡片式，含训练数据）
- 分享到微信/朋友圈/微博/Instagram

**FE-16.2: 成就分享**
- 徽章解锁后生成分享卡片
- 含用户昵称、徽章图标、解锁日期

**FE-16.3: 技术实现**
- 依赖：`react-native-view-shot`（截屏）+ `expo-sharing`
- 分享图片缓存到临时目录

---

### Feature 17: Excel/CSV导出

**FE-17.1: Excel导出**
- 依赖：`xlsx` 库
- 导出训练记录为Excel表格
- 包含：日期、动作、组数、重量、次数、容量

**FE-17.2: CSV导出**
- 纯文本CSV格式
- 可用Excel/Numbers/Google Sheets打开

---

### Feature 18: 训练照片记录

**FE-18.1: 训练后拍照**
- 训练总结页 → "拍照记录"
- 拍照或选择相册
- 关联到本次训练记录

**FE-18.2: 照片管理**
- 我的 → 训练照片
- 按日期浏览
- 删除/分享单张照片

---

## 五、v3.0 智能版（AI深度集成）

**目标：** 对话式AI计划生成 + 全AI能力统一配置
**工期：** 4-6周
**版本定位：** 从"智能"到"AI原生"

---

### Feature 19: AI模型配置系统（核心基础设施）

**FE-19.1: 模型配置页面**
- 设置 → AI模型配置
- 可配置项：
  - API URL（支持OpenAI兼容格式）
  - API Key（加密存储）
  - 模型名称（如 gpt-4o / kimi-k2p6 / deepseek-chat）
  - 温度参数（0-1，默认0.7）
  - 最大token数（默认4096）

**FE-19.2: 配置存储**
- 使用 `AsyncStorage` 存储（密钥加密）
- 默认模型：OpenAI gpt-4o-mini（免费额度）
- 提供预设配置：OpenAI / Kimi / DeepSeek / 通义千问 / 本地Ollama

**FE-19.3: API调用封装**
```javascript
// utils/aiApi.js
export async function callAI({ messages, temperature = 0.7, maxTokens = 4096 }) {
  const config = await getAIConfig(); // 从存储读取
  const response = await fetch(config.url, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${config.key}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: config.model,
      messages,
      temperature,
      max_tokens: maxTokens
    })
  });
  return response.json();
}
```

**FE-19.4: 联网/离线切换**
- 有网络：调用云端AI API
- 无网络：使用本地规则引擎（降级 gracefully）
- 用户可关闭AI功能（纯离线模式）

---

### Feature 20: 对话式AI计划生成（AI Plan Generator）

**FE-20.1: 入口**
- 首页 → "AI生成计划"
- 聊天界面风格（类似ChatGPT）

**FE-20.2: 信息采集对话**
- AI提问，用户选择/输入：
  - "您的训练经验？" → 新手/进阶/高级
  - "每周训练几天？" → 3/4/5/6
  - "主要目标？" → 增肌/减脂/力量/塑形
  - "可用器械？" → 健身房/哑铃/自重
  - "训练时间？" → 早晨/中午/晚上

**FE-20.3: 计划生成**
- AI根据信息生成完整计划
- 输出JSON格式，App解析为训练计划
- 包含：计划名称、周期、分化、每天训练内容

**FE-20.4: 预览与调整**
- 生成后展示周视图预览
- 用户可：调整天数/替换动作/修改组数/直接保存
- "重新生成"按钮

**FE-20.5: Prompt工程**
```
You are HYROS Fit AI, a professional fitness coach.
Generate a structured workout plan based on user info.
Output in JSON format with: name, weeks, split, days[dayOfWeek, focus, exercises[name, sets, reps, rest]].
Consider progressive overload and muscle recovery.
```

---

### Feature 21: 智能计划调整（AI Plan Adjustment）

**FE-21.1: 基于训练数据自动调整**
- 分析用户4周训练数据
- AI建议："检测到卧推停滞3周，建议减载周"
- 用户确认后自动调整计划

**FE-21.2: 周期化自动管理**
- 增肌期 → 减脂期 → 力量期自动过渡建议
- 自动计算减载周时机

---

### Feature 22: 视频动作指导（Video Coaching）

**FE-22.1: 动作视频库**
- 为每个动作提供教学视频
- 视频托管：云端CDN（或YouTube嵌入）
- 本地缓存最近观看的10个视频

**FE-22.2: AI姿势分析（P3延伸）**
- 用户录制训练视频
- AI分析动作质量（深度/速度/对称性）
- 给出改进建议

---

## 六、v3.5+ 生态版（P3扩展）

**目标：** 社交生态 + 商业化
**工期：** 待定（根据用户增长情况启动）

---

### Feature 23: 教练端（Coach Portal）

**FE-23.1: 教练账号类型**
- 注册时选择"我是教练"
- 教练可为客户制定计划

**FE-23.2: 客户管理**
- 邀请客户（二维码/链接）
- 查看客户训练数据
- 远程调整客户计划

**FE-23.3: 计划分发**
- 教练创建计划 → 分享给客户 → 客户一键导入执行

---

### Feature 24: 社区/圈子（Community）

**FE-24.1: 训练打卡动态**
- 类似朋友圈的训练动态流
- 显示：用户头像、训练摘要、容量、照片

**FE-24.2: 圈子**
- 按主题创建圈子（"力量举爱好者"/"减脂打卡群"）
- 圈子内排行榜（周容量/连续打卡）

**FE-24.3: 互动**
- 点赞、评论、鼓励

---

### Feature 25: 商城/商业化（Monetization）

**FE-25.1: 高级会员**
- AI计划生成（免费用户限3次/月）
- 高级模板库
- 云端同步（免费用户仅本地）
- 数据导出Excel
- 去除广告

**FE-25.2: 补剂/装备推荐**
- 基于训练数据推荐补剂
-  affiliate 链接跳转购买

**FE-25.3: 广告位**
- 免费用户：启动页/训练总结页展示健身相关广告

---

## 七、技术债与架构演进

### Tech-1: 后端服务搭建（v2.5启动）

**当前：** 纯本地SQLite，无后端
**演进路线：**
- v2.0: 本地为主，JSON导出备份
- v2.5: 可选自建后端（Supabase/Firebase）做云端同步
- v3.0: 用户可选择：纯离线 / 云端同步 / 混合模式

**后端功能：**
- 用户认证（JWT）
- 训练数据云存储
- AI API代理（保护用户Key，服务端调用）
- 计划模板市场
- 社交数据

### Tech-2: 跨平台统一（v2.0）

**当前：** 仅Android
**目标：** iOS同步上线
**工作：**
- SQLite兼容性测试
- 通知系统iOS适配
- App Store审核准备
- 图标/启动屏iOS规范

### Tech-3: 代码质量持续优化

**v2.0:**
- TypeScript迁移（类型安全）
- 单元测试覆盖核心逻辑
- ESLint + Prettier规范

**v2.5:**
- 模块化重构（Feature-based架构）
- 性能监控（Sentry集成）

**v3.0:**
- 微前端架构（独立模块可热更新）

---

## 八、迭代执行 checklist

### v1.2 Hotfix 执行清单

- [ ] FIX-001: Zustand全局状态管理替换零散AsyncStorage
- [ ] FIX-002: SafeAreaView全页面适配
- [ ] FIX-003A: bcrypt密码哈希
- [ ] FIX-003B: 输入防抖（debounce）
- [ ] FIX-003C: 数据库事务保护
- [ ] FIX-004: UI点击反馈 + 加载状态 + 错误提示
- [ ] EAS重新构建APK
- [ ] 真机测试验证（登录/状态栏/密码/输入/删除）
- [ ] 更新版本号到v1.2
- [ ] GitHub推送新版本代码

### v2.0 增强版 执行清单

- [ ] FE-1: 密码安全（bcrypt + SQLCipher + 生物识别）
- [ ] FE-2: 动作库扩展（50→300 + 自定义 + 搜索优化）
- [ ] FE-3: AI文本导入（NLP规则引擎 + 模糊匹配 + 预览编辑）
- [ ] FE-4: 超级组支持（创建 + 打卡逻辑 + 数据库扩展）
- [ ] FE-5: 补签功能（4种补签方式 + 顺延逻辑）
- [ ] FE-6: 身体数据追踪（记录 + 展示 + 照片）
- [ ] FE-7: 计划模板库（10个内置模板 + 用户分享）
- [ ] FE-8: 成就系统（徽章类型 + 解锁检测 + 展示）
- [ ] FE-9: 通知提醒（训练提醒 + 计时器 + 复盘）
- [ ] FE-10: 数据导出（JSON + 文本 + 分享）
- [ ] FE-11: UI全面升级（对标Keep风格）
- [ ] FE-12: 性能优化（启动 < 2s + 渲染优化）
- [ ] EAS构建v2.0 APK
- [ ] 完整回归测试（50+用例）
- [ ] GitHub推送 + Tag v2.0

### v2.5 AI版 执行清单

- [ ] FE-13: OCR截图导入（图片选择 + 识别 + 修正）
- [ ] FE-14: 语音输入（录音 + 语音转文字 + 快捷指令）
- [ ] FE-15: 智能建议（停滞/过载/频率/休息检测）
- [ ] FE-16: 社交分享（卡片生成 + 多平台分享）
- [ ] FE-17: Excel/CSV导出
- [ ] FE-18: 训练照片记录
- [ ] FE-19: AI模型配置系统（URL/Key/模型选择）
- [ ] EAS构建v2.5 APK
- [ ] GitHub推送 + Tag v2.5

### v3.0 智能版 执行清单

- [ ] FE-20: 对话式AI计划生成
- [ ] FE-21: 智能计划调整
- [ ] FE-22: 视频动作指导
- [ ] 后端服务搭建（可选）
- [ ] EAS构建v3.0 APK
- [ ] GitHub推送 + Tag v3.0

---

## 九、版本交付物标准

每个版本发布时必须包含：

1. **APK构建产物**（EAS Cloud）
2. **完整源代码**（GitHub Tag）
3. **CHANGELOG.md**（版本变更日志）
4. **测试报告**（测试用例 + 执行结果）
5. **用户手册更新**（新功能说明）
6. **数据库迁移脚本**（如Schema变更）

---

## 十、决策点

| 决策项 | 当前状态 | 需要嘉文决策 |
|--------|----------|-------------|
| v1.2 Hotfix立即执行？ | 建议立即 | 等你确认 |
| v2.0优先级最高的3个功能？ | 建议：AI导入 + 模板库 + UI升级 | 可调整 |
| AI模型配置默认提供商？ | 建议：OpenAI（gpt-4o-mini免费额度） | 可选 |
| 后端服务自建还是BaaS？ | 建议：Supabase（免费额度够用） | 待定 |
| iOS版本优先级？ | 建议：v2.5后启动 | 可调整 |
| 商业化模式？ | 建议：免费+高级订阅 | 待定 |

---

*文档生成：2026-05-08*
*维护人：wenner*
*下次评审：v1.2完成后或嘉文确认v2.0优先级后*
