//
//  MatrixModel.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import Foundation

class MatrixObject: ObservableObject {
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
    if let det = matrix.reduceDiag(1, *), matrix.isLowerTriangular || matrix.isUpperTriangular { return (.none, .double(det)) }
    return (.none, .double(getDetHelper(matrix)))
}

private func getDetHelper(_ matrix: Matrix) -> Double {
    switch matrix.rows {
    case 1: return matrix[0][0]
    case 2: return (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0])
    default:
        var output = 0.0
        for i in 0..<matrix.rows {
            output += pow(-1, i.toDouble()) * matrix[0][i] * getDetHelper(matrix.withoutColumn(at: i))
        }
        return output
    }
}

func getMatrix(cols: Int, rows: Int) -> Matrix {
    Array(repeating: Array(repeating: 0.0, count: cols), count: rows)
}

private func swapRows(matrix: Matrix, row1: Int, row2: Int) -> Matrix {
    // row1 <-> row2
    var returny = matrix
    returny.swapAt(row1, row2)
    return returny
}

private func scaleRow(matrix: Matrix, row: Int, scale: Double) -> Matrix {
    // row = scale * row
    matrix.mapAt(row: row) { $0 * scale }
}

private func addRows(matrix: Matrix, row1: Int, row2: Int, scale: Double) -> Matrix {
    // row2 = row2 + scale * row1
    var returny = matrix
    for col in 0..<returny[0].count { returny[row2][col] += scale * returny[row1][col] }
    return returny
}

private func rowEchelon(matrix: Matrix) -> Matrix {
    // convert the given matrix in to row echelon form
    var returny = matrix
    // if the first row and first column index is 0, switch the row with another row that has a non-zero value in the first column
    if returny[0][0] == 0 {
        for i in 1..<returny.rows {
            guard returny[i][0] != 0 else { continue }
            returny = swapRows(matrix: returny, row1: 0, row2: i)
            break
        }
    }
    
    for col in 0..<returny.cols {
        if col + 1 < returny.rows {
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
            guard returny[row][col] != 0 else { continue }
            returny = scaleRow(matrix: returny, row: row, scale: 1/returny[row][col])
            break
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
    guard let det = getDeterminant(matrix: matrix)?.solution else { return .none }
    switch det {
    case .double(let determinant): guard determinant != 0 else { return .none }
    default: return .none
    }
    var returny = getMatrix(cols: matrix.count, rows: matrix.count)
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
    var isLowerTriangular: Bool {
        guard isSquare else { return false }
        for row in 0..<rows {
            for col in row+1..<cols {
                guard self[row][col] == 0 else { return false }
            }
        }
        return true
    }
    var isUpperTriangular: Bool {
        guard isSquare else { return false }
        for row in 0..<rows {
            for col in 0..<row {
                guard self[row][col] == 0 else { return false }
            }
        }
        return true
    }
    var transpose: Matrix {
        var returny = getMatrix(cols: rows, rows: cols)
        for i in 0..<returny.rows {
            for j in 0..<returny.cols {
                returny[i][j] = self[j][i]
            }
        }
        return returny
    }
    
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
    
    func getDiagonal() -> [Double] {
        guard isSquare else { return [] }
        var returny = self[0]
        for i in 0..<rows { returny[i] = self[i][i] }
        return returny
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
    
    func mapDiag(_ transform: (Double) -> Double) -> Matrix? {
        guard isSquare else { return .none }
        var returny = self
        for i in 0..<returny.rows { returny[i][i] = transform(returny[i][i]) }
        return returny
    }
    
    func reduceDiag(_ initial: Double, _ transform: (Double, Double) -> Double) -> Double? {
        guard isSquare else { return .none }
        return getDiagonal().reduce(initial, transform)
    }
}

extension Array where Element == Double {
    func removeItem(at index: Int) -> [Double] {
        self.enumerated().compactMap { $0 == index ? nil : $1 }
    }
}
