import Foundation

/// 用户行为分析系统 (v3.6)
class AnalyticsManager {
    
    // MARK: - Singleton
    
    static let shared = AnalyticsManager()
    private init() {}
    
    // MARK: - Events
    
    enum Event: String {
        // 核心功能使用
        case appOpen = "app_open"
        case calculation = "calculation"
        case voiceInput = "voice_input"
        case equationSolve = "equation_solve"
        
        // 用户操作
        case buttonTap = "button_tap"
        case historyView = "history_view"
        case settingsOpen = "settings_open"
        
        // 商业化
        case purchaseAttempt = "purchase_attempt"
        case purchaseSuccess = "purchase_success"
        
        // 错误
        case error = "error"
        case crash = "crash"
    }
    
    // MARK: - Properties
    
    private var events: [AnalyticsEvent] = []
    private let maxEvents = 1000
    
    struct AnalyticsEvent: Codable {
        let event: String
        let timestamp: Date
        let parameters: [String: String]?
    }
    
    // MARK: - Methods
    
    func track(_ event: Event, parameters: [String: String]? = nil) {
        let analyticsEvent = AnalyticsEvent(
            event: event.rawValue,
            timestamp: Date(),
            parameters: parameters
        )
        
        events.append(analyticsEvent)
        
        // 保持事件数量在限制内
        if events.count > maxEvents {
            events.removeFirst()
        }
        
        #if DEBUG
        print("📊 [Analytics] \(event.rawValue)")
        #endif
    }
    
    // MARK: - Statistics
    
    func getEventCount(for event: Event) -> Int {
        return events.filter { $0.event == event.rawValue }.count
    }
    
    func getTodayEventCount(for event: Event) -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return events.filter { $0.event == event.rawValue && $0.timestamp >= today }.count
    }
    
    func getMostUsedFunctions() -> [(Event, Int)] {
        var counts: [String: Int] = [:]
        
        for event in events {
            counts[event.event, default: 0] += 1
        }
        
        return counts
            .map { (Event(rawValue: $0.key) ?? .error, $0.value) }
            .sorted { $0.1 > $1.1 }
    }
    
    func getUsageReport() -> UsageReport {
        let totalCalculations = getEventCount(for: .calculation)
        let totalVoiceInput = getEventCount(for: .voiceInput)
        let totalEquationSolve = getEventCount(for: .equationSolve)
        
        return UsageReport(
            totalCalculations: totalCalculations,
            totalVoiceInput: totalVoiceInput,
            totalEquationSolve: totalEquationSolve,
            lastUpdated: Date()
        )
    }
    
    // MARK: - Persistence
    
    func saveEvents() {
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: "analytics_events")
        }
    }
    
    func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: "analytics_events"),
           let savedEvents = try? JSONDecoder().decode([AnalyticsEvent].self, from: data) {
            events = savedEvents
        }
    }
}

// MARK: - Usage Report

struct UsageReport {
    let totalCalculations: Int
    let totalVoiceInput: Int
    let totalEquationSolve: Int
    let lastUpdated: Date
    
    var voiceUsageRate: Double {
        guard totalCalculations > 0 else { return 0 }
        return Double(totalVoiceInput) / Double(totalCalculations)
    }
    
    var equationUsageRate: Double {
        guard totalCalculations > 0 else { return 0 }
        return Double(totalEquationSolve) / Double(totalCalculations)
    }
}
