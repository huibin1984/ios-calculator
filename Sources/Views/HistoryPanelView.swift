import SwiftUI

/// 历史记录面板 - 上滑显示最近计算记录
struct HistoryPanelView: View {
    
    @ObservedObject var viewModel: CalculatorViewModel
    @Binding var isPresented: Bool
    
    private let maxHistoryCount = 20
    
    var body: some View {
        ZStack(alignment: .top) {
            // 背景遮罩
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // 面板内容
            VStack(spacing: 0) {
                // 拖动手柄
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 40)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 20)
                                .onEnded { value in
                                    if value.translation.height > 50 {
                                        isPresented = false
                                    }
                                }
                        )
                    
                    Image(systemName: "goforward.fill")
                        .resizable()
                        .frame(width: 40, height: 5)
                        .foregroundColor(.gray)
                        .padding(.top, geometry.size.height - 25)
                }
                .frame(height: 40)
                
                // 标题和清除按钮
                HStack {
                    Text("计算历史")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.clearHistory()
                    }) {
                        Text("清除全部")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                
                // 历史记录列表
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.getRecentHistory(count: maxHistoryCount).enumerated(), id: \.offset) { index, transaction in
                            HistoryItemView(transaction: transaction)
                                .onTapGesture {
                                    viewModel.restoreFromHistory(transaction)
                                    isPresented = false
                                }
                        }
                    }
                    .padding()
                }
                
                // 空状态提示
                if viewModel.getRecentHistory(count: maxHistoryCount).isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        
                        Text("暂无历史记录")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

/// 历史单项视图
struct HistoryItemView: View {
    let transaction: TransactionHistory.Transaction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 表达式
            Text(transaction.expression)
                .font(.subheadline.monospaced())
                .foregroundColor(.secondary)
            
            // 结果
            HStack {
                Text("=")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.locale = Locale(identifier: "en_US")
                if let resultString = formatter.string(from: NSDecimalNumber(decimal: transaction.result)) {
                    Text(resultString)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            // 时间戳
            Text(formattedDate(transaction.timestamp))
                .font(.caption2)
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    HistoryPanelView(viewModel: CalculatorViewModel(), isPresented: .constant(true))
}
