import SwiftUI

/// 设置视图 - 用户偏好配置 (v3.3)
struct SettingsView: View {
    @AppStorage(\"isHapticEnabled\") private var isHapticEnabled = true
    @AppStorage(\"isVoiceEnabled\") private var isVoiceEnabled = true
    @AppStorage(\"voiceLanguage\") private var voiceLanguage = \"zh-CN\"
    @AppStorage(\"voiceSpeed\") private var voiceSpeed = 0.9
    @AppStorage(\"isDarkMode\") private var isDarkMode = true
    @AppStorage(\"historyLimit\") private var historyLimit = 10
    
    var body: some View {
        NavigationView {
            List {
                // 语音设置
                Section {
                    Toggle(isOn: $isVoiceEnabled) {
                        Label(\"语音反馈\", systemImage: \"speaker.wave.2.fill\")
                    }
                    
                    if isVoiceEnabled {
                        Picker(selection: $voiceLanguage) {
                            Text(\"中文\").tag(\"zh-CN\")
                            Text(\"英文\").tag(\"en-US\")
                        } label: {
                            Label(\"语言\", systemImage: \"globe\")
                        }
                        
                        VStack(alignment: .leading) {
                            Label(\"语速\", systemImage: \"speedometer\")
                            Slider(value: $voiceSpeed, in: 0.5...1.5, step: 0.1)
                            HStack {
                                Text(\"慢\")
                                Spacer()
                                Text(\"快\")
                            }
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text(\"语音设置\")
                }
                
                // 触觉反馈设置
                Section {
                    Toggle(isOn: $isHapticEnabled) {
                        Label(\"触觉反馈\", systemImage: \"hand.tap.fill\")
                    }
                } header: {
                    Text(\"触感设置\")
                } footer: {
                    Text(\"关闭触觉反馈可以节省电池电量\")
                }
                
                // 显示设置
                Section {
                    Toggle(isOn: $isDarkMode) {
                        Label(\"深色模式\", systemImage: \"moon.fill\")
                    }
                } header: {
                    Text(\"显示设置\")
                }
                
                // 历史记录设置
                Section {
                    Stepper(value: $historyLimit, in: 5...50, step: 5) {
                        Label(\"历史记录数量\", systemImage: \"clock.arrow.circlepath\")
                        Text(\"\(historyLimit) 条\")
                    }
                } header: {
                    Text(\"历史记录\")
                } footer: {
                    Text(\"免费用户限制为 10 条，付费用户可解锁无限历史\")
                }
                
                // 关于
                Section {
                    HStack {
                        Text(\"版本\")
                        Spacer()
                        Text(\"v3.3 Beta\")
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: \"https://github.com/huibin1984/ios-calculator\")!) {
                        HStack {
                            Text(\"GitHub\")
                            Spacer()
                            Image(systemName: \"arrow.up.right.square\")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text(\"关于\")
                }
            }
            .navigationTitle(\"设置\")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/// 历史记录设置视图 (v3.3)
struct HistorySettingsView: View {
    @AppStorage(\"historyLimit\") private var historyLimit = 10
    @AppStorage(\"autoSaveHistory\") private var autoSaveHistory = true
    
    var body: some View {
        List {
            Section {
                Stepper(value: $historyLimit, in: 5...50, step: 5) {
                    HStack {
                        Text(\"最大记录数\")
                        Spacer()
                        Text(\"\(historyLimit)\")
                            .foregroundColor(.secondary)
                    }
                }
                
                Toggle(\"自动保存历史\", isOn: $autoSaveHistory)
            } header: {
                Text(\"历史记录\")
            } footer: {
                Text(\"当历史记录达到上限时，最旧的记录将被自动删除\")
            }
            
            Section {
                Button(\"清空所有历史记录\", role: .destructive) {
                    // 清空历史记录
                    TransactionHistory.shared.clearAll()
                }
            }
        }
        .navigationTitle(\"历史记录设置\")
    }
}

/// 用户反馈视图 (v3.3)
struct FeedbackView: View {
    @State private var feedbackText = \"\"
    @State private var rating = 5
    @State private var showSuccess = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 评分
            Text(\"您对 App 的体验满意吗？\")
                .font(.headline)
            
            HStack(spacing: 16) {
                ForEach(1...5, id: \\.self) { index in
                    Button(action: { rating = index }) {
                        Image(systemName: index <= rating ? \"star.fill\" : \"star\")
                            .font(.title)
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            // 反馈文本
            TextField(\"请告诉我们您的想法...\", text: $feedbackText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(5...10)
                .padding(.horizontal)
            
            // 提交按钮
            Button(action: {
                showSuccess = true
                // 提交反馈逻辑
            }) {
                Text(\"提交反馈\")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle(\"用户反馈\")
        .alert(\"感谢您的反馈！\", isPresented: $showSuccess) {
            Button(\"确定\", role: .cancel) { }
        }
    }
}
