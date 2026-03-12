import SwiftUI

/// 方程求解器界面
struct EquationSolverView: View {
    
    @StateObject private var viewModel: EquationSolverViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 标题和类型切换
                HStack {
                    Text("方程求解器")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: viewModel.toggleEquationType) {
                        Text(viewModel.equationType == "线性" ? "切换到二次方程" : "切换到线性方程")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                // 方程类型显示
                Text(equationDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // 输入区域
                VStack(spacing: 15) {
                    // a 系数输入
                    HStack {
                        Text("a =")
                            .fontWeight(.semibold)
                        
                        TextField("输入数字", text: $viewModel.coefficientA, onCommit: viewModel.solve)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .accessibilityLabel("系数 A")
                    }
                    
                    // b 系数输入
                    HStack {
                        Text("b =")
                            .fontWeight(.semibold)
                        
                        TextField("输入数字", text: $viewModel.coefficientB, onCommit: viewModel.solve)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .accessibilityLabel("系数 B")
                    }
                    
                    // c 常数输入 (仅线性方程 ax + b = c 需要)
                    if viewModel.equationType == "线性" {
                        HStack {
                            Text("c =")
                                .fontWeight(.semibold)
                            
                            TextField("常数项", text: $viewModel.constantC, onCommit: viewModel.solve)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .accessibilityLabel("常数 C")
                        }
                    } else {
                        // 二次方程 ax² + bx + c = 0，c 是常数项
                        HStack {
                            Text("c =")
                                .fontWeight(.semibold)
                            
                            TextField("常数项", text: $viewModel.constantC, onCommit: viewModel.solve)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .accessibilityLabel("常数 C")
                        }
                    }
                }
                
                Spacer()
                
                // 求解按钮
                Button(action: viewModel.solve) {
                    HStack {
                        Image(systemName: "equal")
                        Text("求解")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                
                // 清除按钮
                Button(action: viewModel.clearAll) {
                    Text("清除")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 结果显示区域
                if !viewModel.solutionText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("结果:")
                            .font(.headline)
                        
                        Text(viewModel.solutionText)
                            .font(.body.monospaced())
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                
            }
            .padding()
            .navigationTitle("方程求解")
        }
    }
    
    // MARK: - Computed Properties
    
    private var equationDescription: String {
        if viewModel.equationType == "线性" {
            return "格式：ax + b = c (如果 c 为空，则为 ax = b)"
        } else {
            return "格式：ax² + bx + c = 0"
        }
    }
    
    // MARK: - Initialization
    
    init() {
        _viewModel = StateObject(wrappedValue: EquationSolverViewModel())
    }
}

// MARK: - Preview

#Preview {
    EquationSolverView()
}
