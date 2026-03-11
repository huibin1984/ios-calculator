import Foundation
import AVFoundation

/// 语音队列管理器 - 解决语音播报重叠问题 (v3.4)
class VoiceQueueManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = VoiceQueueManager()
    private init() {}
    
    // MARK: - Published Properties
    
    @Published var isSpeaking: Bool = false
    @Published var currentQueueCount: Int = 0
    
    // MARK: - Private Properties
    
    private var speechQueue: [SpeechItem] = []
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var isProcessingQueue = false
    
    /// 队列最大容量
    private let maxQueueSize = 10
    
    /// 播报延迟（毫秒）
    private var speakDelay: TimeInterval = 0.3
    
    // MARK: - Speech Item
    
    struct SpeechItem: Identifiable {
        let id = UUID()
        let text: String
        let priority: Priority
        let timestamp: Date
        
        enum Priority: Int {
            case low = 0
            case normal = 1
            case high = 2
            case critical = 3
        }
        
        init(text: String, priority: Priority = .normal) {
            self.text = text
            self.priority = priority
            self.timestamp = Date()
        }
    }
    
    // MARK: - Public Methods
    
    /// 添加到播报队列
    func speak(_ text: String, priority: SpeechItem.Priority = .normal) {
        // 避免重复播报相同内容
        if let last = speechQueue.last, last.text == text, Date().timeIntervalSince(last.timestamp) < 2 {
            return
        }
        
        let item = SpeechItem(text: text, priority: priority)
        
        // 高优先级直接插队到前面
        if priority == .critical || priority == .high {
            // 找到第一个低优先级元素，在其之前插入
            if let index = speechQueue.firstIndex(where: { $0.priority.rawValue < priority.rawValue }) {
                speechQueue.insert(item, at: index)
            } else {
                speechQueue.append(item)
            }
        } else {
            speechQueue.append(item)
        }
        
        // 限制队列大小
        if speechQueue.count > maxQueueSize {
            // 移除最旧的低优先级项
            speechQueue.removeFirst()
        }
        
        currentQueueCount = speechQueue.count
        
        // 开始处理队列
        processQueue()
    }
    
    /// 立即播报（跳过队列）
    func speakImmediate(_ text: String) {
        stop()
        speakNow(text)
    }
    
    /// 停止当前播报
    func stop() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
    
    /// 暂停队列处理
    func pause() {
        speechSynthesizer.pauseSpeaking(at: .immediate)
    }
    
    /// 恢复队列处理
    func resume() {
        speechSynthesizer.continueSpeaking()
    }
    
    /// 清空队列
    func clearQueue() {
        speechQueue.removeAll()
        currentQueueCount = 0
        stop()
    }
    
    // MARK: - Private Methods
    
    private func processQueue() {
        guard !isProcessingQueue, !speechQueue.isEmpty else { return }
        
        isProcessingQueue = true
        
        // 获取下一个播报项
        let item = speechQueue.removeFirst()
        currentQueueCount = speechQueue.count
        
        // 延迟播报
        DispatchQueue.main.asyncAfter(deadline: .now() + speakDelay) { [weak self] in
            self?.speakNow(item.text)
        }
    }
    
    private func speakNow(_ text: String) {
        isSpeaking = true
        
        let utterance = AVSpeechUtterance(string: text)
        
        // 配置语音
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        // 选择语音
        let voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.voice = voice
        
        // 播报完成回调
        let delegate = SpeechDelegate { [weak self] in
            DispatchQueue.main.async {
                self?.isSpeaking = false
                self?.isProcessingQueue = false
                self?.processQueue()
            }
        }
        
        speechSynthesizer.delegate = delegate
        speechSynthesizer.speak(utterance)
    }
}

// MARK: - Speech Delegate

class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    private let onComplete: () -> Void
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onComplete()
    }
}

// MARK: - Voice Settings Manager

class VoiceSettingsManager: ObservableObject {
    static let shared = VoiceSettingsManager()
    
    @Published var isEnabled: Bool = true
    @Published var language: String = "zh-CN"
    @Published var rate: Double = 0.9  // 0.0 - 1.0
    @Published var pitch: Double = 1.0  // 0.5 - 2.0
    @Published var volume: Double = 1.0  // 0.0 - 1.0
    
    // 语言选项
    enum Language: String, CaseIterable {
        case chinese = "zh-CN"
        case english = "en-US"
        
        var displayName: String {
            switch self {
            case .chinese: return "中文"
            case .english: return "English"
            }
        }
    }
    
    private init() {
        loadSettings()
    }
    
    func loadSettings() {
        isEnabled = UserDefaults.standard.bool(forKey: "voiceEnabled")
        language = UserDefaults.standard.string(forKey: "voiceLanguage") ?? "zh-CN"
        rate = UserDefaults.standard.double(forKey: "voiceRate")
        pitch = UserDefaults.standard.double(forKey: "voicePitch")
        volume = UserDefaults.standard.double(forKey: "voiceVolume")
        
        // 默认值
        if rate == 0 { rate = 0.9 }
        if pitch == 0 { pitch = 1.0 }
        if volume == 0 { volume = 1.0 }
    }
    
    func saveSettings() {
        UserDefaults.standard.set(isEnabled, forKey: "voiceEnabled")
        UserDefaults.standard.set(language, forKey: "voiceLanguage")
        UserDefaults.standard.set(rate, forKey: "voiceRate")
        UserDefaults.standard.set(pitch, forKey: "voicePitch")
        UserDefaults.standard.set(volume, forKey: "voiceVolume")
    }
}
