import Foundation

/// 方程求解器 - 支持一元一次方程 (ax + b = c)
class EquationSolver {
    
    /// 方程类型
    enum EquationType: String {
        case linear = "线性"      // ax + b = c
        case quadratic = "二次"   // ax² + bx + c = 0
        
        var symbol: String { rawValue }
    }
    
    /// 求解结果
    struct Solution {
        let equationType: EquationType
        let solutions: [Decimal]
        let description: String
        
        init(type: EquationType, solutions: [Decimal], description: String) {
            self.equationType = type
            self.solutions = solutions
            self.description = description
        }
    }
    
    // MARK: - Linear Equation Solver (ax + b = c)
    
    /// 求解线性方程 ax + b = c
    /// - Parameters:
    ///   - a: x 的系数
    ///   - b: 常数项 (左侧)
    ///   - c: 等号右侧的值
    /// - Returns: 解的结果描述
    func solveLinear(a: Decimal, b: Decimal, c: Decimal) -> Solution? {
        guard a != 0 else {
            // a = 0 时，方程变为 b = c
            if b == c {
                return Solution(type: .linear, solutions: [], 
                              description: "无穷多解 (任意 x 都成立)")
            } else {
                return Solution(type: .linear, solutions: [], 
                              description: "无解")
            }
        }
        
        // x = (c - b) / a
        let x = (c - b) / a
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        
        if let aStr = formatter.string(from: NSDecimalNumber(decimal: a)),
           let bStr = formatter.string(from: NSDecimalNumber(decimal: b)),
           let cStr = formatter.string(from: NSDecimalNumber(decimal: c)),
           let xStr = formatter.string(from: NSDecimalNumber(decimal: x)) {
            
            return Solution(type: .linear, solutions: [x], 
                          description: "\(aStr)x + \(bStr) = \(cStr)\n解：x = \(xStr)")
        }
        
        return nil
    }
    
    /// 简化版线性方程求解 (ax = b)
    func solveSimpleLinear(a: Decimal, b: Decimal) -> Solution? {
        return solveLinear(a: a, b: 0, c: b)
    }
    
    // MARK: - Quadratic Equation Solver (ax² + bx + c = 0)
    
    /// 求解二次方程 ax² + bx + c = 0
    func solveQuadratic(a: Decimal, b: Decimal, c: Decimal) -> Solution? {
        guard a != 0 else {
            // 退化为线性方程
            return solveLinear(a: b, b: c, c: 0)
        }
        
        // 计算判别式 Δ = b² - 4ac
        let delta = (b * b) - (Decimal(4) * a * c)
        
        var solutions: [Decimal] = []
        var description = ""
        
        if delta > 0 {
            // 两个不同的实根
            let sqrtDelta = Decimal(string: String(sqrt(Double(delta))))!
            let x1 = (-b + sqrtDelta) / (Decimal(2) * a)
            let x2 = (-b - sqrtDelta) / (Decimal(2) * a)
            solutions = [x1, x2]
            
            description = "Δ > 0，有两个不同的实根\nx₁ = \(formatNumber(x1))\nx₂ = \(formatNumber(x2))"
        } else if delta == 0 {
            // 一个重根
            let x = -b / (Decimal(2) * a)
            solutions = [x]
            
            description = "Δ = 0，有一个重根\nx = \(formatNumber(x))"
        } else {
            // 无实根（在实数范围内）
            description = "Δ < 0，无实根（复数解暂不支持）"
        }
        
        return Solution(type: .quadratic, solutions: solutions, description: description)
    }
    
    // MARK: - Helper Methods
    
    private func formatNumber(_ number: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        
        if let string = formatter.string(from: NSDecimalNumber(decimal: number)) {
            return removeTrailingZeros(string)
        }
        
        return "0"
    }
    
    private func removeTrailingZeros(_ numberString: String) -> String {
        var result = numberString
        
        if let decimalRange = result.range(of: ".") {
            while result.last == "0" {
                result.removeLast()
            }
            
            if result.last == "." {
                result.removeLast()
            }
        }
        
        return result
    }
}
