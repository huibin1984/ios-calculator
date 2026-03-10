import SwiftUI

/// 语音开关控件 - 右上角明显位置
struct VoiceToggleView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    var body: some View {
        Button(action: {
            viewModel.toggleVoice()
        }) {
            HStack(spacing: 4) {
                Image(systemName: voiceIcon)
                    .font(.caption)
                Text(voiceText)
                    .font(.caption2)
            }
            .foregroundColor(viewModel.voiceEnabled ? .white : .gray)
            .padding(8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
        }
    }
    
    private var voiceIcon: String {
        viewModel.voiceEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill"
    }
    
    private var voiceText: String {
        viewModel.voiceEnabled ? "语音开" : "语音关"
    }
}
