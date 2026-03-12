<!-- 此文件将由 CI/CD 自动更新 -->

# 🧮 iOS Calculator - 高级智能计算器

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org/) [![Platform](https://img.shields.io/badge/platform-iOS%2016.0%2B-blue.svg)](https://developer.apple.com/ios/) [![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

> 一款支持**语音交互**的离线计算器，为双手不便、视障人士提供解放双手的体验。目前最新版本：**v2.7 (Swift 6 兼容)**

---

## 📱 功能特性

### ✅ v2.7 已完成功能

| 模块 | 功能描述 |
|------|---------|
| **🔊 语音交互** | 支持中英文切换，语音反馈每次按键操作 |
| **🎤 语音输入** | 直接说"五加三"自动执行运算 |
| **🧮 科学计算** | sin/cos/tan/log/sqrt/power等函数 |
| **📐 方程求解器** | 线性方程 + 二次方程求解 |
| **💾 交易历史** | 滑动面板显示完整操作记录，支持批量删除 |
| **🔢 记忆功能** | M+, M-, MR, MC 标准计算器记忆操作 |
| **📳 触觉反馈** | 每次操作提供震动确认 |

### 🚧 v3.0+ 规划中

- [ ] AI 复杂方程大模型求解接入
- [ ] iCloud 历史记录多端同步
- [ ] 商业化功能（内购解锁高级特性）

---

## 🏗️ 项目架构

采用严格的 **MVVM 架构**，保证代码可维护性和可测试性：

```
ios-calculator/
├── Sources/
│   ├── Core/              # 核心业务逻辑层
│   │   ├── CalculatorEngine.swift    # 高精度运算引擎（Decimal）
│   │   ├── EquationSolver.swift      # 方程求解算法
│   │   ├── VoiceManager.swift        # 语音合成 (TTS) + 识别 (STT)
│   │   └── HapticManager.swift       # 触觉反馈管理
│   ├── Models/            # 数据模型层
│   │   ├── TransactionHistory.swift  # 历史记录持久化
│   │   └── ...
│   ├── ViewModels/        # 视图模型层（业务状态）
│   │   ├── CalculatorViewModel.swift
│   │   ├── EquationSolverViewModel.swift
│   │   └── CalculatorSolverBridgeViewModel.swift  # v2.4 桥接模块
│   └── Views/             # UI 展示层
│       ├── CalculatorView.swift
│       ├── HistoryPanelView.swift
│       ├── VoiceInputButton.swift    # v2.3
│       └── ...
├── docs/                  # 文档目录
│   ├── CHANGELOG.md       # 版本历史（中文化进行中）
│   ├── CODE_REVIEW_v*.md  # Code Review 记录
│   └── RESTRUCTURE_PLAN.md # 重构计划
└── Package.swift          # Swift Package Manager 配置
```

---

## 🚀 快速开始

### 在 Xcode 中打开

```bash
cd /home/huibin/.openclaw/workspace/ios-calculator
code .  # VS Code
# 或直接在 Xcode 中打开 Package.swift
```

### 运行项目

1. 在 Xcode 中选择 `CalculatorApp` scheme
2. 选择目标设备（模拟器或真机）
3. 按 `Cmd + R` 运行

---

## 📊 版本历史

| 版本 | 日期 | 核心特性 |
|------|------|---------|
| **v2.7** | 2026-03-12 | Swift 6 全面适配，严谨的并发检查，新增大批单元测试。 |
| **v2.6** | 2026-03-12 | 语音输入运算优先级修复，VoiceOver 辅助无障碍体验提升。 |
| **v2.5** | 2026-03-11 | 方程求解器语音反馈 |
| **v2.4** | 2026-03-11 | 计算器 ↔ 方程求解器桥接 |
| **v2.3** | 2026-03-11 | 语音输入按钮（麦克风） |
| **v2.2** | 2026-03-11 | 交易历史记录面板 |
| **v2.1** | 2026-03-11 | 记忆功能 (M+, M-, MR, MC) |
| **v2.0** | 2026-03-11 | 语音反馈开关 + 中英文切换 |
| **v1.3** | 2026-03-11 | 科学计算器模式 |
| **v1.0** | 2026-03-11 | 基础四则运算 |

---

## 🎯 核心设计理念

### 1️⃣ 无障碍优先 (Accessibility First)

> "这不是一个计算器，而是一个 AI 数学助手"

- **视障人士**: 完全通过语音操作，无需触碰屏幕
- **双手不便**: 厨房、车间场景解放双手
- **教育场景**: 学生用自然语言表达数学问题

### 2️⃣ 离线优先 (Offline First)

所有功能在本地运行，无需网络连接：
- ✅ 语音识别使用系统原生 Speech Framework（离线）
- ✅ 方程求解算法完全本地化
- ❌ 不涉及任何第三方 API 调用

### 3️⃣ 高精度运算 (Financial Grade Precision)

使用 `Decimal` 类型替代 `Double`，保证商业级精度：
```swift
// Double:  0.1 + 0.2 = 0.30000000000000004 ❌
// Decimal: 0.1 + 0.2 = 0.3 ✅
```

---

## 💰 商业化规划 (v2.6+)

### 免费层级（当前全部功能）
- 基础计算器
- 语音反馈
- 交易历史（最近 10 条，滚动覆盖）

### $0.99 内购解锁（计划中）
- ✅ 科学计算器模式
- ✅ 方程求解器
- ✅ 无限历史记录
- ✅ 记忆功能 + 触觉反馈
- ✅ 无广告体验

### v3.0 订阅制（云端 AI）
- $2.99/月：AI 自然语言方程解析
- iCloud 多设备同步

---

## 📝 Code Review 摘要

**最新审查日期:** 2026-03-11  
**整体评级:** A-（优秀，有改进空间）

### ✅ 优势
- MVVM 架构清晰，分层合理
- 语音输入智能解析数字和运算符
- Bridge ViewModel 为未来双向通信预留接口

### 🔧 待改进
- 语音输入错误处理缺失（TODO v2.6）
- Bridge 导航逻辑未连接实际 TabView
- CalculatorViewModel 可考虑拆分语音模块

---

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！当前主要开发方向：

1. **AI 方程求解器** (v3.0) - 自然语言解析
2. **Cloud Sync** (v3.1) - iCloud 历史记录同步
3. **教育模式** (v3.2) - 详细计算步骤展示

---

## 📄 License

MIT License - 详见 [LICENSE](LICENSE)

---

<div align="center">

**🔥 持续迭代中 | Next Release: v2.6 (Voice Input Error Handling + AdMob Integration)**

[GitHub](https://github.com/huibin1984/ios-calculator) • [Issues](https://github.com/huibin1984/ios-calculator/issues)

</div>
