import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// 主内容视图 - 在计算器和方程求解器之间切换
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CalculatorView()
                .tabItem {
                    Label("计算器", systemImage: "calculator")
                }
                .tag(0)
            
            EquationSolverView()
                .tabItem {
                    Label("方程求解", systemImage: "function")
                }
                .tag(1)
        }
    }
}
