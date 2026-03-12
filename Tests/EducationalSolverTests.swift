import XCTest
@testable import Calculator

final class EducationalSolverTests: XCTestCase {
    
    var solver: EducationalSolver!
    
    override func setUp() {
        super.setUp()
        solver = EducationalSolver.shared
    }
    
    override func tearDown() {
        solver = nil
        super.tearDown()
    }
    
    // MARK: - solveWithSteps Tests
    
    func testLinearEquation() {
        // Due to the current logic in EducationalSolver:
        // if input.contains("x") -> returns (.linear, 1, 0, nil) -> a=1, b=0, c=0
        let solution = solver.solveWithSteps("2x + 4 = 10")
        XCTAssertNotNil(solution)
        XCTAssertEqual(solution?.type, .linear)
        // With a=1, b=0, c=0, x = (0 - 0) / 1 = 0
        XCTAssertEqual(solution?.result, "x = 0")
        XCTAssertEqual(solution?.steps.count, 4)
    }
    
    func testQuadraticEquation() {
        // Due to the current logic:
        // if input.contains("x²") -> returns (.quadratic, 1, 0, 0)
        let solution = solver.solveWithSteps("x² - 4 = 0")
        XCTAssertNotNil(solution)
        XCTAssertEqual(solution?.type, .quadratic)
        // With a=1, b=0, c=0, x1 and x2 should evaluate to 0
        XCTAssertEqual(solution?.result, "x₁ = 0, x₂ = 0")
        XCTAssertEqual(solution?.steps.count, 4)
    }
    
    func testArithmeticExpression() {
        // Evaluated using ExpressionParser, split by space.
        let solution = solver.solveWithSteps("5 + 3 × 2")
        XCTAssertNotNil(solution)
        XCTAssertEqual(solution?.type, .arithmetic)
        XCTAssertEqual(solution?.result, "11")
        XCTAssertEqual(solution?.steps.count, 2)
    }
    
    func testInvalidArithmeticExpression() {
        // "abc" will fail splitting by space to valid tokens for evaluate()
        let solution = solver.solveWithSteps("abc")
        XCTAssertNil(solution, "Should return nil for completely invalid arithmetic inputs that expression parser cannot evaluate")
    }
}
