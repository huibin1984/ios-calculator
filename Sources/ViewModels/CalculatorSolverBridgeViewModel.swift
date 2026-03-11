import Foundation

/// 计算器 <-> 方程求解器 桥接 ViewModel (v2.4)
class CalculatorSolverBridgeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 当前从计算器接收到的结果值
    @Published var lastCalculatorResult: String = ""
    
    /// 是否正在传递数据
    @Published var isTransferringData: Bool = false
    
    /// 桥接状态消息
    @Published var bridgeStatusMessage: String = ""
    
    // MARK: - Private Properties
    
    private let hapticManager: HapticManager
    
    // MARK: - Initialization
    
    init(hapticManager: HapticManager = HapticManager.shared) {
        self.hapticManager = hapticManager
    }
    
    // MARK: - Bridge Actions
    
    /// 从计算器发送结果到方程求解器 (v2.4)
    @MainActor
    func sendToEquationSolver(calculatorResult: String) {
        guard !calculatorResult.isEmpty else { return }
        
        isTransferringData = true
        lastCalculatorResult = calculatorResult
        
        // 模拟数据传递 (实际项目中需要更复杂的导航和数据持久化)
        bridgeStatusMessage = "正在发送到方程求解器..."
        hapticManager.success()
        
        // 延迟更新状态，给用户反馈
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.bridgeStatusMessage = "✓ 已发送到方程求解器：\(calculatorResult)"
            self.isTransferringData = false
        }
    }
    
    /// 从方程求解器接收数据回计算器 (未来扩展)
    func receiveFromEquationSolver(_ equationResult: String) {
        bridgeStatusMessage = "收到方程结果：\(equationResult)"
        hapticManager.success()
    }
}
