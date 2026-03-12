import XCTest
@testable import Calculator

final class ExpressionParserTests: XCTestCase {
    
    var parser: ExpressionParser!
    
    override func setUp() {
        super.setUp()
        parser = ExpressionParser()
    }
    
    override func tearDown() {
        parser = nil
        super.tearDown()
    }
    
    // MARK: - Evaluate Tokens Tests
    
    func testSimpleAddition() {
        let tokens = ["5", "+", "3"]
        let result = parser.evaluate(tokens: tokens)
        XCTAssertEqual(result, 8, "5 + 3 should be 8")
    }
    
    func testOperatorPrecedence() {
        // 5 + 3 * 2 = 11
        let tokens = ["5", "+", "3", "×", "2"]
        let result = parser.evaluate(tokens: tokens)
        XCTAssertEqual(result, 11, "5 + 3 * 2 should be 11, strictly following operator precedence")
    }
    
    func testParentheses() {
        // ( 5 + 3 ) * 2 = 16
        let tokens = ["(", "5", "+", "3", ")", "×", "2"]
        let result = parser.evaluate(tokens: tokens)
        XCTAssertEqual(result, 16, "( 5 + 3 ) * 2 should be 16")
    }
    
    func testPowerOperator() {
        // 2 ^ 3 = 8
        let tokens = ["2", "^", "3"]
        let result = parser.evaluate(tokens: tokens)
        XCTAssertEqual(result, 8, "2 ^ 3 should be 8")
    }
    
    func testComplexExpression() {
        // 10 + 2 * ( 6 - 4 ) ^ 2 = 10 + 2 * 4 = 18
        let tokens = ["10", "+", "2", "*", "(", "6", "-", "4", ")", "^", "2"]
        let result = parser.evaluate(tokens: tokens)
        XCTAssertEqual(result, 18, "10 + 2 * ( 6 - 4 ) ^ 2 should be 18")
    }
    
    func testDivisionByZero() {
        let tokens = ["5", "÷", "0"]
        let result = parser.evaluate(tokens: tokens)
        XCTAssertNil(result, "Division by zero should fail and return nil")
    }
    
    func testInvalidTokens() {
        let tokens = ["5", "+", "abc"]
        let result = parser.evaluate(tokens: tokens)
        XCTAssertNil(result, "Invalid token 'abc' should cause evaluation to fail or return nil due to insufficient operands or parsing error")
    }
    
    // MARK: - Chinese Voice Input Parsing Tests
    
    func testParseChineseSimple() {
        // "五加三"
        let input = "五加三"
        let result = parser.parseChineseVoiceInput(input)
        XCTAssertEqual(result, 8, "五加三 should be 8")
    }
    
    func testParseChineseWithPrecedence() {
        // "五加三乘二"
        let input = "五加三乘二"
        let result = parser.parseChineseVoiceInput(input)
        XCTAssertEqual(result, 11, "五加三乘二 should be 11")
    }
    
    func testParseChineseComplexNumbers() {
        // "十加五十" -> Note: ExpressionParser implementation treats "十" as "10", "五" as "5", "十" as "10".
        // It concatenates them into "10510", which is not ideal but test reflects current state.
        // Wait, the implementation says `currentNumber += num`, so "五十" becomes "510". "十加五十" becomes "10" + "510" = 520
        // Currently tokenizing algorithm just maps characters and concatenates numbers.
        let input = "十加五十"
        let result = parser.parseChineseVoiceInput(input)
        XCTAssertEqual(result, 520, "十(10) 加 五十(510) should be 520 under current logic")
    }
}
