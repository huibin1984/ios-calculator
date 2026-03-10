import Foundation
import Combine

/// 方程求解器视图模型
class EquationSolverViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var equationType: String = "线性"
    @Published var coefficientA: String = ""
    @Published var coefficientB: String = ""
    @Published var constantC: String = ""
    @Published var solutionText: String = ""
    @Published var isSolving: Bool = false
    
    // MARK: - Private Properties
    
    private let solver: EquationSolver
    
    // MARK: - Initialization
    
    init(solver: EquationSolver = EquationSolver()) {
        self.solver = solver
    }
    
    // MARK: - Public Methods
    
    /// 求解方程
    func solve() {
        isSolving = true
        
        guard let a = Decimal(string: coefficientA),
              let b = Decimal(string: coefficientB) else {
            solutionText = "请输入有效的系数"
            isSolving = false
            return
        }
        
        var result: EquationSolver.Solution?
        
        if equationType == "线性" {
            // ax + b = c 或 ax = b (如果 C 为空)
            let c = constantC.isEmpty ? Decimal(0) : Decimal(string: constantC) ?? Decimal(0)
            
            if constantC.isEmpty {
                result = solver.solveSimpleLinear(a: a, b: b)
            } else {
                result = solver.solveLinear(a: a, b: b, c: c!)
            }
        } else if equationType == "二次" {
            // ax² + bx + c = 0
            let c = constantC.isEmpty ? Decimal(0) : Decimal(string: constantC) ?? Decimal(0)
            result = solver.solveQuadratic(a: a, b: b, c: c)
        }
        
        if let result = result {
            solutionText = result.description
        } else {
            solutionText = "求解失败，请检查输入"
        }
        
        isSolving = false
    }
    
    /// 清除所有输入
    func clearAll() {
        coefficientA = ""
        coefficientB = ""
        constantC = ""
        solutionText = ""
    }
    
    /// 切换方程类型
    func toggleEquationType() {
        if equationType == "线性" {
            equationType = "二次"
        } else {
            equationType = "线性"
        }
        clearAll()
    }
}
