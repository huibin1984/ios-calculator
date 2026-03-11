import Foundation

/// 通用工具函数库 (v3.5)
struct CalculatorUtils {
    
    // MARK: - Number Formatting
    
    /// 格式化数字显示
    static func formatNumber(_ number: Decimal, maxDecimalPlaces: Int = 10) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maxDecimalPlaces
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: number as NSDecimalNumber) ?? "\(number)"
    }
    
    /// 简化大数字显示 (如 1,000,000 → 1M)
    static func formatCompact(_ number: Decimal) -> String {
        let n = NSDecimalNumber(decimal: number).doubleValue
        
        if n >= 1_000_000_000 {
            return String(format: "%.1fB", n / 1_000_000_000)
        } else if n >= 1_000_000 {
            return String(format: "%.1fM", n / 1_000_000)
        } else if n >= 1_000 {
            return String(format: "%.1fK", n / 1_000)
        }
        
        return formatNumber(number)
    }
    
    // MARK: - Date/Time Formatting
    
    /// 格式化时间戳
    static func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    /// 相对时间显示 (如 "刚刚", "5分钟前")
    static func formatRelativeTime(_ date: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        if interval < 60 {
            return "刚刚"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)分钟前"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)小时前"
        } else {
            return formatTimestamp(date)
        }
    }
    
    // MARK: - String Utilities
    
    /// 检查字符串是否为空
    static func isEmpty(_ string: String?) -> Bool {
        return string?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
    
    /// 安全转换为字符串
    static func toString(_ any: Any?) -> String {
        guard let any = any else { return "" }
        return String(describing: any)
    }
    
    // MARK: - Array Utilities
    
    /// 安全获取数组元素
    static func safeArrayElement<T>(_ array: [T], at index: Int) -> T? {
        guard index >= 0 && index < array.count else { return nil }
        return array[index]
    }
    
    /// 数组分组
    static func groupBy<T, K>(_ array: [T], keyPath: KeyPath<T, K>) -> [K: [T]] {
        return Dictionary(grouping: array) { $0[keyPath: keyPath] }
    }
}

// MARK: - UserDefaults Keys

struct UserDefaultsKeys {
    static let voiceEnabled = "voiceEnabled"
    static let voiceLanguage = "voiceLanguage"
    static let voiceRate = "voiceRate"
    static let theme = "selectedTheme"
    static let onboardingComplete = "onboardingComplete"
    static let historyLimit = "historyLimit"
    static let isPremiumUnlocked = "isPremiumUnlocked"
    
    private init() {}
}

// MARK: - Notification Names

extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
    static let voiceSettingsDidChange = Notification.Name("voiceSettingsDidChange")
    static let historyDidUpdate = Notification.Name("historyDidUpdate")
    static let premiumStatusDidChange = Notification.Name("premiumStatusDidChange")
}

// MARK: - App Constants

struct AppConstants {
    struct Calculator {
        static let maxDigits = 12
        static let maxMemoryDigits = 10
        static let defaultDecimalPlaces = 2
    }
    
    struct Voice {
        static let defaultLanguage = "zh-CN"
        static let defaultRate: Float = 0.9
        static let duplicateFilterInterval: TimeInterval = 2.0
    }
    
    struct History {
        static let defaultLimit = 10
        static let maxLimit = 50
        static let freeLimit = 10
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let shortDuration: Double = 0.15
        static let longDuration: Double = 0.5
    }
    
    private init() {}
}
