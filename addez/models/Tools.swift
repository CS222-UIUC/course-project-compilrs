//
//  Tools.swift
//  addez
//
//  Created by Spencer Sadler on 2/23/23.
//

import Foundation

extension Int {
    func toDouble() -> Double {
        Double(self)
    }
}

extension Double {
    func toInt() -> Int {
        Int(self)
    }
}

extension String {
    func latexify() -> String {
        var latex = self
        latex = latex.replacingOccurrences(of: "sin", with: "\\sin")
        latex = latex.replacingOccurrences(of: "cos", with: "\\cos")
        latex = latex.replacingOccurrences(of: "tan", with: "\\tan")
        latex = latex.replacingOccurrences(of: "log", with: "\\log")
        latex = latex.replacingOccurrences(of: "ln", with: "\\ln")
        latex = latex.replacingOccurrences(of: "sqrt", with: "\\sqrt")
        latex = latex.replacingOccurrences(of: "pi", with: "\\pi")
        latex = latex.replacingOccurrences(of: "e", with: "\\e")
        latex = latex.replacingOccurrences(of: "x", with: "x")
        latex = "$\(latex)$"
        // \text is used to prevent LaTeX from interpreting the string as math
        return latex
    }
    func substringify() -> Substring {
        Substring(self)
    }
}
