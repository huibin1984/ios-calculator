# 📝 版本历史

所有对本项目的重大更改都将记录在此文件中。

---

## [v3.4] - 2026-03-11 ✨ (当前版本)

### ✨ 语音置信度系统 (v3.4)

**VoiceRecognitionManager.swift**
- 置信度评分系统（0-100%）
- 高置信度（>=80%）：直接执行
- 中置信度（50-80%）：显示确认对话框
- 低置信度（<50%）：提示重试
- ConfidenceIndicator 组件

### ✨ 新手引导系统 (v3.4)

**OnboardingManager.swift**
- 6 步引导流程
- Welcome → Basic Mode → Voice → Scientific → Equation → Complete
- OnboardingOverlay 带进度指示器
- CoachMarkView 元素高亮提示
- UserDefaults 状态持久化

### ✨ 主题系统 (v3.4)

**ThemeManager.swift**
- 4 种预设主题：经典深色、简约浅色、护眼暗色、自定义
- ThemePreviewCard 主题预览卡片
- ThemeSettingsView 主题设置界面
- 跟随系统主题选项

### ✨ 设置集成 (v3.4)

- 计算器顶栏添加齿轮图标
- 设置页面 Sheet 展示
- 主题设置、通用设置、用户反馈入口

---

## [v3.3] - 2026-03-11 ✨

### ✨ 用户体验核心组件 (v3.3)

**增强型按钮 (EnhancedButtons.swift)**
- 数字按钮按下缩放动画 (scale 0.92)
- 运算符按钮颜色变化 + 缩放动画
- 等号按钮脉冲光环效果
- 记忆按钮激活状态显示
- 统一的手势反馈系统

**增强型 UI 组件 (EnhancedComponents.swift)**
- EnhancedDisplayView: 显示值变化过渡动画
- ToastView/ToastManager: Toast 提示系统
- LoadingIndicator: 加载状态指示器
- ConfirmationDialog: 确认对话框组件

**用户设置界面 (SettingsView.swift)**
- 语音设置: 开关、语言、语速滑块
- 触觉设置: 开关
- 显示设置: 深色模式切换
- 历史记录设置: 数量限制
- 用户反馈入口

### 🎯 GitHub Issues 优化

- ✅ 已关闭 21 个旧 Issues
- ✅ 创建新 Issues:
  - #22: 用户体验全面优化
  - #23: 视觉美化与主题支持
  - #24: 性能优化与稳定性提升
  - #25: v3.4 Voice Confidence + Onboarding
  - #26: v3.4 Voice Queue Management
  - #27: v3.4 Theme System

### 📄 文档更新

- USER_EXPERIENCE_ANALYSIS.md: 用户体验深度洞察报告
  - 用户旅程分析
  - 痛点深度分析
  - 竞品对比分析
  - v3.4 开发清单

---

## [v3.3] - 2026-03-11 ✨

### ✨ 新增

**用户体验核心组件 (v3.3)**
- EnhancedButtons.swift 增强型按钮组件
  - 数字按钮按下缩放动画 (scale 0.92)
  - 运算符按钮颜色变化 + 缩放动画
  - 等号按钮脉冲光环效果
  - 统一的手势反馈系统
  
- EnhancedComponents.swift 增强型 UI 组件
  - EnhancedDisplayView: 显示值变化过渡动画
  - ToastView/ToastManager: Toast 提示系统
  - LoadingIndicator: 加载状态指示器
  - ConfirmationDialog: 确认对话框组件
  
- SettingsView.swift 用户设置界面
  - 语音设置: 开关、语言、语速滑块
  - 触觉设置: 开关
  - 显示设置: 深色模式切换
  - 历史记录设置: 数量限制
  - FeedbackView: 用户反馈入口

### 🎯 GitHub Issues 优化

- 已关闭 21 个旧 Issues
- 新增 #22: 用户体验全面优化
- 新增 #23: 视觉美化与主题支持  
- 新增 #24: 性能优化与稳定性提升

---

## [v3.2] - 2026-03-11 📚

### ✨ 新增

**教育模式 (v3.2)**
- 详细解题步骤展示
- 线性方程：识别 → 移项 → 求解 → 验证（四步法）
- 二次方程：判别式分析 + 求根公式
- 算术表达式步骤解析
- EducationalSolutionView SwiftUI 组件
- 学习提示（Tips）功能

---

## [v3.1] - 2026-03-11 ☁️

### ✨ 新增

**云同步架构 (v3.1)**
- CloudSyncManager.swift 云同步管理器
- 免费层：iCloud Keychain（50 条记录限制）
- 高级层：CloudKit 架构设计（无限记录）
- 冲突解决策略
- SyncStatusView SwiftUI 组件
- 实时同步状态显示

---

## [v3.0] - 2026-03-11 🤖

### ✨ 新增

**AI 方程求解器 (v3.0)**
- AIEquationSolver.swift 本地规则引擎 + AI 架构
- LocalEquationParser 免费版：标准格式方程解析
  - 支持：2x + 5 = 17, 3x - 2 = 10
- LLMEquationClient：云端 LLM API 集成架构设计
- 支持线性方程和二次方程
- 付费版 AI 模式预留接口

---

## [v2.7] - 2026-03-11 🎨

### ✨ 新增

**语音输入动画反馈 (v2.7)**
- 麦克风按钮脉冲动画（v2.7 新增）
- 红色背景指示"正在听..."
- 显示"正在听..."文字提示
- 与 isListeningToVoice 状态绑定

**表达式优先级解析 (v2.7)**
- 使用 Shunting Yard 算法实现中缀表达式转后缀表达式
- 正确运算优先级：乘除 > 加减
- 中文数字支持："五加三乘二" = 11（不再是 16）
- 解析失败时回退到逐个输入模式

---

## [v2.6] - 2026-03-11 🔧

### ✨ 新增

**语音输入错误处理 (v2.6)**
- 识别失败时显示视觉提示
- 语音播报："未识别到数字，请重试"
- 触觉反馈：Error 震动

**桥接导航集成 (v2.6)**
- DisplayView "发送到方程求解器" 按钮现在会切换 Tab
- activeTab 状态管理
- 自动跳转到方程求解器页面

**内购基础架构 (v2.6)**
- 新建 PurchaseManager.swift
- Product Identifiers 定义
- purchase() / restorePurchases() 基础流程
- UserDefaults 持久化

---

## [v2.5] - 2026-03-11 🔊

### ✨ 新增

**方程求解器语音反馈 (v2.5)**
- 方程求解完成后自动语音播报结果
- 支持成功和错误消息的语音提示
- 使用现有的 VoiceManager 基础设施
- 示例："方程求解完成：x 等于二"

---

## [v2.4] - 2026-03-11 ↔️

### ✨ 新增

**计算器 ↔ 方程求解器桥接 (v2.4)**
- DisplayView 中新增"发送到方程求解器"按钮
- 一键将计算器结果传递到方程求解器
- 新建 `CalculatorSolverBridgeViewModel` 管理跨模块数据流
- 成功传输时提供触觉反馈
- 为未来双向通信预留架构接口

---

## [v2.3] - 2026-03-11 🎤

### ✨ 新增

**语音输入按钮 (v2.3)**
- 顶部栏新增麦克风按钮（紧接语音开关右侧）
- 激活语音转文字进行数字输入
- 智能解析：自动识别数字和运算符
- 自然语言支持：
  - 数字："一", "二", "三"... 或 "1", "2", "3"...
  - 运算符："加" (+), "减" (-), "乘" (×), "除" (÷)
- 分词后按顺序执行操作
- 激活时提供触觉反馈

---

## [v2.2] - 2026-03-11 📜

### ✨ 新增

**交易历史记录面板**
- 完整操作历史，带时间戳
- 左滑删除单条记录
- "清空全部"批量删除功能
- 使用 UserDefaults 持久化存储
- 动画滑动面板（宽度为屏幕的 50%）

---

## [v2.1] - 2026-03-11 🧮

### ✨ 新增

**记忆功能 (M+, M-, MR, MC)**
- `M+`: 将当前值加到记忆中
- `M-`: 从记忆中减去
- `MR`: 读取存储的值
- `MC`: 清空记忆
- 记忆激活时显示屏显示 "M" 指示器

---

## [v2.0] - 2026-03-11 🔊

### ✨ 新增

**语音反馈开关 (v2.0)**
- 语音反馈的打开/关闭切换按钮
- 语言选择器：英文 / 中文
- 带声音图标的视觉指示器
- 全局尊重用户偏好设置

---

## [v1.3] - 2026-03-11 📐

### ✨ 新增

**科学计算器模式**
- 高级函数：sin, cos, tan, log, sqrt, pow
- 基础模式和科学模式之间切换
- 按钮动画过渡效果

---

## [v1.0] - 2026-03-11 🎉

### ✨ 初次发布

- 基础四则运算 (+, -, ×, ÷)
- 小数点支持
- 清除 (C) 和删除 (⌫) 按钮
- "=" 结果计算
- MVVM 架构基础建设
