import SwiftUI

/// 用户反馈管理器 (v3.6)
class FeedbackManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = FeedbackManager()
    private init() {}
    
    // MARK: - Properties
    
    @Published var feedbackHistory: [FeedbackItem] = []
    
    struct FeedbackItem: Identifiable, Codable {
        let id: UUID
        let rating: Int
        let message: String
        let timestamp: Date
        let deviceInfo: String
        
        init(rating: Int, message: String) {
            self.id = UUID()
            self.rating = rating
            self.message = message
            self.timestamp = Date()
            #if os(iOS)
            self.deviceInfo = UIDevice.current.modelName
            #else
            self.deviceInfo = "Mac"
            #endif
        }
    }
    
    // MARK: - Methods
    
    func submitFeedback(rating: Int, message: String) {
        let feedback = FeedbackItem(rating: rating, message: message)
        feedbackHistory.append(feedback)
        saveFeedback()
        
        // 打印反馈摘要
        print("📝 收到用户反馈:")
        print("   评分: \(rating) 星")
        print("   内容: \(message)")
    }
    
    func getAverageRating() -> Double {
        guard !feedbackHistory.isEmpty else { return 0 }
        let total = feedbackHistory.reduce(0) { $0 + $1.rating }
        return Double(total) / Double(feedbackHistory.count)
    }
    
    func getRecentFeedback(count: Int = 10) -> [FeedbackItem] {
        return Array(feedbackHistory.suffix(count).reversed())
    }
    
    // MARK: - Persistence
    
    private func saveFeedback() {
        if let data = try? JSONEncoder().encode(feedbackHistory) {
            UserDefaults.standard.set(data, forKey: "userFeedback")
        }
    }
    
    private func loadFeedback() {
        if let data = UserDefaults.standard.data(forKey: "userFeedback"),
           let history = try? JSONDecoder().decode([FeedbackItem].self, from: data) {
            feedbackHistory = history
        }
    }
}

// MARK: - Device Extension

#if os(iOS)
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
#endif
