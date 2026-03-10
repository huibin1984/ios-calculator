import Foundation
import AVFoundation

/// 语音管理器 - 负责按键时的语音反馈和语音输入识别
class VoiceManager: NSObject {
    
    /// 单例实例
    static let shared = VoiceManager()
    
    /// 语音合成器 (输出)
    private let synthesizer = AVSpeechSynthesizer()
    
    /// 语音识别器 (输入)
    private let recognizer = SFSpeechRecognizer()
    
    /// 是否启用语音输出
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
        
        // 请求语音识别权限
        requestSpeechRecognitionAuthorization()
    }
    
    private func updateVoiceSettings() {
        synthesizer.rate = rate
    }
    
    /// 请求语音识别权限 (iOS 特性)
    private func requestSpeechRecognitionAuthorization() {
        guard let recognizer = SFSpeechRecognizer(language: language.rawValue) else {
            return
        }
        
        // 检查是否已授权
        _ = recognizer.isAvailable
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
    
    /// 朗读计算结果 (增强版 - 读完整数字)
    func speakResult(_ number: Decimal) {
        guard isEnabled else { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        if let string = formatter.string(from: NSDecimalNumber(decimal: number)) {
            speak(string)
        }
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
    
    /// 朗读读取记忆 (带数值)
    func speakMemoryRecall(_ value: Decimal) {
        guard isEnabled else { return }
        
        if language == .chinese {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "en_US")
            if let string = formatter.string(from: NSDecimalNumber(decimal: value)) {
                speak("记忆值 \(string)")
            }
        } else {
            speak("memory recall")
        }
    }
    
    /// 朗读清除记忆
    func speakMemoryClear() {
        guard isEnabled else { return }
        let text = language == .chinese ? "清除记忆" : "memory clear"
        speak(text)
    }
    
    /// 朗读存储到记忆 (MS)
    func speakMemoryStore(_ value: Decimal) {
        guard isEnabled else { return }
        
        if language == .chinese {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "en_US")
            if let string = formatter.string(from: NSDecimalNumber(decimal: value)) {
                speak("存储 \(string) 到记忆")
            }
        } else {
            speak("memory store")
        }
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
    
    // MARK: - Mode Switching
    
    /// 朗读模式切换
    func speakModeSwitch(to mode: CalculatorEngine.CalculatorMode) {
        guard isEnabled else { return }
        
        let text = language == .chinese 
            ? (mode == .basic ? "切换到普通商用版" : "切换到科学版")
            : (mode == .basic ? "Basic mode" : "Scientific mode")
        
        speak(text)
    }
    
    // MARK: - Voice Input Recognition
    
    /// 开始语音输入识别
    func startVoiceInput(completion: @escaping (String?) -> Void) {
        guard let recognizer = SFSpeechRecognizer(language: language.rawValue) else {
            completion(nil)
            return
        }
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let error = error {
                print("语音识别错误：\(error.localizedDescription)")
                completion(nil)
            } else if let result = result {
                let recognizedText = result.bestTranscription.formattedString
                print("识别到：\(recognizedText)")
                completion(recognizedText)
            }
        }
        
        // 返回音频输入流供外部使用
        // (实际实现中需要配合 AVAudioEngine)
    }
    
    /// 解析语音输入的数学表达式
    func parseVoiceInput(_ text: String) -> ParsedExpression? {
        // 简单示例：识别 "123 加 456" 这样的格式
        let components = text.components(separatedBy: ["加", "减", "乘", "除", "+", "-", "*", "/"])
        
        if components.count >= 2 {
            if let first = Decimal(string: components[0].trimmingCharacters(in: .whitespaces)),
               let second = Decimal(string: components[1].trimmingCharacters(in: .whitespaces)) {
                
                var operation: CalculatorEngine.Operation?
                if text.contains("加") || text.contains("+") {
                    operation = .add
                } else if text.contains("减") || text.contains("-") {
                    operation = .subtract
                } else if text.contains("乘") || text.contains("*") {
                    operation = .multiply
                } else if text.contains("除") || text.contains("/") {
                    operation = .divide
                }
                
                return ParsedExpression(first: first, second: second, operation: operation)
            }
        }
        
        // 尝试直接解析为数字
        if let number = Decimal(string: text.trimmingCharacters(in: .whitespaces)) {
            return ParsedExpression(number: number)
        }
        
        return nil
    }
    
    /// 语音输入解析结果
    struct ParsedExpression {
        var firstOperand: Decimal?
        var secondOperand: Decimal?
        var operation: CalculatorEngine.Operation?
        var directNumber: Decimal?
        
        init(first: Decimal, second: Decimal, operation: CalculatorEngine.Operation?) {
            self.firstOperand = first
            self.secondOperand = second
            self.operation = operation
        }
        
        init(number: Decimal) {
            self.directNumber = number
        }
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
