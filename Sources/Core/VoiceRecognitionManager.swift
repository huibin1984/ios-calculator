import Foundation

/// 语音识别管理器 - 带置信度系统 (v3.4)
class VoiceRecognitionManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = VoiceRecognitionManager()
    private init() {}
    
    // MARK: - Published Properties
    
    @Published var isListening: Bool = false
    @Published var recognizedText: String = ""
    @Published var confidence: Double = 0.0  // 0.0 - 1.0
    @Published var recognitionStatus: RecognitionStatus = .idle
    
    // MARK: - Configuration
    
    /// 置信度阈值配置
    struct ConfidenceThresholds {
        var high: Double = 0.8    // >= 80% 直接执行
        var medium: Double = 0.5  // 50-80% 显示确认
        var low: Double = 0.5     // < 50% 提示重试
    }
    
    var thresholds = ConfidenceThresholds()
    
    // MARK: - Status
    
    enum RecognitionStatus {
        case idle
        case listening
        case processing
        case success
        case lowConfidence
        case failed
    }
    
    // MARK: - Public Methods
    
    /// 开始语音识别
    func startRecognition(language: String = "zh-CN") {
        recognitionStatus = .listening
        isListening = true
        recognizedText = ""
        confidence = 0.0
        
        // v3.4 TODO: 调用 Speech Framework
        // 这里模拟识别过程
        simulateRecognition()
    }
    
    /// 停止识别
    func stopRecognition() {
        isListening = false
        recognitionStatus = .idle
    }
    
    /// 获取置信度等级
    func getConfidenceLevel() -> ConfidenceLevel {
        if confidence >= thresholds.high {
            return .high
        } else if confidence >= thresholds.medium {
            return .medium
        } else {
            return .low
        }
    }
    
    enum ConfidenceLevel {
        case high   // 直接执行
        case medium // 显示确认
        case low    // 提示重试
        
        var message: String {
            switch self {
            case .high:
                return "识别成功"
            case .medium:
                return "请确认您的输入"
            case .low:
                return "请再说一次"
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func simulateRecognition() {
        // 模拟识别过程
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            self.recognitionStatus = .processing
            
            // 模拟随机置信度
            let randomConfidence = Double.random(in: 0.3...0.95)
            self.confidence = randomConfidence
            
            // 模拟识别结果
            self.recognizedText = "五加三乘二"
            
            // 根据置信度设置状态
            if randomConfidence >= self.thresholds.high {
                self.recognitionStatus = .success
            } else if randomConfidence >= self.thresholds.medium {
                self.recognitionStatus = .medium == .processing ? .success : .lowConfidence
            } else {
                self.recognitionStatus = .lowConfidence
            }
            
            self.isListening = false
        }
    }
}

// MARK: - Voice Confirmation Dialog (v3.4)

import SwiftUI

struct VoiceConfirmationDialog: View {
    let recognizedText: String
    let confidence: Double
    let onConfirm: () -> Void
    let onRetry: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // 置信度指示器
            VStack(spacing: 8) {
                Text("语音识别结果")
                    .font(.headline)
                
                // 置信度进度条
                HStack {
                    Text("置信度:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(confidence * 100))%")
                        .font(.subheadline)
                        .foregroundColor(confidenceColor)
                }
                
                ProgressView(value: confidence)
                    .tint(confidenceColor)
            }
            
            // 识别文本
            VStack(alignment: .leading, spacing: 8) {
                Text("您说的是:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(recognizedText)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            
            // 操作按钮
            HStack(spacing: 16) {
                Button(action: onCancel) {
                    Text("取消")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                
                Button(action: onRetry) {
                    Text("重试")
                        .font(.body)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                
                Button(action: onConfirm) {
                    Text("确认")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 20)
        )
        .padding(.horizontal, 32)
    }
    
    private var confidenceColor: Color {
        if confidence >= 0.8 {
            return .green
        } else if confidence >= 0.5 {
            return .orange
        } else {
            return .red
        }
    }
}

/// 置信度指示器组件 (v3.4)
struct ConfidenceIndicator: View {
    let confidence: Double
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(confidenceColor)
                .frame(width: 10, height: 10)
            
            Text("\(Int(confidence * 100))%")
                .font(.caption)
                .foregroundColor(confidenceColor)
        }
    }
    
    private var confidenceColor: Color {
        if confidence >= 0.8 {
            return .green
        } else if confidence >= 0.5 {
            return .orange
        } else {
            return .red
        }
    }
}
