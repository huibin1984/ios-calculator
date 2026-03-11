import SwiftUI

@main
struct CalculatorApp: App {
    // MARK: - App Initialization
    
    init() {
        initializeManagers()
    }
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onAppear {
                    AnalyticsManager.shared.track(.appOpen)
                }
        }
    }
    
    // MARK: - Initialize All Managers
    
    private func initializeManagers() {
        // 加载保存的状态
        OnboardingManager.shared.loadState()
        
        // 初始化主题
        ThemeManager.shared.loadSavedTheme()
        
        // 加载分析数据
        AnalyticsManager.shared.loadEvents()
        
        // 加载反馈数据
        FeedbackManager.shared.submitFeedback(rating: 0, message: "")  // This loads the history
        
        // 启动性能监控
        #if DEBUG
        PerformanceMonitor.shared.startMonitoring()
        #endif
        
        // 设置电池监控
        _ = BatteryMonitor.shared
        
        // 设置生命周期监控
        _ = AppLifecycleMonitor.shared
        
        print("✅ App 初始化完成")
    }
}

/// 主内容视图 - TabView 切换
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 计算器 Tab
            CalculatorView()
                .tabItem {
                    Label("计算器", systemImage: "calculator.fill")
                }
                .tag(0)
            
            // 方程求解器 Tab
            EquationSolverView()
                .tabItem {
                    Label("方程求解", systemImage: "function")
                }
                .tag(1)
            
            // 设置 Tab (v3.6)
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("设置", systemImage: "gearshape.fill")
            }
            .tag(2)
        }
        .accentColor(.orange)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
