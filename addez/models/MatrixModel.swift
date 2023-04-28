//
//  MatrixModel.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import Foundation
import Collections

typealias Matrix = [[Double]]

typealias Vector = [Double]

typealias NTuple = [String]

class MatrixObject: ObservableObject {
    @Published var matrix: Matrix
    var rows: Int { matrix.rows }
    var cols: Int { matrix.cols }
    init(_ matrix: Matrix) { self.matrix = matrix }
}

func *(lhs: Vector, rhs: Double) -> Vector { lhs.map { $0 * rhs } }

func *(lhs: Double, rhs: Vector) -> Vector { rhs.map { $0 * lhs } }

func *(lhs: Vector, rhs: Vector) -> Double? {
    guard lhs.count == rhs.count else { return .none }
    return lhs.enumerated()
        .map { i, element in element * rhs[i] }
        .reduce(0.0, +)
}

infix operator <+>: AdditionPrecedence

infix operator <->: AdditionPrecedence

infix operator <*>: MultiplicationPrecedence

func <+>(lhs: Vector, rhs: Vector) -> Vector { (0..<max(lhs.count, rhs.count)).map { lhs.at($0) + rhs.at($0) } }

func <->(lhs: Vector, rhs: Vector) -> Vector { (0..<max(lhs.count, rhs.count)).map { lhs.at($0) - rhs.at($0) } }

func <*>(lhs: Vector, rhs: Vector) -> Vector {
    var returny = Array(repeating: 0.0, count: lhs.count + rhs.count - 1)
    for i in 0..<lhs.count { for j in 0..<rhs.count { returny[i + j] += lhs[i] * rhs[j] } }
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

func *(lhs: Matrix, rhs: Double) -> Matrix { lhs.map { $0 * rhs } }

func *(lhs: Double, rhs: Matrix) -> Matrix { rhs.map { $0 * lhs } }

func <->(lhs: Matrix, rhs: Matrix) -> Matrix { lhs.enumerated().map { i, row in row <-> rhs[i] } }

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
        return (steps, solution >>> SolutionType.matrixTuple)
    } else if let solution = solution as? Vector {
        return (steps, .vector(solution))
    } else if let solution = solution as? Dictionary<Complex, Int> {
        return (steps, .roots(solution))
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
    case roots(Dictionary<Complex, Int>)
}

typealias MatrixSolution = (steps: Steps?, solution: Matrix)
typealias NTupleSolution = (steps: Steps?, solution: NTuple)
typealias DoubleSolution = (steps: Steps?, solution: Double)
typealias MatrixTupleSolution = (steps: Steps?, solution: (lower: Matrix, upper: Matrix))
typealias VectorSolution = (steps: Steps?, solution: Vector)
typealias RootsSolution = (steps: Steps?, solution: Dictionary<Complex, Int>)


enum MatrixFunctions: String, CaseIterable {
    case solve = "Solve"
    case rref = "Reduced Row Echelon"
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

private func getDetHelper(_ matrix: Matrix) -> Double { getCharacteristicPolynomial(matrix: matrix.map { $0.map { [$0] } } )[0] }

func getMatrix(cols: Int, rows: Int) -> Matrix { Array(repeating: Array(repeating: 0.0, count: cols), count: rows) }

func swapRows(matrix: Matrix, row1: Int, row2: Int) -> Matrix {
    // row1 <-> row2
    var returny = matrix
    returny.swapAt(row1, row2)
    return returny
}

func scaleRow(matrix: Matrix, row: Int, scale: Double) -> Matrix {
    // row = scale * row
    var returny = matrix
    returny[row] = returny[row] * scale
    return returny
}

func addRows(matrix: Matrix, row1: Int, row2: Int, scale: Double) -> Matrix {
    // row2 = row2 + scale * row1
    var returny = matrix
    returny[row2] = returny[row2] <+> scale * returny[row1]
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

func reducedRowEchelon(matrix: Matrix) -> MatrixSolution {
    var returny = rowEchelon(matrix: matrix)
    // divide each each row by its pivot value
    for row in 0..<returny.count {
        // find the first non-zero value in the row and divide the row by that value
        for col in 0..<returny[0].count {
            if (returny[row][col] != 0) {
                returny = scaleRow(matrix: returny, row: row, scale: 1/returny[row][col])
                break
            }
        }
    }
    
    for col in 0..<returny[0].count {
        for row in 0..<col {
            if (returny[row][col] != 0 && col < returny.count) {
                returny = addRows(matrix: returny, row1: col, row2: row, scale: -returny[row][col])
            }
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

func getEigenvalues(matrix: Matrix) -> RootsSolution? {
    guard matrix.isSquare else { return .none }
    let cube = matrix.enumerated().map { i, row in
        row.enumerated().map { j, element in
            var arr = Array(repeating: 0.0, count: matrix.count + 1)
            arr[0] = element
            if j == i { arr[1] = -1 }
            return arr
        }
    }
    return (.none, getEigHelper(matrix: cube))
}

private func getEigHelper(matrix: [[Vector]]) -> Dictionary<Complex, Int> {
    let polynomial = matrix >>> getCharacteristicPolynomial
    // find the potential rational roots
    let allRoots = polynomial >>> rootFinding
    // return the roots that result in 0
    var dict = Dictionary<Complex, Int>()
    for root in allRoots { dict.updateValue(dict[root] ?? 0, forKey: root) }
    return dict
}

func getCharacteristicPolynomial(matrix: [[[Double]]]) -> Vector {
    switch matrix.count {
    case 1: return matrix[0][0]
    case 2:
        let a = matrix[0][0], b = matrix[0][1], c = matrix[1][0], d = matrix[1][1]
        return a <*> d <-> b <*> c
    default:
        return matrix.first?.enumerated()
            .map { i, pivot in
                (-1 ** i) * pivot <*> getCharacteristicPolynomial(matrix: matrix.withoutColumn(at: i).withoutRow(at: 0))
            }
            .reduce(Array(repeating: 0.0, count: matrix.count), <+>) ?? []
    }
}

func makeIdentityMatrix(size: Int) -> Matrix {
    var returny = getMatrix(cols: size, rows: size)
    for i in 0..<size {
        for j in 0..<size {
            if i == j { returny[i][j] = 1 }
        }
    }
    return returny
}

/// Returns the basis for the nullspace of `matrix`
func getNullspace(_ matrix: Matrix) -> Matrix {
    let rref = (matrix >>> reducedRowEchelon).solution
    var isPivotCol = Array(repeating: false, count: rref.rows)
    var j = 0
    for i in 0..<rref.rows {
        isPivotCol[i] = rref[i][j] == 1
        if rref[i][j] == 1 { j += 1 }
    }
    let nullspace = matrix.map { row in
        row.enumerated().filter { i, _ in !isPivotCol[i] }.map { _, element in element }
    }
    return []
}

func getEigenvectors(matrix: Matrix) -> MatrixSolution? {
    guard let eigenvals = getEigenvalues(matrix: matrix)?.solution else { return .none }
    let eigenvecs = eigenvals.keys
        .filter { $0.imaginary.isZero }
        .map { $0.real }
        .flatMap { eigenval in
            let entry = matrix <-> (makeIdentityMatrix(size: matrix.count) * eigenval)
            return entry >>> getNullspace
        }
    return (.none, eigenvecs)
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
        case .eigenvec: return getEigenvectors
        }
    }
    
    var maxDimensions: (rows: Double, cols: Double) {
        switch self {
        case .det: return (8, 8)
        default: return (10, 10)
        }
    }
}

extension [[[Double]]] {
    var rows: Int { self.count }
    var cols: Int {
        guard rows != 0 else { return 0 }
        return self[0].count
    }
    func withoutColumn(at column: Int) -> [[[Double]]] {
        guard column >= 0 && column < rows else { return self }
        return self.map { $0.removeItem(at: column) }
    }
    
    func withoutRow(at row: Int) -> [[[Double]]] {
        guard row >= 0 && row < rows else { return self }
        return self.removeItem(at: row)
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
        guard column >= 0 && column < rows else { return self }
        return self.map { $0.removeItem(at: column) }
    }
    
    func withoutRow(at row: Int) -> Matrix {
        guard row >= 0 && row < rows else { return self }
        return self.removeItem(at: row)
    }
    
    func getColumn(at column: Int) -> Vector {
        guard column >= 0 && column < cols else { return [] }
        return self.map { $0[column] }
    }
    
    func getRow(at row: Int) -> Vector {
        guard row >= 0 && row < rows else { return [] }
        return self[row]
    }
    
    func getDiagonal() -> Vector? {
        guard isSquare else { return .none }
        return self.enumerated().map { $1[$0] }
    }
    
    func mapAt(row: Int, _ transform: Function) -> Matrix {
        var returny = self
        for i in 0..<returny[row].count { returny[row][i] = returny[row][i] >>> transform }
        return returny
    }
    
    func mapAt(col: Int, _ transform: Function) -> Matrix {
        var returny = self
        for i in 0..<returny.rows { returny[i][col] = returny[i][col] >>> transform }
        return returny
    }
    
    func mapDiag(_ transform: Function) -> Matrix? {
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
    
    func resize(to size: Int) -> [Element] { Array(repeating: 0.0, count: size).enumerated().map { i, element in self.at(i) } }
    
    /// Return a latexified version of a coeffecient vector
    func polynomialToString() -> String {
        self.reversed().enumerated().compactMap { i, coef in
            coef != 0 ? "\(coef)x^\(count - i - 1) + " : nil
        }
        .reduce("", +)
        .dropLast(3) >>> String.init >>> parseLatex ?? ""
    }
    
    /// Return a composed function described by a coeffecient vector of a polynomial
    func polynomialToFunction() -> Function {
        self.enumerated().compactMap { i, coef in
            // ignore 0 coeffecient as `nil` and return cx^i otherwise
            coef != 0 ? { x in coef*(x ** i) } : nil
        }
        .reduce(zero, +)
    }
}
