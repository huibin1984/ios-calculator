import SwiftUI

/// 主题管理器 (v3.4)
class ThemeManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = ThemeManager()
    private init() {}
    
    // MARK: - Published Properties
    
    @Published var currentTheme: AppTheme = .dark
    @Published var colorScheme: ColorScheme = .dark
    
    // MARK: - Theme Definitions
    
    enum AppTheme: String, CaseIterable, Identifiable {
        case dark = "经典深色"
        case light = "简约浅色"
        case warmDark = "护眼暗色"
        case custom = "自定义"
        
        var id: String { rawValue }
        
        var background: Color {
            switch self {
            case .dark: return Color(hex: "000000")
            case .light: return Color(hex: "F5F5F5")
            case .warmDark: return Color(hex: "1A1410")
            case .custom: return Color(hex: "000000")
            }
        }
        
        var secondaryBackground: Color {
            switch self {
            case .dark: return Color(hex: "1C1C1E")
            case .light: return Color(hex: "FFFFFF")
            case .warmDark: return Color(hex: "2A2420")
            case .custom: return Color(hex: "1C1C1E")
            }
        }
        
        var primaryText: Color {
            switch self {
            case .dark, .custom: return Color.white
            case .light: return Color.black
            case .warmDark: return Color(hex: "E8D5C4")
            }
        }
        
        var secondaryText: Color {
            switch self {
            case .dark, .custom: return Color.white.opacity(0.7)
            case .light: return Color.black.opacity(0.7)
            case .warmDark: return Color(hex: "A89888")
            }
        }
        
        var operatorColor: Color {
            switch self {
            case .dark: return Color.orange
            case .light: return Color.orange
            case .warmDark: return Color(hex: "FF9500")
            case .custom: return Color.orange
            }
        }
        
        var numberColor: Color {
            switch self {
            case .dark, .custom: return Color.white
            case .light: return Color.black
            case .warmDark: return Color(hex: "E8D5C4")
            }
        }
        
        var functionColor: Color {
            switch self {
            case .dark: return Color.gray.opacity(0.3)
            case .light: return Color.gray.opacity(0.3)
            case .warmDark: return Color(hex: "3A3430")
            case .custom: return Color.gray.opacity(0.3)
            }
        }
        
        var accentColor: Color {
            switch self {
            case .dark: return Color.blue
            case .light: return Color.blue
            case .warmDark: return Color(hex: "007AFF")
            case .custom: return Color.blue
            }
        }
        
        var icon: String {
            switch self {
            case .dark: return "moon.fill"
            case .light: return "sun.max.fill"
            case .warmDark: return "eye.fill"
            case .custom: return "paintbrush.fill"
            }
        }
    }
    
    // MARK: - Custom Theme (for future)
    
    struct CustomThemeColors {
        var background: Color = .black
        var secondaryBackground: Color = Color(hex: "1C1C1E")
        var primaryText: Color = .white
        var secondaryText: Color = .white.opacity(0.7)
        var operatorColor: Color = .orange
        var numberColor: Color = .white
        var functionColor: Color = Color.gray.opacity(0.3)
        var accentColor: Color = .blue
    }
    
    @Published var customColors = CustomThemeColors()
    
    // MARK: - Public Methods
    
    /// 设置主题
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        
        switch theme {
        case .dark:
            colorScheme = .dark
        case .light:
            colorScheme = .light
        case .warmDark:
            colorScheme = .dark
        case .custom:
            colorScheme = .dark
        }
        
        // 保存设置
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }
    
    /// 跟随系统主题
    func followSystemTheme() {
        UserDefaults.standard.set("system", forKey: "selectedTheme")
    }
    
    /// 加载保存的主题
    func loadSavedTheme() {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") {
            if savedTheme == "system" {
                // 跟随系统
                return
            }
            
            if let theme = AppTheme(rawValue: savedTheme) {
                setTheme(theme)
            }
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Theme Preview Card

struct ThemePreviewCard: View {
    let theme: ThemeManager.AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // 预览
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.background)
                        .frame(height: 80)
                    
                    HStack(spacing: 8) {
                        // 数字按钮预览
                        Circle()
                            .fill(theme.functionColor)
                            .frame(width: 30, height: 30)
                        
                        Circle()
                            .fill(theme.numberColor.opacity(0.3))
                            .frame(width: 30, height: 30)
                        
                        Circle()
                            .fill(theme.operatorColor)
                            .frame(width: 30, height: 30)
                    }
                }
                
                // 主题名称
                HStack {
                    Image(systemName: theme.icon)
                        .foregroundColor(theme.accentColor)
                    
                    Text(theme.rawValue)
                        .font(.subheadline)
                        .foregroundColor(theme.primaryText)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(theme.accentColor)
                    }
                }
            }
            .padding(12)
            .background(theme.secondaryBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? theme.accentColor : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Theme Settings View

struct ThemeSettingsView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    @Environment(\.colorScheme) var systemColorScheme
    
    var body: some View {
        List {
            Section {
                ForEach(ThemeManager.AppTheme.allCases) { theme in
                    ThemePreviewCard(
                        theme: theme,
                        isSelected: themeManager.currentTheme == theme
                    ) {
                        themeManager.setTheme(theme)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            } header: {
                Text("选择主题")
            }
            
            Section {
                Button(action: {
                    themeManager.followSystemTheme()
                }) {
                    HStack {
                        Image(systemName: "gear")
                        Text("跟随系统")
                        Spacer()
                        if UserDefaults.standard.string(forKey: "selectedTheme") == "system" {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } header: {
                Text("自动")
            }
        }
        .navigationTitle("主题设置")
        .onAppear {
            themeManager.loadSavedTheme()
        }
    }
}

// MARK: - Theme Aware View Modifier

struct ThemeAware: ViewModifier {
    @ObservedObject var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.colorScheme)
    }
}

extension View {
    func themeAware() -> some View {
        modifier(ThemeAware())
    }
}
