//
//  MatrixSolveView.swift
//  addez
//
//  Created by Ayush Raman on 2/22/23.
//

import SwiftUI
import Neumorphic

struct MatrixSolveView: View {
    @ObservedObject var model = MatrixObject(getMatrix(cols: 2, rows: 2))
    @State var matrixFunction = MatrixFunctions.solve
    @State var steps: [Step]?
    @State var solution: SolutionType?
    var body: some View {
        VStack {
            Picker(selection: $matrixFunction, label: Text("Picker")) {
                ForEach(MatrixFunctions.allCases, id:\.rawValue) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            MatrixEditor()
                .environmentObject(model)
            Text("Show Steps")
                .navLink(viewLet(steps, to: StepsList.init))
            viewLet(solution, to: SolutionView.init)
            Button("Solve") {
                let sol = matrixFunction.compute(model.matrix)
                steps = sol?.steps
                solution = sol?.solution
            }
            .softButtonStyle(RoundedRectangle(cornerRadius: 20), pressedEffect: .hard)
            .fontWeight(.bold)
        }
        .navigationTitle("Matrix Solver")
    }
}

struct MatrixSolveView_Previews: PreviewProvider {
    static var previews: some View {
        MatrixSolveView()
    }
}
