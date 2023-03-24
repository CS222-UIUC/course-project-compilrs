//
//  matrixTests.swift
//  addezTests
//
//  Created by Ayush Raman on 2/1/23.
//

import XCTest

final class addezTests: XCTestCase {
    
    func testReducedRowEchelon2x2() {
        let matrix = [[1.0, 3.0], [4.0, 9.0]]
        let expected = [[1.0, 0.0], [0.0, 1.0]]
        guard let return_matrix = reducedRowEchelon(matrix: matrix) else { XCTAssertNotNil(nil); return }
        switch return_matrix.solution {
        case .matrix(let matrix): XCTAssertEqual(matrix, expected)
        default: XCTAssert(false)
        }
    }
    
    func testReducedRowEchelon3x3() {
        let matrix = [[1.0, 2.0, 6.0], [4.0, 10.0, 6.0], [5.0, 8.0, 12.0]]
        let expected = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]
        guard let returny = reducedRowEchelon(matrix: matrix) else { return }
        switch returny.solution {
        case .matrix(let matrix): XCTAssertEqual(matrix, expected)
        default: XCTAssert(false)
        }
    }
    
    func testReducedRowEchelon3x4() {
        let matrix = [[1.0, 2.0, 6.0, 4.0], [4.0, 10.0, 6.0, 7.0], [5.0, 8.0, 12.0, 6.0]]
        guard let returny = reducedRowEchelon(matrix: matrix) else { XCTAssertNotNil(nil); return }
        var expected = [[1.0, 0.0, 0.0, -7.0/3.0], [0.0, 1.0, 0.0, 5.0/4.0], [0.0, 0.0, 1.0, 23.0/36.0]]
        // round everything in expected and returny to 7 decimal places
        switch returny.solution {
        case .matrix(var matrix):
            for i in 0..<expected.count {
                for j in 0..<expected[0].count {
                    expected[i][j] = round(expected[i][j] * 10000000) / 10000000
                    matrix[i][j] = round(matrix[i][j] * 10000000) / 10000000
                }
            }
            XCTAssertEqual(matrix, expected)
        default: XCTAssert(false)
        }
    }
    
    func testReducedRowEchelon4x3() {
        let matrix = [[1.0, 2.0, 6.0], [4.0, 10.0, 6.0], [5.0, 8.0, 12.0], [3.0, 2.0, 9.0]]
        guard let returny = reducedRowEchelon(matrix: matrix) else { XCTAssertNotNil(nil); return }
        var expected = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0], [0.0, 0.0, 0.0]]
        // round everything in expected and returny to 7 decimal places
        switch returny.solution {
        case .matrix(var matrix):
            for i in 0..<expected.count {
                for j in 0..<expected[0].count {
                    expected[i][j] = round(expected[i][j] * 10000000) / 10000000
                    matrix[i][j] = round(matrix[i][j] * 10000000) / 10000000
                }
            }
            XCTAssertEqual(matrix, expected)
        default: XCTAssert(false)
        }
    }

}
