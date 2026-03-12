import XCTest
@testable import Calculator

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
        let result = solver.solveLinear(a: 2, b: 4, c: 10)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.solutions[0], 3, "2x + 4 = 10 should have x = 3")
    }
    
    func testLinearEquation2() {
        // 3x - 6 = 0 → x = 2
        let result = solver.solveLinear(a: 3, b: -6, c: 0)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.solutions[0], 2, "3x - 6 = 0 should have x = 2")
    }
    
    func testLinearEquationNoSolution() {
        // 0x + 5 = 10 → no solution
        let result = solver.solveLinear(a: 0, b: 5, c: 10)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.solutions.isEmpty, "0x + 5 = 10 should have no solution")
    }
    
    func testLinearEquationInfiniteSolutions() {
        // 0x + 0 = 0 → infinite solutions
        let result = solver.solveLinear(a: 0, b: 0, c: 0)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.solutions.isEmpty, "0x + 0 = 0 should have infinite solutions")
    }
    
    // MARK: - Quadratic Equation Tests
    
    func testQuadraticEquation1() {
        // x² - 3x + 2 = 0 → x = 1 or x = 2
        let result = solver.solveQuadratic(a: 1, b: -3, c: 2)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.solutions[0], 2, "First root should be 2")
        XCTAssertEqual(result!.solutions[1], 1, "Second root should be 1")
    }
    
    func testQuadraticEquationNoSolution() {
        // x² + 1 = 0 → no real solutions
        let result = solver.solveQuadratic(a: 1, b: 0, c: 1)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.solutions.isEmpty, "x² + 1 = 0 should have no real solutions")
    }
    
    func testQuadraticEquationOneSolution() {
        // x² - 2x + 1 = 0 → x = 1
        let result = solver.solveQuadratic(a: 1, b: -2, c: 1)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.solutions[0], 1, "Both roots should be 1")
    }
    
}
