import SwiftUI

/// 增强型数字按钮 - 带动画效果 (v3.3)
struct EnhancedNumberButton: View {
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                )
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

/// 增强型运算符按钮 - 带动画效果 (v3.3)
struct EnhancedOperatorButton: View {
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHighlighted = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.15)) {
                isHighlighted = true
            }
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeIn(duration: 0.15)) {
                    isHighlighted = false
                }
            }
        }) {
            Text(title)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(isHighlighted ? Color.orange : Color.orange.opacity(0.8))
                )
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

/// 增强型功能按钮 - 带动画效果 (v3.3)
struct EnhancedFunctionButton: View {
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
            }
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeIn(duration: 0.1)) {
                    isPressed = false
                }
            }
        }) {
            Text(title)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(isPressed ? Color.gray.opacity(0.5) : Color.gray.opacity(0.15))
                )
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// 等号按钮 - 带脉冲动画 (v3.3)
struct EnhancedEqualsButton: View {
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var showPulse = false
    
    var body: some View {
        Button(action: {
            // 脉冲动画
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
                showPulse = true
            }
            
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeIn(duration: 0.2)) {
                    isPressed = false
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showPulse = false
            }
        }) {
            ZStack {
                // 脉冲光环
                if showPulse {
                    Circle()
                        .fill(Color.orange.opacity(0.3))
                        .frame(width: 70, height: 70)
                        .scaleEffect(showPulse ? 1.3 : 1.0)
                        .opacity(showPulse ? 0 : 1)
                }
                
                // 主按钮
                Circle()
                    .fill(Color.orange)
                    .frame(width: 60, height: 60)
                
                Text(\"=\")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// 记忆按钮 - 带动画 (v3.3)
struct EnhancedMemoryButton: View {
    let title: String
    let action: () -> Void
    var isActive: Bool = false
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
            }
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeIn(duration: 0.1)) {
                    isPressed = false
                }
            }
        }) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(isActive ? .white : .white.opacity(0.9))
                .frame(width: 50, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isActive ? Color.purple : Color.purple.opacity(0.5))
                )
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// 科学函数按钮 - 带动画 (v3.3)
struct EnhancedScientificButton: View {
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
            }
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeIn(duration: 0.1)) {
                    isPressed = false
                }
            }
        }) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 55, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isPressed ? Color.blue : Color.blue.opacity(0.6))
                )
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// 常量按钮 - 带动画 (v3.3)
struct EnhancedConstantButton: View {
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
            }
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeIn(duration: 0.1)) {
                    isPressed = false
                }
            }
        }) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 55, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isPressed ? Color.green : Color.green.opacity(0.6))
                )
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
