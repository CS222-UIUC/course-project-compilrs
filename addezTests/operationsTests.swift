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
    func testCoefVectorMultiplication() {
        let a = [1.0, -1]
        let b = [3.0, 0]
        let c = [-2.0, 0]
        let d = [2, -1.0]
        let res = a <*> d <-> b <*> c
        let expected = [8.0, -3, 1]
        XCTAssertEqual(res, expected)
    }
    func testAddRows() {
        var A = [
            [1, 3, 7, 9],
            [3, 4, 0, 2.0]
        ]
        A = addRows(matrix: A, row1: 1, row2: 0, scale: 2)
        let expected = [
            [7, 11, 7, 13.0],
            [3, 4, 0, 2.0]
        ]
        XCTAssertEqual(A, expected)
    }
    func testPolynomialConversion() {
        let poly = [3.0, 4.0, 7.0]
        let f = poly.polynomialToFunction()
        XCTAssertEqual(f(3), 7*(3**2) + 4*(3) + 3)
        let arr = [3.0, 12.0, 9.0, 0.0, 7.0]
        let g = arr.polynomialToFunction()
        XCTAssertEqual(g(3), 7*(3**4) + 9*(3**2) + 12*3 + 3.0)
    }
    func testRationalRootsThm() {
        let polynomial = [-1, 0, 4.0]
        let roots = getRationalRoots(polynomial: polynomial)
        XCTAssert(roots.contains([-0.5, 0.5]))
    }
}
