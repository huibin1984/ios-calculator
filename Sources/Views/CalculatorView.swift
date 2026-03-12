import SwiftUI

/// 计算器主界面 - MVVM 架构的 View 层 (v3.4 + Settings + Onboarding)
struct CalculatorView: View {
    
    @StateObject private var viewModel: CalculatorViewModel
    @StateObject private var bridgeViewModel: CalculatorSolverBridgeViewModel // v2.4
    @StateObject private var onboardingManager = OnboardingManager.shared // v3.4
    @State private var showHistoryPanel = false
    @State private var showSettings = false // v3.4
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // 顶部控制栏：模式切换 + 语音开关 + 历史按钮
                HStack {
                    ModeToggleView(isScientificMode: viewModel.isScientificMode, 
                                  toggleAction: viewModel.toggleMode)
                    
                    Button(action: { showHistoryPanel = true }) {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                        Text("历史")
                            .font(.caption2)
                    }
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    // 语音输入按钮 (v2.3 + v2.7 动画)
                    Button(action: { 
                        viewModel.handleVoiceInput()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: viewModel.isListeningToVoice ? "mic.fill" : "mic.fill")
                                .font(.caption)
                                .scaleEffect(viewModel.isListeningToVoice ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: viewModel.isListeningToVoice)
                            
                            Text(viewModel.isListeningToVoice ? "正在听..." : "语音")
                                .font(.caption2)
                        }
                    }
                    .accessibilityLabel(viewModel.isListeningToVoice ? "语音输入中" : "开始语音输入")
                    .foregroundColor(viewModel.isListeningToVoice ? .red : .white)
                    .padding(8)
                    .background(viewModel.isListeningToVoice ? Color.red.opacity(0.3) : Color.blue.opacity(0.7))
                    .cornerRadius(10)
                    
                    VoiceToggleView(viewModel: viewModel)
                    
                    // 设置按钮 (v3.4)
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.caption)
                    }
                    .accessibilityLabel("设置")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
                }
                
                // 显示屏
                DisplayView(
                    displayValue: viewModel.displayValue,
                    hasMemory: viewModel.hasMemory,
                    onSendToEquation: {
                        bridgeViewModel.sendToEquationSolver(calculatorResult: viewModel.displayValue)
                    }
                )
                
                Spacer()
                
                // 按钮区域 (根据模式显示不同内容)
                if viewModel.isScientificMode {
                    ScientificButtonGridView(viewModel: viewModel)
                } else {
                    BasicButtonGridView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            
            // 历史记录面板 (上滑显示)
            if showHistoryPanel {
                HistoryPanelView(viewModel: viewModel, isPresented: $showHistoryPanel)
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationView {
                List {
                    // 主题设置
                    Section {
                        NavigationLink(destination: ThemeSettingsView()) {
                            Label("主题", systemImage: "paintbrush.fill")
                        }
                        
                        NavigationLink(destination: SettingsView()) {
                            Label("通用设置", systemImage: "gear")
                        }
                    } header: {
                        Text("外观")
                    }
                    
                    // 反馈
                    Section {
                        NavigationLink(destination: FeedbackView()) {
                            Label("用户反馈", systemImage: "envelope.fill")
                        }
                    }
                }
                .navigationTitle("设置")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            // 检查是否需要显示新手引导 (v3.4)
            if onboardingManager.shouldShowOnboarding() {
                // 显示引导（需要配合 UIKit present）
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        _viewModel = StateObject(wrappedValue: CalculatorViewModel())
        _bridgeViewModel = StateObject(wrappedValue: CalculatorSolverBridgeViewModel())
    }
}

// MARK: - Display View (v2.6 + Bridge Navigation)

struct DisplayView: View {
    let displayValue: String
    let hasMemory: Bool
    let onSendToEquation: () -> Void  // v2.6: 回调函数用于导航
    
    var body: some View {
        EnhancedDisplayView(displayValue: displayValue, hasMemory: hasMemory, onSendToEquation: onSendToEquation)
    }
}

// MARK: - Mode Toggle View

struct ModeToggleView: View {
    let isScientificMode: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        Button(action: toggleAction) {
            HStack(spacing: 4) {
                Image(systemName: isScientificMode ? "flame.fill" : "1.2")
                    .font(.caption)
                Text(isScientificMode ? "科学版" : "商用版")
                    .font(.caption2)
            }
            .foregroundColor(isScientificMode ? .orange : .white)
            .padding(8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
        }
    }
}

// MARK: - Basic Button Grid (普通商用版) - v3.3 增强版

struct BasicButtonGridView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // 记忆功能行
            HStack(spacing: 12) {
                EnhancedMemoryButton(title: "MC", action: viewModel.memoryClear, isActive: false)
                EnhancedMemoryButton(title: "MR", action: viewModel.memoryRecall, isActive: viewModel.hasMemory)
                EnhancedMemoryButton(title: "MS", action: viewModel.memoryStore)
                EnhancedMemoryButton(title: "M+", action: viewModel.memoryAdd)
            }
            
            // 清除 + 正负 + 除 + 乘
            HStack(spacing: 12) {
                EnhancedFunctionButton(title: "AC", action: viewModel.allClear)
                EnhancedFunctionButton(title: "+/-", action: viewModel.toggleSign)
                EnhancedFunctionButton(title: "%", action: viewModel.percent)
                EnhancedOperatorButton(title: "÷", action: viewModel.divide)
            }
            
            // 7, 8, 9, +
            HStack(spacing: 12) {
                EnhancedNumberButton(title: "7", action: { viewModel.inputDigit(7) })
                EnhancedNumberButton(title: "8", action: { viewModel.inputDigit(8) })
                EnhancedNumberButton(title: "9", action: { viewModel.inputDigit(9) })
                EnhancedOperatorButton(title: "+", action: viewModel.add)
            }
            
            // 4, 5, 6, -
            HStack(spacing: 12) {
                EnhancedNumberButton(title: "4", action: { viewModel.inputDigit(4) })
                EnhancedNumberButton(title: "5", action: { viewModel.inputDigit(5) })
                EnhancedNumberButton(title: "6", action: { viewModel.inputDigit(6) })
                EnhancedOperatorButton(title: "-", action: viewModel.subtract)
            }
            
            // 1, 2, 3, ×
            HStack(spacing: 12) {
                EnhancedNumberButton(title: "1", action: { viewModel.inputDigit(1) })
                EnhancedNumberButton(title: "2", action: { viewModel.inputDigit(2) })
                EnhancedNumberButton(title: "3", action: { viewModel.inputDigit(3) })
                EnhancedOperatorButton(title: "×", action: viewModel.multiply)
            }
            
            // 0, ., =
            HStack(spacing: 12) {
                EnhancedNumberButton(title: "0", action: { viewModel.inputDigit(0) })
                    .frame(maxWidth: .infinity)
                
                EnhancedFunctionButton(title: ".", action: viewModel.inputDecimalPoint)
                EnhancedEqualsButton(action: viewModel.equals)
            }
        }
        .padding()
    }
}

// MARK: - Scientific Button Grid (科学版) - v3.3 增强版

struct ScientificButtonGridView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // 记忆功能行
            HStack(spacing: 12) {
                EnhancedMemoryButton(title: "MC", action: viewModel.memoryClear)
                EnhancedMemoryButton(title: "MR", action: viewModel.memoryRecall, isActive: viewModel.hasMemory)
                EnhancedMemoryButton(title: "MS", action: viewModel.memoryStore)
                EnhancedMemoryButton(title: "M+", action: viewModel.memoryAdd)
            }
            
            // 科学函数行 1
            HStack(spacing: 12) {
                EnhancedScientificButton(title: "sin", action: viewModel.sine)
                EnhancedScientificButton(title: "cos", action: viewModel.cosine)
                EnhancedScientificButton(title: "tan", action: viewModel.tangent)
                EnhancedScientificButton(title: "log", action: viewModel.logarithm)
            }
            
            // 科学函数行 2
            HStack(spacing: 12) {
                EnhancedScientificButton(title: "ln", action: viewModel.naturalLogarithm)
                EnhancedScientificButton(title: "x²", action: viewModel.square)
                EnhancedScientificButton(title: "√", action: viewModel.squareRoot)
                EnhancedConstantButton(title: "π", action: viewModel.setPi)
            }
            
            // 清除 + 正负 + 除 + 乘
            HStack(spacing: 12) {
                EnhancedFunctionButton(title: "AC", action: viewModel.allClear)
                EnhancedFunctionButton(title: "+/-", action: viewModel.toggleSign)
                EnhancedFunctionButton(title: "%", action: viewModel.percent)
                EnhancedOperatorButton(title: "÷", action: viewModel.divide)
            }
            
            // 7, 8, 9, +
            HStack(spacing: 12) {
                EnhancedNumberButton(title: "7", action: { viewModel.inputDigit(7) })
                EnhancedNumberButton(title: "8", action: { viewModel.inputDigit(8) })
                EnhancedNumberButton(title: "9", action: { viewModel.inputDigit(9) })
                EnhancedOperatorButton(title: "+", action: viewModel.add)
            }
            
            // 4, 5, 6, -
            HStack(spacing: 12) {
                EnhancedNumberButton(title: "4", action: { viewModel.inputDigit(4) })
                EnhancedNumberButton(title: "5", action: { viewModel.inputDigit(5) })
                EnhancedNumberButton(title: "6", action: { viewModel.inputDigit(6) })
                EnhancedOperatorButton(title: "-", action: viewModel.subtract)
            }
            
            // 1, 2, 3, ×
            HStack(spacing: 12) {
                EnhancedNumberButton(title: "1", action: { viewModel.inputDigit(1) })
                EnhancedNumberButton(title: "2", action: { viewModel.inputDigit(2) })
                EnhancedNumberButton(title: "3", action: { viewModel.inputDigit(3) })
                EnhancedOperatorButton(title: "×", action: viewModel.multiply)
            }
            
            // 0, ., =
            HStack(spacing: 12) {
                EnhancedNumberButton(title: "0", action: { viewModel.inputDigit(0) })
                    .frame(maxWidth: .infinity)
                
                EnhancedFunctionButton(title: ".", action: viewModel.inputDecimalPoint)
                EnhancedEqualsButton(action: viewModel.equals)
            }
        }
        .padding()
    }
}

// MARK: - Button Components (复用之前的组件)

struct NumberButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
        }
    }
}

struct OperatorButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.orange.opacity(0.8))
                .clipShape(Circle())
        }
    }
}

struct FunctionButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.15))
                .clipShape(Circle())
        }
    }
}

struct ScientificButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 55, height: 50)
                .background(Color.blue.opacity(0.6))
                .cornerRadius(10)
        }
    }
}

struct MemoryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .frame(width: 50, height: 40)
                .background(Color.purple.opacity(0.5))
                .cornerRadius(8)
        }
    }
}

struct ConstantButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 55, height: 50)
                .background(Color.green.opacity(0.6))
                .cornerRadius(10)
        }
    }
}

// MARK: - Preview

#Preview {
    CalculatorView()
}
