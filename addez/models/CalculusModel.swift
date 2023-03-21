//
//  CalculusModel.swift
//  addez
//
//  Created by Ayush Raman on 3/21/23.
//

import Foundation

func orderOfOps(arg: Character) -> Int {
    switch arg {
    case "+": return 1
    case "-": return 1
    case "*": return 2
    case "/": return 2
    case "^": return 3
    default: return 4
    }
}

func funcParser(arg: String) -> ((Double) -> Double)? {
    switch arg {
    case "log": return log
    case "sin": return sin
    case "cos": return cos
    case "tan": return tan
    case "sec": return { x in 1 / cos(x) }
    case "csc": return { x in 1 / sin(x) }
    case "cot": return { x in 1 / tan(x) }
    default: return .none
    }
}

func operParser(arg: Character) -> ((Double, Double) -> Double)? {
    switch arg {
    case "+": return (+)
    case "-": return (-)
    case "*": return (*)
    case "/": return (/)
    case "^": return pow
    default: return .none
    }
}

func isValid(input: String) -> Bool {
    var st = Stack<Character>()
    for c in input {
        if (c == "(") {
            st.push(c)
        }
        else if (c == ")") {
            st.pop()
        }
    }
    return st.empty();
}

func parseExpression(arg: String) -> ((Double) -> Double)? {
    // TODO: Implement a recursive solution that reduces the problem size for each parantheses set
    for i in 0..<arg.count {
        let index = arg.index(arg.startIndex, offsetBy: i)
        if arg[index] == "(" {
            var j = i + 1
            var count = 1
            while count > 0 {
                let index = arg.index(arg.startIndex, offsetBy: j)
                if arg[index] == "(" { count += 1 }
                else if arg[index] == ")" { count -= 1 }
                j += 1
            }
            let sub = String(arg[arg.index(arg.startIndex, offsetBy: i + 1)..<arg.index(arg.startIndex, offsetBy: j - 1)])
            let subFunc = parseExpression(arg: sub)
            let pre = String(arg[..<arg.index(arg.startIndex, offsetBy: i)])
            let post = String(arg[arg.index(arg.startIndex, offsetBy: j)...])
            return parseExpression(arg: pre + String(describing: subFunc) + post)
        }
    }
}

func riemannSum(lowerBound: Double, upperBound: Double, _ fun: ((Double) -> Double)?) -> Double? {
    guard let fun = fun else { return .none }
    let step = (upperBound - lowerBound) / 1000
    return stride(from: lowerBound, through: upperBound, by: step).reduce(0.0, { $0 + fun($1) * step })
}
