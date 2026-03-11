import SwiftUI

/// 语音输入按钮 - v2.3
struct VoiceInputButton: View {
    let onActivate: () -> Void
    
    var body: some View {
        Button(action: onActivate) {
            Image(systemName: "mic.fill")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(Circle().fill(Color.blue.gradient()))
        }
    }
}
