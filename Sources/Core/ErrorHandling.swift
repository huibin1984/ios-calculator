import Foundation

/// 通用错误类型 (v3.5)
enum CalculatorError: Error, LocalizedError {
    case divisionByZero
    case invalidInput
    case overflow
    case undefinedOperation
    case speechRecognitionFailed
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .divisionByZero:
            return "除数不能为零"
        case .invalidInput:
            return "无效输入"
        case .overflow:
            return "数值超出范围"
        case .undefinedOperation:
            return "未定义的操作"
        case .speechRecognitionFailed:
            return "语音识别失败"
        case .networkError:
            return "网络错误"
        case .unknown:
            return "未知错误"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .divisionByZero:
            return "请输入非零的除数"
        case .invalidInput:
            return "请检查您的输入"
        case .overflow:
            return "请输入较小的数值"
        case .undefinedOperation:
            return "请选择有效的操作"
        case .speechRecognitionFailed:
            return "请再说一次"
        case .networkError:
            return "请检查网络连接"
        case .unknown:
            return "请重试"
        }
    }
}

/// Result 类型扩展
extension Result {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
}

/// 计算引擎增强版 - 带完整错误处理 (v3.5)
class CalculatorEngineV2 {
    
    // MARK: - Properties
    
    private(set) var currentValue: Decimal = 0
    private(set) var memoryValue: Decimal = 0
    private var firstOperand: Decimal?
    private var pendingOperation: Operation?
    private var shouldResetDisplay: Bool = false
    
    // MARK: - Operation Enum
    
    enum Operation: String {
        case add = "+"
        case subtract = "-"
        case multiply = "×"
        case divide = "÷"
        case percent = "%"
    }
    
    // MARK: - Public Methods with Error Handling
    
    /// 安全输入数字
    func inputDigit(_ digit: Int) -> Result<Decimal, CalculatorError> {
        guard digit >= 0 && digit <= 9 else {
            return .failure(.invalidInput)
        }
        
        // 检查溢出
        let newValue = currentValue * 10 + Decimal(digit)
        if newValue > Decimal(1e10) {
            return .failure(.overflow)
        }
        
        currentValue = newValue
        shouldResetDisplay = false
        return .success(currentValue)
    }
    
    /// 安全设置操作
    func setOperation(_ operation: Operation) -> Result<Void, CalculatorError> {
        guard let first = firstOperand, pendingOperation != nil else {
            firstOperand = currentValue
            pendingOperation = operation
            shouldResetDisplay = true
            return .success(())
        }
        
        // 如果已有待计算的操作，先计算
        let result = calculate()
        if case .failure(let error) = result {
            return .failure(error)
        }
        
        firstOperand = currentValue
        pendingOperation = operation
        shouldResetDisplay = true
        return .success(())
    }
    
    /// 安全计算
    func calculate() -> Result<Decimal, CalculatorError> {
        guard let first = firstOperand, let op = pendingOperation else {
            return .success(currentValue)
        }
        
        let result: Decimal?
        
        switch op {
        case .add:
            result = first + currentValue
        case .subtract:
            result = first - currentValue
        case .multiply:
            result = first * currentValue
        case .divide:
            guard currentValue != 0 else {
                return .failure(.divisionByZero)
            }
            result = first / currentValue
        case .percent:
            result = first * (currentValue / 100)
        }
        
        guard let calculatedResult = result else {
            return .failure(.unknown)
        }
        
        // 检查结果溢出
        if calculatedResult > Decimal(1e10) || calculatedResult < Decimal(-1e10) {
            return .failure(.overflow)
        }
        
        currentValue = calculatedResult
        firstOperand = nil
        pendingOperation = nil
        shouldResetDisplay = true
        
        return .success(currentValue)
    }
    
    /// 安全清除
    func clear() {
        currentValue = 0
        firstOperand = nil
        pendingOperation = nil
        shouldResetDisplay = false
    }
    
    /// 安全内存操作
    func memoryAdd() -> Result<Decimal, CalculatorError> {
        memoryValue += currentValue
        return .success(memoryValue)
    }
    
    func memorySubtract() -> Result<Decimal, CalculatorError> {
        memoryValue -= currentValue
        return .success(memoryValue)
    }
    
    func memoryRecall() -> Result<Decimal, CalculatorError> {
        currentValue = memoryValue
        return .success(currentValue)
    }
    
    func memoryClear() -> Result<Void, CalculatorError> {
        memoryValue = 0
        return .success(())
    }
}

// MARK: - Validation Helper

struct InputValidator {
    
    /// 验证数字输入
    static func isValidNumber(_ string: String) -> Bool {
        return Decimal(string: string) != nil
    }
    
    /// 验证运算符
    static func isValidOperator(_ string: String) -> Bool {
        let validOperators = ["+", "-", "×", "÷", "*", "/"]
        return validOperators.contains(string)
    }
    
    /// 清理输入字符串
    static func sanitizeInput(_ input: String) -> String {
        return input
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
    }
}

// MARK: - Logger

struct CalculatorLogger {
    
    enum LogLevel: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
    
    static func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let filename = (file as NSString).lastPathComponent
        print("[\(level.rawValue)] [\(filename):\(line)] \(function): \(message)")
        #endif
    }
    
    static func debug(_ message: String) {
        log(message, level: .debug)
    }
    
    static func info(_ message: String) {
        log(message, level: .info)
    }
    
    static func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    static func error(_ message: String) {
        log(message, level: .error)
    }
}
