//
//  CalculusModel.swift
//  addez
//
//  Created by Ayush Raman on 3/21/23.
//

import Foundation

typealias Function = (Double) -> Double
typealias Operation = (Double, Double) -> Double

struct Complex: Hashable {
    var real: Double
    var imaginary: Double
}

func *(lhs: Complex, rhs: Complex) -> Complex {
    let a = lhs.real, b = lhs.imaginary
    let c = rhs.real, d = rhs.imaginary
    return Complex(real: a * c - b * d, imaginary: a * d + b * c)
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

// overload the *= operator for complex numbers
func *= (lhs: inout Complex, rhs: Complex) {
    lhs = Complex(real: lhs.real * rhs.real - lhs.imaginary * rhs.imaginary, imaginary: lhs.real * rhs.imaginary + lhs.imaginary * rhs.real)
}

// overload the - operator for complex numbers
func - (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
}

//overload the / operator for complex numbers
func / (lhs: Complex, rhs: Complex) -> Complex {
    let denominator = rhs.real * rhs.real + rhs.imaginary * rhs.imaginary
    return Complex(real: (lhs.real * rhs.real + lhs.imaginary * rhs.imaginary) / denominator, imaginary: (lhs.imaginary * rhs.real - lhs.real * rhs.imaginary) / denominator)
}

// overload multiplication for a complex number and a scalar
func * (lhs: Complex, rhs: Double) -> Complex {
    return Complex(real: lhs.real * rhs, imaginary: lhs.imaginary * rhs)
}

// overload the += operator for complex numbers
func += (lhs: inout Complex, rhs: Complex) {
    lhs = Complex(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
}

func == (lhs: Complex, rhs: Complex) -> Bool {
    return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
}

// overload the approx operator for complex numbers
func ≈≈ (lhs: Complex, rhs: Complex) -> Bool {
    let tolerance = 1e-8
    return abs(lhs.real - rhs.real) < tolerance && abs(lhs.imaginary - rhs.imaginary) < tolerance
}

func complexPow(_ number: Complex, _ power: Int) -> Complex {
    if (power == 0) { return Complex(real: 1, imaginary: 0) }
    if (power == 1) { return number }
    
    var result = number
    for _ in 1..<power { result *= number }
    return result
}

func evaluate(polynomial: Vector, value: Complex) -> Complex {
    var result = Complex(real: 0, imaginary: 0)
    for i in 0..<polynomial.count {
        result += complexPow(value, i) * polynomial[i]
    }
    return result
}

func rootFinding(polynom: Vector) -> [Complex] {
    // remove leading zeros (end of the vector)
    var poly = polynom
     while poly.last == 0 { poly.removeLast() }
     if poly.count == 0 { return [] }
    
    var polynomial = poly
    // use Durand Kerner method to find roots of the polynomial f
    // https://en.wikipedia.org/wiki/Durand%E2%80%93Kerner_method
    let degree = polynomial.count - 1
    
    // divide the polynomial by its leading coefficient to make it monic
    for i in 0..<polynomial.count { polynomial[i] /= polynomial.last! }
    
    // make an Array of roots initialized to powers of (0.4 + 0.9i) using the Complex typealias
    // ex: roots[0] = 0.4 + 0.9i, roots[1] = (0.4 + 0.9i)^2, roots[2] = (0.4 + 0.9i)^3, etc.
    var roots = (0..<degree).map { complexPow(Complex(real: 0.4, imaginary: 0.9), $0) }
//    print("roots: \(roots)")

    let iterations = 100
    for i in 0..<iterations {
        
        // for each root in roots Array, apply the Durand Kerner method
        // make an array to store the new roots called newRoots

        for i in 0..<roots.count {
            let currentRoot = roots[i]
            let otherRoots = roots.filter { $0 != currentRoot }
//            print("\ncurrentRoot: \(currentRoot)")
//            print("otherRoots: \(otherRoots)")

            let numerator = evaluate(polynomial: polynomial, value: currentRoot)
//            print("numerator:  \(numerator)")
            
            var denominator = Complex(real: 1, imaginary: 0)
            for root in otherRoots { denominator *= (currentRoot - root) }
//            print("denominator: \(denominator)")
            
//            print("numerator/denominator: \(numerator / denominator)")
            
            let newRoot = currentRoot - (numerator / denominator)
//            print("currentRoot: \(currentRoot) --> newRoot: \(newRoot)\n")
            
            roots[i] = newRoot
            // print("newRoot: \(newRoot)")
        }
        // print the roots array rounded to 3 decimal places
//        var rounded_roots = [Complex]()
//        for root in roots {
//            rounded_roots.append(Complex(real: round(1000 * root.real) / 1000, imaginary: round(1000 * root.imaginary) / 1000))
//        }
        // print iteration number and roots
//        let spacer = i + 1 <= 9 ? " " : ""
//        print("iteration \(spacer)\(i + 1): \(rounded_roots)")
    }
    // for each root in the roots array, if the real of imaginary component is less than 1e-10, set it to 0
    for i in 0..<roots.count {
        if abs(roots[i].real) < 1e-8 { roots[i].real = 0 }
        if abs(roots[i].imaginary) < 1e-8 { roots[i].imaginary = 0 }
    }
    // for each root if the distance from the nearest integer is less than 1e-8, round it to the nearest integer
    for i in 0..<roots.count {
        let nearestInteger = round(roots[i].real)
        if abs(nearestInteger - roots[i].real) < 1e-8 { roots[i].real = nearestInteger }
    }
    return roots
}
