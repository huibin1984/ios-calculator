import XCTest
@testable import CalculatorCore

final class CalculatorEngineTests: XCTestCase {
    
    var engine: CalculatorEngine!
    
    override func setUp() {
        super.setUp()
        engine = CalculatorEngine()
    }
    
    override func tearDown() {
        engine = nil
        super.tearDown()
    }
    
    // MARK: - Basic Operations
    
    func testAddition() {
        engine.inputDigit(5)
        engine.setOperation(.add)
        engine.inputDigit(3)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 8, "5 + 3 should equal 8")
    }
    
    func testSubtraction() {
        engine.inputDigit(10)
        engine.setOperation(.subtract)
        engine.inputDigit(4)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 6, "10 - 4 should equal 6")
    }
    
    func testMultiplication() {
        engine.inputDigit(4)
        engine.setOperation(.multiply)
        engine.inputDigit(5)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 20, "4 × 5 should equal 20")
    }
    
    func testDivision() {
        engine.inputDigit(20)
        engine.setOperation(.divide)
        engine.inputDigit(4)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 5, "20 ÷ 4 should equal 5")
    }
    
    func testDivisionByZero() {
        engine.inputDigit(10)
        engine.setOperation(.divide)
        engine.inputDigit(0)
        let result = engine.calculate()
        
        XCTAssertNil(result, "Division by zero should return nil")
    }
    
    // MARK: - Decimal Operations
    
    func testDecimalAddition() {
        engine.inputDigit(1)
        engine.inputDecimalPoint()
        engine.inputDigit(5)
        engine.setOperation(.add)
        engine.inputDigit(2)
        engine.inputDecimalPoint()
        engine.inputDigit(5)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 4, "1.5 + 2.5 should equal 4")
    }
    
    // MARK: - Memory Operations
    
    func testMemoryAdd() {
        engine.inputDigit(10)
        engine.memoryAdd()
        
        XCTAssertEqual(engine.memoryValue, 10, "Memory should be 10")
    }
    
    func testMemoryClear() {
        engine.inputDigit(10)
        engine.memoryAdd()
        engine.memoryClear()
        
        XCTAssertEqual(engine.memoryValue, 0, "Memory should be cleared to 0")
    }
    
    // MARK: - Clear Operations
    
    func testAllClear() {
        engine.inputDigit(5)
        engine.setOperation(.add)
        engine.inputDigit(3)
        engine.allClear()
        
        XCTAssertEqual(engine.currentValue, 0, "Should be cleared to 0")
    }
    
    func testToggleSign() {
        engine.inputDigit(5)
        engine.toggleSign()
        
        XCTAssertEqual(engine.currentValue, -5, "Should be -5")
    }
    
    // MARK: - Percentage
    
    func testPercentage() {
        engine.inputDigit(5)
        engine.inputDigit(0)
        engine.percentage()
        
        XCTAssertEqual(engine.currentValue, 0.5, "50% of 100 should be 50, but input was 50 not 100")
    }
}
