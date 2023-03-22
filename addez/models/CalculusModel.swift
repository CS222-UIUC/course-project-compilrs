//
//  CalculusModel.swift
//  addez
//
//  Created by Ayush Raman on 3/21/23.
//

import Foundation

typealias Function = (Double) -> Double?
typealias Operation = (Double, Double) -> Double?

enum Component {
    case fun(Function)
    case op(Operation)
}

infix operator ~/

func ~/(lhs: Double, rhs: Double) -> Double? {
    guard rhs != 0 else { return .none }
    return lhs / rhs
}

func orderOfOps(_ arg: Character) -> Int {
    switch arg {
    case "+": return 1
    case "-": return 1
    case "*": return 2
    case "/": return 2
    case "^": return 3
    default: return 4
    }
}

func safeTan(_ x: Double) -> Double? {
    guard cos(x) != 0 else { return .none }
    return tan(x)
}

func safeCot(_ x: Double) -> Double? {
    guard sin(x) != 0 else { return .none }
    return cos(x) / sin(x)
}

func funcParser(_ arg: Substring) -> Function? {
    switch arg {
    case "": return { x in x }
    case "ln": return log
    case "log": return log10
    case "sin": return sin
    case "cos": return cos
    case "tan": return safeTan
    case "sec": return { x in 1 ~/ cos(x) }
    case "csc": return { x in 1 ~/ sin(x) }
    case "cot": return safeCot
    default: return .none
    }
}

func operParser(_ arg: Character) -> Operation? {
    switch arg {
    case "+": return (+)
    case "-": return (-)
    case "*": return (*)
    case "/": return (~/)
    case "^": return pow
    default: return .none
    }
}

func isValid(_ input: String) -> Bool {
    var st = Stack<Character>()
    for c in input {
        // TODO: Add case for invalid characters
        if (c == "(") {
            st.push(c)
        } else if (c == ")") {
            st.pop()
        }
    }
    return st.empty();
}

func isNumeral(_ arg: Substring) -> Bool {
    Double(arg) != .none
}

func parseExpression(_ arg: String) -> Function? {
    guard isValid(arg) else { return .none }
    return parseHelper(Substring(arg.filter { $0 != " " }))
}

func getPivot(_ arg: Substring) -> Int? {
    var min = 4
    var minIdx: Int?
    var st = Stack<Character>()
    for (i, c) in arg.enumerated() {
        if c == "(" { st.push(c) }
        else if c == ")" { st.pop() }
        if !st.empty() { continue }
        let order = orderOfOps(c)
        if (order < min) {
            min = order
            minIdx = i
        }
    }
    return minIdx
}

func parseHelper(_ arg: Substring) -> Function? {
    guard arg.count != 0 else { return { _ in 0 } }
    guard arg != "x" else { return { x in x } }
    guard !isNumeral(arg) else { return { _ in Double(arg) } }
    guard let pivot = getPivot(arg) else {
        // evaluate as functional component
        guard let parIdx = arg.firstIndex(of: "(") else { return .none }
        guard let fun = funcParser(arg[..<parIdx]) else { return .none }
        guard let params = parseHelper(arg[arg.index(after: parIdx)..<arg.index(before: arg.endIndex)]) else { return .none }
        return { x in
            guard let args = params(x) else { return .none }
            return fun(args)
        }
    }
    // evaluate operands
    guard let op = operParser(arg[arg.index(arg.startIndex, offsetBy: pivot)]) else { return .none }
    guard let lhs = parseHelper(arg[..<arg.index(arg.startIndex, offsetBy: pivot)]) else { return .none }
    guard let rhs = parseHelper(arg[arg.index(arg.startIndex, offsetBy: pivot + 1)...]) else { return .none }
    return { x in
        guard let lhsVal = lhs(x), let rhsVal = rhs(x) else { return .none }
        return op(lhsVal, rhsVal)
    }
}

func riemannSum(lowerBound: Double, upperBound: Double, _ fun: Function) -> Double {
    let step = (upperBound - lowerBound) / 10000
    //trapezoidal rule
    var sum = 0.0
    for i in 0..<10000 {
        let x1 = lowerBound + Double(i) * step
        let x2 = lowerBound + Double(i + 1) * step
        guard let y1 = fun(x1), let y2 = fun(x2) else { return .nan }
        sum += (y1 + y2) * step / 2
    }
    return sum
}

func derivative(x: Double, _ fun: Function) -> Double? {
    let h = 0.0000001
    guard let y1 = fun(x - h), let y2 = fun(x + h) else { return .none }
    return (y2 - y1) / (2 * h)
}
