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
    func testEvaluatePolynomialsComplexValue() {
        let polynomial = [-5.0, 3.0, -3.0, 1.0]
        let value = Complex(real: 1, imaginary: 0)
        
        let res = evaluate(polynomial: polynomial, value: value)
        let expected = Complex(real: -4, imaginary: 0)
        
        XCTAssertEqual(res.real, expected.real)
        XCTAssertEqual(res.imaginary, expected.imaginary)
    }
    func testKurnerDurand() {
        let polynomial = [-5.0, 3.0, -3.0, 1.0]
        let res = rootFinding(polynom: polynomial)
        let expected = [Complex(real: 2.587401051968199474751706, imaginary: 0), Complex(real: 0.2062994740159002626241472, imaginary: 1.3747296369986026263834792), Complex(real: 0.2062994740159002626241472, imaginary: -1.3747296369986026263834792)]
        // check if each element in res is in expected and that their lengths are the same
        XCTAssertEqual(res.count, expected.count)
        // var error_vector = [Double]()
        for i in 0..<res.count {
            for j in 0..<expected.count {
                if res[i] ≈≈ expected[j] {
                    // error_vector.append((res[i].real - expected[j].real).magnitude)
                    // error_vector.append((res[i].imaginary - expected[j].imaginary).magnitude)
                    break
                }
                if j == expected.count - 1 {
                    // error_vector.append((res[i].real - expected[j].real).magnitude)
                    // error_vector.append((res[i].imaginary - expected[j].imaginary).magnitude)
                    XCTFail("res[\(i)] = \(res[i]) not in expected")
                }
            }
        }
        // Swift.print("error: \(error_vector)")
    }
    func testKurnerDurand2() {
        let polynomial = [30.0, -18.0, 3.0, 0.0, 5.0]
        let res = rootFinding(polynom: polynomial)
        let expected = [Complex(real: 1.070017935364537754766582, imaginary: 0.7770656248581305512797152), Complex(real: 1.070017935364537754766582, imaginary: -0.7770656248581305512797152), Complex(real: -1.070017935364537754766582, imaginary: -1.511967519051721994121402), Complex(real: -1.070017935364537754766582, imaginary: 1.511967519051721994121402)]
        // check if each element in res is in expected and that their lengths are the same
        XCTAssertEqual(res.count, expected.count)
        // var error_vector = [Double]()
        for i in 0..<res.count {
            for j in 0..<expected.count {
                if res[i] ≈≈ expected[j] {
                    // error_vector.append((res[i].real - expected[j].real).magnitude)
                    // error_vector.append((res[i].imaginary - expected[j].imaginary).magnitude)
                    break
                }
                if j == expected.count - 1 {
                    // error_vector.append((res[i].real - expected[j].real).magnitude)
                    // error_vector.append((res[i].imaginary - expected[j].imaginary).magnitude)
                    XCTFail("res[\(i)] = \(res[i]) not in expected")
                }
            }
        }
        // Swift.print("error: \(error_vector)")
    }
    func testKurnerDurand3() {
        let polynomial = [1.0, 0.0, 0.0, 0.0, 1.0]
        let res = rootFinding(polynom: polynomial)
        let expected = [Complex(real: 0.70710678118655, imaginary: 0.70710678118655), Complex(real: 0.70710678118655, imaginary: -0.70710678118655), Complex(real: -0.70710678118655, imaginary: -0.70710678118655), Complex(real: -0.70710678118655, imaginary: 0.70710678118655)]
        // check if each element in res is in expected and that their lengths are the same
        XCTAssertEqual(res.count, expected.count)
        // var error_vector = [Double]()
        for i in 0..<res.count {
            for j in 0..<expected.count {
                if res[i] ≈≈ expected[j] {
                    // error_vector.append((res[i].real - expected[j].real).magnitude)
                    // error_vector.append((res[i].imaginary - expected[j].imaginary).magnitude)
                    break
                }
                if j == expected.count - 1 {
                    // error_vector.append((res[i].real - expected[j].real).magnitude)
                    // error_vector.append((res[i].imaginary - expected[j].imaginary).magnitude)
                    XCTFail("res[\(i)] = \(res[i]) not in expected")
                }
            }
        }
        // Swift.print("error: \(error_vector)")
    }
    func testKurnerDurand4() {
        let polynomial = [1.0, 2.0, 1.0]
        let res = rootFinding(polynom: polynomial)
        let expected = [Complex(real: -1, imaginary: 0), Complex(real: -1, imaginary: 0)]
        
        // check if each element in res is in expected and that their lengths are the same
        XCTAssertEqual(res.count, expected.count)
        // var error_vector = [Double]()
        for i in 0..<res.count {
            for j in 0..<expected.count {
                if res[i] ≈≈ expected[j] {
                    // error_vector.append((res[i].real - expected[j].real).magnitude)
                    // error_vector.append((res[i].imaginary - expected[j].imaginary).magnitude)
                    break
                }
                if j == expected.count - 1 {
                    // error_vector.append((res[i].real - expected[j].real).magnitude)
                    // error_vector.append((res[i].imaginary - expected[j].imaginary).magnitude)
                    XCTFail("res[\(i)] = \(res[i]) not in expected")
                }
            }
        }
        // Swift.print("error: \(error_vector)")
    }
}
