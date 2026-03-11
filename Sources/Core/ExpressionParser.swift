import Foundation

/// 表达式解析器 - 使用 Shunting Yard 算法实现运算优先级 (v2.7)
class ExpressionParser {
    
    // MARK: - Operator Precedence
    
    /// 运算符优先级（数字越大优先级越高）
    private let operatorPrecedence: [String: Int] = [
        "+": 1,
        "-": 1,
        "×": 2,
        "*": 2,
        "÷": 2,
        "/": 2,
        "^": 3  // 幂运算
    ]
    
    /// 运算符结合性（left = 左结合，right = 右结合）
    private let rightAssociative: Set<String> = ["^"]
    
    // MARK: - Public Methods
    
    /// 解析并计算中缀表达式（支持优先级）
    /// - Parameter tokens: 分词后的数组，如 ["5", "+", "3", "×", "2"]
    /// - Returns: 计算结果
    func evaluate(tokens: [String]) -> Decimal? {
        // Step 1: 将中缀表达式转换为后缀表达式（逆波兰式）
        guard let postfix = infixToPostfix(tokens: tokens) else {
            print("❌ 表达式转换失败：\(tokens)")
            return nil
        }
        
        print("✅ 后缀表达式：\(postfix)")
        
        // Step 2: 计算后缀表达式
        return evaluatePostfix(postfix)
    }
    
    // MARK: - Shunting Yard Algorithm
    
    /// 中缀表达式转后缀表达式（逆波兰式）
    private func infixToPostfix(tokens: [String]) -> [String]? {
        var outputQueue: [String] = []
        var operatorStack: [String] = []
        
        for token in tokens {
            // 如果是数字，直接加入输出队列
            if let _ = Decimal(string: token) {
                outputQueue.append(token)
            }
            // 如果是运算符
            else if isOperator(token) {
                // 如果运算符栈不为空，且栈顶元素也是运算符
                while let topOperator = operatorStack.last,
                      isOperator(topOperator),
                      shouldPopOperator(token, topOperator) {
                    outputQueue.append(operatorStack.removeLast())
                }
                operatorStack.append(token)
            }
            // 左括号入栈
            else if token == "(" {
                operatorStack.append(token)
            }
            // 右括号：弹出直到左括号
            else if token == ")" {
                while let top = operatorStack.last, top != "(" {
                    outputQueue.append(operatorStack.removeLast())
                }
                // 弹出左括号
                if !operatorStack.isEmpty {
                    operatorStack.removeLast()
                }
            }
            // 忽略未知token
            else {
                print("⚠️ 未知token：\(token)")
            }
        }
        
        // 弹出所有剩余的运算符
        while !operatorStack.isEmpty {
            if let op = operatorStack.popLast() {
                outputQueue.append(op)
            }
        }
        
        return outputQueue
    }
    
    /// 判断是否应该弹出运算符
    private func shouldPopOperator(_ current: String, _ top: String) -> Bool {
        let currentPrecedence = operatorPrecedence[current] ?? 0
        let topPrecedence = operatorPrecedence[top] ?? 0
        
        // 如果当前运算符优先级小于等于栈顶运算符，应该弹出
        if currentPrecedence <= topPrecedence {
            return true
        }
        
        // 如果优先级相同且当前运算符是左结合的，应该弹出
        if currentPrecedence == topPrecedence && !rightAssociative.contains(current) {
            return true
        }
        
        return false
    }
    
    /// 判断是否是运算符
    private func isOperator(_ token: String) -> Bool {
        return operatorPrecedence.keys.contains(token)
    }
    
    // MARK: - Postfix Evaluation
    
    /// 计算后缀表达式
    private func evaluatePostfix(_ postfix: [String]) -> Decimal? {
        var stack: [Decimal] = []
        
        for token in postfix {
            // 如果是数字，入栈
            if let number = Decimal(string: token) {
                stack.append(number)
            }
            // 如果是运算符，弹出两个操作数进行计算
            else if isOperator(token) {
                guard stack.count >= 2 else {
                    print("❌ 操作数不足")
                    return nil
                }
                
                // 弹出两个操作数（注意：后进先出）
                let b = stack.removeLast()
                let a = stack.removeLast()
                
                if let result = performOperation(a, b, token) {
                    stack.append(result)
                } else {
                    return nil
                }
            }
        }
        
        // 栈中应该只有一个元素，即最终结果
        return stack.last
    }
    
    /// 执行二元运算
    private func performOperation(_ a: Decimal, _ b: Decimal, _ op: String) -> Decimal? {
        switch op {
        case "+":
            return a + b
        case "-":
            return a - b
        case "×", "*":
            return a * b
        case "÷", "/":
            guard b != 0 else {
                print("❌ 除数不能为零")
                return nil
            }
            return a / b
        case "^":
            // 幂运算
            return pow(Decimal.self, a, b)
        default:
            print("❌ 未知运算符：\(op)")
            return nil
        }
    }
    
    // MARK: - Helper: Decimal Power
    
    /// Decimal 幂运算
    private func pow(_ type: Decimal.Type, _ base: Decimal, _ exponent: Decimal) -> Decimal {
        // 简化的幂运算实现
        let exponentInt = NSDecimalNumber(decimal: exponent).intValue
        guard exponentInt >= 0 else { return 0 }
        
        var result: Decimal = 1
        for _ in 0..<exponentInt {
            result *= base
        }
        return result
    }
}

// MARK: - Convenience Extension for Voice Input

extension ExpressionParser {
    
    /// 解析中文语音输入并计算（支持优先级）
    /// - Parameter input: 原始语音输入，如 "五加三乘二"
    /// - Returns: 计算结果
    func parseChineseVoiceInput(_ input: String) -> Decimal? {
        // Step 1: 将中文数字转换为阿拉伯数字
        let tokens = tokenizeChinese(input)
        
        print("📝 分词结果：\(tokens)")
        
        // Step 2: 解析并计算
        return evaluate(tokens: tokens)
    }
    
    /// 分词中文语音输入
    private func tokenizeChinese(_ input: String) -> [String] {
        var tokens: [String] = []
        var currentNumber = ""
        
        let chineseNumbers: [String: String] = [
            "零": "0", "一": "1", "二": "2", "三": "3", "四": "4",
            "五": "5", "六": "6", "七": "7", "八": "8", "九": "9",
            "十": "10", "百": "100", "千": "1000"
        ]
        
        let operators: [String: String] = [
            "加": "+", "减": "-", "乘": "×", "除": "÷"
        ]
        
        for char in input {
            let str = String(char)
            
            // 如果是数字
            if let num = chineseNumbers[str] {
                currentNumber += num
            }
            // 如果是运算符
            else if let op = operators[str] {
                if !currentNumber.isEmpty {
                    tokens.append(currentNumber)
                    currentNumber = ""
                }
                tokens.append(op)
            }
            // 忽略其他字符
        }
        
        // 添加最后一个数字
        if !currentNumber.isEmpty {
            tokens.append(currentNumber)
        }
        
        return tokens
    }
}
