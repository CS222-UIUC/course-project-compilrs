//
//  addezTests.swift
//  addezTests
//
//  Created by Ayush Raman on 2/1/23.
//

import XCTest

final class addezTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        // create a matrix of size 2x2 with [[1, 3], [4, 9]] and apply the row reduction algorithm to it
        // create a matrix of size 3x3 with [[1, 3, 5], [4, 9, 2], [7, 6, 8]] and apply the row reduction algorithm to it
        // create a matrix of size 4x4 with [[1, 3, 5, 7], [4, 9, 2, 6], [7, 6, 8, 4], [3, 2, 1, 5]] and apply the row reduction algorithm to it

        matrix = [[1, 3], [4, 9]]
        // apply the row reduction algorithm to the matrix
        // check if the matrix is in reduced row echelon form
        return_matrix = rowEchelon(matrix: matrix)
        // print out return matrix
        print(return_matrix)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
