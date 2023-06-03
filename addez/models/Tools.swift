//
//  Tools.swift
//  addez
//
//  Created by Spencer Sadler on 2/23/23.
//

import Foundation

extension Int {
    func toDouble() -> Double { Double(self) }
}

extension Double {
    func toInt() -> Int { Int(self) }
}

extension Complex {
    func toString() -> String {
        if (real == 0 && imaginary == 0) { return "0" }
        if (real == 0) { return imaginary.toString() + "i" }
        if (imaginary == 0) { return real.toString() }
        if (imaginary < 0) { return real.toString() + " - " + abs(imaginary).toString() + "i" }
        return real.toString() + " + " + imaginary.toString() + "i"
    }
}



extension String {
    func latexify() -> String {
        self
            .replacingOccurrences(of: "(", with: "{")
            .replacingOccurrences(of: ")", with: "}")
            .replacingOccurrences(of: "sin", with: "\\sin")
            .replacingOccurrences(of: "cos", with: "\\cos")
            .replacingOccurrences(of: "tan", with: "\\tan")
            .replacingOccurrences(of: "log", with: "\\log")
            .replacingOccurrences(of: "ln", with: "\\ln")
            .replacingOccurrences(of: "sqrt", with: "\\sqrt")
            .replacingOccurrences(of: "pi", with: "\\pi")
            .replacingOccurrences(of: "e", with: "\\e")
    }
    func substringify() -> Substring { Substring(self) }
}

extension ClosedRange where Element == Int {
    func inBounds(element x: Double) -> Bool { x >= Double(lowerBound) && x <= Double(upperBound) }
    
    func continuous() -> [Double] { stride(from: Double(lowerBound), through: Double(upperBound), by: 0.01).map(identity) }
}

infix operator >>>: AdditionPrecedence

infix operator !>>>: AdditionPrecedence

infix operator **: MultiplicationPrecedence

postfix operator <>

postfix func <>(lhs: Double) -> Double { tgamma(lhs + 1) }

func **(lhs: Double, rhs: Double) -> Double { pow(lhs, rhs) }

func **(lhs: Int, rhs: Double) -> Double { pow(lhs.toDouble(), rhs) }

func **(lhs: Double, rhs: Int) -> Double { pow(lhs, rhs.toDouble()) }

func **(lhs: Int, rhs: Int) -> Double { pow(lhs.toDouble(), rhs.toDouble()) }

func +(lhs: Double, rhs: Int) -> Double { lhs + rhs.toDouble() }

func +(lhs: Int, rhs: Double) -> Double { lhs.toDouble() + rhs }

func -(lhs: Double, rhs: Int) -> Double { lhs - rhs.toDouble() }

func -(lhs: Int, rhs: Double) -> Double { lhs.toDouble() - rhs }

func /(lhs: Double, rhs: Int) -> Double { lhs / rhs.toDouble() }

func /(lhs: Int, rhs: Double) -> Double { lhs.toDouble() / rhs }

func !>>><T, B>(lhs: T?, rhs: ((T) -> B?)?) -> B? {
    guard let lhs = lhs, let rhs = rhs else { return .none }
    return rhs(lhs)
}

func >>><T, B>(lhs: T, rhs: (T) -> B) -> B { rhs(lhs) }

infix operator ≈≈

/// Roughly equal
func ≈≈(lhs: Double, rhs: Double) -> Bool { return abs(lhs - rhs) < 0.01 }

postfix operator ~

postfix func ~(lhs: @escaping Function) -> Function { return lhs >>> derivative }

infix operator <==>

func <==>(lhs: Double, rhs: Double) -> ClosedRange<Double> {
    min(lhs, rhs)...max(lhs, rhs)
}
