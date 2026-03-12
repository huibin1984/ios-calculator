import Foundation

/// 计算引擎 - 使用 Decimal 实现精确计算
class CalculatorEngine {
    
    // MARK: - Operations
    
    /// 数学运算类型
    enum Operation: String {
        case add = "+"
        case subtract = "-"
        case multiply = "×"
        case divide = "÷"
        case percent = "%"
        
        var symbol: String { rawValue }
    }
    
    /// 科学函数类型
    enum ScientificFunction: String {
        case sin = "sin"
        case cos = "cos"
        case tan = "tan"
        case log = "log"
        case ln = "ln"
        case sqrt = "√"
        case square = "x²"
        case cube = "x³"
        
        var symbol: String { rawValue }
    }
    
    /// 计算器模式
    enum CalculatorMode {
        case basic      // 普通商用版：基础运算 + 百分比 + 记忆
        case scientific // 科学版：全部功能
        
        var hasScientificFunctions: Bool {
            self == .scientific
        }
    }
    
    // MARK: - Public Methods (v2.7)
    
    /// 直接设置当前值（用于语音表达式解析结果）
    func setValue(_ value: Decimal) {
        currentValue = value
        shouldResetDisplay = true
    }
    
    // MARK: - Properties
    
    /// 当前显示的值 (内部存储为 Decimal，避免浮点数精度问题)
    var currentValue: Decimal = 0
    
    /// 记忆值
    private(set) var memoryValue: Decimal = 0
    
    /// 上一个操作数
    private var firstOperand: Decimal?
    
    /// 当前运算符
    private var pendingOperation: Operation?
    
    /// 是否开始新输入 (按等号后或运算完成后)
    var shouldResetDisplay: Bool = false
    
    /// 计算器模式
    private(set) var mode: CalculatorMode = .basic
    
    // MARK: - Mode Switching
    
    /// 切换到普通商用版
    func switchToBasicMode() {
        mode = .basic
        allClear() // 切换模式时清除状态
    }
    
    /// 切换到科学版
    func switchToScientificMode() {
        mode = .scientific
    }
    
    /// 切换计算器模式
    func toggleMode() {
        if mode == .basic {
            switchToScientificMode()
        } else {
            switchToBasicMode()
        }
    }
    
    // MARK: - Basic Operations
    
    /// 输入数字
    func inputDigit(_ digit: Int) {
        guard digit >= 0 && digit <= 9 else { return }
        
        if shouldResetDisplay {
            currentValue = Decimal(digit)
            shouldResetDisplay = false
        } else {
            currentValue = (currentValue * 10) + Decimal(digit)
        }
    }
    
    /// 输入小数点
    func inputDecimalPoint() {
        if shouldResetDisplay {
            currentValue = Decimal(string: "0.")!
            shouldResetDisplay = false
            return
        }
        
        // 如果当前值没有小数点，添加一个
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        
        if formatter.string(from: NSDecimalNumber(decimal: currentValue))?.contains(".") == false {
            currentValue /= 10
        }
    }
    
    /// 执行基本运算
    func performOperation(_ operation: Operation) {
        switch operation {
        case .add, .subtract, .multiply, .divide:
            if firstOperand == nil {
                firstOperand = currentValue
            } else if let existingOp = pendingOperation {
                calculate(existingOp)
            }
            
            pendingOperation = operation
            shouldResetDisplay = true
        case .percent:
            currentValue /= 100
        }
    }
    
    /// 计算结果
    func calculate(_ operation: Operation? = nil) -> Decimal {
        let op = operation ?? pendingOperation
        
        guard let first = firstOperand, let op = op else {
            return currentValue
        }
        
        switch op {
        case .add:
            currentValue = first + currentValue
        case .subtract:
            currentValue = first - currentValue
        case .multiply:
            currentValue = first * currentValue
        case .divide:
            if currentValue != 0 {
                currentValue = first / currentValue
            } else {
                currentValue = .greatestFiniteMagnitude // 除以零显示错误
            }
        case .percent:
            break
        }
        
        firstOperand = nil
        pendingOperation = nil
        shouldResetDisplay = true
        
        return currentValue
    }
    
    /// 执行等号运算
    func equals() -> Decimal {
        if let op = pendingOperation {
            return calculate(op)
        }
        return currentValue
    }
    
    // MARK: - Clear Functions
    
    /// 清除当前输入 (C)
    func clearCurrent() {
        currentValue = 0
        shouldResetDisplay = false
    }
    
    /// 全部清除 (AC)
    func allClear() {
        currentValue = 0
        firstOperand = nil
        pendingOperation = nil
        shouldResetDisplay = false
    }
    
    // MARK: - Sign Toggle
    
    /// 切换正负号
    func toggleSign() {
        currentValue *= -1
    }
    
    // MARK: - Memory Functions
    
    /// 记忆加 (M+)
    func memoryAdd() {
        memoryValue += currentValue
    }
    
    /// 记忆减 (M-)
    func memorySubtract() {
        memoryValue -= currentValue
    }
    
    /// 读取记忆 (MR)
    func memoryRecall() -> Decimal {
        shouldResetDisplay = true
        return memoryValue
    }
    
    /// 清除记忆 (MC)
    func memoryClear() {
        memoryValue = 0
    }
    
    /// 存储到记忆 (MS) - 覆盖当前记忆值
    func memoryStore() {
        memoryValue = currentValue
    }
    
    // MARK: - Scientific Functions
    
    /// 计算平方
    func square() -> Decimal {
        currentValue = currentValue * currentValue
        return currentValue
    }
    
    /// 计算立方
    func cube() -> Decimal {
        currentValue = currentValue * currentValue * currentValue
        return currentValue
    }
    
    /// 计算平方根
    func squareRoot() -> Decimal {
        if currentValue >= 0 {
            let doubleValue = NSDecimalNumber(decimal: currentValue).doubleValue
            currentValue = Decimal(string: String(sqrt(doubleValue)))!
        } else {
            currentValue = 0 // 负数开方显示错误
        }
        return currentValue
    }
    
    /// 计算正弦 (角度制)
    func sine() -> Decimal {
        let doubleValue = NSDecimalNumber(decimal: currentValue).doubleValue
        let result = sin(doubleValue * .pi / 180)
        currentValue = Decimal(string: String(result))!
        return currentValue
    }
    
    /// 计算余弦 (角度制)
    func cosine() -> Decimal {
        let doubleValue = NSDecimalNumber(decimal: currentValue).doubleValue
        let result = cos(doubleValue * .pi / 180)
        currentValue = Decimal(string: String(result))!
        return currentValue
    }
    
    /// 计算正切 (角度制)
    func tangent() -> Decimal {
        let doubleValue = NSDecimalNumber(decimal: currentValue).doubleValue
        let result = tan(doubleValue * .pi / 180)
        currentValue = Decimal(string: String(result))!
        return currentValue
    }
    
    /// 计算常用对数 (log₁₀)
    func logarithm() -> Decimal {
        if currentValue > 0 {
            let doubleValue = NSDecimalNumber(decimal: currentValue).doubleValue
            let result = log10(doubleValue)
            currentValue = Decimal(string: String(result))!
        } else {
            currentValue = 0 // 非正数显示错误
        }
        return currentValue
    }
    
    /// 计算自然对数 (ln)
    func naturalLogarithm() -> Decimal {
        if currentValue > 0 {
            let doubleValue = NSDecimalNumber(decimal: currentValue).doubleValue
            let result = log(doubleValue)
            currentValue = Decimal(string: String(result))!
        } else {
            currentValue = 0 // 非正数显示错误
        }
        return currentValue
    }
    
    /// 设置 π
    func setPi() {
        shouldResetDisplay = true
        currentValue = Decimal(string: String(Double.pi))!
    }
    
    /// 设置 e
    func setEuler() {
        shouldResetDisplay = true
        currentValue = Decimal(string: String(exp(1.0)))!
    }
}
