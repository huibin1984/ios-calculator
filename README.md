# iOS Calculator - 高级科学计算器

一个为商务人士设计的增强型 iOS 计算器应用，具备语音反馈和强大的科学计算功能。

## 🎯 核心特性

### 基础功能
- [ ] 标准四则运算（加减乘除）
- [ ] 百分比计算
- [ ] 正负号切换
- [ ] 清除/全部清除 (C / AC)
- [ ] 记忆功能 (M+ / M- / MR / MC)

### 科学计算
- [ ] 三角函数（sin/cos/tan）
- [ ] 对数运算（log/ln）
- [ ] 幂运算和开方
- [ ] 括号优先级支持
- [ ] π 和 e 常数

### 语音反馈（商务模式）
- [ ] 按键时朗读数字和操作符
- [ ] 可切换的语音开关
- [ ] 支持中文/英文双语
- [ ] 音量自适应环境

### 用户体验
- [ ] 大按钮设计，易于误触
- [ ] 高对比度显示
- [ ] 单手操作优化
- [ ] 离线运行（无需联网）
- [ ] **精确小数计算** (Decimal/BigDecimal)

## 📱 技术架构

- **语言**: Swift 5.9+
- **最低支持**: iOS 16.0+
- **架构模式**: MVVM
- **语音引擎**: AVSpeechSynthesizer (系统 TTS)

## 🚀 快速开始

```bash
# 克隆项目
git clone https://github.com/huibin1984/ios-calculator.git

# 查看依赖
cat Package.swift  # 或 Podfile

# 构建运行
xcodebuild -scheme Calculator -sdk iphonesimulator -configuration Debug build
```

## 📋 开发规范

- 遵循 Swift API Design Guidelines
- 使用 Combine 进行响应式编程
- 所有计算结果保留最多 10 位小数
- 语音反馈延迟 < 100ms

---

**项目状态**: 🟢 进行中  
**创建日期**: 2026-03-11
