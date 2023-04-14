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
