import SwiftUI

/// 增强型显示屏 - 带动画效果 (v3.3)
struct EnhancedDisplayView: View {
    let displayValue: String
    let hasMemory: Bool
    let onSendToEquation: () -> Void
    
    @State private var displayText: String = "0"
    @State private var showTransition = false
    
    // 当值变化时触发动画
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // 记忆指示器
            if hasMemory {
                Text("M")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .transition(.scale.combined(with: .opacity))
            }
            
            // 发送到方程求解器按钮
            if !displayValue.isEmpty && displayValue != "0" {
                Button(action: onSendToEquation) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right.to.line.end")
                            .font(.caption)
                        Text("发送到方程求解器")
                            .font(.caption2)
                    }
                    .foregroundColor(.blue)
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
            
            Spacer()
            
            // 主显示屏 - 带过渡动画
            Text(displayValue)
                .font(.system(size: 64, weight: .light, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .opacity(showTransition ? 0.8 : 1.0)
                .scaleEffect(showTransition ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: displayValue)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .onChange(of: displayValue) { newValue in
            // 值变化时触发动画
            withAnimation(.easeInOut(duration: 0.1)) {
                showTransition = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    showTransition = false
                }
            }
        }
    }
}

/// Toast 提示组件 (v3.3)
struct ToastView: View {
    let message: String
    let type: ToastType
    
    enum ToastType {
        case success
        case error
        case warning
        case info
        
        var backgroundColor: Color {
            switch self {
            case .success: return .green
            case .error: return .red
            case .warning: return .orange
            case .info: return .blue
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
                .font(.title3)
            
            Text(message)
                .font(.subheadline)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(type.backgroundColor)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

/// Toast 管理器 (v3.3)
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var currentToast: ToastItem?
    
    struct ToastItem: Identifiable {
        let id = UUID()
        let message: String
        let type: ToastView.ToastType
    }
    
    private init() {}
    
    func show(message: String, type: ToastView.ToastType, duration: Double = 2.0) {
        DispatchQueue.main.async {
            self.currentToast = ToastItem(message: message, type: type)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.currentToast = nil
            }
        }
    }
    
    func showSuccess(_ message: String) {
        show(message: message, type: .success)
    }
    
    func showError(_ message: String) {
        show(message: message, type: .error)
    }
    
    func showWarning(_ message: String) {
        show(message: message, type: .warning)
    }
    
    func showInfo(_ message: String) {
        show(message: message, type: .info)
    }
}

/// Toast 展示视图 (v3.3)
struct ToastPresenter: View {
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        ZStack {
            if let toast = toastManager.currentToast {
                VStack {
                    ToastView(message: toast.message, type: toast.type)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 50)
                    
                    Spacer()
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: toast.id)
            }
        }
    }
}

/// 加载指示器 (v3.3)
struct LoadingIndicator: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.7))
        )
    }
}

/// 确认对话框 (v3.3)
struct ConfirmationDialog: View {
    let title: String
    let message: String
    let confirmText: String
    let cancelText: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button(action: onCancel) {
                    Text(cancelText)
                        .font(.body)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                
                Button(action: onConfirm) {
                    Text(confirmText)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
        )
        .shadow(radius: 20)
    }
}
