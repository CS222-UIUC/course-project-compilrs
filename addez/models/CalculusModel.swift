//
//  CalculusModel.swift
//  addez
//
//  Created by Ayush Raman on 3/21/23.
//

import Foundation

typealias Function = (Double) -> Double?
typealias Operation = (Double, Double) -> Double?

infix operator ~/: MultiplicationPrecedence

func ~/(lhs: Double?, rhs: Double?) -> Double? {
    guard let lhs = lhs, let rhs = rhs else { return .none }
    guard rhs != 0 else { return .none }
    return lhs / rhs
}

infix operator >>: AdditionPrecedence

func >><T, B>(lhs: T?, rhs: ((T) -> B?)?) -> B? {
    guard let lhs = lhs, let rhs = rhs else { return .none }
    return rhs(lhs)
}

private func orderOfOps(_ arg: Character) -> Int {
    switch arg {
    case "+": return 1
    case "-": return 1
    case "*": return 2
    case "/": return 2
    case "^": return 3
    default: return 4
    }
}

private func reflexive(_ x: Double) -> Double { x }

private func zero(_ x: Double) -> Double { 0 }

func safeLog(_ x: Double) -> Double? {
    guard x > 0 else { return .none }
    return log10(x)
}

func ln(_ x: Double) -> Double? {
    guard x > 0 else { return .none }
    return log(x)
}

private func funcParser(_ arg: Substring) -> Function? {
    switch arg {
    case "": return reflexive
    case "ln": return ln
    case "log": return safeLog
    case "sin": return sin
    case "sinh": return sinh
    case "cos": return cos
    case "cosh": return cosh
    case "tan": return { x in sin(x) ~/ cos(x) }
    case "tanh": return tanh
    case "sec": return { x in 1 ~/ cos(x) }
    case "sech": return { x in 1 ~/ cosh(x) }
    case "csc": return { x in 1 ~/ sin(x) }
    case "csch": return { x in 1 ~/ sinh(x) }
    case "cot": return { x in cos(x) ~/ sin(x) }
    case "coth": return { x in 1 ~/ tanh(x) }
    default: return .none
    }
}

private func operParser(_ arg: Character) -> Operation? {
    switch arg {
    case "+": return (+)
    case "-": return (-)
    case "*": return (*)
    case "/": return (~/)
    case "^": return pow
    default: return .none
    }
}

private func postfixParser(_ arg: Character?) -> Function? {
    switch arg {
    case "!": return { x in tgamma(x+1) }
    default: return .none
    }
}

func numeralParser(_ arg: Substring) -> Double? {
    switch arg {
    case "e": return exp(1)
    case "pi", "π": return .pi
    default: return Double(arg)
    }
}

private func refactorCoeffecients(_ arg: Substring) -> Substring {
    var formatted = ""
    var prev: Character?
    for c in arg {
        if let prev = prev, prev.isNumber, c == "x" {
            formatted += "*\(c)"
        } else {
            formatted += String(c)
        }
        prev = c
    }
    return Substring(formatted)
}

private func encapsulateNegatives(_ arg: Substring) -> Substring {
    // TODO: Implement iterative solution to encapsulate negative numbers
    // ex: -3 => (-3)
    // Treated as (0-3)
    arg
}


private func isValid(_ input: String) -> Bool {
    guard !input.isEmpty else { return false }
    var st = Stack<Character>()
    for c in input {
        if (c == "(") {
            st.push(c)
        } else if (c == ")") {
            st.pop()
        }
    }
    return st.empty();
}

private func getPivot(_ arg: Substring) -> Int? {
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

func parseExpression(_ arg: String) -> Function? {
    guard isValid(arg) else { return .none }
    return arg.filter { $0 != " " }.lowercased().substringify() >> refactorCoeffecients >> encapsulateNegatives >> parseHelper
}

private func parseHelper(_ arg: Substring) -> Function? {
    guard arg.count != 0 else { return zero }
    guard arg != "x" else { return reflexive }
    if let numeral = arg >> numeralParser { return { _ in numeral } }
    guard let pivot = arg >> getPivot else {
        // evaluate as functional component
        if let post = arg.last >> postfixParser { return { $0 >> parseHelper(arg.dropLast()) >> post } }
        guard let parIdx = arg.firstIndex(of: "(") else { return .none }
        guard let fun = arg[..<parIdx] >> funcParser,
              let params = arg[arg.index(after: parIdx)..<arg.index(before: arg.endIndex)] >> parseHelper else { return .none }
        return { $0 >> params >> fun }
    }
    // evaluate operands
    guard let op = arg[arg.index(arg.startIndex, offsetBy: pivot)] >> operParser,
          let lhs = arg[..<arg.index(arg.startIndex, offsetBy: pivot)] >> parseHelper,
          let rhs = arg[arg.index(arg.startIndex, offsetBy: pivot + 1)...] >> parseHelper else { return .none }
    return { x in
        guard let lhsVal = x >> lhs, let rhsVal = x >> rhs else { return .none }
        return (lhsVal, rhsVal) >> op
    }
}

func riemannSum(lowerBound: Double, upperBound: Double, _ fun: Function) -> Double {
    let step = (upperBound - lowerBound) / 10000
    return (0..<10000).reduce(0.0) { sum, i in
        let x1 = lowerBound + Double(i) * step
        let x2 = lowerBound + Double(i + 1) * step
        guard let y1 = fun(x1), let y2 = fun(x2) else { return .nan }
        return sum + (y1 + y2) * step / 2
    }
}

func derivative(x: Double, _ fun: Function) -> Double? {
    let h = 0.0000001
    guard let y1 = fun(x - h), let y2 = fun(x + h) else { return .none }
    return (y2 - y1) / (2 * h)
}

func summation(range: ClosedRange<Int>, _ f: Function) -> Double {
    range.reduce(0.0) { $0 + (f(Double($1)) ?? 0) }
}
