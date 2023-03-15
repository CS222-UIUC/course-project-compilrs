//
//  addezTests.swift
//  addezTests
//
//  Created by Ayush Raman on 2/1/23.
//

import XCTest
@testable import addez

final class addezTests: XCTestCase {
    
    func testReducedRowEchelon2x2() {
        let matrix = [[1.0, 3.0], [4.0, 9.0]]
        let return_matrix = reducedRowEchelon(matrix: matrix)
        let expected = [[1.0, 0.0], [0.0, 1.0]]
        XCTAssertEqual(return_matrix, expected)
    }
    
    func testReducedRowEchelon3x3() {
        let matrix = [[1.0, 2.0, 6.0], [4.0, 10.0, 6.0], [5.0, 8.0, 12.0]]
        let returny = reducedRowEchelon(matrix: matrix)
        let expected = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]
        XCTAssertEqual(returny, expected)
    }
    
    func testReducedRowEchelon3x4() {
        let matrix = [[1.0, 2.0, 6.0, 4.0], [4.0, 10.0, 6.0, 7.0], [5.0, 8.0, 12.0, 6.0]]
        var returny = reducedRowEchelon(matrix: matrix)
        var expected = [[1.0, 0.0, 0.0, -7.0/3.0], [0.0, 1.0, 0.0, 5.0/4.0], [0.0, 0.0, 1.0, 23.0/36.0]]
        // round everything in expected and returny to 7 decimal places
        for i in 0..<expected.count {
            for j in 0..<expected[0].count {
                expected[i][j] = round(expected[i][j] * 10000000) / 10000000
                returny[i][j] = round(returny[i][j] * 10000000) / 10000000
            }
        }
        XCTAssertEqual(returny, expected)
    }
    
    func testReducedRowEchelon4x3() {
        let matrix = [[1.0, 2.0, 6.0], [4.0, 10.0, 6.0], [5.0, 8.0, 12.0], [3.0, 2.0, 9.0]]
        var returny = reducedRowEchelon(matrix: matrix)
        var expected = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0], [0.0, 0.0, 0.0]]
        // round everything in expected and returny to 7 decimal places
        for i in 0..<expected.count {
            for j in 0..<expected[0].count {
                expected[i][j] = round(expected[i][j] * 10000000) / 10000000
                returny[i][j] = round(returny[i][j] * 10000000) / 10000000
            }
        }
        XCTAssertEqual(returny, expected)
    }

}
