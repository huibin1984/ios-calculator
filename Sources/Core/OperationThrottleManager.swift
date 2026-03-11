import Foundation

/// 操作节流管理器 - 优化快速连续操作的性能 (v3.4)
class OperationThrottleManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = OperationThrottleManager()
    private init() {}
    
    // MARK: - Configuration
    
    struct ThrottleConfig {
        var minInterval: TimeInterval = 0.1  // 最小操作间隔 (100ms)
        var skipThreshold: TimeInterval = 0.2 // 跳过动画阈值 (200ms)
    }
    
    var config = ThrottleConfig()
    
    // MARK: - State
    
    private var lastOperationTime: [String: Date] = [:]
    private var operationCounts: [String: Int] = [:]
    
    // MARK: - Public Methods
    
    /// 检查是否可以执行操作
    /// - Parameter identifier: 操作标识符
    /// - Returns: 是否可以执行
    func canExecute(identifier: String) -> Bool {
        let now = Date()
        
        guard let lastTime = lastOperationTime[identifier] else {
            lastOperationTime[identifier] = now
            operationCounts[identifier] = 1
            return true
        }
        
        let elapsed = now.timeIntervalSince(lastTime)
        
        if elapsed >= config.minInterval {
            lastOperationTime[identifier] = now
            operationCounts[identifier] = (operationCounts[identifier] ?? 0) + 1
            return true
        }
        
        return false
    }
    
    /// 获取当前操作速度（操作/秒）
    func getOperationSpeed(identifier: String) -> Double {
        let count = operationCounts[identifier] ?? 0
        guard let lastTime = lastOperationTime[identifier] else { return 0 }
        
        let elapsed = Date().timeIntervalSince(lastTime)
        guard elapsed > 0 else { return 0 }
        
        return Double(count) / elapsed
    }
    
    /// 是否应该播放完整动画
    func shouldPlayFullAnimation(identifier: String) -> Bool {
        let speed = getOperationSpeed(identifier: identifier)
        return speed < 5.0 // 每秒少于 5 次操作时播放完整动画
    }
    
    /// 是否应该跳过动画
    func shouldSkipAnimation(identifier: String) -> Bool {
        let speed = getOperationSpeed(identifier: identifier)
        return speed > 10.0 // 每秒多于 10 次操作时跳过动画
    }
    
    /// 重置计数器
    func reset(identifier: String) {
        lastOperationTime[identifier] = nil
        operationCounts[identifier] = nil
    }
    
    /// 重置所有计数器
    func resetAll() {
        lastOperationTime.removeAll()
        operationCounts.removeAll()
    }
}

// MARK: - Operation Debouncer

/// 操作防抖管理器 - 用于搜索等需要延迟执行的场景
class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    
    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }
    
    func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        
        workItem = DispatchWorkItem(block: action)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
    
    func cancel() {
        workItem?.cancel()
    }
}

// MARK: - Animation Controller

/// 动画控制器 - 根据操作速度动态调整动画
class AnimationController: ObservableObject {
    static let shared = AnimationController()
    
    @Published var animationDuration: Double = 0.3  // 默认动画时长
    @Published var shouldReduceMotion: Bool = false
    
    private let throttleManager = OperationThrottleManager.shared
    private let batteryMonitor = BatteryMonitor.shared
    
    private init() {
        updateAnimationSettings()
    }
    
    /// 更新动画设置
    func updateAnimationSettings() {
        // 根据操作速度调整
        let speed = throttleManager.getOperationSpeed(identifier: "button_tap")
        
        if throttleManager.shouldSkipAnimation(identifier: "button_tap") {
            animationDuration = 0.05 // 几乎无动画
            shouldReduceMotion = true
        } else if throttleManager.shouldPlayFullAnimation(identifier: "button_tap") {
            animationDuration = 0.3 // 完整动画
            shouldReduceMotion = false
        } else {
            animationDuration = 0.15 // 简化动画
        }
        
        // 根据电池状态调整
        if batteryMonitor.shouldReduceAnimations() {
            animationDuration = min(animationDuration, 0.15)
            shouldReduceMotion = true
        }
        
        if batteryMonitor.shouldDisableHaptics() {
            // 可以在这里禁用触觉反馈
        }
    }
    
    /// 获取适合的动画时长
    func getAnimationDuration(for type: AnimationType) -> Double {
        switch type {
        case .buttonPress:
            return animationDuration * 0.5
        case .displayUpdate:
            return animationDuration * 0.3
        case .pageTransition:
            return animationDuration
        case .spring:
            return animationDuration * 1.5
        }
    }
    
    enum AnimationType {
        case buttonPress
        case displayUpdate
        case pageTransition
        case spring
    }
}
