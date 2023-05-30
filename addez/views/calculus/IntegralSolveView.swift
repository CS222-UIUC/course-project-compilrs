//
//  IntegralSolveView.swift
//  addez
//
//  Created by Ayush Raman on 3/22/23.
//

import SwiftUI
import Neumorphic
import LaTeXSwiftUI
import Charts

struct Point: Identifiable {
    var id = UUID()
    let x: Double
    let y: Double
    init(id: UUID = UUID(), _ x: Double, _ y: Double) {
        self.id = id
        self.x = x
        self.y = y
    }
}

struct IntegralSolveView: View {
    @State var userInput = "sin(x)"
    @State var latexed = "\\sin(x)"
    @State var x = 0.0
    @State var inputX = ""
    @State var f: Function?
    @State var xRange = -10...10
    @State var yRange = -10...10
    @State var integralBound = 0.0...5.0
    @State var points = [Point]()
    @State var integ = 0.0
    @State var sum = 0.0
    var body: some View {
        VStack {
            Chart(points) { point in
                LineMark(x: .value("x", point.x), y: .value("f(\(x))", point.y))
                PointMark(x: .value("x", x), y: .value("f(\(x))", f?(x) ?? .nan))
            }
            TextField("f(x)", text: $userInput)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .autocorrectionDisabled(true)
//                .textInputAutocapitalization(.never)
            Slider(value: $x, in: Double(xRange.lowerBound)...Double(xRange.upperBound)) {
                Text("x")
            }
            TextField("x", value: $x, formatter: .numberFormatter)
                .textFieldStyle(.roundedBorder)
//                .keyboardType(.numberPad)
            Button("Evaluate") {
                f = parseExpression(userInput)
                guard let f = f else { points = []; return }
                if let latex = parseLatex(userInput) { latexed = latex }
                else { latexed = "" }
                integralBound = 0 <==> x
                sum = summation(in: 0...Int(integralBound.upperBound), f)
                integ = riemannSum(in: integralBound, f)
                points = xRange.continuous().compactMap { x in
                    let x = Double(x)
                    let y = f(Double(x))
                    guard yRange.inBounds(element: y) else { return .none }
                    return Point(x, y)
                }
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: 20), pressedEffect: .hard)
            .fontWeight(.bold)
            solView()
        }
        .navigationTitle("Integral Solver")
    }
    func solView() -> AnyView {
        guard let f = f else { return EmptyView().format() }
        return VStack {
            LaTeX("$f(\(x)) = \(String(describing: f(x)))$")
            LaTeX("$\\int_{0}^{\(integralBound.upperBound)} \(latexed) = \(integ)$")
            LaTeX("$\\sum_0^{\(Int(integralBound.upperBound))} \(latexed) = \(sum)$")
        }
        .format()
    }
}

struct IntegralSolveView_Previews: PreviewProvider {
    static var previews: some View {
        IntegralSolveView()
    }
}
