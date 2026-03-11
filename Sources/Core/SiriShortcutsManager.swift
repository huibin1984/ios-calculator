import Foundation
import Intents

/// Siri Shortcuts 支持 (v3.6)
class SiriShortcutsManager {
    
    // MARK: - Singleton
    
    static let shared = SiriShortcutsManager()
    private init() {}
    
    // MARK: - Donate Shortcuts
    
    /// 捐赠常用计算快捷指令
    func donateCalculationShortcut(expression: String, result: String) {
        let activity = NSUserActivity(activityType: "com.calculator.calculate")
        activity.title = "计算 \(expression)"
        activity.userInfo = ["expression": expression, "result": result]
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier("calculate.\(expression)")
        
        activity.becomeCurrent()
    }
    
    // MARK: - Add to Siri
    
    /// 添加快捷指令到 Siri
    func addShortcutToSiri(expression: String, result: String) {
        // v3.6 TODO: 实现完整的 Shortcuts 集成
        /*
        let intent = CalculateIntent()
        intent.expression = expression
        intent.result = result
        
        let shortcut = INShortcut(intent: intent)
        
        let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        viewController.delegate = self
        
        // Present the view controller
        */
        
        print("📱 Siri Shortcut: \(expression) = \(result)")
    }
}

// MARK: - Calculate Intent

@available(iOS 16.0, *)
class CalculateIntent: INExtension, INIntentHandlerProviding {
    
    func handler(for intent: INIntent) -> INIntentHandler & KNSpeechRecognitionShortcutHandling {
        return CalculateIntentHandler()
    }
    
    func resolveExpression(for intent: CalculateIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let expression = intent.expression, !expression.isEmpty {
            completion(.success(with: expression))
        } else {
            completion(.needsValue())
        }
    }
    
    func resolveResult(for intent: CalculateIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let result = intent.result, !result.isEmpty {
            completion(.success(with: result))
        } else {
            completion(.needsValue())
        }
    }
}

class CalculateIntentHandler: NSObject, INIntentHandler {
    func handle(intent: INIntent, completion: @escaping (INIntentResponse) -> Void) {
        guard let calculateIntent = intent as? CalculateIntent,
              let expression = calculateIntent.expression else {
            completion(INIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        // 执行计算
        let parser = ExpressionParser()
        let tokens = expression.split(separator: " ").map(String.init)
        
        if let result = parser.evaluate(tokens: tokens) {
            let response = CalculateIntentResponse(code: .success, userActivity: nil)
            response.result = "\(result)"
            completion(response)
        } else {
            completion(INIntentResponse(code: .failure, userActivity: nil))
        }
    }
}

@objc
class CalculateIntentResponse: INIntentResponse {
    @objc var result: String?
    
    @objc init(code: INIntentResponseCode, userActivity: NSUserActivity?) {
        super.init()
        self.code = code
        self.userActivity = userActivity
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Quick Calculate Shortcut

/// 快速计算快捷指令
struct QuickCalculateShortcut {
    let expression: String
    let result: String
    let timestamp: Date
    
    init(expression: String, result: String) {
        self.expression = expression
        self.result = result
        self.timestamp = Date()
    }
}
