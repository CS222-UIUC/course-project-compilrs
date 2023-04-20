//
//  CalculusModel.swift
//  addez
//
//  Created by Ayush Raman on 3/21/23.
//

import Foundation

typealias Function = (Double) -> Double
typealias Operation = (Double, Double) -> Double

typealias Complex = (Double, Double)

func *(lhs: Complex, rhs: Complex) -> Complex {
    let (a, b) = lhs
    let (c, d) = rhs
    return (a * c - b * d, a * d + b * c)
}

func complexPow(_ lhs: Complex, _ rhs: Double) -> Complex {
    if (rhs == 0) { return (1, 0) }
    let (r, i) = lhs
    var returny = (r, i)
    for _ in 1..<Int(rhs) {
        returny = returny * lhs
    }
    return returny
}

private func orderOfOps(_ arg: Character) -> Int {
    switch arg {
    case "+": return 0
    case "-": return 1
    case "*": return 2
    case "/": return 2
    case "^": return 3
    default: return 4
    }
}

func +(lhs: @escaping Function, rhs: @escaping Function) -> Function {{ x in lhs(x) + rhs(x) } }

func identity<T>(_ x: T) -> T { x }

func zero(_ x: Double) -> Double { 0 }

func sec(_ x: Double) -> Double { 1 / cos(x) }

func sech(_ x: Double) -> Double { 1 / cosh(x) }

func csc(_ x: Double) -> Double { 1 / sin(x) }

func csch(_ x: Double) -> Double { 1 / sinh(x) }

func cot(_ x: Double) -> Double { 1 / tan(x) }

func coth(_ x: Double) -> Double { 1 / tanh(x) }

private func funcParser(_ arg: Substring) -> Function? {
    guard arg.last != "’" else { return arg.dropLast() !>>> funcParser !>>> derivative }
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

private func postfixParser(_ arg: Character?) -> ((@escaping Function) -> Function)? {
    switch arg {
    case "!": return { f in { x in f(x)<> } }
    case "’": return derivative
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

func numeralParserLatex(_ arg: Substring) -> String? {
    switch arg {
    case "pi": return "\\\(String(arg))"
    case "π", "e": return String(arg)
    default:
        guard Double(arg) != nil else { return .none }
        return String(arg)
    }
}

private func refactorCoeffecients(_ arg: Substring) -> Substring {
    var formatted = ""
    var prev: Character?
    for c in arg {
        if let prev = prev, prev.isNumber, !c.isNumber, c != ")", operParser(c) == nil {
            formatted += "*\(c)"
        } else {
            formatted += String(c)
        }
        prev = c
    }
    return Substring(formatted)
}

private func refactorX(_ arg: Substring) -> Substring {
    var formatted = ""
    var prev: Character?
    for c in arg {
        if let prev = prev, prev == "x", c != "x", c != ")", operParser(c) == nil, postfixParser(c) == nil {
            formatted += "*\(c)"
        } else {
            formatted += String(c)
        }
        prev = c
    }
    return Substring(formatted)
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
        if order < min {
            min = order
            minIdx = i
        }
    }
    return minIdx
}

func parseExpression(_ arg: String) -> Function? {
    guard isValid(arg) else { return .none }
    return arg.filter { $0 != " " }.lowercased().substringify() >>> refactorCoeffecients >>> parseHelper
}

private func parseHelper(_ arg: Substring) -> Function? {
    guard arg.count != 0 else { return zero }
    guard arg != "x" else { return identity }
    if let numeral = arg >>> numeralParser { return { _ in numeral } }
    if let pivot = arg >>> getPivot {
        // evaluate operands first
        guard let operand = arg[arg.index(arg.startIndex, offsetBy: pivot)] >>> operParser,
              // recursively evaluate the lhs and rhs around lowest-order operation
              let lhs = arg[..<arg.index(arg.startIndex, offsetBy: pivot)] >>> parseHelper,
              let rhs = arg[arg.index(arg.startIndex, offsetBy: pivot + 1)...] >>> parseHelper else { return .none }
        return { operand(lhs($0), rhs($0)) }
    }
    // evaluate x as a coeffecient
    if arg.first == "x", let f = arg.dropFirst() >>> parseHelper { return { $0 * f($0) } }
    // evaluate postfix functions
    if let post = arg.last >>> postfixParser {
        guard !arg.dropLast().isEmpty, let f = arg.dropLast() >>> parseHelper else { return .none }
        return { $0 >>> f } >>> post
    }
    // find index of highest-order function
    guard let parIdx = arg.firstIndex(of: "(") else { return .none }
    // f is the prefix to the paranthesis
    guard let f = arg[..<parIdx] >>> funcParser,
          // params are the arguments in between the parantheses
          let params = arg[arg.index(after: parIdx)..<arg.index(before: arg.endIndex)] >>> parseHelper else { return .none }
    return { $0 >>> params >>> f }
}

func parseLatex(_ arg: String) -> String? {
    guard isValid(arg) else { return .none }
    return arg.filter { $0 != " " }.lowercased().substringify() >>> parseLatexHelper
}

private func parseLatexHelper(_ arg: Substring) -> String? {
    guard arg.count != 0 else { return "" }
    guard arg != "x" else { return "x" }
    if let numeral = arg >>> numeralParserLatex { return numeral  }
    if let pivot = arg >>> getPivot {
        let operand = arg[arg.index(arg.startIndex, offsetBy: pivot)]
        // recursively evaluate the lhs and rhs around lowest-order operation
        guard let lhs = arg[..<arg.index(arg.startIndex, offsetBy: pivot)] >>> parseLatexHelper,
              let rhs = arg[arg.index(arg.startIndex, offsetBy: pivot + 1)...] >>> parseLatexHelper else { return .none }
        return "{\(lhs)}\(operand){\(rhs)}"
    }
    // evaluate x as a coeffecient
    if arg.first == "x", let f = arg.dropFirst() >>> parseLatexHelper { return "x\(f)" }
    // evaluate postfix functions
    if (arg.last >>> postfixParser) != nil {
        guard !arg.dropLast().isEmpty, arg.dropLast() >>> parseLatexHelper != nil else { return .none }
        return String(arg)
    }
    // find index of highest-order function
    guard let parIdx = arg.firstIndex(of: "(") else { return .none }
    // f is the prefix to the paranthesis
    let f = arg[..<parIdx].isEmpty ? "" : "\\\(arg[..<parIdx])"
    // params are the arguments in between the parantheses
    let params = arg[arg.index(after: parIdx)..<arg.index(before: arg.endIndex)]
    return "\(f){(\(params))}"
}

func riemannSum(in range: ClosedRange<Double>, _ f: @escaping Function) -> Double {
    let step = (range.upperBound - range.lowerBound) / 10000
    return (0..<10000).reduce(0) { sum, i in
        let x1 = range.lowerBound + Double(i) * step
        let x2 = range.lowerBound + Double(i + 1) * step
        return sum + (f(x1) + f(x2)) * step / 2
    }
}

func limit(approaches x: Double, _ f: @escaping Function) -> Double {
    let h = 0.00000000001
    return (f(x + h) + f(x - h)) / 2
}

func derivative(_ f: @escaping Function) -> Function {
    { x in limit(approaches: 0) { h in
        return (f(x + h) - f(x)) / h
    } }
}

func summation(in range: ClosedRange<Int>, _ f: Function) -> Double { range.map(Double.init).compactMap(f).reduce(0, +) }

func rootFinding(polynomial: Vector) -> [Complex] {
    // reverse polynomial
    var poly = polynomial.reversed()
    // guard against the first coefficient being 0
    // while the leading coefficient is 0, erase the leading coefficient
    // and shift the polynomial to the right
    while poly[0] == 0.0 { poly.removeFirst() }
    if poly.isEmpty { return [] }
    
    // use Durand Kerner method to find roots of the polynomial f
    // https://en.wikipedia.org/wiki/Durand%E2%80%93Kerner_method
    let degree = poly.count - 1
    
    // divide the polynomial by its leading coefficient if it is not 0
    let f = poly[0] == 0.0 ? poly : poly.map { $0 / poly[0] }
    
    // make an Array of roots initialized to powers of (0.4 + 0.9i) using the Complex typealias
    // ex: roots[0] = 0.4 + 0.9i, roots[1] = (0.4 + 0.9i)^2, roots[2] = (0.4 + 0.9i)^3, etc.
    var roots = (0...degree).map { n in complexPow(Complex(0.4, 0.9), n) }

    // iterate 10 times for accuracy
    for _ in 0..<10 {
        
        // for each root in roots Array, apply the Durand Kerner method
        for i in 0..<roots.count {
            
            // create an array of the "other" roots
            let otherRoots = roots.enumerated().filter { $0.offset != i }.map { $0.element }
            let currentRoot = roots[i]
            
            // compute new_current_root = current_root - f(current_root) / prod(current_root - other_root)
            let newRoot = currentRoot - evaluate(f, at: currentRoot) / otherRoots.reduce(1) { $0 * (currentRoot - $1) }
            
            // update roots Array
            roots[i] = newRoot
        }
    }
    return roots
}

// q: can swift multithread?
// a: yes, but only on macOS and iOS

// q: can you rewrite the function above but multi-threaded?
// a: yes, but it's not worth it

// q: just do it please
// a: ok

// q: write a function to evalute a function f at a complex number (a, b)
func evaluate(polynomial: Vector, value: Double) -> Complex {
    // init a return value to (0, 0)
    var result = Complex(0, 0)

    // for each coefficient in the polynomial
    for (i, coefficient) in polynomial.enumerated() {
        // add the coefficient times z^i to the return value
        result += coefficient * complexPow(value, i)
    }
    return result
}

func rootFindingMT(polynomial: Vector) -> [Complex] {
    // reverse polynomial
    let polynomial = polynomial.reversed()
    // guard against the first coefficient being 0
    // while the leading coefficient is 0, erase the leading coefficient
    // and shift the polynomial to the right
    var polynomial = polynomial
    while polynomial[0] == 0 { polynomial.removeFirst() }
    if polynomial.isEmpty { return [] }
    
    // use Durand Kerner method to find roots of the polynomial f
    // https://en.wikipedia.org/wiki/Durand%E2%80%93Kerner_method
    let degree = polynomial.count - 1
    
    // divide the polynomial by its leading coefficient if it is not 0
    let f = polynomial[0] == 0 ? polynomial : polynomial.map { $0 / polynomial[0] }
    
    // make an Array of roots initialized to powers of (0.4 + 0.9i) using the Complex typealias
    // ex: roots[0] = 0.4 + 0.9i, roots[1] = (0.4 + 0.9i)^2, roots[2] = (0.4 + 0.9i)^3, etc.
    var roots = (0...degree).map{ n in complexPow(Complex(0.4, 0.9), n) }

    // iterate 10 times for accuracy
    for _ in 0..<10 {
        
        // for each root in roots Array, apply the Durand Kerner method
        DispatchQueue.concurrentPerform(iterations: roots.count) { i in
            
            // create an array of the "other" roots
            let otherRoots = roots.enumerated().filter { $0.offset != i }.map { $0.element }
            let currentRoot = roots[i]
            
            // compute new_current_root = current_root - f(current_root) / prod(current_root - other_root)\
            let newRoot = currentRoot - evaluate(polynomial: f, at: currentRoot) / otherRoots.reduce(1) { $0 * (currentRoot - $1) }
            
            // update roots Array
            roots[i] = newRoot
        }
    }
    return roots
}
