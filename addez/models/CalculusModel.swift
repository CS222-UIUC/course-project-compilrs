//
//  CalculusModel.swift
//  addez
//
//  Created by Ayush Raman on 3/21/23.
//

import Foundation

typealias Function = (Double) -> Double?
typealias Operation = (Double, Double) -> Double?

infix operator >>: AdditionPrecedence

infix operator **: MultiplicationPrecedence

func **(lhs: Double, rhs: Double) -> Double { pow(lhs, rhs) }

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

func identity<T>(_ x: T) -> T { x }

private func zero(_ x: Double) -> Double { 0 }

func sec(_ x: Double) -> Double { 1 / cos(x) }

func sech(_ x: Double) -> Double { 1 / cosh(x) }

func csc(_ x: Double) -> Double { 1 / sin(x) }

func csch(_ x: Double) -> Double { 1 / sinh(x) }

func cot(_ x: Double) -> Double { 1 / tan(x) }

func coth(_ x: Double) -> Double { 1 / tanh(x) }

private func funcParser(_ arg: Substring) -> Function? {
    switch arg {
    case "": return identity
    case "abs": return abs
    case "sqrt", "√": return sqrt
    case "cbrt": return cbrt
        
    case "ln": return log
    case "log": return log10
        
    case "sin": return sin
    case "asin": return asin
    case "sinh": return sinh
    case "asinh": return asinh
        
    case "cos": return cos
    case "acos": return acos
    case "cosh": return cosh
    case "acosh": return acosh
        
    case "tan": return tan
    case "atan": return atan
    case "tanh": return tanh
    case "atanh": return atanh
        
    case "sec": return sec
    case "sech": return sech
        
    case "csc": return csc
    case "csch": return csch
        
    case "cot": return cot
    case "coth": return coth
        
    default: return .none
    }
}

private func operParser(_ arg: Character) -> Operation? {
    switch arg {
    case "+": return (+)
    case "-": return (-)
    case "*": return (*)
    case "/": return (/)
    case "^": return (**)
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
    guard arg != "x" else { return identity }
    if let numeral = arg >> numeralParser { return { _ in numeral } }
    if let pivot = arg >> getPivot {
        // evaluate operands first
        guard let operand = arg[arg.index(arg.startIndex, offsetBy: pivot)] >> operParser,
              // recursively evaluate the lhs and rhs around lowest-order operation
              let lhs = arg[..<arg.index(arg.startIndex, offsetBy: pivot)] >> parseHelper,
              let rhs = arg[arg.index(arg.startIndex, offsetBy: pivot + 1)...] >> parseHelper else { return .none }
        return { x in
            guard let lhsVal = x >> lhs, let rhsVal = x >> rhs else { return .none }
            return (lhsVal, rhsVal) >> operand
        }
    }
    // evaluate postfix functions
    if let post = arg.last >> postfixParser { return { $0 >> parseHelper(arg.dropLast()) >> post } }
    // find index of highest-order function
    guard let parIdx = arg.firstIndex(of: "(") else { return .none }
    // f is the prefix to the paranthesis
    guard let f = arg[..<parIdx] >> funcParser,
          // params are the arguments in between the parantheses
          let params = arg[arg.index(after: parIdx)..<arg.index(before: arg.endIndex)] >> parseHelper else { return .none }
    return { $0 >> params >> f }
}

func riemannSum(lowerBound: Double, upperBound: Double, _ f: @escaping Function) -> Double {
    let step = (upperBound - lowerBound) / 10000
    return (0..<10000).reduce(0.0) { sum, i in
        let x1 = lowerBound + Double(i) * step
        let x2 = lowerBound + Double(i + 1) * step
        guard let y1 = f(x1), let y2 = f(x2) else { return .nan }
        return sum + (y1 + y2) * step / 2
    }
}

func limit(approaches x: Double, _ f: @escaping Function) -> Double {
    let h = 0.00000000001
    guard let f1 = f(x - h), let f2 = f(x + h) else { return .nan }
    return (f2 + f1) / 2
}

func derivative(_ f: @escaping Function) -> Function {
    { x in limit(approaches: 0.0) { h in
        guard let fxh = f(x + h), let fx = f(x) else { return .none }
        return (fxh - fx) / h
    } }
}

func summation(range: ClosedRange<Int>, _ f: Function) -> Double {
    range
        .map(Double.init)
        .compactMap(f)
        .reduce(0.0, +)
}
