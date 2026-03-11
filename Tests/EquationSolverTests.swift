import XCTest
@testable import CalculatorCore

final class EquationSolverTests: XCTestCase {
    
    var solver: EquationSolver!
    
    override func setUp() {
        super.setUp()
        solver = EquationSolver()
    }
    
    override func tearDown() {
        solver = nil
        super.tearDown()
    }
    
    // MARK: - Linear Equation Tests
    
    func testLinearEquation1() {
        // 2x + 4 = 10 → x = 3
        let result = solver.solveLinearEquation(a: 2, b: 4, c: 10)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.x, 3, "2x + 4 = 10 should have x = 3")
    }
    
    func testLinearEquation2() {
        // 3x - 6 = 0 → x = 2
        let result = solver.solveLinearEquation(a: 3, b: -6, c: 0)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.x, 2, "3x - 6 = 0 should have x = 2")
    }
    
    func testLinearEquationNoSolution() {
        // 0x + 5 = 10 → no solution
        let result = solver.solveLinearEquation(a: 0, b: 5, c: 10)
        
        XCTAssertNil(result, "0x + 5 = 10 should have no solution")
    }
    
    func testLinearEquationInfiniteSolutions() {
        // 0x + 0 = 0 → infinite solutions
        let result = solver.solveLinearEquation(a: 0, b: 0, c: 0)
        
        XCTAssertNil(result, "0x + 0 = 0 should have infinite solutions")
    }
    
    // MARK: - Quadratic Equation Tests
    
    func testQuadraticEquation1() {
        // x² - 3x + 2 = 0 → x = 1 or x = 2
        let result = solver.solveQuadraticEquation(a: 1, b: -3, c: 2)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.x1, 2, "First root should be 2")
        XCTAssertEqual(result!.x2, 1, "Second root should be 1")
    }
    
    func testQuadraticEquationNoSolution() {
        // x² + 1 = 0 → no real solutions
        let result = solver.solveQuadraticEquation(a: 1, b: 0, c: 1)
        
        XCTAssertNil(result, "x² + 1 = 0 should have no real solutions")
    }
    
    func testQuadraticEquationOneSolution() {
        // x² - 2x + 1 = 0 → x = 1
        let result = solver.solveQuadraticEquation(a: 1, b: -2, c: 1)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.x1, 1, "Both roots should be 1")
    }
    
    // MARK: - Discriminant Tests
    
    func testDiscriminantPositive() {
        // x² - 4x + 3 = 0 → Δ = 16 - 12 = 4 > 0
        let discriminant = solver.calculateDiscriminant(a: 1, b: -4, c: 3)
        
        XCTAssertEqual(discriminant, 4, "Discriminant should be 4")
    }
    
    func testDiscriminantZero() {
        // x² - 2x + 1 = 0 → Δ = 4 - 4 = 0
        let discriminant = solver.calculateDiscriminant(a: 1, b: -2, c: 1)
        
        XCTAssertEqual(discriminant, 0, "Discriminant should be 0")
    }
    
    func testDiscriminantNegative() {
        // x² + 1 = 0 → Δ = 0 - 4 = -4 < 0
        let discriminant = solver.calculateDiscriminant(a: 1, b: 0, c: 1)
        
        XCTAssertEqual(discriminant, -4, "Discriminant should be -4")
    }
}
