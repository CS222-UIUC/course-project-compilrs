//
//  AppModel.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import Foundation

class MatrixObject : ObservableObject {
    @Published var matrix: Matrix
    var rows: Int { matrix.count }
    var cols: Int { matrix[0].count }
    init(_ matrix: Matrix) {
        self.matrix = matrix
    }
}

typealias Matrix = [[Double]]

typealias NTuple = [String]

struct Step: Identifiable {
    var id: UUID
    let matrix: Matrix
    let stepDescription: String
    init(matrix: Matrix, stepDescription: String) {
        self.id = UUID()
        self.matrix = matrix
        self.stepDescription = stepDescription
    }
}

typealias ReturnType = (steps: [Step]?, solution: SolutionType?)

enum SolutionType {
    case ntuple(NTuple)
    case matrixTuple(lower: Matrix, upper: Matrix)
    case matrix(Matrix)
    case double(Double)
}

enum MatrixFunctions: String, CaseIterable {
    case solve = "Solve"
    case rref = "Reduced Row Echelon"
    case ludecomp = "LU Decomposition"
    case inv = "Inverse"
    case det = "Determinant"
    case eigenval = "Eigenvalue"
    case eigenvec = "Eigenvector"
}

func solveMatrix(matrix: Matrix) -> ReturnType? {
    .none
}

func getDeterminant(matrix: Matrix) -> ReturnType? {
    // if (matrix dimension is 1x1 then return the only value
    // if the matrix dimension is 2x2 then return the ad-bc
    // int output = for each int in the first row:
    // output += (-1)^index * (int in the row) * getDeterminant(genmatrix(matrix: Matrix, Int: col))
    // return output
    guard matrix.count != 0 && matrix[0].count != 0 else { return .none }
    return (.none, .double(getDetHelper(matrix)))
}

func getDetHelper(_ matrix: Matrix) -> Double {
    switch matrix.count {
    case 1: return matrix[0][0]
    case 2: return (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0])
    default:
        var output = 0.0
        for i in 0..<matrix.count {
            output += pow(-1, i.toDouble()) * matrix[0][i] * getDetHelper(matrix.withoutColumn(at: i))
        }
        return output
    }
}

func getMatrix(width: Int, height: Int) -> Matrix {
    Array(repeating: Array(repeating: 0.0, count: width), count: height)
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

func swapRows(matrix: Matrix, row1: Int, row2: Int) -> Matrix {
    // row1 <-> row2
    var returny = matrix
    returny.swapAt(row1, row2)
    return returny
}

func scaleRow(matrix: Matrix, row: Int, scale: Double) -> Matrix {
    // row = scale * row
    matrix.mapAt(row: row) { $0 * scale }
}

func addRows(matrix: Matrix, row1: Int, row2: Int, scale: Double) -> Matrix {
    // row2 = row2 + scale * row1
    var returny = matrix
    for col in 0..<returny[0].count { returny[row2][col] += scale * returny[row1][col] }
    return returny
}

func rowEchelon(matrix: Matrix) -> Matrix {
    // convert the given matrix in to row echelon form
    var returny = matrix
    // if the first row and first column index is 0, switch the row with another row that has a non-zero value in the first column
    if (returny[0][0] == 0) {
        for i in 1..<returny.count {
            if (returny[i][0] != 0) {
                returny = swapRows(matrix: returny, row1: 0, row2: i)
                break
            }
        }
    }
    
    for col in 0..<returny[0].count {
        if (col + 1 < returny.count) { 
            for row in col+1..<returny.count {
                if (returny[row][col] != 0) {
                    returny = addRows(matrix: returny, row1: col, row2: row, scale: -returny[row][col]/returny[col][col])
                }
            }
        }
    }
    return returny
}

func reducedRowEchelon(matrix: Matrix) -> ReturnType? {
    var returny = rowEchelon(matrix: matrix)
    // divide each each row by its pivot value
    for row in 0..<returny.rows {
        // find the first non-zero value in the row and divide the row by that value
        for col in 0..<returny[0].count {
            if (returny[row][col] != 0) {
                returny = scaleRow(matrix: returny, row: row, scale: 1/returny[row][col])
                break
            }
        }
    }
    
    for col in 0..<returny.cols {
        for row in 0..<col {
            if (returny[row][col] != 0 && col < returny.rows) {
                returny = addRows(matrix: returny, row1: col, row2: row, scale: -returny[row][col])
            }
        }
    }
    return (.none, .matrix(returny))
}

extension MatrixFunctions {
    var compute: (Matrix) -> ReturnType? {
        switch self {
        case .solve: return solveMatrix
        case .det: return getDeterminant
        case .rref: return reducedRowEchelon
        default: return solveMatrix
        }
    }
    
    var maxDimensions: (rows: Double, cols: Double) {
        switch self {
        case .det: return (8, 8)
        default: return (10, 10)
        }
    }
}

extension Matrix {
    var rows: Int { self.count }
    var cols: Int { self[0].count }
    
    static let maxDimensions = (rows: 6, cols: 6)
    
    static let validDimensions = (rows: 1...6, cols: 1...6)
    
    func withoutColumn(at column: Int) -> Matrix {
        guard column > 0 && column < count else { return self }
        return self.map { $0.removeItem(at: column) }
    }
    
    func getColumn(at column: Int) -> [Double] {
        guard column > 0 && column < cols else { return [] }
        return self.map { $0[column] }
    }
    
    func getRow(at row: Int) -> [Double] {
        guard row > 0 && row < rows else { return [] }
        return self[row]
    }
    
    func mapAt(row: Int, _ transform: (Double) -> Double) -> Matrix {
        var returny = self
        for i in 0..<returny.cols { returny[row][i] = transform(returny[row][i]) }
        return returny
    }
    
    func mapAt(col: Int, _ transform: (Double) -> Double) -> Matrix {
        var returny = self
        for i in 0..<returny.rows { returny[i][col] = transform(returny[i][col]) }
        return returny
    }
}

extension Array where Element == Double {
    func removeItem(at index: Int) -> [Double] {
        self.enumerated().compactMap { $0 == index ? nil : $1 }
    }
}
