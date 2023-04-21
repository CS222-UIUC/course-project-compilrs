//
//  matrixTests.swift
//  addezTests
//
//  Created by Ayush Raman on 2/1/23.
//

import XCTest

final class matrixTests: XCTestCase {
    
    func testReducedRowEchelon2x2() {
        let matrix = [[1.0, 3.0], [4.0, 9.0]]
        let expected = [[1.0, 0.0], [0.0, 1.0]]
        guard let returny = reducedRowEchelon(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }
    
    func testReducedRowEchelon3x3() {
        let matrix = [[1.0, 2.0, 6.0], [4.0, 10.0, 6.0], [5.0, 8.0, 12.0]]
        let expected = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]
        guard let returny = reducedRowEchelon(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }
    
    func testReducedRowEchelon3x4() {
        let matrix = [[1.0, 2.0, 6.0, 4.0], [4.0, 10.0, 6.0, 7.0], [5.0, 8.0, 12.0, 6.0]]
        guard var returny = reducedRowEchelon(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
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
        guard var returny = reducedRowEchelon(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        var expected = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0], [0.0, 0.0, 0.0]]
        // round everything in expected and returny to 7 decimal places
        for i in 0..<expected.count {
            for j in 0..<expected[0].count {
                expected[i][j] = round(expected[i][j] * 10000000) / 10000000
                returny[i][j] = round(returny[i][j] * 10000000) / 10000000
            }
        }
        XCTAssertEqual(matrix, expected)
    }

    func testgetDet1x1() {
        let matrix = [[8.0]]
        let expected = 8.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }
    
    func testgetDet2x2Normal() {
        let matrix = [
            [1.0, 3.0], 
            [4.0, 9.0]]
        let expected = -3.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }

    func testgetDet2x2Triag() {
        let matrix = [
            [1.0, 3.0],
            [0.0, 9.0]]
        let expected = 9.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }
    
    func testgetDet3x3Normal() {
        let matrix = [
            [1.0, 3.0, 0.0], 
            [4.0, -2.0, -1.0], 
            [2.0, 3.0, -1.0]]
        let expected = 11.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }

    func testgetDet3x3Ones() {
        let matrix = [
            [1.0, 1.0, 1.0], 
            [1.0, 1.0, 1.0], 
            [1.0, 1.0, 1.0]]
        let expected = 0.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }
    
    func testgetDet3x3Triag() {
        let matrix = [
            [7.0, 0.0, 0.0],
            [4.0, -2.0, 0.0],
            [2.0, 3.0, -3.0]]
        let expected = 42.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }

    func testgetDet4x4Normal() {
        let matrix = [
            [1.0, 3.0, 0.0, 2.0], 
            [4.0, -2.0, -1.0, 3.0], 
            [2.0, 3.0, -1.0, 1.0], 
            [1.0, 2.0, 3.0, 4.0]]
        let expected = -57.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }
    
    func testgetDet4x4Triag() {
        let matrix = [
            [1.0, 3.0, 0.0, 2.0],
            [0.0, -2.0, -1.0, 3.0],
            [0.0, 0.0, -1.0, 1.0],
            [0.0, 0.0, 0.0, 4.0]]
        let expected = 8.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }

    func testgetDet5x5Normal() {
        let matrix = [
            [1.0, 3.0, 0.0, 2.0, 1.0], 
            [4.0, -2.0, -1.0, 3.0, 2.0], 
            [2.0, 3.0, -1.0, 1.0, 3.0], 
            [1.0, 2.0, 3.0, 4.0, 4.0], 
            [-4.0, 2.0, 0.0, 1.0, 5.0]]
        let expected = -915.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }
    
    func testgetDet5x5Triag() {
        let matrix = [
            [1.0, 0.0, 0.0, 0.0, 0.0],
            [4.0, -2.0, 0.0, 0.0, 0.0],
            [2.0, 3.0, -1.0, 0.0, 0.0],
            [1.0, 2.0, 3.0, 4.0, 0.0],
            [-4.0, 2.0, 0.0, 1.0, 5.0]]
        let expected = 40.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }

    func testgetDet6x6Normal() {
        let matrix = [
            [1.0, 3.0, 0.0, 2.0, 1.0, 1.0], 
            [4.0, -2.0, -1.0, 3.0, 2.0, 2.0],  
            [1.0, 2.0, 3.0, 4.0, 4.0, 4.0], 
            [-4.0, 2.0, 0.0, 1.0, 5.0, 5.0], 
            [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
            [2.0, 3.0, -1.0, 1.0, 3.0, 3.0]]
        let expected = 915.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }
    
    func testgetDet6x6Triag() {
        let matrix = [
            [1.0, 3.0, 0.0, 2.0, 1.0, 1.0],
            [0.0, -2.0, -1.0, 3.0, 2.0, 2.0],
            [0.0, 0.0, 3.0, 4.0, 4.0, 4.0],
            [0.0, 0.0, 0.0, 1.0, 5.0, 5.0],
            [0.0, 0.0, 0.0, 0.0, 5.0, 6.0],
            [0.0, 0.0, 0.0, 0.0, 0.0, 3.0]]
        let expected = -90.0
        guard let returny = getDeterminant(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
        XCTAssertEqual(returny, expected)
    }

    func testCharacteristicPoly() {
        var matrix = [
            [1.0, 2.0, -2.0],
            [3.0, 0.0, 1.0],
            [-2.0, 1.0, 4.0]
        ]
        var cube = matrix.enumerated().map { i, row in
            row.enumerated().map { j, element in
                var arr = [element]
                if j == i { arr.append(-1) }
                return arr
            }
        }
        var expected = [-35.0, 7.0, 5.0, -1.0]
        var returny = getCharacteristicPolynomial(matrix: cube)
        XCTAssertEqual(returny, expected)
        
        matrix = [
            [9.0, -3, 0, 2, 4],
            [-2.0, 0, 3, 1, 5],
            [1.0, 2, 1, 1, 0],
            [-4.0, 5, 2, 1, 4],
            [6.0, 9, 8, 3, 1]
        ]
        cube = matrix.enumerated().map { i, row in
            row.enumerated().map { j, element in
                var arr = [element]
                if j == i { arr.append(-1) }
                return arr
            }
        }
        expected = [-1283, -705, -679, 62, 12, -1]
        returny = getCharacteristicPolynomial(matrix: cube)
        XCTAssertEqual(returny, expected)
    }
    
//    func testEigenvalues() {
//        var matrix = [
//            [1.0, 2.0, -2.0],
//            [3.0, 0.0, 1.0],
//            [-2.0, 1.0, 4.0]
//        ]
//        var expected = [5.0]
//        guard let eigenvalues = getEigenvalues(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
//        XCTAssertEqual(eigenvalues, expected)
//        matrix = [
//            [3.0, 2.0, -2.0],
//            [3.0, 5.0, 1.0],
//            [-2.0, 1.0, 2.0]
//        ]
//        expected = [6.65736, 3.91775, -0.575112]
//        guard let eigenvalues = getEigenvalues(matrix: matrix)?.solution else { XCTAssertNotNil(nil); return }
//        XCTAssertEqual(eigenvalues, expected)
//    }
}
