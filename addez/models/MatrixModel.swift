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
    init(_ matrix: Matrix) { self.matrix = matrix }
}

func *(lhs: [Double], rhs: Double) -> [Double] { lhs.map { $0 * rhs } }

func *(lhs: Double, rhs: [Double]) -> [Double] { rhs.map { $0 * lhs } }

func *(lhs: Vector, rhs: Vector) -> Double? {
    guard lhs.count == rhs.count else { return .none }
    return lhs.enumerated()
        .map { i, element in element * rhs[i] }
        .reduce(0.0, +)
}

infix operator <+>: AdditionPrecedence

infix operator <->: AdditionPrecedence

infix operator <*>: MultiplicationPrecedence

func <+>(lhs: Vector?, rhs: Vector?) -> Vector? {
    guard let lhs = lhs, let rhs = rhs else { return .none }
    guard lhs.count == rhs.count else { return .none }
    return lhs.enumerated().map { $1 + rhs[$0] }
}

func <->(lhs: Vector?, rhs: Vector?) -> Vector? {
    guard let lhs = lhs, let rhs = rhs else { return .none }
    guard lhs.count == rhs.count else { return .none }
    return lhs.enumerated().map { $1 - rhs[$0] }
}

func <*>(lhs: Vector?, rhs: Vector?) -> Vector? {
    guard let lhs = lhs, let rhs = rhs else { return .none }
    guard lhs.count == rhs.count else { return .none }
    let left = lhs.toMatrix().transpose, right = rhs.toMatrix()
    guard let product = left * right else { return .none }
    var returny = Array(repeating: 0.0, count: product.cols + product.rows - 1)
    for i in 0..<product.rows {
        for j in 0..<product.cols {
            returny[i + j] += product[i][j]
        }
    }
    return returny
}

func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
    guard lhs.cols == rhs.rows else { return .none }
    var returny = getMatrix(cols: rhs.cols, rows: lhs.rows)
    let rhs = rhs.transpose
    for i in 0..<returny.rows {
        for j in 0..<returny.cols {
            guard let val = lhs[i] * rhs[j] else { return .none }
            returny[i][j] = val
        }
    }
    return returny
}

typealias Matrix = [[Double]]

typealias Vector = [Double]

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

typealias Steps = [Step]

typealias ReturnType = (steps: [Step]?, solution: SolutionType?)

func typeParser(steps: [Step]?, solution: Any) -> ReturnType {
    if let solution = solution as? NTuple {
        return (steps, .ntuple(solution))
    } else if let solution = solution as? Matrix {
        return (steps, .matrix(solution))
    } else if let solution = solution as? Double {
        return (steps, .double(solution))
    } else if let solution = solution as? (lower: Matrix, upper: Matrix) {
        return (steps, .matrixTuple(lower: solution.lower, upper: solution.upper))
    } else if let solution = solution as? SolutionType {
        return (steps, solution)
    } else {
        return (steps, .none)
    }
}

enum SolutionType {
    case ntuple(NTuple)
    case matrixTuple(lower: Matrix, upper: Matrix)
    case matrix(Matrix)
    case double(Double)
    case vector(Vector)
}

typealias MatrixSolution = (steps: Steps?, solution: Matrix)
typealias NTupleSolution = (steps: Steps?, solution: NTuple)
typealias DoubleSolution = (steps: Steps?, solution: Double)
typealias MatrixTupleSolution = (steps: Steps?, solution: (lower: Matrix, upper: Matrix))
typealias VectorSolution = (steps: Steps?, solution: Vector)


enum MatrixFunctions: String, CaseIterable {
    case solve = "Solve"
    case rref = "Reduced Row Echelon"
    case ludecomp = "LU Decomposition"
    case inv = "Inverse"
    case det = "Determinant"
    case eigenval = "Eigenvalues"
    case eigenvec = "Eigenvectors"
}

enum ComputationErrors: Error {
    case notSquare
}

func solveMatrix(matrix: Matrix) -> ReturnType? {
    .none
}

func getDeterminant(matrix: Matrix) -> DoubleSolution? {
    // if (matrix dimension is 1x1 then return the only value
    // if the matrix dimension is 2x2 then return the ad-bc
    // int output = for each int in the first row:
    // output += (-1)^index * (int in the row) * getDeterminant(genmatrix(matrix: Matrix, Int: col))
    // return output
    guard matrix.rows != 0 && matrix.cols != 0 && matrix.isSquare else { return .none }
    if let det = matrix.getDiagonal()?.reduce(1, *), matrix.isTriangular { return (.none, det) }
    return (.none, getDetHelper(matrix))
}

private func getDetHelper(_ matrix: Matrix) -> Double {
    switch matrix.rows {
    case 1: return matrix[0][0]
    case 2: return (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0])
    default: return matrix.first?.enumerated()
            .map { i, pivot in (-1 ** i.toDouble()) * pivot * getDetHelper(matrix.withoutRow(at: 0).withoutColumn(at: i)) }
            .reduce(0.0, +) ?? 0.0
    }
}

func getMatrix(cols: Int, rows: Int) -> Matrix { Array(repeating: Array(repeating: 0.0, count: cols), count: rows) }

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
    returny[row1] = (returny[row1] <+> scale * returny[row2]) ?? []
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
        guard col + 1 < returny.rows else { continue }
        for row in col+1..<returny.count {
            guard returny[row][col] != 0 else { continue }
            returny = addRows(matrix: returny, row1: col, row2: row, scale: -returny[row][col]/returny[col][col])
        }
    }
    return returny
}

func reducedRowEchelon(matrix: Matrix) -> MatrixSolution? {
    var returny = rowEchelon(matrix: matrix)
    // divide each each row by its pivot value
    for row in 0..<returny.rows {
        // find the first non-zero value in the row and divide the row by that value
        for col in 0..<returny.cols {
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
    
    return (.none, returny)
}

func inverseMatrix(matrix: Matrix) -> MatrixSolution? {
    guard matrix.rows != 0 && matrix.cols != 0 else { return .none }
    guard matrix.isSquare else { return .none }
    guard let det = getDeterminant(matrix: matrix)?.solution, det != 0 else { return .none }
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
    return (steps, returny)
}

func getEigenvalues(matrix: Matrix) -> VectorSolution? {
    guard matrix.isSquare else { return .none }
    return .none
}

func getEigHelper(matrix: [[[Double]]]) -> Vector? {
    switch matrix.count {
    case 1: return matrix[0][1]
    case 2:
        let a = matrix[0][0], b = matrix[0][1], c = matrix[1][0], d = matrix[1][1]
        return a <*> d <-> b <*> c
    default:
        return .none
//        return matrix.first?.enumerated()
//                .map { i, pivot in (-1 ** i.toDouble()) * pivot * getEigHelper(matrix.withoutRow(at: 0).withoutColumn(at: i)) }
//                .reduce(0.0, +) ?? 0.0
    }
}

extension MatrixFunctions {
    var compute: (Matrix) -> ReturnType? { { $0 !>>> functionMapper !>>> typeParser } }
    
    private var functionMapper: (Matrix) -> (Steps?, Any)? {
        switch self {
        case .solve: return solveMatrix
        case .det: return getDeterminant
        case .rref: return reducedRowEchelon
        case .inv: return inverseMatrix
        case .eigenval: return getEigenvalues
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
        for row in 0..<rows { for col in row+1..<cols { guard self[row][col] == 0 else { return false } } }
        return true
    }
    var isUpperTriangular: Bool {
        guard isSquare else { return false }
        for row in 0..<rows { for col in 0..<row { guard self[row][col] == 0 else { return false } } }
        return true
    }
    var isTriangular: Bool { isUpperTriangular || isLowerTriangular }
    var transpose: Matrix {
        var returny = getMatrix(cols: rows, rows: cols)
        for row in 0..<returny.rows { for col in 0..<returny.cols { returny[row][col] = self[col][row] } }
        return returny
    }
    
    static let maxDimensions = (rows: 6, cols: 6)
    
    static let validDimensions = (rows: 1...6, cols: 1...6)
    
    func withoutColumn(at column: Int) -> Matrix {
        guard column > 0 && column < rows else { return self }
        return self.map { $0.removeItem(at: column) }
    }
    
    func withoutRow(at row: Int) -> Matrix {
        guard row > 0 && row < rows else { return self }
        return self.removeItem(at: row)
    }
    
    func getColumn(at column: Int) -> [Double] {
        guard column > 0 && column < cols else { return [] }
        return self.map { $0[column] }
    }
    
    func getRow(at row: Int) -> [Double] {
        guard row > 0 && row < rows else { return [] }
        return self[row]
    }
    
    func getDiagonal() -> [Double]? {
        guard isSquare else { return .none }
        return self.enumerated().map { $1[$0] }
    }
    
    func mapAt(row: Int, _ transform: (Double) -> Double) -> Matrix {
        var returny = self
        for i in 0..<returny[row].count { returny[row][i] = returny[row][i] >>> transform }
        return returny
    }
    
    func mapAt(col: Int, _ transform: (Double) -> Double) -> Matrix {
        var returny = self
        for i in 0..<returny.rows { returny[i][col] = returny[i][col] >>> transform }
        return returny
    }
    
    func mapDiag(_ transform: (Double) -> Double) -> Matrix? {
        guard isSquare else { return .none }
        var returny = self
        for i in 0..<returny.rows { returny[i][i] = returny[i][i] >>> transform }
        return returny
    }
}

extension Array {
    func removeItem(at index: Int) -> [Element] { self.enumerated().compactMap { $0 == index ? nil : $1 } }
}

extension Vector {
    func at(_ index: Int) -> Double {
        guard index < count && index >= 0 else { return 0 }
        return self[index]
    }
    
    func toMatrix() -> Matrix { [self] }
}
