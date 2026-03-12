import XCTest
@testable import Calculator

final class TransactionHistoryTests: XCTestCase {
    
    var history: TransactionHistory!
    
    override func setUp() {
        super.setUp()
        history = TransactionHistory.shared
        // Ensure a clean state before each test
        history.clearAll()
    }
    
    override func tearDown() {
        // Clean up after test
        history.clearAll()
        history = nil
        super.tearDown()
    }
    
    // MARK: - TransactionHistory Tests
    
    func testAddTransaction() {
        history.addTransaction(expression: "5 + 3", result: 8)
        let transactions = history.getAllTransactions()
        
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first?.expression, "5 + 3")
        XCTAssertEqual(transactions.first?.result, 8)
    }
    
    func testMaxHistoryLimit() {
        // Add 25 transactions, max limit is 20
        for i in 1...25 {
            history.addTransaction(expression: "\(i) + 0", result: Decimal(i))
        }
        
        let transactions = history.getAllTransactions()
        
        XCTAssertEqual(transactions.count, 20, "Should not exceed the maximum history count of 20")
        
        // As items are inserted at 0, the last inserted "25 + 0" should be first
        XCTAssertEqual(transactions.first?.expression, "25 + 0")
        XCTAssertEqual(transactions.first?.result, 25)
        
        // The last item should be "6 + 0" because 1-5 were pushed out
        XCTAssertEqual(transactions.last?.expression, "6 + 0")
        XCTAssertEqual(transactions.last?.result, 6)
    }
    
    func testGetRecentTransactions() {
        for i in 1...10 {
            history.addTransaction(expression: "\(i) + 0", result: Decimal(i))
        }
        
        let recent = history.getRecentTransactions(count: 5)
        XCTAssertEqual(recent.count, 5, "Should only return exactly 5 transactions")
        XCTAssertEqual(recent.first?.result, 10, "The most recent transaction should be first")
        XCTAssertEqual(recent.last?.result, 6)
    }
    
    func testRemoveTransaction() {
        history.addTransaction(expression: "10 + 0", result: 10)
        history.addTransaction(expression: "20 + 0", result: 20)
        history.addTransaction(expression: "30 + 0", result: 30)
        
        // Transactions are inserted at 0:
        // [0]: 30 + 0
        // [1]: 20 + 0
        // [2]: 10 + 0
        
        history.removeTransaction(at: 1)
        
        let transactions = history.getAllTransactions()
        XCTAssertEqual(transactions.count, 2)
        XCTAssertEqual(transactions[0].result, 30)
        XCTAssertEqual(transactions[1].result, 10)
    }
    
    func testClearAll() {
        history.addTransaction(expression: "1 + 1", result: 2)
        XCTAssertEqual(history.getAllTransactions().count, 1)
        
        history.clearAll()
        XCTAssertTrue(history.getAllTransactions().isEmpty, "History should be empty after clearAll")
    }
}
