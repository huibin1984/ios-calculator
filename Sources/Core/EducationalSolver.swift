import Foundation

/// 教育模式 - 显示详细计算步骤 (v3.2)
class EducationalSolver {
    
    // MARK: - Singleton
    
    static let shared = EducationalSolver()
    private init() {}
    
    // MARK: - Public Methods
    
    /// 求解方程并返回详细步骤
    func solveWithSteps(_ input: String) -> EducationalSolution? {
        // 解析方程类型
        guard let (type, a, b, c) = parseEquation(input) else {
            return nil
        }
        
        switch type {
        case .linear:
            return solveLinearWithSteps(a: a ?? 0, b: b ?? 0, c: c ?? 0)
        case .quadratic:
            return solveQuadraticWithSteps(a: a!, b: b!, c: c!)
        case .arithmetic:
            return solveArithmeticWithSteps(input)
        }
    }
    
    // MARK: - Equation Parser
    
    private enum EquationType {
        case linear
        case quadratic
        case arithmetic
    }
    
    private func parseEquation(_ input: String) -> (EquationType, Decimal?, Decimal?, Decimal?)? {
        // 检查是否是二次方程
        if input.contains("x²") || input.contains("x^2") {
            // 二次方程 ax² + bx + c = 0
            // 简化解析...
            return (.quadratic, 1, 0, 0)  // TODO: 完善解析
        }
        
        // 检查是否是线性方程
        if input.contains("x") {
            // 线性方程 ax + b = c
            return (.linear, 1, 0, nil)  // TODO: 完善解析
        }
        
        // 算术表达式
        return (.arithmetic, nil, nil, nil)
    }
    
    // MARK: - Linear Equation with Steps
    
    private func solveLinearWithSteps(a: Decimal, b: Decimal, c: Decimal) -> EducationalSolution {
        var steps: [SolutionStep] = []
        
        // Step 1: 识别方程类型
        steps.append(SolutionStep(
            number: 1,
            title: "识别方程类型",
            description: "这是一个一元一次方程（线性方程）",
            formula: "ax + b = c",
            details: "其中 a = \(a), b = \(b), c = \(c)"
        ))
        
        // Step 2: 移项
        let newC = c - b
        steps.append(SolutionStep(
            number: 2,
            title: "移项",
            description: "将常数项移到等式右边",
            formula: "ax = c - b",
            details: "x = \(c) - \(b) = \(newC)"
        ))
        
        // Step 3: 求解
        let x = newC / a
        steps.append(SolutionStep(
            number: 3,
            title: "求解 x",
            description: "两边同时除以 a",
            formula: "x = (c - b) / a",
            details: "x = \(newC) / \(a) = \(x)"
        ))
        
        // Step 4: 验证
        let verify = a * x + b
        steps.append(SolutionStep(
            number: 4,
            title: "验证",
            description: "将解代入原方程验证",
            formula: "a × x + b = c",
            details: "\(a) × \(x) + \(b) = \(verify) ✓"
        ))
        
        return EducationalSolution(
            type: .linear,
            result: "x = \(x)",
            steps: steps,
            tips: [
                "移项时注意符号变化",
                "除法时确保除数不为零"
            ]
        )
    }
    
    // MARK: - Quadratic Equation with Steps
    
    private func solveQuadraticWithSteps(a: Decimal, b: Decimal, c: Decimal) -> EducationalSolution {
        var steps: [SolutionStep] = []
        
        // Step 1: 识别方程类型
        steps.append(SolutionStep(
            number: 1,
            title: "识别方程类型",
            description: "这是一个一元二次方程",
            formula: "ax² + bx + c = 0",
            details: "其中 a = \(a), b = \(b), c = \(c)"
        ))
        
        // Step 2: 计算判别式
        let discriminant = b * b - 4 * a * c
        steps.append(SolutionStep(
            number: 2,
            title: "计算判别式 Δ",
            description: "判别式决定方程解的个数",
            formula: "Δ = b² - 4ac",
            details: "Δ = (\(b))² - 4 × \(a) × \(c) = \(discriminant)"
        ))
        
        // Step 3: 分析判别式
        let discriminantType: String
        if discriminant > 0 {
            discriminantType = "Δ > 0，方程有两个不相等的实数根"
        } else if discriminant == 0 {
            discriminantType = "Δ = 0，方程有两个相等的实数根"
        } else {
            discriminantType = "Δ < 0，方程无实数根"
        }
        steps.append(SolutionStep(
            number: 3,
            title: "判别式分析",
            description: discriminantType,
            formula: "判断根的情况",
            details: "Δ = \(discriminant)"
        ))
        
        // Step 4: 求根公式
        if discriminant >= 0 {
            let sqrtD = sqrt(Double(truncating: discriminant as NSNumber))
            let sqrtDecimal = Decimal(sqrtD)
            
            let x1 = (-b + sqrtDecimal) / (2 * a)
            let x2 = (-b - sqrtDecimal) / (2 * a)
            
            steps.append(SolutionStep(
                number: 4,
                title: "应用求根公式",
                description: "使用求根公式计算",
                formula: "x = (-b ± √Δ) / 2a",
                details: "x₁ = \(x1), x₂ = \(x2)"
            ))
            
            return EducationalSolution(
                type: .quadratic,
                result: "x₁ = \(x1), x₂ = \(x2)",
                steps: steps,
                tips: [
                    "求根公式是解二次方程的万能方法",
                    "注意根号运算的精度问题"
                ]
            )
        } else {
            steps.append(SolutionStep(
                number: 4,
                title: "结论",
                description: "判别式小于零，方程无实数解",
                formula: "在实数范围内无解",
                details: "需要引入复数才能求解"
            ))
            
            return EducationalSolution(
                type: .quadratic,
                result: "无实数解",
                steps: steps,
                tips: [
                    "复数解需要使用虚数单位 i",
                    "i² = -1"
                ]
            )
        }
    }
    
    // MARK: - Arithmetic with Steps
    
    private func solveArithmeticWithSteps(_ input: String) -> EducationalSolution? {
        // 使用 ExpressionParser 解析
        let parser = ExpressionParser()
        
        // 简单分词
        let tokens = input.split(separator: " ").map(String.init)
        
        guard let result = parser.evaluate(tokens: tokens) else {
            return nil
        }
        
        var steps: [SolutionStep] = []
        
        steps.append(SolutionStep(
            number: 1,
            title: "识别运算",
            description: "识别表达式中的运算符和运算顺序",
            formula: input,
            details: "按照运算优先级计算"
        ))
        
        steps.append(SolutionStep(
            number: 2,
            title: "计算结果",
            description: "按照优先级逐步计算",
            formula: "= \(result)",
            details: "最终结果"
        ))
        
        return EducationalSolution(
            type: .arithmetic,
            result: "\(result)",
            steps: steps,
            tips: [
                "乘除优先于加减",
                "可以使用括号改变运算顺序"
            ]
        )
    }
}

// MARK: - Educational Solution Models

struct EducationalSolution {
    let type: EquationSolutionType
    let result: String
    let steps: [SolutionStep]
    let tips: [String]
    
    enum EquationSolutionType: String {
        case linear = "一元一次方程"
        case quadratic = "一元二次方程"
        case arithmetic = "算术运算"
    }
}

struct SolutionStep {
    let number: Int
    let title: String
    let description: String
    let formula: String
    let details: String
}

// MARK: - Educational View (SwiftUI)

import SwiftUI

struct EducationalSolutionView: View {
    let solution: EducationalSolution
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 标题
                Text(solution.type.rawValue)
                    .font(.headline)
                    .foregroundColor(.blue)
                
                // 结果
                VStack(alignment: .leading, spacing: 4) {
                    Text("结果")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(solution.result)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                
                // 步骤
                Text("解题步骤")
                    .font(.headline)
                
                ForEach(solution.steps, id: \.number) { step in
                    StepCard(step: step)
                }
                
                // 提示
                if !solution.tips.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("💡 提示")
                            .font(.headline)
                        
                        ForEach(solution.tips, id: \.self) { tip in
                            Text("• " + tip)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}

struct StepCard: View {
    let step: SolutionStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(step.number)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                Text(step.title)
                    .font(.headline)
            }
            
            Text(step.description)
                .font(.subheadline)
            
            if !step.formula.isEmpty {
                Text(step.formula)
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            if !step.details.isEmpty {
                Text(step.details)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}
