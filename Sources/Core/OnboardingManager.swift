import SwiftUI

/// 新手引导管理器 (v3.4)
class OnboardingManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = OnboardingManager()
    private init() {}
    
    // MARK: - Published Properties
    
    @Published var currentStep: OnboardingStep = .welcome
    @Published var isOnboardingComplete: Bool = false
    @Published var isActive: Bool = false
    
    // MARK: - Configuration
    
    /// 引导步骤
    enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case basicMode = 1
        case voiceInput = 2
        case scientificMode = 3
        case equationSolver = 4
        case completion = 5
        
        var title: String {
            switch self {
            case .welcome: return "欢迎使用"
            case .basicMode: return "基础计算"
            case .voiceInput: return "语音输入"
            case .scientificMode: return "科学计算"
            case .equationSolver: return "方程求解"
            case .completion: return "完成"
            }
        }
        
        var description: String {
            switch self {
            case .welcome:
                return "一款支持语音交互的智能计算器"
            case .basicMode:
                return "点击数字和运算符进行基础计算"
            case .voiceInput:
                return "点击麦克风图标，说出你要计算的表达式"
            case .scientificMode:
                return "切换到科学模式，使用高级数学函数"
            case .equationSolver:
                return "解方程从未如此简单"
            case .completion:
                return "准备开始使用！"
            }
        }
        
        var systemImage: String {
            switch self {
            case .welcome: return "hand.wave.fill"
            case .basicMode: return "calculator"
            case .voiceInput: return "mic.fill"
            case .scientificMode: return "function"
            case .equationSolver: return "x.squareroot"
            case .completion: return "checkmark.circle.fill"
            }
        }
        
        var targetView: TargetView? {
            switch self {
            case .welcome: return nil
            case .basicMode: return .button(number: "7")
            case .voiceInput: return .button(identifier: "voiceInput")
            case .scientificMode: return .button(identifier: "modeToggle")
            case .equationSolver: return .tabBar
            case .completion: return nil
            }
        }
    }
    
    enum TargetView {
        case button(number: String)
        case button(identifier: String)
        case tabBar
    }
    
    // MARK: - User Defaults Keys
    
    private let onboardingCompleteKey = "onboardingComplete"
    private let lastShownStepKey = "onboardingLastStep"
    
    // MARK: - Public Methods
    
    /// 检查是否需要显示引导
    func shouldShowOnboarding() -> Bool {
        return !isOnboardingComplete
    }
    
    /// 开始引导
    func startOnboarding() {
        isActive = true
        currentStep = .welcome
    }
    
    /// 结束引导
    func completeOnboarding() {
        isActive = false
        isOnboardingComplete = true
        UserDefaults.standard.set(true, forKey: onboardingCompleteKey)
        currentStep = .completion
    }
    
    /// 跳过引导
    func skipOnboarding() {
        isActive = false
        isOnboardingComplete = true
        UserDefaults.standard.set(true, forKey: onboardingCompleteKey)
    }
    
    /// 进入下一步
    func nextStep() {
        if let nextIndex = OnboardingStep(rawValue: currentStep.rawValue + 1) {
            currentStep = nextIndex
            UserDefaults.standard.set(nextIndex.rawValue, forKey: lastShownStepKey)
        } else {
            completeOnboarding()
        }
    }
    
    /// 返回上一步
    func previousStep() {
        if let prevIndex = OnboardingStep(rawValue: currentStep.rawValue - 1) {
            currentStep = prevIndex
        }
    }
    
    /// 重置引导（用于测试）
    func resetOnboarding() {
        isOnboardingComplete = false
        isActive = false
        currentStep = .welcome
        UserDefaults.standard.set(false, forKey: onboardingCompleteKey)
    }
    
    /// 加载保存的状态
    func loadState() {
        isOnboardingComplete = UserDefaults.standard.bool(forKey: onboardingCompleteKey)
    }
}

// MARK: - Onboarding Views

/// 引导覆盖层
struct OnboardingOverlay: View {
    @ObservedObject var manager = OnboardingManager.shared
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    // 点击背景不关闭
                }
            
            // 引导卡片
            VStack(spacing: 24) {
                // 进度指示器
                HStack(spacing: 8) {
                    ForEach(0..<OnboardingManager.OnboardingStep.allCases.count - 1, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(index <= manager.currentStep.rawValue ? Color.blue : Color.gray.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 32)
                
                // 图标
                Image(systemName: manager.currentStep.systemImage)
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                // 标题
                Text(manager.currentStep.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                // 描述
                Text(manager.currentStep.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // 操作按钮
                HStack(spacing: 16) {
                    if manager.currentStep != .welcome && manager.currentStep != .completion {
                        Button("跳过") {
                            manager.skipOnboarding()
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Button(manager.currentStep == .completion ? "开始使用" : "下一步") {
                        if manager.currentStep == .completion {
                            manager.completeOnboarding()
                            onComplete()
                        } else {
                            manager.nextStep()
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(25)
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemBackground))
            )
            .padding(.horizontal, 24)
        }
    }
}

/// 教练标记 (Coach Mark) - 引导用户关注特定元素
struct CoachMarkView: View {
    let message: String
    let arrowDirection: ArrowDirection
    let onDismiss: () -> Void
    
    enum ArrowDirection {
        case top, bottom, left, right
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // 箭头
            if arrowDirection == .bottom {
                Triangle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 10)
                    .offset(y: 1)
            }
            
            // 消息气泡
            HStack {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button("知道了") {
                    onDismiss()
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))
            }
            .padding(12)
            .background(Color.blue)
            .cornerRadius(12)
            
            // 箭头
            if arrowDirection == .top {
                Triangle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 10)
                    .rotationEffect(.degrees(180))
                    .offset(y: -1)
            }
        }
    }
}

/// 三角形用于教练标记箭头
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

/// 新手引导入口按钮
struct OnboardingButton: View {
    @ObservedObject var manager = OnboardingManager.shared
    
    var body: some View {
        Button(action: {
            manager.startOnboarding()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                Text("引导")
            }
            .font(.caption)
            .foregroundColor(.white)
            .padding(8)
            .background(Color.blue.opacity(0.7))
            .cornerRadius(10)
        }
    }
}
