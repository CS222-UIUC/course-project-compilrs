//
//  AppModel.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import Foundation

typealias Matrix = [[Double]]

typealias NTuple = [String]

typealias Step = (Matrix, String)

typealias ReturnType = ([Step], SolutionType?)

enum SolutionType {
    case ntuple(NTuple)
    case matrixTuple(Matrix, Matrix)
    case matrix(Matrix)
    case double(Double)
}

enum MatrixFunctions: String, CaseIterable {
    case solve = "Solve"
    case ludecomp = "LU Decomposition"
    case inv = "Inverse"
    case det = "Determinant"
    case eigenval = "Eigenvalue"
    case eigenvec = "Eigenvector"
}

func solveMatrix(matrix: Matrix) -> ReturnType {
    ([Step](), .double(1.0))
}

func getDeterminant(matrix: Matrix) -> ReturnType? {
    // if (matrix dimension is 1x1 then return the only value
    // if the matrix dimension is 2x2 then return the ad-bc
    // int output = for each int in the first row:
        // output += (-1)^index * (int in the row) * getDeterminant(genmatrix(matrix: Matrix, Int: col))
    // return output
    guard matrix.count != 0 && matrix[0].count != 0 else {
        return .none
    }
    return ([Step](), .double(getDetHelper(matrix)))
}

func getDetHelper(_ matrix: Matrix) -> Double {
    switch matrix.count {
        case 1: return matrix[0][0]
        case 2: return (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0])
        default:
        var output = 0.0
        for i in 0..<matrix.count {
            output += pow(-1, i).toDouble() * matrix[0][i] * getDetHelper(genMatrix(matrix: matrix, col: i))
        }
        return output
    }
}

func genMatrix(matrix: Matrix, col: Int) -> Matrix {
    var returny = Array(repeating: Array(repeating: 0.0, count: matrix[0].count - 1), count: matrix.count - 1)
    for i in 1..<matrix.count {
        for j in 0..<matrix.count {
            if (j < col) {
                returny[i-1][j] = matrix[i][j]
            }
            if (j > col) {
                returny[i-1][j-1] = matrix[i][j]
            }
        }
    }
    return returny
}


extension MatrixFunctions {
    func getFunc() -> (Matrix) -> ReturnType? {
        switch self {
            case .solve: return solveMatrix
            case .det: return getDeterminant
            default: return solveMatrix
        }
    }
    
    func getMaxDimensions() -> (Double, Double) {
        switch self {
        case .det: return (8, 8)
        default: return (10, 10)
        }
    }
}
