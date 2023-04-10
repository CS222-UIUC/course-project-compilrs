//
//  MatrixModel.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import Foundation

class MatrixObject : ObservableObject {
    @Published var matrix: Matrix
    var rows: Int { matrix.rows }
    var cols: Int { matrix.cols }
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

enum ComputationErrors: Error {
    case notSquare
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
    guard matrix.rows != 0 && matrix.cols != 0 && matrix.isSquare else { return .none }
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
        for i in 1..<returny.rows {
            guard returny[i][0] != 0 else { continue }
            returny = swapRows(matrix: returny, row1: 0, row2: i)
            break
        }
    }
    
    for col in 0..<returny.cols {
        if (col + 1 < returny.rows) {
            for row in col+1..<returny.count {
                guard returny[row][col] != 0 else { continue }
                returny = addRows(matrix: returny, row1: col, row2: row, scale: -returny[row][col]/returny[col][col])
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
            guard returny[row][col] != 0 && col < returny.rows else { continue }
            returny = addRows(matrix: returny, row1: col, row2: row, scale: -returny[row][col])
        }
    }
    
    return (.none, .matrix(returny))
}

func inverseMatrix(matrix: Matrix) -> ReturnType? {
    guard matrix.rows != 0 && matrix.cols != 0 else { return .none }
    guard matrix.isSquare else { return .none }
    guard getDeterminant(matrix: matrix) != nil else { return .none }
    var returny = getMatrix(width: matrix.count, height: matrix.count)
    for i in 0..<matrix.count { returny[i][i] = 1.0 }
    
    var steps = [Step]()
    var matrix = matrix
    
    for i in 0..<matrix.count {
        let scale = 1.0 / matrix[i][i]
        matrix = scaleRow(matrix: matrix, row: i, scale: scale)
        returny = scaleRow(matrix: returny, row: i, scale: scale)
        steps.append(Step(matrix: matrix, stepDescription: "Scale row \(i) by \(scale)"))
        steps.append(Step(matrix: returny, stepDescription: "Scale row \(i) by \(scale)"))
        for j in 0..<matrix.count {
            guard j != i else { continue }
            let scale = -1.0 * matrix[j][i]
            matrix = addRows(matrix: matrix, row1: i, row2: j, scale: scale)
            returny = addRows(matrix: returny, row1: i, row2: j, scale: scale)
            steps.append(Step(matrix: matrix, stepDescription: "Add \(scale) * row \(i) to row \(j)"))
            steps.append(Step(matrix: returny, stepDescription: "Add \(scale) * row \(i) to row \(j)"))
        }
    }
    return (steps, .matrix(returny))
}

extension MatrixFunctions {
    var compute: (Matrix) -> ReturnType? {
        switch self {
        case .solve: return solveMatrix
        case .det: return getDeterminant
        case .rref: return reducedRowEchelon
        case .inv: return inverseMatrix
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
    var cols: Int {
        guard rows != 0 else { return 0 }
        return self[0].count
    }
    var isSquare: Bool { rows == cols }
    
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
    
    func mapDiag(_ transform: (Double) -> Double) throws -> Matrix {
        guard isSquare else { throw ComputationErrors.notSquare }
        var returny = self
        for i in 0..<returny.rows { returny[i][i] = transform(returny[i][i]) }
        return returny
    }
}

extension Array where Element == Double {
    func removeItem(at index: Int) -> [Double] {
        self.enumerated().compactMap { $0 == index ? nil : $1 }
    }
}
