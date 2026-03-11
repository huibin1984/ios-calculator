import Foundation

/// 计算器 <-> 方程求解器 桥接 ViewModel (v2.4 + v2.6 Navigation)
class CalculatorSolverBridgeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 当前从计算器接收到的结果值
    @Published var lastCalculatorResult: String = ""
    
    /// 是否正在传递数据
    @Published var isTransferringData: Bool = false
    
    /// 桥接状态消息
    @Published var bridgeStatusMessage: String = ""
    
    // v2.6: Navigation State
    @Published var activeTab: Int = 0  // 0=Calculator, 1=EquationSolver
    
    // MARK: - Private Properties
    
    private let hapticManager: HapticFeedbackManager
    
    // MARK: - Initialization
    
    init(hapticManager: HapticFeedbackManager = HapticFeedbackManager.shared) {
        self.hapticManager = hapticManager
    }
    
    // MARK: - Bridge Actions (v2.4 + v2.6)
    
    /// 从计算器发送结果到方程求解器 (v2.4 + v2.6 Navigation)
    @MainActor
    func sendToEquationSolver(calculatorResult: String) {
        guard !calculatorResult.isEmpty else { return }
        
        isTransferringData = true
        lastCalculatorResult = calculatorResult
        
        // 模拟数据传递 (实际项目中需要更复杂的导航和数据持久化)
        bridgeStatusMessage = "正在发送到方程求解器..."
        hapticManager.success()
        
        // v2.6: 自动切换到方程标签页
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.activeTab = 1  // Switch to Equation Solver tab
            
            // 延迟更新状态，给用户反馈
            self.bridgeStatusMessage = "✓ 已发送到方程求解器：\(calculatorResult)"
            self.isTransferringData = false
        }
    }
    
    /// 从方程求解器返回计算器 (v2.6)
    @MainActor
    func returnToCalculator() {
        activeTab = 0  // Switch back to Calculator tab
    }
    
    /// 从方程求解器接收数据回计算器 (未来扩展)
    func receiveFromEquationSolver(_ equationResult: String) {
        bridgeStatusMessage = "收到方程结果：\(equationResult)"
        hapticManager.success()
    }
}
