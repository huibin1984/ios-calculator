import Foundation
import UIKit

/// 触觉反馈管理器 - 为所有操作提供物理确认感
class HapticFeedbackManager {
    
    /// 单例实例
    static let shared = HapticFeedbackManager()
    
    /// 是否启用触觉反馈
    private(set) var isEnabled: Bool = true
    
    /// 反馈强度 (0.5 - 2.0, 默认 1.0)
    var intensity: CGFloat = 1.0 {
        didSet {
            // 限制范围
            if intensity < 0.5 { intensity = 0.5 }
            if intensity > 2.0 { intensity = 2.0 }
        }
    }
    
    /// 初始化
    override init() {
        super.init()
        isEnabled = true
    }
    
    // MARK: - Feedback Types
    
    /// 轻触反馈 (用于普通按钮点击)
    func lightTap() {
        guard isEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactIntensity = intensity * 0.5
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 中等反馈 (用于运算符、等号)
    func mediumTap() {
        guard isEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactIntensity = intensity * 0.8
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 重击反馈 (用于模式切换、清除操作)
    func heavyTap() {
        guard isEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactIntensity = intensity
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 选择反馈 (用于模式切换、选项确认)
    func selectionChange() {
        guard isEnabled else { return }
        
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    /// 错误反馈 (用于无效操作、除以零等)
    func errorOccurred() {
        guard isEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationIntensity = intensity
        generator.prepare()
        generator.notificationOccurred(.error)
    }
    
    /// 成功反馈 (用于计算完成、存储成功等)
    func successOccurred() {
        guard isEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationIntensity = intensity * 0.8
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    /// 警告反馈 (用于重要提示)
    func warningOccurred() {
        guard isEnabled else { return }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationIntensity = intensity * 0.6
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
    
    // MARK: - Convenience Methods for Calculator
    
    /// 数字按钮点击
    func digitButtonTapped() {
        lightTap()
    }
    
    /// 运算符按钮点击
    func operatorButtonTapped() {
        mediumTap()
    }
    
    /// 等号按下 (计算完成)
    func equalsPressed() {
        heavyTap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.successOccurred()
        }
    }
    
    /// 清除操作
    func clearAction() {
        mediumTap()
    }
    
    /// 记忆功能操作
    func memoryOperation() {
        selectionChange()
    }
    
    /// 科学函数操作
    func scientificFunctionTapped() {
        lightTap()
    }
    
    /// 模式切换
    func modeSwitched() {
        heavyTap()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.selectionChange()
        }
    }
    
    /// 错误发生 (如除以零、无效输入)
    func calculationError() {
        errorOccurred()
    }
    
    // MARK: - Toggle
    
    /// 切换触觉反馈开关
    func toggle() {
        isEnabled.toggle()
    }
}
