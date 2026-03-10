import SwiftUI

/// 计算器主界面 - MVVM 架构的 View 层
struct CalculatorView: View {
    
    @StateObject private var viewModel: CalculatorViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部控制栏：模式切换 + 语音开关
            HStack {
                ModeToggleView(isScientificMode: $viewModel.isScientificMode, 
                              toggleAction: viewModel.toggleMode)
                
                Spacer()
                
                VoiceToggleView(viewModel: viewModel)
            }
            
            // 显示屏
            DisplayView(displayValue: $viewModel.displayValue, hasMemory: $viewModel.hasMemory)
            
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
    }
    
    // MARK: - Initialization
    
    init() {
        _viewModel = StateObject(wrappedValue: CalculatorViewModel())
    }
}

// MARK: - Display View

struct DisplayView: View {
    let displayValue: String
    let hasMemory: Bool
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // 记忆指示器
            if hasMemory {
                Text("M")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // 主显示屏
            Text(displayValue)
                .font(.system(size: 64, weight: .light, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color.black.opacity(0.3))
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

// MARK: - Basic Button Grid (普通商用版)

struct BasicButtonGridView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // 记忆功能行
            HStack(spacing: 12) {
                MemoryButton(title: "MC", action: viewModel.memoryClear)
                MemoryButton(title: "MR", action: viewModel.memoryRecall)
                MemoryButton(title: "MS", action: viewModel.memoryStore)
                MemoryButton(title: "M+", action: viewModel.memoryAdd)
            }
            
            // 清除 + 正负 + 除 + 乘
            HStack(spacing: 12) {
                FunctionButton(title: "AC", action: viewModel.allClear)
                FunctionButton(title: "+/-", action: viewModel.toggleSign)
                FunctionButton(title: "%", action: viewModel.percent)
                OperatorButton(title: "÷", action: viewModel.divide)
            }
            
            // 7, 8, 9, +
            HStack(spacing: 12) {
                NumberButton(title: "7", action: { viewModel.inputDigit(7) })
                NumberButton(title: "8", action: { viewModel.inputDigit(8) })
                NumberButton(title: "9", action: { viewModel.inputDigit(9) })
                OperatorButton(title: "+", action: viewModel.add)
            }
            
            // 4, 5, 6, -
            HStack(spacing: 12) {
                NumberButton(title: "4", action: { viewModel.inputDigit(4) })
                NumberButton(title: "5", action: { viewModel.inputDigit(5) })
                NumberButton(title: "6", action: { viewModel.inputDigit(6) })
                OperatorButton(title: "-", action: viewModel.subtract)
            }
            
            // 1, 2, 3, ×
            HStack(spacing: 12) {
                NumberButton(title: "1", action: { viewModel.inputDigit(1) })
                NumberButton(title: "2", action: { viewModel.inputDigit(2) })
                NumberButton(title: "3", action: { viewModel.inputDigit(3) })
                OperatorButton(title: "×", action: viewModel.multiply)
            }
            
            // 0, ., =
            HStack(spacing: 12) {
                NumberButton(title: "0", action: { viewModel.inputDigit(0) })
                    .frame(maxWidth: .infinity)
                
                FunctionButton(title: ".", action: viewModel.inputDecimalPoint)
                OperatorButton(title: "=", action: viewModel.equals)
            }
        }
        .padding()
    }
}

// MARK: - Scientific Button Grid (科学版)

struct ScientificButtonGridView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // 记忆功能行
            HStack(spacing: 12) {
                MemoryButton(title: "MC", action: viewModel.memoryClear)
                MemoryButton(title: "MR", action: viewModel.memoryRecall)
                MemoryButton(title: "MS", action: viewModel.memoryStore)
                MemoryButton(title: "M+", action: viewModel.memoryAdd)
            }
            
            // 科学函数行 1
            HStack(spacing: 12) {
                ScientificButton(title: "sin", action: viewModel.sine)
                ScientificButton(title: "cos", action: viewModel.cosine)
                ScientificButton(title: "tan", action: viewModel.tangent)
                ScientificButton(title: "log", action: viewModel.logarithm)
            }
            
            // 科学函数行 2
            HStack(spacing: 12) {
                ScientificButton(title: "ln", action: viewModel.naturalLogarithm)
                ScientificButton(title: "x²", action: viewModel.square)
                ScientificButton(title: "√", action: viewModel.squareRoot)
                ConstantButton(title: "π", action: viewModel.setPi)
            }
            
            // 清除 + 正负 + 除 + 乘
            HStack(spacing: 12) {
                FunctionButton(title: "AC", action: viewModel.allClear)
                FunctionButton(title: "+/-", action: viewModel.toggleSign)
                FunctionButton(title: "%", action: viewModel.percent)
                OperatorButton(title: "÷", action: viewModel.divide)
            }
            
            // 7, 8, 9, +
            HStack(spacing: 12) {
                NumberButton(title: "7", action: { viewModel.inputDigit(7) })
                NumberButton(title: "8", action: { viewModel.inputDigit(8) })
                NumberButton(title: "9", action: { viewModel.inputDigit(9) })
                OperatorButton(title: "+", action: viewModel.add)
            }
            
            // 4, 5, 6, -
            HStack(spacing: 12) {
                NumberButton(title: "4", action: { viewModel.inputDigit(4) })
                NumberButton(title: "5", action: { viewModel.inputDigit(5) })
                NumberButton(title: "6", action: { viewModel.inputDigit(6) })
                OperatorButton(title: "-", action: viewModel.subtract)
            }
            
            // 1, 2, 3, ×
            HStack(spacing: 12) {
                NumberButton(title: "1", action: { viewModel.inputDigit(1) })
                NumberButton(title: "2", action: { viewModel.inputDigit(2) })
                NumberButton(title: "3", action: { viewModel.inputDigit(3) })
                OperatorButton(title: "×", action: viewModel.multiply)
            }
            
            // 0, ., =
            HStack(spacing: 12) {
                NumberButton(title: "0", action: { viewModel.inputDigit(0) })
                    .frame(maxWidth: .infinity)
                
                FunctionButton(title: ".", action: viewModel.inputDecimalPoint)
                OperatorButton(title: "=", action: viewModel.equals)
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
