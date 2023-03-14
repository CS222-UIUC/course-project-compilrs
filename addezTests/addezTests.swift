//
//  addezTests.swift
//  addezTests
//
//  Created by Ayush Raman on 2/1/23.
//

import XCTest
@testable import addez

final class addezTests: XCTestCase {

    func testRowEchelon2x2() {
        let matrix = [[1.0, 3.0], [4.0, 9.0]]
        let return_matrix = rowEchelon(matrix: matrix)
        let expected = [[1.0, 2.25], [0.0, 1.0]]
        XCTAssertEqual(return_matrix, expected)
    }
    
    func testRowEchelon3x3() {
        let matrix = [[1.0, 2.0, 6.0], [4.0, 10.0, 6.0], [5.0, 8.0, 12.0]]
        let returny = rowEchelon(matrix: matrix)
        let expected = [[1.0, 1.6, 2.4], [0.0, 1.0, -1.0], [0.0, 0.0, 1.0]]
        XCTAssertEqual(returny, expected)
    }

}
