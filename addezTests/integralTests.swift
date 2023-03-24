//
//  integralTests.swift
//  addezTests
//
//  Created by Ayush Raman on 3/24/23.
//

import XCTest


final class integralTests: XCTestCase {
    func within(_ x: Double?, _ y: Double?, delta: Double = 0.000001) -> Bool {
        guard x != y else { return true }
        guard let x = x, let y = y else { return false }
        return abs(x - y) < delta
    }
    
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
}
