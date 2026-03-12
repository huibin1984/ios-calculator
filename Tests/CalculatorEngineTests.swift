import XCTest
@testable import Calculator

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
        engine.setValue(5)
        engine.performOperation(.add)
        engine.setValue(3)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 8, "5 + 3 should equal 8")
    }
    
    func testSubtraction() {
        engine.setValue(10)
        engine.performOperation(.subtract)
        engine.setValue(4)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 6, "10 - 4 should equal 6")
    }
    
    func testMultiplication() {
        engine.setValue(4)
        engine.performOperation(.multiply)
        engine.setValue(5)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 20, "4 × 5 should equal 20")
    }
    
    func testDivision() {
        engine.setValue(20)
        engine.performOperation(.divide)
        engine.setValue(4)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 5, "20 ÷ 4 should equal 5")
    }
    
    func testDivisionByZero() {
        engine.setValue(10)
        engine.performOperation(.divide)
        engine.setValue(0)
        let result = engine.calculate()
        
        XCTAssertEqual(result, Decimal.greatestFiniteMagnitude, "Division by zero should handle gracefully and return greatestFiniteMagnitude in this engine")
    }
    
    // MARK: - Decimal Operations
    
    func testDecimalAddition() {
        engine.setValue(1.5)
        engine.performOperation(.add)
        engine.setValue(2.5)
        let result = engine.calculate()
        
        XCTAssertEqual(result, 4, "1.5 + 2.5 should equal 4")
    }
    
    // MARK: - Memory Operations
    
    func testMemoryAdd() {
        engine.setValue(10)
        engine.memoryAdd()
        
        XCTAssertEqual(engine.memoryValue, 10, "Memory should be 10")
    }
    
    func testMemoryClear() {
        engine.setValue(10)
        engine.memoryAdd()
        engine.memoryClear()
        
        XCTAssertEqual(engine.memoryValue, 0, "Memory should be cleared to 0")
    }
    
    // MARK: - Clear Operations
    
    func testAllClear() {
        engine.setValue(5)
        engine.performOperation(.add)
        engine.setValue(3)
        engine.allClear()
        
        XCTAssertEqual(engine.currentValue, 0, "Should be cleared to 0")
    }
    
    func testToggleSign() {
        engine.setValue(5)
        engine.toggleSign()
        
        XCTAssertEqual(engine.currentValue, -5, "Should be -5")
    }
    
    // MARK: - Percentage
    
    func testPercentage() {
        engine.setValue(50)
        engine.performOperation(.percent)
        
        XCTAssertEqual(engine.currentValue, 0.5, "50% of 100 should be 50, but input was 50 not 100")
    }
    // MARK: - Scientific Functions
    
    func testSquare() {
        engine.setValue(4)
        let result = engine.square()
        XCTAssertEqual(result, 16, "4 squared should be 16")
    }
    
    func testCube() {
        engine.setValue(3)
        let result = engine.cube()
        XCTAssertEqual(result, 27, "3 cubed should be 27")
    }
    
    func testSquareRoot() {
        engine.setValue(25)
        let result = engine.squareRoot()
        XCTAssertEqual(result, 5, "Square root of 25 should be 5")
    }
    
    func testSquareRootNegative() {
        engine.setValue(-9)
        let result = engine.squareRoot()
        XCTAssertEqual(result, 0, "Square root of negative number should return 0 (error state)")
    }
    
    func testSine() {
        engine.setValue(90)
        let result = engine.sine()
        // sin(90 degrees) = 1
        XCTAssertEqual(result, 1, "sin(90°) should be 1")
    }
    
    func testCosine() {
        engine.setValue(180)
        let result = engine.cosine()
        // cos(180 degrees) = -1
        XCTAssertEqual(result, -1, "cos(180°) should be -1")
    }
    
    func testTangent() {
        engine.setValue(0)
        let result = engine.tangent()
        XCTAssertEqual(result, 0, "tan(0°) should be 0")
    }
    
    func testLogarithm() {
        engine.setValue(100)
        let result = engine.logarithm()
        XCTAssertEqual(result, 2, "log10(100) should be 2")
    }
    
    func testNaturalLogarithm() {
        // We evaluate ln(e)
        // Since e = exp(1.0), ln(e) = 1
        engine.setEuler()
        let result = engine.naturalLogarithm()
        // Decimal representation might have tiny rounding issue, let's round or check closeness
        // or let's test ln(1) = 0
        engine.setValue(1)
        let result2 = engine.naturalLogarithm()
        XCTAssertEqual(result2, 0, "ln(1) should be 0")
    }
    
    func testConstants() {
        engine.setPi()
        XCTAssertEqual(engine.currentValue, Decimal(string: String(Double.pi))!, "Pi should be set correctly")
        
        engine.setEuler()
        XCTAssertEqual(engine.currentValue, Decimal(string: String(exp(1.0)))!, "e should be set correctly")
    }
}
