//
//  integralTests.swift
//  addezTests
//
//  Created by Ayush Raman on 3/24/23.
//

import XCTest

func within(_ x: Double?, _ y: Double?, delta: Double = 0.0001) -> Bool {
    if ((x == .nan && y == .nan) || (x == .none && y == .none) || (x == .infinity && y == .infinity)) {
        return true }
    guard x != y else { return true }
    guard let x = x, let y = y else { return false }
    return abs(x - y) < delta
}

final class integralTests: XCTestCase {
    func testNestedFunctions() {
        guard let f = parseExpression("sin(cos(tan(x)))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 0.835947745218))
        guard let f = parseExpression("log(sin(x^3))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), -0.0193713634352))
        guard let f = parseExpression("log(sin(x^(tan(x))))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), -0.122283654628))
        guard let f = parseExpression("log(sin(x^(tan(x))))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), -0.122283654628))
    }
    
    func testPEMDAS() {
        guard let f = parseExpression("e^(3*(x+2))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 3269017.37247))
        guard let f = parseExpression("sqrt(x^2+3*x)") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 4.24264068712))
        guard let f = parseExpression("6/(x*(1+x))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 0.5))
        guard let f = parseExpression("x+x*(1/(3-x))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), .infinity))
    }
    
    func testCoefficients() {
        guard let f = parseExpression("2x") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 6))
        guard let f = parseExpression("3sin(x)") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(.pi*3), 0))
        guard let f = parseExpression("15x^4/(4x)") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 101.25))
        guard let f = parseExpression("-3x^(3tan(x*pi))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), -3))
        guard let f = parseExpression("xpi") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 3 * Double.pi))
        guard let f = parseExpression("xsin(3x + 7cos(2x))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 3*sin(3*3 + 7*cos(2*3))))
    }
    
    func testTrig() {
        guard let f = parseExpression("sin(acos(x))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(0.5), 0.866))
        guard let f = parseExpression("tan(asin(x))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(0.5), 0.57735))
        guard let f = parseExpression("tan(asin(cos(x*pi)))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(0.25), 1))
        guard let f = parseExpression("csc(tan(1/acos(x)))") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(0.5), 1.01257))
    }
    
    func testIntegrals() {
        guard let f = parseExpression("3") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(riemannSum(in: 0...(3.0), f), 9))
        guard let f = parseExpression("4x^3") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(riemannSum(in: 0...(2.0), f), 16))
        guard let f = parseExpression("1/x") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(riemannSum(in: (1.0)...exp(2), f), 2))
        guard let f = parseExpression("(x/3)*cos(x)") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(riemannSum(in: (0.0)...(4.0), f), -1.56028))
    }
    
    func testPostfixFunctions() {
        guard let f = parseExpression("x!") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), 3<>))
        XCTAssert(within(f(0), 1))
        guard let f = parseExpression("sin(x)!") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), sin(3)<>))
        guard let f = parseExpression("(x^2)!") else { XCTAssertNotNil(nil); return }
        XCTAssert(within(f(3), (3**2)<>))
    }
    

}
