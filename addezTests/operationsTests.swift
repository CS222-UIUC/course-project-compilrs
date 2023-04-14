//
//  operationsTests.swift
//  addezTests
//
//  Created by Ayush Raman on 4/14/23.
//

import Foundation

import XCTest

final class operationsTests: XCTestCase {
    func testVectorTimesScalar() {
        let vec = [1, -3.0, 4, 0]
        let res = 2 * vec
        let expected = [2, -6.0, 8, 0]
        XCTAssertEqual(res, expected)
    }
    func testVectorPlusVector() {
        let vec = [1, 2.0, 3]
        let res = [1, -4.0, 9] <+> vec
        let expected = [2, -2.0, 12]
        XCTAssertEqual(res, expected)
    }
    func testRowScale() {
        let matrix = [
            [2, 2],
            [3, 9.0]
        ]
        let res = scaleRow(matrix: matrix, row: 1, scale: 7)
        let expected = [
            [2, 2],
            [21, 63.0]
        ]
        XCTAssertEqual(res, expected)
    }
}
