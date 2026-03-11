import Foundation

/// AI 方程求解器 - 本地规则引擎 + AI API 集成架构 (v3.0)
class AIEquationSolver {
    
    // MARK: - Singleton
    
    static let shared = AIEquationSolver()
    private init() {}
    
    // MARK: - Properties
    
    private let localParser = LocalEquationParser()
    
    /// 是否使用 AI（付费功能）
    var isAIModeEnabled: Bool = false
    
    // MARK: - Public Methods
    
    /// 求解方程 - 主入口
    /// - Parameter input: 用户输入，可以是自然语言或标准格式
    /// - Returns: 求解结果
    func solve(_ input: String) -> AIEquationSolution? {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        
        // 尝试本地解析器（免费）
        if let solution = localParser.parse(trimmed) {
            return solution
        }
        
        // 如果本地解析失败，且 AI 模式启用，返回 nil（让调用方处理 AI 请求）
        if isAIModeEnabled {
            return nil  // 需要 AI 处理
        }
        
        return nil
    }
    
    /// 使用 AI 求解（付费功能）
    /// - Parameters:
    ///   - input: 自然语言输入
    ///   - completion: 回调
    func solveWithAI(_ input: String, completion: @escaping (AIEquationSolution?) -> Void) {
        // v3.0 TODO: 接入云端 LLM API
        // 示例调用：
        // LLMClient.shared.solveEquation(input) { response in
        //     completion(parseAIResponse(response))
        // }
        
        print("🤖 AI 方程求解功能需要配置 LLM API")
        completion(nil)
    }
}

// MARK: - AI Equation Solution

struct AIEquationSolution {
    let equationType: EquationType
    let coefficients: Coefficients
    let steps: [SolutionStep]  // v3.2 教育模式需要
    let result: String
    let isExact: Bool
    
    enum EquationType {
        case linear      // 线性方程 ax + b = c
        case quadratic   // 二次方程 ax² + bx + c = 0
        case unknown
    }
    
    struct Coefficients {
        let a: Decimal?
        let b: Decimal?
        let c: Decimal?
    }
    
    struct SolutionStep {
        let stepNumber: Int
        let description: String
        let formula: String?
        let result: String?
    }
}

// MARK: - Local Equation Parser (免费版)

class LocalEquationParser {
    
    // MARK: - Public Methods
    
    /// 解析标准格式方程
    /// 支持格式：
    /// - 线性：2x + 5 = 17, 3x - 2 = 10
    /// - 二次：3x² - 6x + 2 = 0, x² + 4x + 4 = 0
    func parse(_ input: String) -> AIEquationSolution? {
        // 尝试线性方程
        if let solution = parseLinearEquation(input) {
            return solution
        }
        
        // 尝试二次方程
        if let solution = parseQuadraticEquation(input) {
            return solution
        }
        
        return nil
    }
    
    // MARK: - Linear Equation Parser
    
    private func parseLinearEquation(_ input: String) -> AIEquationSolution? {
        // 匹配格式：ax + b = c 或 ax - b = c
        // 支持：2x + 5 = 17, 3x - 2 = 10, x = 5
        
        let patterns = [
            // 标准格式：ax + b = c
            #"(\d*)x\s*([+\-])\s*(\d+)\s*=\s*(\d+)"#,
            // 简化格式：x = c
            #"x\s*=\s*(\d+)"#
        ]
        
        for pattern in patterns {
            if let match = input.range(of: pattern, options: .regularExpression) {
                let matched = String(input[match])
                return parseLinearMatch(matched, pattern: pattern)
            }
        }
        
        return nil
    }
    
    private func parseLinearMatch(_ input: String, pattern: String) -> AIEquationSolution? {
        // 提取系数
        // 这里简化处理，实际需要更复杂的正则
        
        if input.contains("=") {
            let parts = input.components(separatedBy: "=")
            guard parts.count == 2 else { return nil }
            
            let left = parts[0].trimmingCharacters(in: .whitespaces)
            let right = parts[1].trimmingCharacters(in: .whitespaces)
            
            guard let c = Decimal(string: right) else { return nil }
            
            // 解析左侧 ax + b
            var a: Decimal = 1
            var b: Decimal = 0
            
            if left.contains("x") {
                let xParts = left.components(separatedBy: "x")
                if xParts[0].isEmpty || xParts[0] == "+" {
                    a = 1
                } else if xParts[0] == "-" {
                    a = -1
                } else if let coef = Decimal(string: xParts[0]) {
                    a = coef
                }
                
                if xParts.count > 1 && !xParts[1].isEmpty {
                    let op = xParts[1].trimmingCharacters(in: .whitespaces)
                    if let num = Decimal(string: op.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "")) {
                        b = op.hasPrefix("-") ? -num : num
                    }
                }
            }
            
            // 求解：ax + b = c → x = (c - b) / a
            let x = (c - b) / a
            
            return AIEquationSolution(
                equationType: .linear,
                coefficients: .init(a: a, b: b, c: c),
                steps: [
                    .init(stepNumber: 1, description: "识别为线性方程", formula: "ax + b = c", result: nil),
                    .init(stepNumber: 2, description: "提取系数", formula: "a = \(a), b = \(b), c = \(c)", result: nil),
                    .init(stepNumber: 3, description: "求解 x = (c - b) / a", formula: "x = (\(c) - \(b)) / \(a)", result: nil),
                    .init(stepNumber: 4, description: "计算结果", formula: "x = \(x)", result: "\(x)")
                ],
                result: "x = \(x)",
                isExact: true
            )
        }
        
        return nil
    }
    
    // MARK: - Quadratic Equation Parser
    
    private func parseQuadraticEquation(_ input: String) -> AIEquationSolution? {
        // 匹配格式：ax² + bx + c = 0
        let pattern = #"(\d*)x²\s*([+\-])\s*(\d*)x\s*([+\-])\s*(\d+)\s*=\s*0"#
        
        if let match = input.range(of: pattern, options: .regularExpression) {
            let matched = String(input[match])
            return parseQuadraticMatch(matched)
        }
        
        return nil
    }
    
    private func parseQuadraticMatch(_ input: String) -> AIEquationSolution? {
        // 简化实现：需要完善正则解析
        // 实际项目中应该使用更健壮的解析器
        
        // 示例：3x² - 6x + 2 = 0
        // a = 3, b = -6, c = 2
        // Δ = b² - 4ac = 36 - 24 = 12
        // x = (6 ± √12) / 6
        
        print("⚠️ 二次方程解析需要完善")
        return nil
    }
}

// MARK: - LLM API Client (架构设计)

class LLMEquationClient {
    
    static let shared = LLMEquationClient()
    private init() {}
    
    /// 使用 LLM 求解任意格式的方程
    /// - Parameters:
    ///   - input: 自然语言输入，如 "2x + 5 = 17"
    ///   - completion: 回调
    func solveEquation(_ input: String, completion: @escaping (String?) -> Void) {
        // v3.0 TODO: 实现 LLM API 调用
        /*
        let prompt = """
        You are a math equation solver. Parse and solve the following equation.
        Return ONLY the solution in this JSON format:
        {"type": "linear|quadratic", "a": number, "b": number, "c": number, "solution": "x = value"}
        
        Equation: \(input)
        """
        
        OpenAIClient.shared.complete(prompt: prompt) { response in
            completion(parseJSON(response))
        }
        */
        
        print("🤖 LLM API 配置待完成")
        completion(nil)
    }
}
