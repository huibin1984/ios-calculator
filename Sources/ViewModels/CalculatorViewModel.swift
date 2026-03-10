import Foundation
import Combine

/// 计算器视图模型 - MVVM 架构的 ViewModel 层
class CalculatorViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 当前显示值
    @Published var displayValue: String = "0"
    
    /// 是否启用语音
    @Published var voiceEnabled: Bool = true
    
    /// 是否有记忆值
    @Published var hasMemory: Bool = false
    
    /// 计算器模式 (普通商用版/科学版)
    @Published var isScientificMode: Bool = false
    
    // MARK: - Private Properties
    
    private let engine: CalculatorEngine
    private let voiceManager: VoiceManager
    private let hapticManager: HapticFeedbackManager
    private let historyManager: TransactionHistory
    
    /// 当前正在构建的表达式 (用于历史记录)
    private var currentExpression: String = ""
    
    // MARK: - Initialization
    
    init(engine: CalculatorEngine = CalculatorEngine(),
         voiceManager: VoiceManager = .shared,
         hapticManager: HapticFeedbackManager = .shared,
         historyManager: TransactionHistory = .shared) {
        self.engine = engine
        self.voiceManager = voiceManager
        self.hapticManager = hapticManager
        self.historyManager = historyManager
        
        voiceManager.isEnabled = true
    }
    
    // MARK: - Mode Switching
    
    /// 切换到普通商用版
    func switchToBasicMode() {
        isScientificMode = false
        engine.switchToBasicMode()
        displayValue = "0"
        currentExpression = ""
        hapticManager.modeSwitched()
        voiceManager.speakModeSwitch(to: .basic)
    }
    
    /// 切换到科学版
    func switchToScientificMode() {
        isScientificMode = true
        engine.switchToScientificMode()
        hapticManager.modeSwitched()
        voiceManager.speakModeSwitch(to: .scientific)
    }
    
    /// 切换计算器模式
    func toggleMode() {
        if isScientificMode {
            switchToBasicMode()
        } else {
            switchToScientificMode()
        }
    }
    
    // MARK: - Digit Input (0-9)
    
    func inputDigit(_ digit: Int) {
        engine.inputDigit(digit)
        displayValue = formatNumber(engine.currentValue)
        
        // 构建表达式
        if currentExpression.isEmpty {
            currentExpression = "\(digit)"
        } else if shouldResetExpression() {
            currentExpression = "\(digit)"
        } else {
            currentExpression += "\(digit)"
        }
        
        hapticManager.digitButtonTapped()
        voiceManager.speakDigit(digit)
    }
    
    /// 输入小数点
    func inputDecimalPoint() {
        engine.inputDecimalPoint()
        displayValue = formatNumber(engine.currentValue)
        
        if shouldResetExpression() {
            currentExpression = "0."
        } else {
            currentExpression += "."
        }
        
        hapticManager.lightTap()
        voiceManager.speakDecimalPoint()
    }
    
    // MARK: - Basic Operations
    
    /// 执行加法
    func add() {
        engine.performOperation(.add)
        updateExpression(operator: "+")
        hapticManager.operatorButtonTapped()
        voiceManager.speakOperation(.add)
    }
    
    /// 执行减法
    func subtract() {
        engine.performOperation(.subtract)
        updateExpression(operator: "-")
        hapticManager.operatorButtonTapped()
        voiceManager.speakOperation(.subtract)
    }
    
    /// 执行乘法
    func multiply() {
        engine.performOperation(.multiply)
        updateExpression(operator: "×")
        hapticManager.operatorButtonTapped()
        voiceManager.speakOperation(.multiply)
    }
    
    /// 执行除法
    func divide() {
        engine.performOperation(.divide)
        updateExpression(operator: "÷")
        hapticManager.operatorButtonTapped()
        voiceManager.speakOperation(.divide)
    }
    
    /// 计算等号 (增强版 - 朗读结果 + 触觉反馈 + 历史记录)
    func equals() {
        let result = engine.equals()
        displayValue = formatNumber(result)
        
        // 保存到历史记录
        if !currentExpression.isEmpty && result != .greatestFiniteMagnitude {
            historyManager.addTransaction(expression: "\(currentExpression) =", result: result)
        }
        
        // 重置表达式为当前结果，便于连续计算
        currentExpression = displayValue
        
        hapticManager.equalsPressed()
        voiceManager.speakEquals()
        
        // 延迟朗读结果，避免与"等于"重叠
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            voiceManager.speakResult(result)
        }
    }
    
    // MARK: - Clear Functions
    
    /// 清除当前 (C)
    func clearCurrent() {
        engine.clearCurrent()
        displayValue = "0"
        currentExpression = ""
        hapticManager.clearAction()
        voiceManager.speakClear()
    }
    
    /// 全部清除 (AC)
    func allClear() {
        engine.allClear()
        displayValue = "0"
        currentExpression = ""
        hapticManager.heavyTap()
        voiceManager.speakAllClear()
    }
    
    // MARK: - Sign Toggle
    
    /// 切换正负号
    func toggleSign() {
        engine.toggleSign()
        displayValue = formatNumber(engine.currentValue)
        
        if !currentExpression.isEmpty && currentExpression.first != "-" {
            currentExpression = "-\(currentExpression)"
        }
        
        hapticManager.mediumTap()
        voiceManager.speakToggleSign()
    }
    
    // MARK: - Percent
    
    /// 百分比
    func percent() {
        engine.performOperation(.percent)
        displayValue = formatNumber(engine.currentValue)
        currentExpression += "%"
        hapticManager.mediumTap()
        voiceManager.speakOperation(.percent)
    }
    
    // MARK: - Memory Functions
    
    /// 记忆加 (M+)
    func memoryAdd() {
        engine.memoryAdd()
        hasMemory = engine.memoryValue != 0
        hapticManager.memoryOperation()
        voiceManager.speakMemoryAdd()
    }
    
    /// 记忆减 (M-)
    func memorySubtract() {
        engine.memorySubtract()
        hasMemory = engine.memoryValue != 0
        hapticManager.memoryOperation()
        voiceManager.speakMemorySubtract()
    }
    
    /// 读取记忆 (MR) - 增强版：朗读数值 + 触觉反馈
    func memoryRecall() {
        let value = engine.memoryRecall()
        displayValue = formatNumber(value)
        hasMemory = engine.memoryValue != 0
        
        // MR 会重置表达式
        currentExpression = displayValue
        
        hapticManager.memoryOperation()
        voiceManager.speakMemoryRecall(value)
    }
    
    /// 清除记忆 (MC)
    func memoryClear() {
        engine.memoryClear()
        hasMemory = false
        hapticManager.memoryOperation()
        voiceManager.speakMemoryClear()
    }
    
    /// 存储到记忆 (MS) - 新增功能
    func memoryStore() {
        engine.memoryStore()
        hasMemory = true
        hapticManager.memoryOperation()
        voiceManager.speakMemoryStore(engine.currentValue)
    }
    
    // MARK: - Scientific Functions
    
    /// 平方
    func square() {
        let result = engine.square()
        displayValue = formatNumber(result)
        currentExpression = "√(\(currentExpression))"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakScientific(.square)
    }
    
    /// 立方
    func cube() {
        let result = engine.cube()
        displayValue = formatNumber(result)
        currentExpression += "³"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakScientific(.cube)
    }
    
    /// 平方根
    func squareRoot() {
        let result = engine.squareRoot()
        displayValue = formatNumber(result)
        currentExpression = "√(\(currentExpression))"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakScientific(.sqrt)
    }
    
    /// 正弦
    func sine() {
        let result = engine.sine()
        displayValue = formatNumber(result)
        currentExpression = "sin(\(currentExpression))"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakScientific(.sin)
    }
    
    /// 余弦
    func cosine() {
        let result = engine.cosine()
        displayValue = formatNumber(result)
        currentExpression = "cos(\(currentExpression))"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakScientific(.cos)
    }
    
    /// 正切
    func tangent() {
        let result = engine.tangent()
        displayValue = formatNumber(result)
        currentExpression = "tan(\(currentExpression))"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakScientific(.tan)
    }
    
    /// 常用对数
    func logarithm() {
        let result = engine.logarithm()
        displayValue = formatNumber(result)
        currentExpression = "log(\(currentExpression))"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakScientific(.log)
    }
    
    /// 自然对数
    func naturalLogarithm() {
        let result = engine.naturalLogarithm()
        displayValue = formatNumber(result)
        currentExpression = "ln(\(currentExpression))"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakScientific(.ln)
    }
    
    /// 设置 π
    func setPi() {
        engine.setPi()
        displayValue = formatNumber(engine.currentValue)
        currentExpression = "π"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakPi()
    }
    
    /// 设置 e
    func setEuler() {
        engine.setEuler()
        displayValue = formatNumber(engine.currentValue)
        currentExpression = "e"
        hapticManager.scientificFunctionTapped()
        voiceManager.speakEuler()
    }
    
    // MARK: - Voice Control
    
    /// 切换语音开关
    func toggleVoice() {
        voiceEnabled.toggle()
        voiceManager.isEnabled = voiceEnabled
        hapticManager.selectionChange()
    }
    
    // MARK: - History Access
    
    /// 获取最近的历史记录
    func getRecentHistory(count: Int = 20) -> [TransactionHistory.Transaction] {
        return historyManager.getRecentTransactions(count: count)
    }
    
    /// 从历史记录恢复值
    func restoreFromHistory(_ transaction: TransactionHistory.Transaction) {
        engine.currentValue = transaction.result
        displayValue = formatNumber(transaction.result)
        currentExpression = "\(transaction.expression)\(transaction.result)"
        hapticManager.successOccurred()
        
        // 语音朗读恢复的值
        voiceManager.speakResult(transaction.result)
    }
    
    /// 清除所有历史记录
    func clearHistory() {
        historyManager.clearAll()
        hapticManager.mediumTap()
    }
    
    // MARK: - Private Methods
    
    private func formatNumber(_ number: Decimal) -> String {
        guard number != .greatestFiniteMagnitude else { 
            hapticManager.calculationError()
            return "Error" 
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        
        // 移除末尾的零
        if let string = formatter.string(from: NSDecimalNumber(decimal: number)) {
            return removeTrailingZeros(string)
        }
        
        return "0"
    }
    
    private func removeTrailingZeros(_ numberString: String) -> String {
        var result = numberString
        
        // 如果有小数点，移除末尾的零
        if let decimalRange = result.range(of: ".") {
            while result.last == "0" {
                result.removeLast()
            }
            
            // 如果小数点后没有数字，移除小数点
            if result.last == "." {
                result.removeLast()
            }
        }
        
        return result
    }
    
    private func updateExpression(operator op: String) {
        if shouldResetExpression() {
            currentExpression = "\(displayValue) \(op)"
        } else {
            currentExpression += " \(op)"
        }
    }
    
    private func shouldResetExpression() -> Bool {
        // 如果刚按过等号或清除，需要重置表达式
        return engine.shouldResetDisplay || currentExpression.isEmpty
    }
}
