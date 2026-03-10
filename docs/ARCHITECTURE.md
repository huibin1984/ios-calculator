# 架构设计文档

## 1. 整体架构

采用 **MVVM (Model-View-ViewModel)** 架构模式，确保关注点分离和可维护性。

```
┌─────────────┐
│   View      │ ← SwiftUI UI Components
├─────────────┤
│ ViewModel   │ ← Business Logic & State Management
├─────────────┤
│    Model    │ ← Data Structures & Calculator Engine
└─────────────┘
```

## 2. 模块划分

### 2.1 View Layer (视图层)
- `CalculatorView.swift` - 主界面容器
- `DisplayView.swift` - 显示屏组件
- `ButtonGrid.swift` - 按钮网格布局
- `VoiceToggle.swift` - 语音开关控件

### 2.2 ViewModel Layer (视图模型层)
- `CalculatorViewModel.swift` - 核心业务逻辑
- `VoiceManager.swift` - 语音反馈管理
- `HistoryManager.swift` - 计算历史管理（可选扩展）

### 2.3 Model Layer (数据层)
- `CalculatorEngine.swift` - 科学计算引擎
- `ExpressionParser.swift` - 表达式解析器
- `MathOperation.swift` - 数学运算定义

## 3. 核心类职责

| 类名 | 职责 |
|------|------|
| CalculatorViewModel | 协调 UI 状态、处理用户输入、触发语音反馈 |
| CalculatorEngine | 执行实际计算，支持表达式求值 |
| VoiceManager | 封装 AVSpeechSynthesizer，管理语音合成 |
| ExpressionParser | 将字符串表达式转换为可计算的 AST |

## 4. 数据流

```
User Input → View → ViewModel → Model (Calculation) → Result → ViewModel → View
                              ↓
                        VoiceManager (TTS Output)
```

## 5. 技术选型理由

- **SwiftUI**: 声明式 UI，易于实现大按钮和高对比度主题
- **Combine**: 响应式状态管理，适合计算器这种频繁更新的应用
- **AVSpeechSynthesizer**: 系统级 TTS，无需额外依赖，离线可用

## 6. 扩展性考虑

- 语音模块独立，可轻松添加多语言支持
- 计算引擎基于表达式解析，易于添加新函数
- MVVM 架构便于单元测试和 CI/CD 集成
