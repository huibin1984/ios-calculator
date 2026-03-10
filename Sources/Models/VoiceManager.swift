import Foundation
import AVFoundation

/// 语音管理器 - 负责按键时的语音反馈
class VoiceManager: NSObject {
    
    /// 单例实例
    static let shared = VoiceManager()
    
    /// 语音合成器
    private let synthesizer = AVSpeechSynthesizer()
    
    /// 是否启用语音
    private(set) var isEnabled: Bool = true
    
    /// 当前语言 (中文/英文)
    var language: VoiceLanguage = .chinese {
        didSet {
            updateVoiceSettings()
        }
    }
    
    /// 语音语速 (0.5 - 2.0)
    var rate: Float = 0.9 {
        didSet {
            updateVoiceSettings()
        }
    }
    
    // MARK: - Voice Language
    
    enum VoiceLanguage: String {
        case chinese = "zh-CN"
        case english = "en-US"
    }
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        synthesizer.delegate = self
        updateVoiceSettings()
    }
    
    private func updateVoiceSettings() {
        synthesizer.rate = rate
    }
    
    // MARK: - Public Methods
    
    /// 切换语音开关
    func toggle() {
        isEnabled.toggle()
    }
    
    /// 朗读数字
    func speakDigit(_ digit: Int) {
        guard isEnabled else { return }
        
        let text = language == .chinese ? chineseNumber(digit) : String(digit)
        speak(text)
    }
    
    /// 朗读操作符
    func speakOperation(_ operation: CalculatorEngine.Operation) {
        guard isEnabled else { return }
        
        let text: String
        switch operation {
        case .add:
            text = language == .chinese ? "加" : "plus"
        case .subtract:
            text = language == .chinese ? "减" : "minus"
        case .multiply:
            text = language == .chinese ? "乘" : "times"
        case .divide:
            text = language == .chinese ? "除" : "divided by"
        case .percent:
            text = language == .chinese ? "百分比" : "percent"
        }
        
        speak(text)
    }
    
    /// 朗读等号
    func speakEquals() {
        guard isEnabled else { return }
        let text = language == .chinese ? "等于" : "equals"
        speak(text)
    }
    
    /// 朗读小数点
    func speakDecimalPoint() {
        guard isEnabled else { return }
        let text = language == .chinese ? "点" : "point"
        speak(text)
    }
    
    /// 朗读清除
    func speakClear() {
        guard isEnabled else { return }
        let text = language == .chinese ? "清除" : "clear"
        speak(text)
    }
    
    /// 朗读全部清除
    func speakAllClear() {
        guard isEnabled else { return }
        let text = language == .chinese ? "全部清除" : "all clear"
        speak(text)
    }
    
    /// 朗读正负切换
    func speakToggleSign() {
        guard isEnabled else { return }
        let text = language == .chinese ? "正负" : "plus minus"
        speak(text)
    }
    
    // MARK: - Memory Functions
    
    /// 朗读记忆加
    func speakMemoryAdd() {
        guard isEnabled else { return }
        let text = language == .chinese ? "记忆加" : "memory plus"
        speak(text)
    }
    
    /// 朗读记忆减
    func speakMemorySubtract() {
        guard isEnabled else { return }
        let text = language == .chinese ? "记忆减" : "memory minus"
        speak(text)
    }
    
    /// 朗读读取记忆
    func speakMemoryRecall() {
        guard isEnabled else { return }
        let text = language == .chinese ? "记忆读取" : "memory recall"
        speak(text)
    }
    
    /// 朗读清除记忆
    func speakMemoryClear() {
        guard isEnabled else { return }
        let text = language == .chinese ? "清除记忆" : "memory clear"
        speak(text)
    }
    
    // MARK: - Scientific Functions
    
    /// 朗读科学函数
    func speakScientific(_ function: CalculatorEngine.ScientificFunction) {
        guard isEnabled else { return }
        
        let text: String
        switch function {
        case .sin:
            text = language == .chinese ? "正弦" : "sine"
        case .cos:
            text = language == .chinese ? "余弦" : "cosine"
        case .tan:
            text = language == .chinese ? "正切" : "tangent"
        case .log:
            text = language == .chinese ? "对数" : "logarithm"
        case .ln:
            text = language == .chinese ? "自然对数" : "natural log"
        case .sqrt:
            text = language == .chinese ? "平方根" : "square root"
        case .square:
            text = language == .chinese ? "平方" : "squared"
        case .cube:
            text = language == .chinese ? "立方" : "cubed"
        }
        
        speak(text)
    }
    
    /// 朗读 π
    func speakPi() {
        guard isEnabled else { return }
        let text = language == .chinese ? "派" : "pi"
        speak(text)
    }
    
    /// 朗读 e
    func speakEuler() {
        guard isEnabled else { return }
        let text = language == .chinese ? "欧拉数" : "euler"
        speak(text)
    }
    
    // MARK: - Private Methods
    
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language.rawValue)
        utterance.rate = rate
        synthesizer.speak(utterance)
    }
    
    private func chineseNumber(_ digit: Int) -> String {
        let numbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        return numbers[digit]
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension VoiceManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        // 语音开始播放时的回调 (可用于 UI 反馈)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // 语音播放完成时的回调
    }
}
