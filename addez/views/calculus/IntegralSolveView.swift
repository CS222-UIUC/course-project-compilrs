//
//  IntegralSolveView.swift
//  addez
//
//  Created by Ayush Raman on 3/22/23.
//

import SwiftUI
import SwiftUICharts
import Neumorphic

struct IntegralSolveView: View {
    @State var userInput = "sin(x)"
    @State var x = 0.0
    @State var function: Function?
    var body: some View {
        VStack {
            LineChart(chartData: generateChartData())
                .frame(height: 300)
            TextField("", text: $userInput)
                .textFieldStyle(.roundedBorder)
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
        let data = (0...100).map { x in Double(x) }.map { x in LineChartDataPoint(value: function(x) ?? 0) }
        return LineChartData(dataSets: LineDataSet(dataPoints: data))
    }
    func solView() -> AnyView {
        guard let function = function else { return AnyView(EmptyView()) }
        return AnyView(
            VStack {
                Text("Integral of \(userInput) from 0 to \(x) is \(riemannSum(lowerBound: 0, upperBound: x, function))")
            }
        )
    }
}

struct IntegralSolveView_Previews: PreviewProvider {
    static var previews: some View {
        IntegralSolveView()
    }
}
