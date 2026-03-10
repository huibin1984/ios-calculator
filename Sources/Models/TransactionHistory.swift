import Foundation

/// 交易历史记录 - 保存最近 20 次计算
class TransactionHistory {
    
    /// 单例实例
    static let shared = TransactionHistory()
    
    /// 交易记录结构
    struct Transaction: Codable {
        let expression: String      // 表达式，如 "123 + 456"
        let result: Decimal         // 计算结果
        let timestamp: Date         // 时间戳
        
        init(expression: String, result: Decimal) {
            self.expression = expression
            self.result = result
            self.timestamp = Date()
        }
    }
    
    /// 最大历史记录数量
    private let maxHistoryCount = 20
    
    /// 历史记录列表 (最新在前)
    private(set) var transactions: [Transaction] = []
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        loadFromStorage()
    }
    
    // MARK: - Public Methods
    
    /// 添加新的交易记录
    func addTransaction(expression: String, result: Decimal) {
        let transaction = Transaction(expression: expression, result: result)
        
        transactions.insert(transaction, at: 0)
        
        // 保持最大数量限制
        if transactions.count > maxHistoryCount {
            transactions.removeLast()
        }
        
        saveToStorage()
    }
    
    /// 获取所有历史记录
    func getAllTransactions() -> [Transaction] {
        return transactions
    }
    
    /// 获取指定数量的最近记录
    func getRecentTransactions(count: Int) -> [Transaction] {
        let actualCount = min(count, transactions.count)
        return Array(transactions.prefix(actualCount))
    }
    
    /// 清除所有历史记录
    func clearAll() {
        transactions.removeAll()
        saveToStorage()
    }
    
    /// 删除指定索引的记录
    func removeTransaction(at index: Int) {
        guard index >= 0 && index < transactions.count else { return }
        transactions.remove(at: index)
        saveToStorage()
    }
    
    // MARK: - Persistence
    
    private let storageKey = "CalculatorTransactionHistory"
    
    private func saveToStorage() {
        do {
            let data = try JSONEncoder().encode(transactions)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("保存历史记录失败：\(error)")
        }
    }
    
    private func loadFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }
        
        do {
            transactions = try JSONDecoder().decode([Transaction].self, from: data)
        } catch {
            print("加载历史记录失败：\(error)")
            transactions = []
        }
    }
}
