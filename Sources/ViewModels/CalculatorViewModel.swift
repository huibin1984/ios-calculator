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
    
    // MARK: - Initialization
    
    init(engine: CalculatorEngine = CalculatorEngine(),
         voiceManager: VoiceManager = .shared) {
        self.engine = engine
        self.voiceManager = voiceManager
        
        voiceManager.isEnabled = true
    }
    
    // MARK: - Mode Switching
    
    /// 切换到普通商用版
    func switchToBasicMode() {
        isScientificMode = false
        engine.switchToBasicMode()
        displayValue = "0"
        voiceManager.speakModeSwitch(to: .basic)
    }
    
    /// 切换到科学版
    func switchToScientificMode() {
        isScientificMode = true
        engine.switchToScientificMode()
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
        voiceManager.speakDigit(digit)
    }
    
    /// 输入小数点
    func inputDecimalPoint() {
        engine.inputDecimalPoint()
        displayValue = formatNumber(engine.currentValue)
        voiceManager.speakDecimalPoint()
    }
    
    // MARK: - Basic Operations
    
    /// 执行加法
    func add() {
        engine.performOperation(.add)
        voiceManager.speakOperation(.add)
    }
    
    /// 执行减法
    func subtract() {
        engine.performOperation(.subtract)
        voiceManager.speakOperation(.subtract)
    }
    
    /// 执行乘法
    func multiply() {
        engine.performOperation(.multiply)
        voiceManager.speakOperation(.multiply)
    }
    
    /// 执行除法
    func divide() {
        engine.performOperation(.divide)
        voiceManager.speakOperation(.divide)
    }
    
    /// 计算等号 (增强版 - 朗读结果)
    func equals() {
        let result = engine.equals()
        displayValue = formatNumber(result)
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
        voiceManager.speakClear()
    }
    
    /// 全部清除 (AC)
    func allClear() {
        engine.allClear()
        displayValue = "0"
        voiceManager.speakAllClear()
    }
    
    // MARK: - Sign Toggle
    
    /// 切换正负号
    func toggleSign() {
        engine.toggleSign()
        displayValue = formatNumber(engine.currentValue)
        voiceManager.speakToggleSign()
    }
    
    // MARK: - Percent
    
    /// 百分比
    func percent() {
        engine.performOperation(.percent)
        displayValue = formatNumber(engine.currentValue)
        voiceManager.speakOperation(.percent)
    }
    
    // MARK: - Memory Functions
    
    /// 记忆加 (M+)
    func memoryAdd() {
        engine.memoryAdd()
        hasMemory = engine.memoryValue != 0
        voiceManager.speakMemoryAdd()
    }
    
    /// 记忆减 (M-)
    func memorySubtract() {
        engine.memorySubtract()
        hasMemory = engine.memoryValue != 0
        voiceManager.speakMemorySubtract()
    }
    
    /// 读取记忆 (MR) - 增强版：朗读数值
    func memoryRecall() {
        let value = engine.memoryRecall()
        displayValue = formatNumber(value)
        hasMemory = engine.memoryValue != 0
        voiceManager.speakMemoryRecall(value)
    }
    
    /// 清除记忆 (MC)
    func memoryClear() {
        engine.memoryClear()
        hasMemory = false
        voiceManager.speakMemoryClear()
    }
    
    /// 存储到记忆 (MS) - 新增功能
    func memoryStore() {
        engine.memoryStore()
        hasMemory = true
        voiceManager.speakMemoryStore(engine.currentValue)
    }
    
    // MARK: - Scientific Functions
    
    /// 平方
    func square() {
        let result = engine.square()
        displayValue = formatNumber(result)
        voiceManager.speakScientific(.square)
    }
    
    /// 立方
    func cube() {
        let result = engine.cube()
        displayValue = formatNumber(result)
        voiceManager.speakScientific(.cube)
    }
    
    /// 平方根
    func squareRoot() {
        let result = engine.squareRoot()
        displayValue = formatNumber(result)
        voiceManager.speakScientific(.sqrt)
    }
    
    /// 正弦
    func sine() {
        let result = engine.sine()
        displayValue = formatNumber(result)
        voiceManager.speakScientific(.sin)
    }
    
    /// 余弦
    func cosine() {
        let result = engine.cosine()
        displayValue = formatNumber(result)
        voiceManager.speakScientific(.cos)
    }
    
    /// 正切
    func tangent() {
        let result = engine.tangent()
        displayValue = formatNumber(result)
        voiceManager.speakScientific(.tan)
    }
    
    /// 常用对数
    func logarithm() {
        let result = engine.logarithm()
        displayValue = formatNumber(result)
        voiceManager.speakScientific(.log)
    }
    
    /// 自然对数
    func naturalLogarithm() {
        let result = engine.naturalLogarithm()
        displayValue = formatNumber(result)
        voiceManager.speakScientific(.ln)
    }
    
    /// 设置 π
    func setPi() {
        engine.setPi()
        displayValue = formatNumber(engine.currentValue)
        voiceManager.speakPi()
    }
    
    /// 设置 e
    func setEuler() {
        engine.setEuler()
        displayValue = formatNumber(engine.currentValue)
        voiceManager.speakEuler()
    }
    
    // MARK: - Voice Control
    
    /// 切换语音开关
    func toggleVoice() {
        voiceEnabled.toggle()
        voiceManager.isEnabled = voiceEnabled
    }
    
    // MARK: - Private Methods
    
    private func formatNumber(_ number: Decimal) -> String {
        guard number != .greatestFiniteMagnitude else { return "Error" }
        
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
            var endIndex = decimalRange.upperBound
            while endIndex < result.endIndex && result[endIndex] == "0" {
                endIndex.formIndex(after: endIndex, byOffset: -1)
                result.removeLast()
            }
            
            // 如果小数点后没有数字，移除小数点
            if result.last == "." {
                result.removeLast()
            }
        }
        
        return result
    }
}
