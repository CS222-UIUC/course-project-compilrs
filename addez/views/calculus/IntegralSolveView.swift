//
//  IntegralSolveView.swift
//  addez
//
//  Created by Ayush Raman on 3/22/23.
//

import SwiftUI
import SwiftUICharts
import Neumorphic
import OrderedCollections
import LaTeXSwiftUI

struct IntegralSolveView: View {
    @State var userInput = "sin(x)"
    @State var x = 0.0
    @State var inputX = ""
    @State var function: Function?
    var body: some View {
        VStack {
            LineChart(chartData: generateChartData())
                .frame(height: 300)
            TextField("", text: $userInput)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            TextField("", value: $x, formatter: NumberFormatter())
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
            Button("Evaluate") {
                function = parseExpression(userInput)
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: 20), pressedEffect: .hard)
            .fontWeight(.bold)
            solView()
        }
        .navigationTitle("Integral Solver")
    }
    func generateChartData() -> LineChartData {
        guard let function = function else { return LineChartData(dataSets: LineDataSet(dataPoints: [LineChartDataPoint]())) }
        let data = (0...10).map { x in LineChartDataPoint(value: function(Double(x)) ?? 0) }
        return LineChartData(dataSets: LineDataSet(dataPoints: data))
    }
    func solView() -> AnyView {
        guard let function = function else { return EmptyView().format() }
        return VStack {
            LaTeX("$f(\(x)) = \(String(describing: function(x) ?? .nan))$")
            LaTeX("$\\int_{0}^{\(x)} \(userInput.latexify()) = \(riemannSum(lowerBound: 0, upperBound: x, function))$")
            LaTeX("$\\sum_0^{\(x)} \(userInput.latexify()) = \(summation(range: 0...Int(x), function))$")
        }
        .format()
    }
}

struct IntegralSolveView_Previews: PreviewProvider {
    static var previews: some View {
        IntegralSolveView()
    }
}
