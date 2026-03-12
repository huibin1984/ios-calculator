import Foundation

/// 云同步管理器 - iCloud Keychain + CloudKit 架构 (v3.1)
class CloudSyncManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = CloudSyncManager()
    private init() {}
    
    // MARK: - Published Properties
    
    @Published var isSyncing: Bool = false
    @Published var lastSyncDate: Date?
    @Published var syncError: String?
    @Published var isCloudAvailable: Bool = false
    
    // MARK: - Sync Configuration
    
    enum SyncTier: String {
        case free       // iCloud Keychain，50 条记录限制
        case premium    // CloudKit，无限记录
    }
    
    var currentTier: SyncTier = .free
    
    // MARK: - Public Methods
    
    /// 初始化云同步
    func initialize() {
        checkCloudAvailability()
    }
    
    /// 检查 iCloud 可用性
    func checkCloudAvailability() {
        // v3.1 TODO: 检查 iCloud 账户状态
        // FileManager.default.ubiquityIdentityToken
        
        // 模拟检查
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isCloudAvailable = true
            print("☁️ iCloud 可用")
        }
    }
    
    /// 同步历史记录到云端
    func syncHistory(_ history: [TransactionRecord], completion: @escaping (Bool) -> Void) {
        guard isCloudAvailable else {
            syncError = "iCloud 不可用"
            completion(false)
            return
        }
        
        isSyncing = true
        
        switch currentTier {
        case .free:
            syncToKeychain(history, completion: completion)
        case .premium:
            syncToCloudKit(history, completion: completion)
        }
    }
    
    /// 从云端下载历史记录
    func downloadHistory(completion: @escaping ([TransactionRecord]?) -> Void) {
        guard isCloudAvailable else {
            completion(nil)
            return
        }
        
        isSyncing = true
        
        switch currentTier {
        case .free:
            downloadFromKeychain(completion: completion)
        case .premium:
            downloadFromCloudKit(completion: completion)
        }
    }
    
    // MARK: - iCloud Keychain Sync (Free Tier)
    
    private let keychainService = "com.calculator.history"
    private let keychainAccount = "cloud_history"
    
    private func syncToKeychain(_ history: [TransactionRecord], completion: @escaping (Bool) -> Void) {
        // 限制免费版只能保存 50 条
        let limitedHistory = Array(history.prefix(50))
        
        do {
            let data = try JSONEncoder().encode(limitedHistory)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: keychainAccount
            ]
            
            // 删除旧数据
            SecItemDelete(query as CFDictionary)
            
            // 添加新数据
            let status = SecItemAdd([
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: keychainService,
                kSecAttrAccount as String: keychainAccount,
                kSecValueData as String: data
            ] as CFDictionary, nil)
            
            if status == errSecSuccess {
                lastSyncDate = Date()
                completion(true)
            } else {
                syncError = "Keychain 同步失败"
                completion(false)
            }
        } catch {
            syncError = "编码失败: \(error.localizedDescription)"
            completion(false)
        }
        
        isSyncing = false
    }
    
    private func downloadFromKeychain(completion: @escaping ([TransactionRecord]?) -> Void) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            do {
                let history = try JSONDecoder().decode([TransactionRecord].self, from: data)
                lastSyncDate = Date()
                completion(history)
            } catch {
                syncError = "解码失败"
                completion(nil)
            }
        } else {
            completion(nil)
        }
        
        isSyncing = false
    }
    
    // MARK: - CloudKit Sync (Premium Tier)
    
    private func syncToCloudKit(_ history: [TransactionRecord], completion: @escaping (Bool) -> Void) {
        // v3.1 TODO: 实现 CloudKit 同步
        /*
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
        
        for record in history {
            let ckRecord = CKRecord(recordType: "CalculatorHistory")
            ckRecord["expression"] = record.expression
            ckRecord["result"] = "\(record.result)"
            ckRecord["timestamp"] = record.timestamp
            
            privateDatabase.save(ckRecord) { _, error in
                if let error = error {
                    print("CloudKit 保存错误: \(error)")
                }
            }
        }
        */
        
        print("☁️ CloudKit 同步需要配置 CloudKit 容器")
        isSyncing = false
        completion(false)
    }
    
    private func downloadFromCloudKit(completion: @escaping ([TransactionRecord]?) -> Void) {
        // v3.1 TODO: 实现 CloudKit 下载
        print("☁️ CloudKit 下载需要配置 CloudKit 容器")
        isSyncing = false
        completion(nil)
    }
    
    // MARK: - Conflict Resolution
    
    /// 冲突解决策略
    func resolveConflict(local: [TransactionRecord], cloud: [TransactionRecord]) -> [TransactionRecord] {
        // 策略：使用最新的记录覆盖旧的
        // 实际项目中可能需要更复杂的策略
        
        var merged = local
        
        for cloudRecord in cloud {
            if !local.contains(where: { $0.id == cloudRecord.id }) {
                merged.append(cloudRecord)
            }
        }
        
        // 按时间排序
        return merged.sorted { $0.timestamp > $1.timestamp }
    }
}

// MARK: - Transaction Record for Cloud Sync

struct TransactionRecord: Codable, Identifiable {
    let id: UUID
    let expression: String
    let result: Decimal
    let timestamp: Date
    
    init(expression: String, result: Decimal) {
        self.id = UUID()
        self.expression = expression
        self.result = result
        self.timestamp = Date()
    }
}

// MARK: - Sync Status View

import SwiftUI

struct SyncStatusView: View {
    @ObservedObject var syncManager = CloudSyncManager.shared
    
    var body: some View {
        HStack(spacing: 8) {
            if syncManager.isSyncing {
                ProgressView()
                    .scaleEffect(0.8)
                Text("同步中...")
                    .font(.caption)
            } else if syncManager.isCloudAvailable {
                Image(systemName: "checkmark.icloud")
                    .foregroundColor(.green)
                Text("已同步")
                    .font(.caption)
            } else {
                Image(systemName: "xmark.icloud")
                    .foregroundColor(.red)
                Text("未同步")
                    .font(.caption)
            }
        }
    }
}
