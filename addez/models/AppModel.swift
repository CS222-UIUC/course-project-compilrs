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

func getDeterminant(matrix: Matrix) -> ReturnType {
    ([Step](), .double(1.0))
}

extension MatrixFunctions {
    func getFunc() -> (Matrix) -> ReturnType {
        switch self {
            case .solve: return solveMatrix
            case .det: return getDeterminant
            default: return solveMatrix
        }
    }
}
