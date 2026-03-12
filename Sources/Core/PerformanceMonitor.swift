import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// 性能监控管理器 (v3.4)
class PerformanceMonitor: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = PerformanceMonitor()
    private init() {}
    
    // MARK: - Published Properties
    
    @Published var fps: Double = 60.0
    @Published var memoryUsage: Double = 0.0  // MB
    @Published var cpuUsage: Double = 0.0   // %
    @Published var isMonitoring: Bool = false
    
    // MARK: - Private Properties
    
    #if os(iOS)
    private var displayLink: CADisplayLink?
    #endif
    private var frameCount: Int = 0
    private var lastFrameTime: CFTimeInterval = 0
    private var monitoringTimer: Timer?
    
    // MARK: - Configuration
    
    struct Thresholds {
        var fpsWarning: Double = 50.0
        var fpsCritical: Double = 30.0
        var memoryWarning: Double = 100.0  // MB
        var memoryCritical: Double = 200.0 // MB
    }
    
    var thresholds = Thresholds()
    
    // MARK: - Public Methods
    
    /// 开始监控
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        
        #if os(iOS)
        // FPS 监控
        displayLink = CADisplayLink(target: self, selector: #selector(updateFPS))
        displayLink?.add(to: .main, forMode: .common)
        #endif
        
        // 内存/CPU 监控 (每 1 秒)
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMemoryAndCPU()
        }
    }
    
    /// 停止监控
    func stopMonitoring() {
        isMonitoring = false
        #if os(iOS)
        displayLink?.invalidate()
        displayLink = nil
        #endif
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }
    
    /// 获取性能报告
    func getPerformanceReport() -> PerformanceReport {
        return PerformanceReport(
            fps: fps,
            memoryUsage: memoryUsage,
            cpuUsage: cpuUsage,
            timestamp: Date()
        )
    }
    
    // MARK: - Private Methods
    
    #if os(iOS)
    @objc private func updateFPS() {
        frameCount += 1
        
        let currentTime = CACurrentMediaTime()
        
        if lastFrameTime == 0 {
            lastFrameTime = currentTime
            return
        }
        
        let elapsed = currentTime - lastFrameTime
        
        if elapsed >= 1.0 {
            fps = Double(frameCount) / elapsed
            frameCount = 0
            lastFrameTime = currentTime
            
            // 检查阈值
            checkThresholds()
        }
    }
    #endif
    
    private func updateMemoryAndCPU() {
        // 内存使用
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            memoryUsage = Double(info.resident_size) / 1024 / 1024
        }
        
        // CPU 使用（简化计算）
        cpuUsage = Double.random(in: 5...25) // 模拟值，实际需要更复杂计算
    }
    
    private func checkThresholds() {
        if fps < thresholds.fpsCritical {
            print("⚠️ 性能警告: FPS 过低 (\(Int(fps)))")
        }
        
        if memoryUsage > thresholds.memoryCritical {
            print("⚠️ 性能警告: 内存使用过高 (\(Int(memoryUsage)) MB)")
        }
    }
}

// MARK: - Performance Report

struct PerformanceReport {
    let fps: Double
    let memoryUsage: Double
    let cpuUsage: Double
    let timestamp: Date
    
    var status: Status {
        if fps < 30 || memoryUsage > 200 {
            return .critical
        } else if fps < 50 || memoryUsage > 100 {
            return .warning
        }
        return .good
    }
    
    enum Status {
        case good
        case warning
        case critical
    }
}

// MARK: - App Lifecycle Monitor

class AppLifecycleMonitor: ObservableObject {
    static let shared = AppLifecycleMonitor()
    
    #if os(iOS)
    @Published var appState: UIApplication.State = .inactive
    #else
    @Published var appState: Int = 0
    #endif
    @Published var isInBackground: Bool = false
    
    private init() {
        setupObservers()
    }
    
    private func setupObservers() {
        #if os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        #endif
    }
    
    @objc private func appDidBecomeActive() {
        #if os(iOS)
        appState = .active
        #endif
        isInBackground = false
        
        // 恢复语音队列
        VoiceQueueManager.shared.resume()
    }
    
    @objc private func appDidEnterBackground() {
        isInBackground = true
        
        // 暂停语音播报
        VoiceQueueManager.shared.pause()
    }
    
    @objc private func appWillResignActive() {
        #if os(iOS)
        appState = .inactive
        #endif
    }
}

// MARK: - Battery Monitor

class BatteryMonitor: ObservableObject {
    static let shared = BatteryMonitor()
    
    @Published var batteryLevel: Double = 1.0
    @Published var isCharging: Bool = false
    #if os(iOS)
    @Published var batteryState: UIDevice.BatteryState = .unknown
    #else
    @Published var batteryState: Int = 0
    #endif
    
    private init() {
        #if os(iOS)
        UIDevice.current.isBatteryMonitoringEnabled = true
        #endif
        updateBatteryInfo()
        
        #if os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        #endif
    }
    
    @objc private func batteryLevelDidChange() {
        updateBatteryInfo()
    }
    
    @objc private func batteryStateDidChange() {
        updateBatteryInfo()
    }
    
    private func updateBatteryInfo() {
        #if os(iOS)
        batteryLevel = Double(UIDevice.current.batteryLevel)
        batteryState = UIDevice.current.batteryState
        isCharging = batteryState == .charging || batteryState == .full
        #else
        batteryLevel = 1.0
        isCharging = true
        #endif
    }
    
    /// 根据电池状态调整功能
    func shouldReduceAnimations() -> Bool {
        return batteryLevel < 0.2 && !isCharging
    }
    
    func shouldDisableHaptics() -> Bool {
        return batteryLevel < 0.1 && !isCharging
    }
}
